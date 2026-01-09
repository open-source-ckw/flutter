class Trainings {
  String TS_ID;
  String ts_name;
  String ts_image;

  @override
  String toString() {
    return 'Trainings{TS_ID: $TS_ID, ts_name: $ts_name, ts_image: $ts_image, ts_duration: $ts_duration, ts_durationin: $ts_durationin, ts_advantage: $ts_advantage, ts_level: $ts_level}';
  }

  String ts_duration;
  String ts_durationin;
  String ts_advantage;
  String ts_level;

  Trainings({
    required this.TS_ID,
    required this.ts_name,
    required this.ts_image,
    required this.ts_duration,
    required this.ts_durationin,
    required this.ts_advantage,
    required this.ts_level,
  });

  Trainings.fromJson(Map<String, dynamic> json)
      : TS_ID = json['TS_ID'],
        ts_name = json['ts_name'],
        ts_image = json['ts_image'],
        ts_duration = json['ts_duration'],
        ts_durationin = json['ts_durationin'],
        ts_advantage = json['ts_advantage'],
        ts_level = json['ts_level'];

  Map<String, dynamic> toJson() => {
        'TS_ID': TS_ID,
        'ts_name': ts_name,
        'ts_image': ts_image,
        'ts_duration': ts_duration,
        'ts_durationin': ts_durationin,
        'ts_advantage': ts_advantage,
        'ts_level': ts_level,
      };
}
