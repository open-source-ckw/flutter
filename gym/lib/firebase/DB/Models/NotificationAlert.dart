class NotificationAlert {
  String NA_ID;
  String UM_ID;
  String na_refType;
  String na_refId;
  String na_refImage;
  String na_adt;

  NotificationAlert({
    required this.NA_ID,
    required this.UM_ID,
    required this.na_refType,
    required this.na_refId,
    required this.na_refImage,
    required this.na_adt,
  });

  NotificationAlert.fromJson(Map<String, dynamic> json)
      : NA_ID = json['NA_ID'] ?? "",
        UM_ID = json['UM_ID'] ?? "",
        na_refType = json['na_refType'] ?? "",
        na_refId = json['na_refId'] ?? "",
        na_refImage = json['na_refImage'] ?? "",
        na_adt = json['na_adt'] ?? "";

  Map<String, dynamic> toJson() => {
        'NA_ID': NA_ID,
        'UM_ID': UM_ID,
        'na_refType': na_refType,
        'na_refId': na_refId,
        'na_refImage': na_refImage,
        'na_adt': na_adt
      };
}
