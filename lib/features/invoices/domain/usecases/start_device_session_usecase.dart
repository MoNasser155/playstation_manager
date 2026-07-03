import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../../devices/data/models/device_model.dart';
import '../../data/models/create_invoice_model.dart';
import '../repositories/invoice_repository.dart';

class StartDeviceSessionUseCase {
  final _repository = sl<InvoiceRepository>();

  Future<Either<Failure, int>> call({
    required CreateInvoiceModel sessionInvoice,
    required DeviceModel device,
  }) async {
    return await _repository.startDeviceSession(
      sessionInvoice: sessionInvoice,
      device: device,
    );
  }
}
