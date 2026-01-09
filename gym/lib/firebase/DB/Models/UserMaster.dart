class UserMaster {
  String UM_ID;
  String um_activityinterest;
  String um_email;
  String um_image;
  String um_dob;
  String um_gender;
  double um_goalweight;
  String um_goalweightin;
  String um_weightin;
  double um_height;
  String um_heightin;
  bool um_isapplehealth;
  bool um_isdarkmode;
  bool um_ispinlock;
  String um_maingoal;
  String um_name;
  String um_phone;
  String um_traininglevel;
  double um_weight;

  UserMaster(
      {required this.UM_ID,
      required this.um_activityinterest,
      required this.um_email,
      required this.um_image,
      required this.um_dob,
      required this.um_gender,
      required this.um_goalweight,
      required this.um_goalweightin,
      required this.um_weightin,
      required this.um_heightin,
      required this.um_isapplehealth,
      required this.um_height,
      required this.um_isdarkmode,
      required this.um_ispinlock,
      required this.um_maingoal,
      required this.um_name,
      required this.um_phone,
      required this.um_traininglevel,
      required this.um_weight});

  UserMaster.fromJson(Map<String, dynamic> json)
      : UM_ID = json['UM_ID'] ?? "",
        um_activityinterest = json['um_activityinterest'] ?? '',
        um_email = json['um_email'],
        um_image = json['um_image'] ?? '',
        um_dob = json['um_dob'] ?? '',
        um_gender = json['um_gender'] ?? '',
        um_goalweight = double.parse(json['um_goalweight'].toString()),
        um_goalweightin = json['um_goalweightin'] ?? 'kg',
        um_weightin = json['um_weightin'] ?? 'kg',
        um_height = double.parse(json['um_height'].toString()),
        um_heightin = json['um_heightin'] ?? 'cm',
        um_isapplehealth = json['um_isapplehealth'] ?? false,
        um_isdarkmode = json['um_isdarkmode'] ?? false,
        um_ispinlock = json['um_ispinlock'] ?? false,
        um_maingoal = json['um_maingoal'] ?? '',
        um_name = json['um_name'],
        um_phone = json['um_phone'],
        um_traininglevel = json['um_traininglevel'] ?? '',
        um_weight = double.parse(json['um_weight'].toString());

  Map<String, dynamic> toJson() => {
        'UM_ID': UM_ID,
        'um_activityinterest': um_activityinterest,
        'um_email': um_email,
        'um_image': um_image,
        'um_dob': um_dob,
        'um_gender': um_gender,
        'um_goalweight': um_goalweight,
        'um_goalweightin': um_goalweightin,
        'um_weightin': um_weightin,
        'um_height': um_height,
        'um_heightin': um_heightin,
        'um_isapplehealth': um_isapplehealth,
        'um_isdarkmode': um_isdarkmode,
        'um_ispinlock': um_ispinlock,
        'um_maingoal': um_maingoal,
        'um_name': um_name,
        'um_phone': um_phone,
        'um_traininglevel': um_traininglevel,
        'um_weight': um_weight
      };

  @override
  String toString() {
    return 'UserMaster{UM_ID: $UM_ID, um_activityinterest: $um_activityinterest, um_email: $um_email, um_image: $um_image, um_dob: $um_dob, um_gender: $um_gender, um_goalweight: $um_goalweight, um_goalweightin: $um_goalweightin, um_weightin: $um_weightin, um_height: $um_height, um_heightin: $um_heightin, um_isapplehealth: $um_isapplehealth, um_isdarkmode: $um_isdarkmode, um_ispinlock: $um_ispinlock, um_maingoal: $um_maingoal, um_name: $um_name, um_phone: $um_phone, um_traininglevel: $um_traininglevel, um_weight: $um_weight}';
  }
}
