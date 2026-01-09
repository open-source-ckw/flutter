import 'dart:convert';

class TonningWorkoutsModel {
  String TWS_ID;
  String tWs_name;
  String tWs_description;
  String tWs_duration;
  String tWs_durationin;
  String tWs_kal;
  String tWs_level;
  String tWS_equipment;
  String tWs_image;

  TonningWorkoutsModel(
      {required this.TWS_ID,
      required this.tWs_name,
      required this.tWs_description,
      required this.tWs_duration,
      required this.tWs_durationin,
      required this.tWs_kal,
      required this.tWs_level,
      required this.tWS_equipment,
      required this.tWs_image});

  TonningWorkoutsModel.fromJson(Map<String, dynamic> json)
      : TWS_ID = json['TWS_ID'],
        tWs_name = json['tWs_name'],
        tWs_description = json['tWs_description'],
        tWs_duration = json['tWs_duration'],
        tWs_durationin = json['tWs_durationin'],
        tWs_kal = json['tWs_kal'],
        tWs_level = json['tWs_level'],
        tWS_equipment = json['tWS_equipment'],
        tWs_image = json['tWs_image'];

  Map<String, dynamic> toJson() => {
        'TWS_ID': TWS_ID,
        'tWs_name': tWs_name,
        'tWs_description': tWs_description,
        'tWs_duration': tWs_duration,
        'tWs_durationin': tWs_durationin,
        'tWs_kal': tWs_kal,
        'tWs_level': tWs_level,
        'tWS_equipment': tWS_equipment,
        'tWs_image': tWs_image,
      };

  @override
  String toString() {
    return 'TonningWorkoutsModel{TWS_ID: $TWS_ID, tWs_name: $tWs_name, tWs_description: $tWs_description, tWs_duration: $tWs_duration, tWs_durationin: $tWs_durationin, tWs_kal: $tWs_kal, tWs_level: $tWs_level, tWS_equipment: $tWS_equipment, tWs_image: $tWs_image}';
  }
}
