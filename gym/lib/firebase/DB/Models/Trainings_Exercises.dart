class TrainingsExercises {
  String TS_ES_ID;
  String TS_ID;
  String ES_ID;

  TrainingsExercises(
      {required this.TS_ES_ID, required this.TS_ID, required this.ES_ID});

  TrainingsExercises.fromJson(Map<String, dynamic> json)
      : TS_ES_ID = json['TS_ES_ID'] ?? "",
        TS_ID = json['TS_ID'] ?? "",
        ES_ID = json['ES_ID'] ?? "";

  Map<String, dynamic> toJson() => {
        'TS_ES_ID': TS_ES_ID,
        'TS_ID': TS_ID,
        'ES_ID': ES_ID,
      };

  @override
  String toString() {
    return 'TrainingsExercises{TS_ES_ID: $TS_ES_ID, TS_ID: $TS_ID, ES_ID: $ES_ID}';
  }
}
