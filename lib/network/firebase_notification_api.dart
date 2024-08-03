import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handelBackgroundMessage(RemoteMessage message) async {
  print('Title ${message.notification?.title}');
  print('body ${message.notification?.body}');
  print('payload ${message.data}');
}

class FirebaseNotificationApi {
  final _firebaseMessing = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Important Notification',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotification = FlutterLocalNotificationsPlugin();

  void handelMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future initLocalNotification() async {
    //const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/pokedex_log');
    const settings = InitializationSettings(android: android);

    await _localNotification.initialize(
      settings,
        onDidReceiveBackgroundNotificationResponse:(payload){
        final message = RemoteMessage.fromMap(jsonDecode(payload as String));
        handelMessage(message);
    }
    );

    final plaform = _localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await plaform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handelMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handelMessage);
    FirebaseMessaging.onBackgroundMessage(handelBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/pokedex_log',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessing.requestPermission();
    final fCMToken = await _firebaseMessing.getToken();
    print('Token: $fCMToken');
    initPushNotification();
    initLocalNotification();
  }
}
