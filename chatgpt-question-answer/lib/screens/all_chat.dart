import 'package:chat_gtp/constants/app_constants.dart';
import 'package:chat_gtp/models/save_chat_model.dart';
import 'package:chat_gtp/providers/save_chat_provider.dart';
import 'package:chat_gtp/screens/chat_screen.dart';
import 'package:chat_gtp/screens/saved_chat_page.dart';
import 'package:flutter/material.dart';

import '../Chats/chats.dart';
import '../constants/constants.dart';
import '../models/list_chat_model.dart';
import '../providers/list_chats_provider.dart';
import '../services/assets_manager.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Authentication/login_page.dart';

class AllChatPage extends StatefulWidget {
  const AllChatPage({Key? key}) : super(key: key);
  @override
  State<AllChatPage> createState() => _AllChatPageState();
}

class _AllChatPageState extends State<AllChatPage> {
  late AllChatProvider allChatProvider;
  late SaveChatProvider saveChatProvider;
  final _forMKey = GlobalKey<FormState>();

  List<AllChatModel> treads = [];

  loadData() async {
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      treads = await MyDb.instance.readAllTreads(user.uid);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadData();
    // loadChatsData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // MyDb.instance.close();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    loadData();
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(AssetsManager.openaiLogo)),
        ),
        title: const Text("Talk AI - Chat with bot",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(/*fontFamily: "Comici"*/)),
        actions: [
          PopupMenuButton<int>(
            color: appPrimaryColor,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          "Logout",
                          style: AppConstants.textStyle15.copyWith(
                            color: Colors.white, /*fontFamily: "Comici"*/
                          ),
                        ),
                      ),
                      Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      )
                    ],
                  )),
              PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          "Delete",
                          style: AppConstants.textStyle15.copyWith(
                            color: Colors.white, /*fontFamily: "Comici"*/
                          ),
                        ),
                      ),
                      Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      )
                    ],
                  )),
            ],
            onSelected: (item) => SelectedItem(context, item),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.appPrimaryColor,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Form(
                  key: _forMKey,
                  child: AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Add title for chat",
                          // style: TextStyle(fontFamily: "Comici"),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear))
                      ],
                    ),
                    content: TextFormField(
                      controller: titleController,
                      // style: TextStyle(fontFamily: "Comici"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: AppConstants.authInputDec.copyWith(
                        hintText: "Title",
                        // hintStyle: TextStyle(fontFamily: "Comici"),
                      ),
                    ),
                    actions: [
                      AppConstants.authButton(
                          text: "Start",
                          onTap: () async {
                            var id = FirebaseAuth.instance.currentUser!.uid;

                            // var formatTime = DateFormat("kk:mm:a");
                            var formatTime = DateFormat("h:mm a");
                            var formatDate = DateFormat("dd MMM yyyy");
                            var now = DateTime.now();

                            if (_forMKey.currentState!.validate()) {
                              final treads = AllChatModel(
                                title: titleController.text.trim(),
                                createdTime: formatTime.format(now),
                                createdDate: formatDate.format(now),
                                u_id: id,
                              );

                              await MyDb.instance
                                  .treadCreate(treads)
                                  .then((value) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                              title: value.title,
                                              t_id: value.id.toString(),
                                            )));
                              });
                            }
                          },
                          width: MediaQuery.of(context).size.width * 0.3,
                          textStyle: const TextStyle(
                              /*fontFamily: "Comici",*/ color: Colors.white)),
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
            itemCount: treads.length,
            itemBuilder: (context, index) {
              return Slidable(
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      // An action can be bigger than the others.
                      flex: 1,
                      onPressed: (BuildContext context) async {
                        await MyDb.instance
                            .deleteTread(id: treads[index].id!)
                            .then((value) async {
                          await MyDb.instance
                              .deleteAllSaveChat(id: treads[index].id!);
                        });
                        setState(() {});
                      },
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Card(
                    elevation: 6,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), /*side: BorderSide(color: appPrimaryColor)*/
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      onTap: () async {
                        // saveChatProvider.getAllSaveChat(
                        //     id: allChatProvider.getChatList[index].id.toString());
                        //
                        // print("-=-=-=-=--=-=-=-=treads[index].id");
                        // print(treads[index].id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaveChatPage(
                                      t_id: treads[index].id!,
                                      title: treads[index].title,
                                    )));
                        // setState(() {
                        //
                        // });
                      },
                      // tileColor: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(20),
                      // side: BorderSide(color: appPrimaryColor)),
                      // contentPadding: EdgeInsets.all(10),
                      title: Text(
                        '${treads[index].title.characters.first.toUpperCase()}${treads[index].title.substring(1)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700, /*fontFamily: "Comici"*/
                        ),
                        overflow: TextOverflow.ellipsis,
                        // maxLines: 1,
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          treads[index].createdTime.toString(),
                          style: TextStyle(
                            color: Colors.grey, /*fontFamily: "Comici"*/
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      leading: CircleAvatar(
                        maxRadius: 37,
                        backgroundColor: appPrimaryColor,
                        // decoration: BoxDecoration(
                        //     color: scaffoldBackgroundColor,
                        //     borderRadius: BorderRadius.circular(70),
                        //     border: Border(
                        //         top: BorderSide(color: appPrimaryColor),
                        //         bottom: BorderSide(color: appPrimaryColor),
                        //         right: BorderSide(color: appPrimaryColor),
                        //         left: BorderSide(color: appPrimaryColor))),
                        // width: 70.0,
                        // height: 70.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(treads[index].createdDate.substring(0, 2),
                                style: TextStyle(
                                    // fontFamily: "Comici",
                                    fontSize: 15,
                                    color: Colors.white)),
                            Text(treads[index].createdDate.substring(2, 6),
                                style: TextStyle(
                                    // fontFamily: "Comici",
                                    fontSize: 15,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        logOutDialog(
            context: context,
            yesOnTap: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              });
            },
            noOnTap: () {
              Navigator.pop(context);
            },
            text: "Are you sure you want to logout?",
            title: "Logout");
        break;
      case 1:
        logOutDialog(
            context: context,
            yesOnTap: () async {
              deleteAccount();
            },
            noOnTap: () {
              Navigator.pop(context);
            },
            text: "Are you sure you want to delete the account ?",
            title: "Delete Account");
        break;
    }
  }

  Future<void> deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;

    await user!.delete().then((value) async {
      // await MyDb.instance.deleteSaveChat();
      await MyDb.instance.deleteTreads(user.uid);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    });
  }
}
