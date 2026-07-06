import 'package:playstation_manager/core/errors/exceptions.dart';

import '../../../storage/data/models/storage_model.dart';

class GetSessionModels {
  final List<StorageModel> storageItems;
  final List<AppException> warnings;

  GetSessionModels({required this.storageItems, required this.warnings});
}
