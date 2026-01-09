// import 'dart:async';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
//
// class NotificationController {
//   static late Timer timer;
//
//   static void initialize() {
//     AwesomeNotifications().initialize(
//         // set the icon to null if you want to use the default app icon
//         //   "resource://drawable/1.jpg",
//         null,
//         [
//           NotificationChannel(
//               // icon: "resource://drawable/1.jpg",
//               channelGroupKey: 'basic_channel_group',
//               channelShowBadge: true,
//               channelKey: 'basic_channel',
//               channelName: 'Basic notifications',
//               channelDescription: 'Notification channel for basic tests',
//               defaultColor: const Color(0xFF9D50DD),
//               ledColor: Colors.white),
//         ],
//         // Channel groups are only visual and are not required
//         channelGroups: [
//           NotificationChannelGroup(
//               channelGroupKey: 'basic_channel_group',
//               channelGroupName: 'Basic group'),
//         ],
//         debug: true);
//   }
//
//   /*@pragma("vm:entry-point")
//   static Future<void> onActionReceivedMethod(BuildContext context,ReceivedAction receivedAction)async{
//     print('onActionReceivedMethod');
//     print(receivedAction.toString());
//   }
//   @pragma("vm:entry-point")
//   static Future<void>  onNotificationCreatedMethod(BuildContext context,ReceivedNotification receivedNotification)async{
//     print('onNotificationCreatedMethod');
//     print(receivedNotification.toString());
//
//
//   }
//   @pragma("vm:entry-point")
//   static Future<void>  onNotificationDisplayedMethod(BuildContext context,ReceivedNotification receivedNotification)async{
//     print('onNotificationDisplayedMethod');
//     print(receivedNotification.toString());
//
//   }
//   @pragma("vm:entry-point")
//   static Future<void>  onDismissActionReceivedMethod(BuildContext context,ReceivedAction receivedAction)async{
//     print('onDismissActionReceivedMethod');
//     print(receivedAction.toString());
//
//
//   }*/
//   @pragma("vm:entry-point")
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // print('onActionReceivedMethod');
//     // print(receivedAction.toString());
//   }
//
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {
//     // print('onNotificationCreatedMethod');
//     // print(receivedNotification.toString());
//   }
//
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     // print('onNotificationDisplayedMethod');
//     // print(receivedNotification.toString());
//   }
//
//   @pragma("vm:entry-point")
//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     // print('onDismissActionReceivedMethod');
//     // print(receivedAction.toString());
//   }
//
//   static void requestPermission() {
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       /*print('----- isAllowed -----');
//       print(isAllowed);*/
//       if (!isAllowed) {
//         //print('---------');
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//   }
//
//   static void showNotification() {
//     AwesomeNotifications().createNotification(
//         content: NotificationContent(
//       // icon: "resource://drawable/1.jpg",
//       bigPicture:
//           'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//       largeIcon:
//           'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//       id: 10,
//       channelKey: 'basic_channel',
//       title: 'Simple Notification',
//       body: 'Simple body',
//       actionType: ActionType.Default,
//       // notificationLayout: NotificationLayout.BigPicture,
//       fullScreenIntent: true,
//       displayOnBackground: true,
//       displayOnForeground: true,
//       // category: NotificationCategory.Alarm,
//     ));
//     // timer = Timer.periodic(const Duration(seconds: 1), (Timer timer2) {
//     //   if(timer2.tick==15) {
//     //     timer.cancel();
//     //   }
//     //   AwesomeNotifications().createNotification(
//     //       content: NotificationContent(
//     //         // icon: "resource://drawable/1.jpg",
//     //         bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//     //         largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//     //         id: 10,
//     //         channelKey: 'basic_channel',
//     //         title: 'Simple Notification',
//     //         body: 'Simple body ${timer2.tick}',
//     //         actionType: ActionType.Default,
//     //         notificationLayout: NotificationLayout.BigText,
//     //
//     //       )
//     //   );
//     // });
//   }
// }
