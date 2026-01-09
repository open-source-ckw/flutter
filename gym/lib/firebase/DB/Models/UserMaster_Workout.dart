class UserMasterWorkout {
  String UM_WS_ID;
  String UM_ID;
  String WS_ID;
  String TS_ID;

  String um_ws_startDate;
  String um_ws_StartTime;
  bool um_ws_Is_Completed;
  String um_ws_activeCategoryId;
  String um_ws_activeExerciseId;
  String um_ws_type;

  String um_ws_categoryName;

  int um_ws_kalBurned;
  String um_ws_totalSpentTime;
  String um_ws_currentExerciseResumeTime;

  @override
  String toString() {
    return 'UserMasterWorkout{UM_WS_ID: $UM_WS_ID, UM_ID: $UM_ID, WS_ID: $WS_ID, TS_ID: $TS_ID, um_ws_startDate: $um_ws_startDate, um_ws_StartTime: $um_ws_StartTime, um_ws_Is_Completed: $um_ws_Is_Completed, um_ws_activeCategoryId: $um_ws_activeCategoryId, um_ws_activeExerciseId: $um_ws_activeExerciseId, um_ws_type: $um_ws_type, um_ws_categoryName: $um_ws_categoryName, um_ws_kalBurned: $um_ws_kalBurned, um_ws_totalSpentTime: $um_ws_totalSpentTime, um_ws_currentExerciseResumeTime: $um_ws_currentExerciseResumeTime}';
  }

  UserMasterWorkout(
      {required this.UM_WS_ID,
      required this.UM_ID,
      required this.WS_ID,
      required this.TS_ID,
      required this.um_ws_startDate,
      required this.um_ws_StartTime,
      required this.um_ws_Is_Completed,
      required this.um_ws_activeCategoryId,
      required this.um_ws_activeExerciseId,
      required this.um_ws_type,
      required this.um_ws_categoryName,
      required this.um_ws_kalBurned,
      required this.um_ws_currentExerciseResumeTime,
      required this.um_ws_totalSpentTime});

  UserMasterWorkout.fromJson(Map<String, dynamic> json)
      : UM_WS_ID = json['UM_WS_ID'] ?? "",
        UM_ID = json['UM_ID'] ?? "",
        WS_ID = json['WS_ID'] ?? "",
        TS_ID = json['TS_ID'] ?? "",
        um_ws_startDate = json['um_ws_startDate'] ?? "",
        um_ws_StartTime = json['um_ws_StartTime'] ?? "",
        um_ws_Is_Completed = json['um_ws_Is_Completed'] ?? "",
        um_ws_activeCategoryId = json['um_ws_activeCategoryId'] ?? "",
        um_ws_activeExerciseId = json['um_ws_activeExerciseId'] ?? "",
        um_ws_type = json['um_ws_type'] ?? "",
        um_ws_categoryName = json['um_ws_categoryName'] ?? "",
        um_ws_kalBurned = json['um_ws_kalBurned'] ?? 0,
        um_ws_currentExerciseResumeTime =
            json['um_ws_currentExerciseResumeTime'] ?? "",
        um_ws_totalSpentTime = json['um_ws_totalSpentTime'] ?? "";

  Map<String, dynamic> toJson() => {
        'UM_WS_ID': UM_WS_ID,
        'UM_ID': UM_ID,
        'WS_ID': WS_ID,
        'TS_ID': TS_ID,
        'um_ws_startDate': um_ws_startDate,
        'um_ws_StartTime': um_ws_StartTime,
        'um_ws_Is_Completed': um_ws_Is_Completed,
        'um_ws_activeCategoryId': um_ws_activeCategoryId,
        'um_ws_activeExerciseId': um_ws_activeExerciseId,
        'um_ws_type': um_ws_type,
        'um_ws_categoryName': um_ws_categoryName,
        'um_ws_kalBurned': um_ws_kalBurned,
        'um_ws_currentExerciseResumeTime': um_ws_currentExerciseResumeTime,
        'um_ws_totalSpentTime': um_ws_totalSpentTime,
      };
}
