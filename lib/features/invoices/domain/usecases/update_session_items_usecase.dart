import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/create_invoice_model.dart';
import '../repositories/invoice_repository.dart';

class UpdateSessionItemsUseCase {
  final _repository = sl<InvoiceRepository>();

  Future<Either<Failure, void>> call({
    required String sessionUuid,
    required List<ItemsInvoice> items,
  }) async {
    return await _repository.updateSessionItems(
      sessionUuid: sessionUuid,
      items: items,
    );
  }
}
