class ReminderWorkouts {
  String RW_ID;
  String UM_ID;
  String WS_ID;

  // String REF_TYPE;
  String rw_reminderDay;
  String rw_scheduledForDay;
  String rw_reminderTime;
  bool rw_isActive;

  // String REF_Type;

  ReminderWorkouts({
    required this.RW_ID,
    required this.UM_ID,
    required this.WS_ID,
    required this.rw_reminderDay,
    required this.rw_scheduledForDay,
    required this.rw_reminderTime,
    required this.rw_isActive,
  });

  ReminderWorkouts.fromJson(Map<String, dynamic> json)
      : RW_ID = json['RW_ID'],
        UM_ID = json['UM_ID'],
        WS_ID = json['WS_ID'],
        rw_reminderDay = json['rw_reminderDay'],
        rw_scheduledForDay = json['rw_scheduledForDay'],
        rw_reminderTime = json['rw_reminderTime'],
        rw_isActive = json['rw_isActive'];

  Map<String, dynamic> toJson() => {
        'RW_ID': RW_ID,
        'UM_ID': UM_ID,
        'WS_ID': WS_ID,
        'rw_reminderDay': rw_reminderDay,
        'rw_scheduledForDay': rw_scheduledForDay,
        'rw_reminderTime': rw_reminderTime,
        'rw_isActive': rw_isActive,
      };
}
