import '../../../../core/errors/exceptions.dart';
import 'package:local_erp_system/core/objectbox/objectbox.g.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../models/device_model.dart';

abstract class DeviceLocalDataSource {
  List<DeviceModel> getAllDevices();
  int addDevice(DeviceModel device);
  bool deleteDevice(String uuid);
  int updateDevice(DeviceModel device);
  DeviceModel? getDeviceByUuid(String uuid);
}

class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();

  DeviceLocalDataSourceImpl();

  @override
  List<DeviceModel> getAllDevices() {
    return _store.devices.getAll();
  }

  @override
  int addDevice(DeviceModel device) {
    return _store.store.runInTransaction(TxMode.write, () {
      final query =
          _store.devices.query(DeviceModel_.uuid.equals(device.uuid)).build();
      final existing = query.findFirst();
      query.close();

      if (existing == null) {
        return _store.devices.put(device);
      } else {
        throw DeviceNotFoundException(); // or duplicate entry exception
      }
    });
  }

  @override
  bool deleteDevice(String uuid) {
    final query = _store.devices.query(DeviceModel_.uuid.equals(uuid)).build();
    final device = query.findFirst();
    query.close();

    if (device != null) {
      return _store.devices.remove(device.id!);
    }
    return false;
  }

  @override
  int updateDevice(DeviceModel device) {
    return _store.devices.put(device);
  }

  @override
  DeviceModel? getDeviceByUuid(String uuid) {
    final query = _store.devices.query(DeviceModel_.uuid.equals(uuid)).build();
    final device = query.findFirst();
    query.close();

    if (device == null) {
      throw DeviceNotFoundException();
    }
    return device;
  }
}
