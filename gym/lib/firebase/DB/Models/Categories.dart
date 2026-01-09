class Categories {
  String CS_ID;
  String cs_name;

  @override
  String toString() {
    return 'Categories{CS_ID: $CS_ID, cs_name: $cs_name, cs_type: $cs_type, cs_image: $cs_image}';
  }

  String cs_type;
  String cs_image;

  Categories({
    required this.CS_ID,
    required this.cs_name,
    required this.cs_type,
    required this.cs_image,
  });

  Categories.fromJson(Map<String, dynamic> json)
      : CS_ID = json['CS_ID'] ?? "",
        cs_name = json['cs_name'] ?? "",
        cs_type = json['cs_type'] ?? "",
        cs_image = json['cs_image'] ?? "";

  Map<String, dynamic> toJson() => {
        'CS_ID': CS_ID,
        'cs_name': cs_name,
        'cs_type': cs_type,
        'cs_image': cs_image
      };
}
