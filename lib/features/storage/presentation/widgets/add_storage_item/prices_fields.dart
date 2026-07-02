part of 'custom_add_new_storage_item.dart';

class _PricesFields extends StatelessWidget {
  const _PricesFields({required this.cubit});
  final AddStorageItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.h8,
      children: [
        Expanded(
          child: CustomTextField(
            hint: LocaleKeys.enterBuyPrice,
            controller: cubit.buyPriceController,
            prefix: Icon(Icons.money),
            validate: Validations.validateEmpty,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d*'),
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomTextField(
            hint: LocaleKeys.enterSellPrice,
            controller: cubit.sellPriceController,
            prefix: Icon(Icons.money_sharp),
            validate: Validations.validateEmpty,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d*'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
