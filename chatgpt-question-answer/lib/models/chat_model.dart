class ChatModel {
  final String msg;
  final int chatIndex;
  bool isSelected;

  ChatModel({
    required this.msg,
    required this.chatIndex,
    required this.isSelected,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        msg: json["msg"],
        chatIndex: json["chatIndex"],
        isSelected: json["chatSelected"],
        // id: json["id"],
      );
}
