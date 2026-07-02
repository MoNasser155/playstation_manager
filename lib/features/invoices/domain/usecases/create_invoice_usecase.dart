import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/create_invoice_model.dart';
import '../repositories/invoice_repository.dart';

class CreateInvoiceUseCase {
  final _repository = sl<InvoiceRepository>();

  Future<Either<Failure, int>> call(CreateInvoiceModel invoiceData) async {
    return await _repository.createInvoice(invoiceData);
  }
}
