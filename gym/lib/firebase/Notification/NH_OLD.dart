/*

import 'package:flutter/material.dart';

class NotificationHandler {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationChannel channel;

  static void requestPermission() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static void initializeNotificationSettings() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,

    );

    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    print('background notification payload');
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    print('foreground notification payload');
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('1', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    const DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }
}
*/
