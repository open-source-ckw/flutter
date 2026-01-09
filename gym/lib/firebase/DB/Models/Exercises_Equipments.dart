class ExercisesEquipments {
  String ES_EQ_ID;
  String ES_ID;
  String EQ_ID;

  ExercisesEquipments(
      {required this.ES_EQ_ID, required this.ES_ID, required this.EQ_ID});

  ExercisesEquipments.fromJson(Map<String, dynamic> json)
      : ES_EQ_ID = json['ES_EQ_ID'],
        ES_ID = json['ES_ID'],
        EQ_ID = json['EQ_ID'];

  Map<String, dynamic> toJson() => {
        'ES_EQ_ID': ES_EQ_ID,
        'ES_ID': ES_ID,
        'EQ_ID': EQ_ID,
      };

  @override
  String toString() {
    return 'ExercisesEquipments{ES_EQ_ID: $ES_EQ_ID, ES_ID: $ES_ID, EQ_ID: $EQ_ID}';
  }
}
