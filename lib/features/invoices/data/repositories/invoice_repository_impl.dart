import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../../devices/data/models/device_model.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_local_data_source.dart';
import '../models/create_invoice_model.dart';
import '../models/get_invoice_models.dart';

class InvoiceRepositoryImpl with ErrorHandler implements InvoiceRepository {
  final _invoiceLocalDataSource = sl<InvoiceLocalDataSource>();

  @override
  Future<Either<Failure, GetInvoiceModels>> getInvoiceModels() async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.getInvoiceModels(),
    );
  }

  @override
  Future<Either<Failure, int>> createInvoice(
    CreateInvoiceModel invoiceData,
  ) async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.createInvoice(invoiceData),
    );
  }

  @override
  Future<Either<Failure, List<CreateInvoiceModel>>> getAllInvoices() async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.getAllInvoices(),
    );
  }



  @override
  Future<Either<Failure, List<CreateInvoiceModel>>> getActiveSessions() async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.getActiveSessions(),
    );
  }

  @override
  Future<Either<Failure, CreateInvoiceModel?>> getActiveSessionForDevice(
    int deviceId,
  ) async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.getActiveSessionForDevice(deviceId),
    );
  }

  @override
  Future<Either<Failure, int>> startDeviceSession({
    required CreateInvoiceModel sessionInvoice,
    required DeviceModel device,
  }) async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.startDeviceSession(
        sessionInvoice: sessionInvoice,
        device: device,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> updateSessionItems({
    required String sessionUuid,
    required List<ItemsInvoice> items,
  }) async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.updateSessionItems(
        sessionUuid: sessionUuid,
        items: items,
      ),
    );
  }

  @override
  Future<Either<Failure, int>> endDeviceSession({
    required CreateInvoiceModel completedInvoice,
    required DeviceModel device,
  }) async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.endDeviceSession(
        completedInvoice: completedInvoice,
        device: device,
      ),
    );
  }
}
