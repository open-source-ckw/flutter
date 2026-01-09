class ExercisesCategories {
  String ES_CS_ID;
  String ES_ID;
  String CS_ID;

  ExercisesCategories(
      {required this.ES_CS_ID, required this.ES_ID, required this.CS_ID});

  ExercisesCategories.fromJson(Map<String, dynamic> json)
      : ES_CS_ID = json['ES_CS_ID'] ?? "",
        ES_ID = json['ES_ID'] ?? "",
        CS_ID = json['CS_ID'] ?? "";

  Map<String, dynamic> toJson() => {
        'ES_CS_ID': ES_CS_ID,
        'ES_ID': ES_ID,
        'CS_ID': CS_ID,
      };

  @override
  String toString() {
    return 'ExercisesCategories{ES_CS_ID: $ES_CS_ID, ES_ID: $ES_ID, CS_ID: $CS_ID}';
  }
}
