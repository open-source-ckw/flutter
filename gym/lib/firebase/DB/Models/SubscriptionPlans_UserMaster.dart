class SubscriptionPlansUserMaster {
  String SP_ID;
  String SP_UM_ID;
  String UM_ID;
  String sp_durationin;
  String sp_duration;
  String sp_enddate;
  String sp_startdate;

  SubscriptionPlansUserMaster({
    required this.SP_ID,
    required this.SP_UM_ID,
    required this.UM_ID,
    required this.sp_durationin,
    required this.sp_duration,
    required this.sp_enddate,
    required this.sp_startdate,
  });

  SubscriptionPlansUserMaster.fromJson(Map<String, dynamic> json)
      : SP_ID = json['SP_ID'],
        SP_UM_ID = json['SP_UM_ID'],
        UM_ID = json['UM_ID'],
        sp_durationin = json['sp_durationin'],
        sp_duration = json['sp_duration'],
        sp_enddate = json['sp_enddate'],
        sp_startdate = json['sp_startdate'];

  Map<String, dynamic> toJson() => {
        'SP_ID': SP_ID,
        'SP_UM_ID': SP_UM_ID,
        'UM_ID': UM_ID,
        'sp_durationin': sp_durationin,
        'sp_duration': sp_duration,
        'sp_enddate': sp_enddate,
        'sp_startdate': sp_startdate,
      };

  @override
  String toString() {
    return 'SubscriptionPlansUserMaster{SP_ID: $SP_ID, SP_UM_ID: $SP_UM_ID, UM_ID: $UM_ID, sp_durationin: $sp_durationin, sp_duration: $sp_duration, sp_enddate: $sp_enddate, sp_startdate: $sp_startdate}';
  }
}
