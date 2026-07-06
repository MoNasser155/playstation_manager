import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../../../../../core/widgets/custom_sliver_padding.dart';
import '../../cubits/cubit/session_cubit.dart';
import 'session_item_row_filled.dart';
import 'session_item_row_input.dart';

class SessionItemsList extends StatelessWidget {
  const SessionItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliverPadding(
      sliver: BlocBuilder<SessionCubit, SessionState>(
        buildWhen:
            (previous, current) =>
                previous.sessionItems != current.sessionItems,
        builder: (context, state) {
          final items = state.sessionItems;
          final totalCount = items.length + 1;

          return SliverList.separated(
            itemCount: totalCount,
            separatorBuilder:
                (_, __) => Divider(
                  height: 0,
                  color: context.colorScheme.secondaryFixed,
                ),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return const SessionItemRowInput();
              }

              return SessionItemRowFilled(item: items[index], index: index);
            },
          );
        },
      ),
    );
  }
}
