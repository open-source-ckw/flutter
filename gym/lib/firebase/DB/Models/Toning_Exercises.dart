class ToningExercises {
  String TWS_ES_ID;
  String TWS_ID;
  String ES_ID;

  ToningExercises(
      {required this.TWS_ES_ID, required this.TWS_ID, required this.ES_ID});

  ToningExercises.fromJson(Map<String, dynamic> json)
      : TWS_ES_ID = json['TWS_ES_ID'],
        TWS_ID = json['TWS_ID'],
        ES_ID = json['ES_ID'];

  Map<String, dynamic> toJson() => {
        'TWS_ES_ID': TWS_ES_ID,
        'TWS_ID': TWS_ID,
        'ES_ID': ES_ID,
      };
}
