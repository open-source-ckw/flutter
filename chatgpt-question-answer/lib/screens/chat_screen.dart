import 'dart:convert';
import 'dart:developer';
import 'package:chat_gtp/models/list_chat_model.dart';
import 'package:chat_gtp/models/save_chat_model.dart';
import 'package:chat_gtp/providers/list_chats_provider.dart';
import 'package:chat_gtp/providers/save_chat_provider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:chat_gtp/constants/app_constants.dart';
import 'package:chat_gtp/screens/Authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Chats/chats.dart';
import '../constants/api_consts.dart';
import '../constants/constants.dart';
import '../providers/chats_provider.dart';
import '../providers/models_provider.dart';

import 'package:file_picker/file_picker.dart';
import '../widgets/chat_widget.dart';
import '../widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final String t_id;
  const ChatScreen({
    super.key,
    required this.title,
    required this.t_id,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final key = GlobalKey<FormState>();

  bool _isTyping = false;

  TextEditingController textEditingController = TextEditingController();
  TextEditingController audioText = TextEditingController();
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      textEditingController.text = result.recognizedWords;
      _lastWords = result.recognizedWords;
    });
  }

  var text = "";

  Future<String> convertSpeechToText(String filePath) async {
    // const apiKey = apiSecretKey;

    var url = Uri.https("api.openai.com", "v1/audio/transcriptions");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(({"Authorization": "Bearer $API_KEY"}));
    request.fields["model"] = 'whisper-1';
    request.fields["language"] = 'en';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    var newResponse = await http.Response.fromStream(response);
    final responseData = json.decode(newResponse.body);

    return responseData['text'];
  }

  late ModelsProvider modelsProvider;
  late ChatProvider chatProvider;
  late SaveChatProvider saveChatProvider;

  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    // db.open();
    focusNode = FocusNode();
    _initSpeech();

    user;
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    chatProvider.getChatList.clear();
    audioText.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // String _copy = "Copy Me";
  bool isSelected = false;

  List<String> messageList = [];
  // List<bool> selectedList = [];
  // MyDb db = MyDb();

  @override
  Widget build(BuildContext context) {
    modelsProvider = Provider.of<ModelsProvider>(context);
    chatProvider = Provider.of<ChatProvider>(context);
    saveChatProvider = Provider.of<SaveChatProvider>(context);
    // allChatProvider = Provider.of<AllChatProvider>(context);

    // chatProvider.getChatList.clear();
    // Navigator.pop(context);

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(
          '${widget.title.characters.first.toUpperCase()}${widget.title.substring(1)}',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
          PopupMenuButton<int>(
            color: appPrimaryColor,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    "Audio to text converter",
                    style:
                        AppConstants.textStyle15.copyWith(color: Colors.white),
                  )),
            ],
            onSelected: (item) => SelectedItem(context, item),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    reverse: false,
                    controller: _listScrollController,
                    itemCount:
                        chatProvider.getChatList.length, //chatList.length,
                    itemBuilder: (context, index) {
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
                                  msg: chatProvider.getChatList[index]
                                      .msg, // chatList[index].msg,
                                  chatIndex:
                                      chatProvider.getChatList[index].chatIndex,
                                  isSelected: chatProvider.getChatList[index]
                                      .isSelected, //chatList[index].chatIndex,
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
                                    msg: chatProvider.getChatList[index]
                                        .msg, // chatList[index].msg,
                                    chatIndex: chatProvider
                                        .getChatList[index].chatIndex,
                                    isSelected: chatProvider.getChatList[index]
                                        .isSelected, //chatList[index].chatIndex,
                                  ),
                                  // value: chatProvider.getChatList[index].isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      chatProvider.getChatList[index]
                                          .isSelected = value!;
                                      if (chatProvider
                                              .getChatList[index].isSelected ==
                                          true) {
                                        messageList.add(chatProvider
                                            .getChatList[index].msg);
                                      } else {
                                        messageList.remove(chatProvider
                                            .getChatList[index].msg);
                                      }
                                      // _roomController.text = '${item.id}';
                                      // print('${_roomController.text}');
                                    });
                                  },
                                  controlAffinity: chatProvider
                                              .getChatList[index].chatIndex ==
                                          0
                                      ? ListTileControlAffinity.leading
                                      : ListTileControlAffinity.trailing,
                                  value: chatProvider
                                      .getChatList[index].isSelected,
                                ),
                              ),
                      );
                    }),
              ),
              if (_isTyping) ...[
                SpinKitThreeBounce(
                  color: appPrimaryColor,
                  size: 18,
                ),
              ],
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Material(
                  color: appPrimaryColor,
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              focusNode: focusNode,
                              style: TextStyle(
                                  /*fontFamily: "Comici",*/ color:
                                      appPrimaryColor),
                              controller: textEditingController,
                              onSubmitted: (value) async {
                                _lastWords = value;
                                await sendMessageFCT(
                                  modelsProvider: modelsProvider,
                                  chatProvider:
                                      chatProvider, /*allChatProvider: allChatProvider*/
                                );
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: scaffoldBackgroundColor,
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: "How can I help you",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey, /*fontFamily: "Comici"*/
                                  ),
                                  contentPadding: const EdgeInsets.all(10))),
                        ),
                        IconButton(
                            onPressed: _speechToText.isNotListening
                                ? _startListening
                                : _stopListening,
                            icon: Icon(
                              _speechToText.isNotListening
                                  ? Icons.mic_off
                                  : Icons.mic,
                              color: Colors.grey,
                            )),
                        IconButton(
                            onPressed: () async {
                              await sendMessageFCT(
                                modelsProvider: modelsProvider,
                                chatProvider:
                                    chatProvider, /*allChatProvider: allChatProvider*/
                              );
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        converterDialog(context: context);
        break;
    }
  }

  void scrollListToEND() {
    _listScrollController.position.maxScrollExtent;
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
    /*required AllChatProvider allChatProvider*/
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      // var id = Uuid();
      int index = 0;
      String mmm = "";
      DateTime date = DateTime.now();
      bool isSelected = false;
      var formatDate = DateFormat("dd-MM-yyyy");
      var formatTime = DateFormat("kk:mm:a");
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        for (var m in chatProvider.getChatList) {
          index = m.chatIndex;
          mmm = m.msg;
          isSelected = m.isSelected;
        }
        // print("==================================index");
        // print(index);

        final saveChat = SaveChatModel(
          msg: mmm,
          chatIndex: 0,
          t_id: widget.t_id,
          isSelected: isSelected,
          // date: formatDate.format(date),
          // time: formatTime.format(date));
        );
        // Future.delayed(const Duration(microseconds: 1500)).then((value) async {
        MyDb.instance.saveChatsCreate(saveChat);
        // });
        textEditingController.clear();
        focusNode.unfocus();
      });

      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      for (var m in chatProvider.getChatList) {
        index = m.chatIndex;
        mmm = m.msg;
        isSelected = m.isSelected;
      }
      // print("index===================================");
      // print(index);
      final saveChat1 = SaveChatModel(
        msg: mmm,
        chatIndex: 1,
        t_id: widget.t_id,
        isSelected: isSelected,
      );
      // date: formatDate.format(date),
      // time: formatTime.format(date));
      await MyDb.instance.saveChatsCreate(saveChat1);

      // db.db!.rawInsert("INSERT INTO students (msg, index, tId) VALUES (?, ?, ?);",
      //     [mmm, index, widget.t_id]);

      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }

  // loadmsg() {
  //   var uuid = Uuid();
  //   List mkm = [];
  //   if (chatProvider.getChatList.isNotEmpty) {
  //     for (var ms in chatProvider.getChatList) {
  //       mkm.add(ms.msg);
  //     }
  //     setState(() {
  //       allChatProvider.addUserChatTitle(
  //           msg: mkm.join(","), title: widget.title, id: uuid.v4());
  //       // chatProvider.getChatList.clear();
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         backgroundColor: Colors.red.shade500,
  //         content: const Text(
  //           "Please start chat then you can save chat.",
  //           style: TextStyle(color: Colors.white),
  //         )));
  //   }
  // }

  // Language _selectedDropdownLanguage = Languages.english;

  converterDialog({required context}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Convert audio to text',
                            style: AppConstants.textStyle20.copyWith(
                                color: appPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                audioText.clear();
                              },
                              child: const Icon(
                                Icons.clear,
                                size: 17,
                              )),
                        ],
                      ),
                      /*const Text(
                        'Select Languages',
                        style: AppConstants.textStyle15,
                      ),*/
                      /*Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: appPrimaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: LanguagePickerDropdown(
                          initialValue: Languages.english,
                          itemBuilder: _buildDropdownItem,
                          onValuePicked: (Language language) {
                            _selectedDropdownLanguage = language;
                          },
                        ),
                      ),*/

                      AppConstants.authButton(
                          text: 'Upload audio',
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.audio);
                            if (result != null) {
                              //call openai's transcription api
                              convertSpeechToText(result.files.single.path!)
                                  .then((value) {
                                text = value;
                                audioText.text = text;
                              });
                            }
                          },
                          width: MediaQuery.of(context).size.width,
                          textStyle: AppConstants.textStyle15
                              .copyWith(color: Colors.white)),
                      TextFormField(
                        style: AppConstants.textStyle15,
                        controller: audioText,

                        // initialValue: audioFile!.name,
                        maxLines: 5,
                        decoration: AppConstants.authInputDec.copyWith(
                            hintText:
                                'Please upload audio and wait few second for conversion.'),
                      ),
                    ]),
              ),
            );
          });
        }).then((value) {
      setState(() {});
    });
  }
}
