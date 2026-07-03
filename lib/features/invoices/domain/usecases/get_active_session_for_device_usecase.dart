import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/create_invoice_model.dart';
import '../repositories/invoice_repository.dart';

class GetActiveSessionForDeviceUseCase {
  final _repository = sl<InvoiceRepository>();

  Future<Either<Failure, CreateInvoiceModel?>> call(int deviceId) async {
    return await _repository.getActiveSessionForDevice(deviceId);
  }
}
