import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  // static final _notificationServicePlugin = FlutterLocalNotificationsPlugin();

  static init() async {
    // _notificationServicePlugin.initialize(InitializationSettings(
    //   android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    // ));
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/res_app_icon',
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ]);
  }

  // static NotificationDetails _notificationDetails() => NotificationDetails(
  //         android: AndroidNotificationDetails(
  //       'channelId',
  //       'channelName',
  //       importance: Importance.defaultImportance,
  //       priority: Priority.defaultPriority,
  //     ));

  // static Future displayNotification({
  //   required int id,
  //   String? title,
  //   String? body,
  //   String? payload,
  // }) async =>
  //     await _notificationServicePlugin.show(
  //       id,
  //       title,
  //       body,
  //       _notificationDetails(),
  //       payload: payload,
  //     );
}
