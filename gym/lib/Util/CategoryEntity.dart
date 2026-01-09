class CategoryEntity {
  String id;
  String name;
  dynamic iconImage;
  dynamic onTap;

  CategoryEntity(
      {required this.id,
      required this.name,
      required this.iconImage,
      required this.onTap});
}
