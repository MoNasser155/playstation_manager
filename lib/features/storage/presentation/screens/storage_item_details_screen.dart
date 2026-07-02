import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/di.dart';
import '../cubits/storage_item_details_cubit/storage_item_details_cubit.dart';
import '../widgets/storage_item_details_body.dart';

class StorageItemDetailsScreen extends StatelessWidget {
  const StorageItemDetailsScreen({super.key, required this.storageItemUuid});
  final String storageItemUuid;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StorageItemDetailsCubit>()..init(storageItemUuid),
      child: const StorageItemDetailsBody(),
    );
  }
}
