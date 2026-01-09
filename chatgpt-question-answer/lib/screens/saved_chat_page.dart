import 'dart:developer';

import 'package:chat_gtp/Chats/chats.dart';
import 'package:chat_gtp/models/save_chat_model.dart';

import 'package:chat_gtp/providers/save_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/models_provider.dart';
import '../widgets/chat_widget.dart';
import '../widgets/text_widget.dart';
import 'package:share_plus/share_plus.dart';

class SaveChatPage extends StatefulWidget {
  final String title;
  final int t_id;
  const SaveChatPage({Key? key, required this.title, required this.t_id})
      : super(key: key);

  @override
  State<SaveChatPage> createState() => _SaveChatPageState();
}

class _SaveChatPageState extends State<SaveChatPage> {
  late ScrollController _listScrollController;
  // late ChatProvider chatProvider;
  late ModelsProvider modelsProvider;
  late SaveChatProvider saveChatProvider;
  late FocusNode focusNode;
  bool isSelected = false;
  // MyDb myDb = MyDb();
  String t_id = "";
  int i = 0;

  // SaveChatModel? saveChats;
  List<SaveChatModel> listChats = [];
  loadChatsData() async {
    // print("-=-=-saveChats");
    // print(saveChats);
    listChats = await MyDb.instance.readSaveChatById(widget.t_id);
    setState(() {
      // save.add(saveChats!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listScrollController = ScrollController();
    focusNode = FocusNode();
    loadChatsData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listScrollController.dispose();
    focusNode.dispose();
    // MyDb.instance.close();
  }

  void scrollListToEND() {
    _listScrollController.position.maxScrollExtent;
  }

  List<String> items = [];
  List<String> messageList = [];

  @override
  Widget build(BuildContext context) {
    // chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.title.characters.first.toUpperCase()}${widget.title.substring(1)}',
            // style: TextStyle(fontFamily: "Comici"),
          ),
          actions: [
            isSelected == true
                ? IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      if (messageList.isNotEmpty) {
                        Share.share(messageList.join(","));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red.shade500,
                            content: const Text(
                              "Chat is not selected yet.Please select chat and share.",
                              style: TextStyle(color: Colors.white),
                            )));
                      }
                    },
                  )
                : Container(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    reverse: false,
                    controller: _listScrollController,
                    itemCount: listChats.length, //chatList.length,
                    itemBuilder: (context, index) {
                      // print(listChats[index].msg.toString());
                      return InkWell(
                        onLongPress: () {
                          setState(() {
                            isSelected = true;
                          });
                        },
                        child: isSelected == false
                            ? ListTile(
                                // activeColor: appPrimaryColor,
                                contentPadding: EdgeInsets.zero,
                                // checkboxShape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                title: ChatWidget(
                                  // user: widget.user,
                                  msg: listChats[index]
                                      .msg, // chatList[index].msg,
                                  chatIndex: listChats[index].chatIndex,
                                  isSelected:
                                  listChats[index].isSelected, //chatList[index].chatIndex,
                                ),

                                // value: chatProvider.getChatList[index].isSelected,
                              )
                            : InkWell(
                                onLongPress: () {
                                  setState(() {
                                    isSelected = false;
                                  });
                                },
                                child: CheckboxListTile(
                                  activeColor: appPrimaryColor,
                                  contentPadding: EdgeInsets.zero,
                                  checkboxShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  title: ChatWidget(
                                    // user: widget.user,
                                    msg: listChats[index]
                                        .msg, // chatList[index].msg,
                                    chatIndex: listChats[index].chatIndex,
                                    isSelected:
                                    listChats[index].isSelected, //chatList[index].chatIndex,
                                  ),
                                  // value: chatProvider.getChatList[index].isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      listChats[index].isSelected = value!;
                                      if (listChats[index].isSelected == true) {
                                        messageList.add(listChats[index].msg);
                                      } else {
                                        messageList
                                            .remove(listChats[index].msg);
                                      }
                                      // _roomController.text = '${item.id}';
                                      // print('${_roomController.text}');
                                    });
                                  },
                                  controlAffinity:
                                      listChats[index].chatIndex == 0
                                          ? ListTileControlAffinity.leading
                                          : ListTileControlAffinity.trailing,
                                  value: listChats[index].isSelected,
                                ),
                              ),
                      );
                    }),
              ),
              // saveChats != null
              //     ? ChatWidget(
              //         // user: widget.user,
              //         msg: saveChats!.mgs, // chatList[index].msg,
              //         chatIndex: saveChats!.chatIndex,
              //         isSelected: isSelected, //chatList[index].chatIndex,
              //       )
              //     : Container(),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }
}
