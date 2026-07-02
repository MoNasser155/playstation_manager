class TapsModel {
  final String title;
  final String icon;
  final void Function()? onTap;

  TapsModel({required this.title, required this.icon, this.onTap});
}
