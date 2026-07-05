import 'package:local_erp_system/core/objectbox/objectbox.g.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/enums/device_status.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../../../devices/data/models/device_model.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../models/get_session_models.dart';
import '../models/session_model.dart';

abstract class SessionLocalDataSource {
  GetSessionModels getSessionModels();
  int createSession(SessionModel sessionData);
  List<SessionModel> getAllSessions();
  List<SessionModel> getActiveSessions();
  SessionModel? getActiveSessionForDevice(int deviceId);
  int startDeviceSession({
    required SessionModel session,
    required DeviceModel device,
  });
  void updateSessionItems({
    required String sessionUuid,
    required List<SessionItem> items,
  });
  int endDeviceSession({
    required SessionModel completedSession,
    required DeviceModel device,
  });
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  @override
  GetSessionModels getSessionModels() {
    final storageItemsQuery = _store.storage.getAll();
    if (storageItemsQuery.isEmpty) {
      throw NoStorageItemsExeption();
    }

    return GetSessionModels(storageItems: storageItemsQuery, warnings: []);
  }

  @override
  int createSession(SessionModel sessionData) {
    return _store.store.runInTransaction(TxMode.write, () {
      // 1. Save session items
      _store.sessionItems.putMany(sessionData.items.toList());

      // 2. Update storage quantities
      for (final sessionItem in sessionData.items) {
        final storageItem = sessionItem.storageItem.target;
        if (storageItem == null) continue;

        _store.storage.put(
          storageItem.copyWith(
            quantity: storageItem.quantity - sessionItem.quantity,
          ),
        );
      }

      // 3. Calculate session profit
      final profit = sessionData.items.fold<double>(0.0, (sum, item) {
        final storageItem = item.storageItem.target;
        if (storageItem == null) return sum;

        return sum + ((item.sellPrice - storageItem.buyPrice) * item.quantity);
      });

      // 4. Generate transaction note
      final note = sessionData.items
          .map((item) {
            final itemName = item.storageItem.target?.itemName ?? '';
            return 'الصنف: $itemName _|_ الكمية: ${item.quantity} _|_ سعر البيع: ${item.sellPrice}';
          })
          .join('\n');

      // 5. Create transaction
      _store.transactions.put(
        TransactionModel.create(
          uuid: const Uuid().v4(),
          sessionProfit: profit,
          transactionType: TransactionType.sessionProfit,
          userType: UserType.customer,
          createdAt: DateTime.now(),
          notes: note,
        ),
      );

      // 6. Save session
      return _store.sessions.put(sessionData);
    });
  }

  @override
  List<SessionModel> getAllSessions() {
    final results = _store.sessions.getAll();
    if (results.isEmpty) {
      throw NoSessionsFoundException();
    }
    return results;
  }

  @override
  List<SessionModel> getActiveSessions() {
    final query =
        _store.sessions.query(SessionModel_.isSession.equals(true)).build();
    final results = query.find();
    query.close();
    return results;
  }

  @override
  SessionModel? getActiveSessionForDevice(int deviceId) {
    final query =
        _store.sessions
            .query(
              SessionModel_.isSession
                  .equals(true)
                  .and(SessionModel_.device.equals(deviceId)),
            )
            .build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  @override
  int startDeviceSession({
    required SessionModel session,
    required DeviceModel device,
  }) {
    return _store.store.runInTransaction(TxMode.write, () {
      final id = _store.sessions.put(session);
      final updatedDevice = device.copyWith(status: DeviceStatus.reserved);
      _store.devices.put(updatedDevice);
      return id;
    });
  }

  @override
  void updateSessionItems({
    required String sessionUuid,
    required List<SessionItem> items,
  }) {
    _store.store.runInTransaction(TxMode.write, () {
      final query =
          _store.sessions.query(SessionModel_.uuid.equals(sessionUuid)).build();
      final session = query.findFirst();
      query.close();

      if (session != null) {
        session.items.clear();
        session.items.addAll(items);
        _store.sessions.put(session);
      }
    });
  }

  @override
  int endDeviceSession({
    required SessionModel completedSession,
    required DeviceModel device,
  }) {
    return _store.store.runInTransaction(TxMode.write, () {
      // 1. Save session items
      _store.sessionItems.putMany(completedSession.items.toList());

      // 2. Update storage quantities
      for (final sessionItem in completedSession.items) {
        final storageItem = sessionItem.storageItem.target;
        if (storageItem == null) continue;

        _store.storage.put(
          storageItem.copyWith(
            quantity: storageItem.quantity - sessionItem.quantity,
          ),
        );
      }

      // 3. Calculate session time cost using the totalSession from session cubit as a reference
      final itemsTotal = completedSession.items.fold<double>(
        0.0,
        (sum, item) => sum + item.totalItemPrice,
      );
      final sessionCost = completedSession.totalSession - itemsTotal;

      // 4. Calculate items profit
      final itemsProfit = completedSession.items.fold<double>(0.0, (sum, item) {
        final storageItem = item.storageItem.target;
        if (storageItem == null) return sum;
        return sum + ((item.sellPrice - storageItem.buyPrice) * item.quantity);
      });

      final totalProfit = sessionCost + itemsProfit;

      // 5. Generate transaction note
      final sessionNote = 'جلسة: ${device.name}';
      final itemsNote = completedSession.items
          .map((item) {
            final itemName = item.storageItem.target?.itemName ?? '';
            return 'الصنف: $itemName _|_ الكمية: ${item.quantity} _|_ سعر البيع: ${item.sellPrice}';
          })
          .join('\n');
      final note = itemsNote.isEmpty ? sessionNote : '$sessionNote\n$itemsNote';

      // 6. Create transaction
      _store.transactions.put(
        TransactionModel.create(
          uuid: const Uuid().v4(),
          sessionProfit: totalProfit,
          transactionType: TransactionType.sessionProfit,
          userType: UserType.customer,
          createdAt: DateTime.now(),
          notes: note,
        ),
      );

      // 7. Save completed session
      final id = _store.sessions.put(completedSession);

      // 8. Update device status
      final updatedDevice = device.copyWith(status: DeviceStatus.available);
      _store.devices.put(updatedDevice);

      return id;
    });
  }
}
