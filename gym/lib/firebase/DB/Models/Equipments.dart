import 'dart:convert';

class Equipments {
  String EQ_ID;
  String eq_name;
  String eq_image;
  int eq_weight;
  int eq_height;
  int eq_width;
  int eq_depth;
  String eq_type;

  Equipments({
    required this.EQ_ID,
    required this.eq_name,
    required this.eq_image,
    required this.eq_weight,
    required this.eq_height,
    required this.eq_width,
    required this.eq_depth,
    required this.eq_type,
  });

  @override
  String toString() {
    return 'Equipments{EQ_ID: $EQ_ID, eq_name: $eq_name, eq_image: $eq_image, eq_weight: $eq_weight, eq_height: $eq_height, eq_width: $eq_width, eq_depth: $eq_depth, eq_type: $eq_type}';
  }

  Equipments.fromJson(Map<String, dynamic> json)
      : EQ_ID = json['EQ_ID'],
        eq_name = json['eq_name'],
        eq_image = json['eq_image'],
        eq_weight = json['eq_weight'],
        eq_height = json['eq_height'],
        eq_width = json['eq_width'],
        eq_depth = json['eq_depth'],
        eq_type = json['eq_type'];

  Map<String, dynamic> toJson() => {
        'EQ_ID': EQ_ID,
        'eq_name': eq_name,
        'eq_image': eq_image,
        'eq_weight': eq_weight,
        'eq_height': eq_height,
        'eq_width': eq_width,
        'eq_depth': eq_depth,
        'eq_type': eq_type
      };
}
