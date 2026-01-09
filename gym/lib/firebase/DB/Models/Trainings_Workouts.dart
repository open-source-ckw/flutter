class TrainingsWorkouts {
  String TS_WS_ID;
  String TS_ID;
  String WS_ID;

  TrainingsWorkouts(
      {required this.TS_WS_ID, required this.TS_ID, required this.WS_ID});

  TrainingsWorkouts.fromJson(Map<String, dynamic> json)
      : TS_WS_ID = json['TS_WS_ID'] ?? "",
        TS_ID = json['TS_ID'] ?? "",
        WS_ID = json['WS_ID'] ?? "";

  Map<String, dynamic> toJson() => {
        'TS_WS_ID': TS_WS_ID,
        'TS_ID': TS_ID,
        'WS_ID': WS_ID,
      };

  @override
  String toString() {
    return 'TrainingsWorkouts{TS_WS_ID: $TS_WS_ID, TS_ID: $TS_ID, WS_ID: $WS_ID}';
  }
}
