class ActivityModel2 {
  String AC2_ID;
  String ac2_name;
  String ac2_duration;
  String ac2_durationin;
  String ac2_date;

  ActivityModel2(
      {required this.AC2_ID,
      required this.ac2_name,
      required this.ac2_duration,
      required this.ac2_durationin,
      required this.ac2_date});

  ActivityModel2.fromJson(Map<String, dynamic> json)
      : AC2_ID = json['AC2_ID'],
        ac2_name = json['ac2_name'],
        ac2_duration = json['ac2_duration'],
        ac2_durationin = json['ac2_durationin'],
        ac2_date = json['ac2_date'];

  Map<String, dynamic> toJson() => {
        'AC2_ID': AC2_ID,
        'ac2_name': ac2_name,
        'ac2_duration': ac2_duration,
        'ac2_durationin': ac2_durationin,
        'ac2_date': ac2_date,
      };

  @override
  String toString() {
    return 'ActivityModel2{AC2_ID: $AC2_ID, ac2_name: $ac2_name, ac2_duration: $ac2_duration, ac2_durationin: $ac2_durationin, ac2_date: $ac2_date}';
  }
}
