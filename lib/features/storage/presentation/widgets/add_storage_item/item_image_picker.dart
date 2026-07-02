part of 'custom_add_new_storage_item.dart';

class _ItemImagePicker extends StatelessWidget {
  const _ItemImagePicker({required this.cubit});
  final AddStorageItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<AddStorageItemCubit, AddStorageItemState>(
          buildWhen: (previous, current) {
            return previous.itemImagePath != current.itemImagePath;
          },
          builder: (context, state) {
            return InkWell(
              onTap: () {
                cubit.pickImage();
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  maxHeight: 300,
                  minWidth: 200,
                  minHeight: 200,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(
                    color: context.colorScheme.secondaryFixed
                        .withValues(alpha: 0.5),
                  ),
                ),
                child:
                    state.itemImagePath != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(state.itemImagePath!),
                            fit: BoxFit.cover,
                          ),
                        )
                        : Icon(
                          Icons.image_not_supported_rounded,
                          size: 80.sp,
                        ),
              ),
            );
          },
        ),
      ],
    );
  }
}
