class Exercises {
  String Es_ID;
  String es_name;
  String es_description;
  String es_image;
  String es_duration;
  String es_durationin;
  String es_advantage;
  String es_kal;
  String es_level;
  String es_type;
  String CS_ID;

  Exercises(
      {required this.Es_ID,
      required this.es_name,
      required this.es_description,
      required this.es_image,
      required this.es_duration,
      required this.es_durationin,
      required this.es_advantage,
      required this.es_kal,
      required this.es_level,
      required this.es_type,
      required this.CS_ID});

  Exercises.fromJson(Map<String, dynamic> json)
      : Es_ID = json['Es_ID'],
        es_name = json['es_name'],
        es_description = json['es_description'],
        es_image = json['es_image'],
        es_duration = json['es_duration'],
        es_durationin = json['es_durationin'],
        es_advantage = json['es_advantage'],
        es_kal = json['es_kal'] ?? "0",
        es_level = json['es_level'],
        es_type = json['es_type'],
        CS_ID = json['CS_ID'] ?? "";

  Map<String, dynamic> toJson() => {
        'Es_ID': Es_ID,
        'es_name': es_name,
        'es_description': es_description,
        'es_image': es_image,
        'es_duration': es_duration,
        'es_durationin': es_durationin,
        'es_advantage': es_advantage,
        'es_kal': es_kal,
        'es_level': es_level,
        'es_type': es_type,
        'CS_ID': CS_ID
      };

  @override
  String toString() {
    return 'Exercises{Es_ID: $Es_ID, es_name: $es_name, es_description: $es_description, es_image: $es_image, es_duration: $es_duration, es_durationin: $es_durationin, es_advantage: $es_advantage, es_kal: $es_kal, es_level: $es_level, es_type: $es_type, CS_ID: $CS_ID}';
  }
}
