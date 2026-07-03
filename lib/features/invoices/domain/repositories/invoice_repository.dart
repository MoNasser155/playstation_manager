import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/create_invoice_model.dart';
import '../../data/models/get_invoice_models.dart';
import '../../../devices/data/models/device_model.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, GetInvoiceModels>> getInvoiceModels();
  Future<Either<Failure, int>> createInvoice(CreateInvoiceModel invoiceData);
  Future<Either<Failure, List<CreateInvoiceModel>>> getAllInvoices();
  Future<Either<Failure, int>> refundInvoice({
    required String invoiceUuid,
    required List<ItemsInvoice> adjustedItems,
    required double newTotal,
    required double newCashPaid,
    required double newLaterPaid,
  });
  Future<Either<Failure, List<CreateInvoiceModel>>> getActiveSessions();
  Future<Either<Failure, CreateInvoiceModel?>> getActiveSessionForDevice(int deviceId);
  Future<Either<Failure, int>> startDeviceSession({
    required CreateInvoiceModel sessionInvoice,
    required DeviceModel device,
  });
  Future<Either<Failure, void>> updateSessionItems({
    required String sessionUuid,
    required List<ItemsInvoice> items,
  });
  Future<Either<Failure, int>> endDeviceSession({
    required CreateInvoiceModel completedInvoice,
    required DeviceModel device,
  });
}
