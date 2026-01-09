class WorkoutsCategories {
  String WS_CS_ID;
  String WS_ID;
  String CS_ID;

  WorkoutsCategories(
      {required this.WS_CS_ID, required this.WS_ID, required this.CS_ID});

  WorkoutsCategories.fromJson(Map<String, dynamic> json)
      : WS_CS_ID = json['WS_CS_ID'] ?? "",
        WS_ID = json['WS_ID'] ?? "",
        CS_ID = json['CS_ID'] ?? "";

  Map<String, dynamic> toJson() => {
        'WS_ES_ID': WS_CS_ID,
        'WS_ID': WS_ID,
        'ES_ID': CS_ID,
      };

  @override
  String toString() {
    return 'WorkoutsCategories{WS_CS_ID: $WS_CS_ID, WS_ID: $WS_ID, CS_ID: $CS_ID}';
  }
}
