import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Util/Constants.dart';
import '../firebase/DB/Models/NotificationAlert.dart';
import '../firebase/DB/Models/UserMaster.dart';
import '../firebase/DB/Repo/NotificationAlertRepository.dart';
import '../firebase/DB/Repo/UserRepository.dart';
import '../firebase/Storage/StorageHandler.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../local/localization/language_constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static const String route = "Notification";

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  StorageHandler storageHandler = StorageHandler();

  UserMaster? userMaster;
  List<NotificationAlert> notificationAlertList = [];

  UserRepository userRepository = UserRepository();
  NotificationAlertRepository notificationAlertRepository =
      NotificationAlertRepository();

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userMaster = await userRepository.getUserFromId(uid: user.uid);
    }
  }

  Future<void> loadUserNotificationAlert() async {
    // userWorkouts.clear();
    await loadUser();
    // DateTime now = DateTime.now();
    notificationAlertList.clear();
    List<NotificationAlert> tempNotificationAlertList =
        await notificationAlertRepository.getAllNotificationAlertFromUserId(
            uid: userMaster!.UM_ID);
    for (var userNotificationAlert in tempNotificationAlertList) {
      if (!notificationAlertList.contains(userNotificationAlert)) {
        notificationAlertList.add(userNotificationAlert);
      }
    }
    notificationAlertList = notificationAlertList.toList();
    context.loaderOverlay.hide();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    loadUserNotificationAlert();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.loaderOverlay.show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.blue.shade50.withOpacity(0.9),
      useDefaultLoading: false,
      closeOnBackButton: false,
      overlayWholeScreen: true,
      overlayWidget: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset('assets/images/loader3-unscreen.gif'))),
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Text(
            "${getTranslated(context, 'notification')}",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline5!.color),
          ),
          elevation: 0.0,
          // backgroundColor: Colors.transparent,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: notificationAlertList.length,
              itemBuilder: (context, index) {
                NotificationAlert notify =
                    notificationAlertList.elementAt(index);

                return getNotificationContainer(
                    image: notify.na_refImage,
                    heading: notify.na_refType,
                    subText: notify.na_adt,
                    icon: Icons.arrow_forward_ios,
                    onTap: () {});
              }),
        ),
      ),
    );
  }

  Widget getDateTag(DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0),
      child: Row(
        children: [
          Expanded(
              child:
                  Text(DateFormat('MMMM, dd yyyy').format(date).toUpperCase()))
        ],
      ),
    );
  }

  Widget getNotificationContainer(
      {required String image,
      required String heading,
      required String subText,
      required IconData icon,
      required dynamic onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListTile(
        tileColor: Theme.of(context).disabledColor.withOpacity(0.11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          // side: BorderSide(
          //     color: Colors.grey
          //         .withOpacity(0.3))
        ),
        minVerticalPadding: 15.0,
        isThreeLine: true,
        leading: ClipRRect(
          // height: 50.0,
          // width: 75.0,
          borderRadius: BorderRadius.circular(15.0),
          child: FutureBuilder(
            future: storageHandler.getImageUrl(image),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return CachedNetworkImage(
                imageUrl: snapshot.data != null && snapshot.data != ''
                    ? snapshot.data!
                    : Constants.loaderUrl,
                fit: BoxFit.fill,
                width: 90,
                height: 80,
              );
            },
            initialData: Constants.loaderUrl,
          ),
        ),
        trailing: IconButton(onPressed: onTap, icon: Icon(icon)),
        title: Row(
          children: [Expanded(child: Text(heading))],
        ),
        subtitle: Row(
          children: [
            Text(
              subText,
              style: TextStyle(
                  // color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 13.0),
            )
          ],
        ),
      ),
    );
  }
}
