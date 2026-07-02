import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/create_invoice_model.dart';
import '../repositories/invoice_repository.dart';

class RefundInvoiceUseCase {
  final _repository = sl<InvoiceRepository>();

  Future<Either<Failure, int>> call({
    required String invoiceUuid,
    required List<ItemsInvoice> adjustedItems,
    required double newTotal,
    required double newCashPaid,
    required double newLaterPaid,
  }) async {
    return await _repository.refundInvoice(
      invoiceUuid: invoiceUuid,
      adjustedItems: adjustedItems,
      newTotal: newTotal,
      newCashPaid: newCashPaid,
      newLaterPaid: newLaterPaid,
    );
  }
}
