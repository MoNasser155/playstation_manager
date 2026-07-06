import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';
import 'package:playstation_manager/core/widgets/custom_sliver_padding.dart';

import '../../../../core/constants/app_values.dart';
import '../../../../core/extentions/date_extensions.dart';
import '../../../../core/languages/local_keys.g.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/gaps.dart';
import '../../../../core/widgets/custom_skeletonizer.dart';
import '../../../../core/widgets/sliver_empty_body.dart';
import '../../data/models/session_model.dart';
import '../cubits/cubit/session_cubit.dart';

class SessionsListView extends StatelessWidget {
  const SessionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen:
          (prev, curr) =>
              prev.sessionList != curr.sessionList ||
              prev.sessionsListStatus != curr.sessionsListStatus,
      builder: (context, state) {
        final length =
            state.sessionsListStatus.isLoading ? 5 : state.sessionList.length;
        final sessions =
            state.sessionsListStatus.isLoading
                  ? List.generate(length, (_) => SessionModel.initial())
                  : [...state.sessionList]
              ..sort((a, b) => b.sessionDate.compareTo(a.sessionDate));

        return CustomScrollView(
          slivers: [
            sliverGapHFix(8),
            if (sessions.isEmpty)
              SliverEmptyBody(title: LocaleKeys.noSessionsFound)
            else
              CustomSliverPadding(
                sliver: SliverList.separated(
                  itemCount: length,
                  separatorBuilder: (_, __) => gapHFix(8),
                  itemBuilder: (context, index) {
                    return CustomSkeletonizer(
                      enabled: state.sessionsListStatus.isLoading,
                      child: _SessionCard(session: sessions[index]),
                    );
                  },
                ),
              ),
            sliverGapHFix(20),
          ],
        );
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});
  final SessionModel session;

  @override
  Widget build(BuildContext context) {
    final isActive = session.isSession;
    final accentColor =
        isActive ? AppColors.successColor : AppColors.primaryColor;

    return Container(
      padding: EdgeInsets.all(AppPadding.pf12),
      decoration: BoxDecoration(
        color: context.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Left accent strip
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(AppRadius.r4),
            ),
          ),
          gapWFix(10),
          // Main info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 13,
                      color: context.colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        session.sessionDate.shortenFormattedDate,
                        style: AppTextStyles.medium12.copyWith(
                          color: context.colorScheme.outline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.r8),
                        ),
                        child: Text(
                          LocaleKeys.reserved,
                          style: AppTextStyles.medium12.copyWith(
                            color: AppColors.successColor,
                          ),
                        ),
                      ),
                  ],
                ),
                if (session.sessionStartDate != null)
                  Row(
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 13,
                        color: context.colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        session.sessionStartDate!.shortenFormattedDate,
                        style: AppTextStyles.regular12.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Icon(
                      Icons.sports_esports_rounded,
                      size: 13,
                      color: context.colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      session.playType.localizedName,
                      style: AppTextStyles.regular12.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                    const Spacer(),
                    if (session.items.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_basket_rounded,
                            size: 13,
                            color: context.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${session.items.length}',
                            style: AppTextStyles.medium12.copyWith(
                              color: context.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          gapWFix(12),
          // Total amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                session.totalSession.toStringAsFixed(0),
                style: AppTextStyles.bold18.copyWith(color: accentColor),
              ),
              Text(
                LocaleKeys.egp,
                style: AppTextStyles.regular12.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
