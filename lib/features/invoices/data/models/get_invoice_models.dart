import 'package:local_erp_system/core/errors/exceptions.dart';

import '../../../storage/data/models/storage_model.dart';

class GetInvoiceModels {
  final List<StorageModel> storageItems;
  final List<AppException> warnings;

  GetInvoiceModels({
    required this.storageItems,
    required this.warnings,
  });
}
