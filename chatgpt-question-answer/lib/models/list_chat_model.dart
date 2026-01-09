/*class AllChatModel {
  final String id;
  final DateTime start_time;
  // final DateTime update_time;
  final String title;

  AllChatModel({
    required this.id,
    required this.title,
    required this.start_time,
    */ /*required this.update_time*/ /*
  });

  factory AllChatModel.fromJson(Map<String, dynamic> json) => AllChatModel(
        id: json["id"],
        title: json["title"],
        start_time: json["start_time"],
        // update_time: json["update_time"],
      );

  Map<String, Object>? tojson() {
    id:
    id;
    title:
    title;
    start_time:
    start_time;
  }
}*/

final String tableTreads = 'treads';

class AllChatFields {
  static final List<String> values = [
    /// Add all fields
    id, title, start_time, start_date, u_id
  ];

  static final String id = '_id';
  static final String u_id = 'u_id';
  static final String title = 'title';
  static final String start_time = 'time';
  static final String start_date = 'date';
}

class AllChatModel {
  final int? id;
  final String title;
  final String u_id;
  final String createdTime;
  final String createdDate;

  const AllChatModel({
    this.id,
    required this.title,
    required this.u_id,
    required this.createdTime,
    required this.createdDate
  });

  AllChatModel copy({
    int? id,
    String? title,
    String? u_id,
    String? createdTime,
    String? createdDate,
  }) =>
      AllChatModel(
        id: id ?? this.id,
        title: title ?? this.title,
        u_id: u_id ?? this.u_id,
        createdTime: createdTime ?? this.createdTime,
        createdDate: createdDate ?? this.createdDate,
      );

  static AllChatModel fromJson(Map<String, Object?> json) => AllChatModel(
        id: json[AllChatFields.id] as int?,
        title: json[AllChatFields.title] as String,
        u_id: json[AllChatFields.u_id] as String,
        createdTime: json[AllChatFields.start_time] as String,
        createdDate: json[AllChatFields.start_date] as String,
      );

  Map<String, Object?> toJson() => {
        AllChatFields.id: id,
        AllChatFields.title: title,
        AllChatFields.u_id: u_id,
        AllChatFields.start_time: createdTime,
        AllChatFields.start_date: createdDate,
      };
}
