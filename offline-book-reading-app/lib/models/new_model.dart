import 'package:isar/isar.dart';

part 'new_model.g.dart';

@Collection()
class Section {
  Id sId = Isar.autoIncrement;
  late String sImage;
  late String sTitle;
  late String sSubTitle;
}

@Collection()
class Topic {
  Id tId = Isar.autoIncrement;
  // @Index(unique: true)
  @Index(composite: [CompositeIndex('sId')], unique: true)
  late String tName;
  late String tTranslateName;
  late int sId;
}

@Collection()
class Content {
  Id cId = Isar.autoIncrement;
  late String cText;
  late bool cBold;
  String? cImage;
  late String cAlign;
  late int tId;
}


@collection
class ImageModel {
  Id iId = Isar.autoIncrement;
  late String imagePath;
}