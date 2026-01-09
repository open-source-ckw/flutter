import 'dart:convert';

class Workouts {
  String WS_ID;
  String ws_name;
  String ws_description;
  String ws_duration;
  String ws_durationin;
  String ws_kal;
  String ws_level;
  String ws_equipment;
  String ws_image;

  Workouts({
    required this.WS_ID,
    required this.ws_name,
    required this.ws_description,
    required this.ws_duration,
    required this.ws_durationin,
    required this.ws_kal,
    required this.ws_level,
    required this.ws_equipment,
    required this.ws_image,
  });

  Workouts.fromJson(Map<String, dynamic> json)
      : WS_ID = json['WS_ID'],
        ws_name = json['ws_name'],
        ws_description = json['ws_description'],
        ws_duration = json['ws_duration'],
        ws_durationin = json['ws_durationin'],
        ws_kal = json['ws_kal'],
        ws_level = json['ws_level'],
        ws_equipment = json['ws_equipment'],
        ws_image = json['ws_image'];

  Map<String, dynamic> toJson() => {
        'WS_ID': WS_ID,
        'ws_name': ws_name,
        'ws_description': ws_description,
        'ws_duration': ws_duration,
        'ws_durationin': ws_durationin,
        'ws_kal': ws_kal,
        'ws_level': ws_level,
        'ws_equipment': ws_equipment,
        'ws_image': ws_image,
      };

  @override
  String toString() {
    return 'Workouts{WS_ID: $WS_ID, ws_name: $ws_name, ws_description: $ws_description, ws_duration: $ws_duration, ws_durationin: $ws_durationin, ws_kal: $ws_kal, ws_level: $ws_level, ws_equipment: $ws_equipment, ws_image: $ws_image}';
  }
}
