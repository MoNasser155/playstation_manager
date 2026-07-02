import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
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
  Future<Either<Failure, List<CreateInvoiceModel>>> getCustomerInvoices(
    String customerUuid,
  ) async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.getCustomerInvoices(customerUuid),
    );
  }

  @override
  Future<Either<Failure, int>> refundInvoice({
    required String invoiceUuid,
    required List<ItemsInvoice> adjustedItems,
    required double newTotal,
    required double newCashPaid,
    required double newLaterPaid,
  }) async {
    return wrapBoxOperationSync(
      () => _invoiceLocalDataSource.refundInvoice(
        invoiceUuid: invoiceUuid,
        adjustedItems: adjustedItems,
        newTotal: newTotal,
        newCashPaid: newCashPaid,
        newLaterPaid: newLaterPaid,
      ),
    );
  }
}
