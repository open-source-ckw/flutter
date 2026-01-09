class ScheduledWorkout {
  String SW_ID;
  String UM_ID;
  String REF_ID;
  String REF_TYPE;
  String sw_scheduledDate;
  String sw_scheduledForDate;
  String sw_scheduledTime;
  bool sw_isActive;

  ScheduledWorkout({
    required this.SW_ID,
    required this.UM_ID,
    required this.REF_ID,
    required this.REF_TYPE,
    required this.sw_scheduledDate,
    required this.sw_scheduledForDate,
    required this.sw_scheduledTime,
    required this.sw_isActive,
  });

  @override
  String toString() {
    return 'ScheduledWorkout{SW_ID: $SW_ID, UM_ID: $UM_ID, REF_ID: $REF_ID, REF_TYPE: $REF_TYPE, sw_scheduledDate: $sw_scheduledDate, sw_scheduledForDate: $sw_scheduledForDate, sw_scheduledTime: $sw_scheduledTime, sw_isActive: $sw_isActive}';
  }

  ScheduledWorkout.fromJson(Map<String, dynamic> json)
      : SW_ID = json['SW_ID'],
        UM_ID = json['UM_ID'],
        REF_ID = json['REF_ID'],
        REF_TYPE = json['REF_TYPE'],
        sw_scheduledDate = json['sw_scheduledDate'],
        sw_scheduledForDate = json['sw_scheduledForDate'],
        sw_scheduledTime = json['sw_scheduledTime'],
        sw_isActive = json['sw_isActive'];

  Map<String, dynamic> toJson() => {
        'SW_ID': SW_ID,
        'UM_ID': UM_ID,
        'REF_ID': REF_ID,
        'REF_TYPE': REF_TYPE,
        'sw_scheduledDate': sw_scheduledDate,
        'sw_scheduledForDate': sw_scheduledForDate,
        'sw_scheduledTime': sw_scheduledTime,
        'sw_isActive': sw_isActive
      };
}
