import 'package:chat_gtp/models/save_chat_model.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../services/api_service.dart';
import 'list_chats_provider.dart';

class SaveChatProvider with ChangeNotifier {
  List<SaveChatModel> chatList = [];
  List<SaveChatModel> saveChatList = [];
  List<SaveChatModel> get getChatList {
    return chatList;
  }

  List<SaveChatModel> get getSaveList {
    return saveChatList;
  }

  List<SaveChatModel> getAllSaveChat({required String id}) {
    saveChatList = chatList.where((element) => element.t_id == id).toList();
    return saveChatList;
  }

  addUserMessage(
      {required String msg, required int id, required String t_id,required int index,/*required String date, required String time*/}) {
    chatList.add(SaveChatModel(
      msg: msg,
      id: id,
      isSelected: false,
      chatIndex: index,
      t_id: t_id,
      // date: date,
      // time: time,
    ));
    notifyListeners();
  }

  /*void removeUserMessage(*/ /*{required String msg}*/ /*) {
    chatList.clear();
    notifyListeners();
  }*/

  // Future<void> sendMessageAndGetAnswers(
  //     {required String msg,
  //     required String chosenModelId,
  //     required String t_id,
  //     required String date,
  //     required String time,
  //     required int id}) async {
  //   chatList.addAll(await ApiService.sendSaveMessage(
  //     message: msg,
  //     modelId: chosenModelId,
  //     id: id,
  //     t_id: t_id,
  //   ));
  //   notifyListeners();
  // }
}
