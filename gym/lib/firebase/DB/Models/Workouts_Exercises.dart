class WorkoutsExercises {
  String WS_ES_ID;
  String WS_ID;
  String ES_ID;

  WorkoutsExercises(
      {required this.WS_ES_ID, required this.WS_ID, required this.ES_ID});

  WorkoutsExercises.fromJson(Map<String, dynamic> json)
      : WS_ES_ID = json['WS_ES_ID'],
        WS_ID = json['WS_ID'],
        ES_ID = json['ES_ID'];

  Map<String, dynamic> toJson() => {
        'WS_ES_ID': WS_ES_ID,
        'WS_ID': WS_ID,
        'ES_ID': ES_ID,
      };

  @override
  String toString() {
    return 'WorkoutsExercises{WS_ES_ID: $WS_ES_ID, WS_ID: $WS_ID, ES_ID: $ES_ID}';
  }
}
