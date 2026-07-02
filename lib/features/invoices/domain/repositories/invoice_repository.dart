import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/create_invoice_model.dart';
import '../../data/models/get_invoice_models.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, GetInvoiceModels>> getInvoiceModels();
  Future<Either<Failure, int>> createInvoice(CreateInvoiceModel invoiceData);
  Future<Either<Failure, List<CreateInvoiceModel>>> getCustomerInvoices(
    String customerUuid,
  );
  Future<Either<Failure, int>> refundInvoice({
    required String invoiceUuid,
    required List<ItemsInvoice> adjustedItems,
    required double newTotal,
    required double newCashPaid,
    required double newLaterPaid,
  });
}
