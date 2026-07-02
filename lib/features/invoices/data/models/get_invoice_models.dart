import 'package:local_erp_system/core/errors/exceptions.dart';

import '../../../customers/data/models/customer_model.dart';
import '../../../storage/data/models/storage_model.dart';

class GetInvoiceModels {
  final List<CustomerModel> customers;
  final List<StorageModel> storageItems;
  final List<AppException> warnings;

  GetInvoiceModels({
    required this.customers,
    required this.storageItems,
    required this.warnings,
  });
}
