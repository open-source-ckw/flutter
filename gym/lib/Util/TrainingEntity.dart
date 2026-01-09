class TrainingEntity {
  dynamic id;
  String image;
  String text;
  String subtext;
  String duration;
  bool isFavorite;

  TrainingEntity(
      {required this.id,
      required this.image,
      required this.text,
      required this.subtext,
      required this.duration,
      required this.isFavorite});
}
