import 'package:chat_gtp/Chats/chats.dart';
import 'package:chat_gtp/models/list_chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllChatProvider with ChangeNotifier {
  var uuid = Uuid();

  // MyDb db = MyDb();

  List<AllChatModel> allChatList = [];
  List<AllChatModel> get getChatList {
    return allChatList;
  }

/*  addUserChatTitle({
    // required String id,
    required String title,
    */ /*required DateTime update_time*/ /*
  }) async {
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


    MyDb.treadCreate(AllChatModel(
      // id: id,
      title: title,
      createdTime: DateTime.now(),
      // update_time: DateTime.now(),
    ));
    // allChatList.add(AllChatModel(
    //   id: id,
    //   title: title,
    //   createdTime: DateTime.now(),
    //   // update_time: DateTime.now(),
    // ));

    notifyListeners();
  }*/

  Future addTreated({required String title,required String id}) async {
    final treads = AllChatModel(
      title: title,
      createdTime: DateTime.now().toString(),
      createdDate: DateTime.now().toString(), u_id: id,
    );

    await MyDb.instance.treadCreate(treads);
    notifyListeners();
  }

  /*void removeUserMessage(*/ /*{required String msg}*/ /*) {
    chatList.clear();
    notifyListeners();
  }*/

  // Future<void> sendMessageAndGetAnswers(
  //     {required String msg, required String chosenModelId}) async {
  //   allChatList.addAll(await ApiService.sendMessage(
  //     message: msg,
  //     modelId: chosenModelId,
  //   ));
  //   notifyListeners();
  // }
}
