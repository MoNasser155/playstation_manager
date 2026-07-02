import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/get_invoice_models.dart';
import '../repositories/invoice_repository.dart';

class GetAllInvoiceModelsUseCase {
  final _repository = sl<InvoiceRepository>();

  Future<Either<Failure, GetInvoiceModels>> call() async {
    return await _repository.getInvoiceModels();
  }
}
