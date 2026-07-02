part of 'show_model_bottom_sheet.dart';

class _CustomAddSheetBody extends StatelessWidget {
  const _CustomAddSheetBody({
    required this.scrollController,
    required this.children,
    required this.onTap,
    required this.isLoading,
    required this.title,
    required this.buttonTitle,
  });

  final ScrollController scrollController;
  final List<Widget> children;
  final void Function()? onTap;
  final bool isLoading;
  final String title;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          spacing: AppSpacing.v12,
          children: [
            gapH(0),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(AppSize.s24),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.pf20),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    title,
                    style: context.textTheme.titleLarge!.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
        ExpandedFilterBody(
          scrollController: scrollController,
          children: children,
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: AppSpacing.v12,
            left: AppPadding.pf20,
            right: AppPadding.pf20,
            top: AppSpacing.v6,
          ),
          child: CustomButton(
            onTap: onTap,
            isLoading: isLoading,
            title: buttonTitle,
          ),
        ),
      ],
    );
  }
}
