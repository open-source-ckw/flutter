/*class SaveChatModel {
  final String id;
  final String t_id;
  final String msg;
  final int chatIndex;
  // bool isSelected;

  SaveChatModel({
    required this.id,
    required this.msg,
    required this.t_id,
    required this.chatIndex,
    // required this.isSelected,
  });

  factory SaveChatModel.fromJson(Map<String, dynamic> json) => SaveChatModel(
        msg: json["msg"],
        chatIndex: json["chatIndex"],
        // isSelected: json["chatSelected"],
        id: json["id"],
        t_id: json["t_id"],
      );
}*/

final String tableSaveChat = 'savechats';

class SaveChatsFields {
  static final List<String> values = [
    /// Add all fields
    id, msg, t_id, chatIndex, isSelected
  ];

  static final String id = '_id';
  static final String msg = 'msg';
  static final String t_id = 't_id';
  static final String chatIndex = 'chatIndex';
  static final String isSelected = 'isSelected';
}

class SaveChatModel {
  final int? id;
  final String msg;
  final String t_id;
  final int chatIndex;
  bool isSelected;
  // final String date;
  // final String time;

  SaveChatModel(
      {this.id,
      required this.msg,
      required this.chatIndex,
      required this.t_id,
      required this.isSelected
      // required this.date,
      // required this.time
      });

  SaveChatModel copy(
          {int? id, int? chatIndex, String? msg, String? t_id, bool? isSelected
          // String? date,
          // String? time,
          }) =>
      SaveChatModel(
        id: id ?? this.id,
        chatIndex: chatIndex ?? this.chatIndex,
        msg: msg ?? this.msg,
        t_id: t_id ?? this.t_id,
        isSelected: isSelected ?? this.isSelected,

        // date: date ?? this.date,
        // time: time ?? this.time,
      );

  static SaveChatModel fromJson(Map<String, dynamic> json) => SaveChatModel(
        id: json[SaveChatsFields.id] as int?,
        chatIndex: json[SaveChatsFields.chatIndex] as int,
        msg: json[SaveChatsFields.msg] as String,
        t_id: json[SaveChatsFields.t_id] as String,
        isSelected: json[SaveChatsFields.isSelected] == 1,
        // date: json[SaveChatsFields.date] as String,
        // time: json[SaveChatsFields.time] as String,
      );

  static List<SaveChatModel> listOfSaveChats(List<dynamic> listData) {
    List<SaveChatModel> returenListData = [];

    for (var list in listData) {
      // print(list);
      returenListData.add(SaveChatModel(
        id: list._id,
        chatIndex: list.chatIndex,
        msg: list.msg,
        t_id: list.t_id,
        isSelected: list.isSelected,
        // date: list.date,
        // time: list.time,
      ));
    }
    return returenListData;
  }

  Map<String, Object?> toJson() => {
        SaveChatsFields.id: id,
        SaveChatsFields.msg: msg,
        SaveChatsFields.t_id: t_id,
        SaveChatsFields.chatIndex: chatIndex,
        SaveChatsFields.isSelected: isSelected ? 1 : 0
        // SaveChatsFields.date: date,
        // SaveChatsFields.time: time,
      };
}
