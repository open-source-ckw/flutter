class User_Fav {
  String FAV_ID;
  String UM_ID;
  String REF_ID;
  String REF_Type;

  User_Fav(
      {required this.FAV_ID,
      required this.UM_ID,
      required this.REF_ID,
      required this.REF_Type});

  User_Fav.fromJson(Map<String, dynamic> json)
      : FAV_ID = json['FAV_ID'],
        UM_ID = json['UM_ID'],
        REF_ID = json['REF_ID'],
        REF_Type = json['REF_Type'];

  Map<String, dynamic> toJson() => {
        'FAV_ID': FAV_ID,
        'UM_ID': UM_ID,
        'REF_ID': REF_ID,
        'REF_Type': REF_Type,
      };

  @override
  String toString() {
    return 'User_Fav{FAV_ID: $FAV_ID, UM_ID: $UM_ID, REF_ID: $REF_ID, REF_Type: $REF_Type}';
  }
}
