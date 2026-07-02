import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/state_status.dart';
import '../../../../../core/utils/gaps.dart';
import '../../../../../core/widgets/custom_skeletonizer.dart';
import '../../cubits/storage_cubit/storage_cubit.dart';
import '../custom_storage_body_appbar.dart';
import '../storage_list.dart';

class TabletStorageBody extends StatelessWidget {
  const TabletStorageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StorageCubit, StorageState, StateStatus>(
      selector: (state) {
        return state.status;
      },
      builder: (context, status) {
        return CustomSkeletonizer(
          enabled: status.isLoading,
          child: CustomScrollView(
            slivers: [
              CustomStorageBodyAppbar(),
              sliverGapH(16),
              StorageList(),
              sliverGapH(20),
            ],
          ),
        );
      },
    );
  }
}
