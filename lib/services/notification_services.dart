import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/shared_preference.dart';

class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  NotificationService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : auth = auth ?? FirebaseAuth.instance,
      firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> init() async {
    await firebaseMessaging.requestPermission();

    if (Platform.isIOS) {
      firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      await firebaseMessaging.getAPNSToken();
    }
    String? token = await firebaseMessaging.getToken();

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showBackgroundNotification(message);
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    NotificationService().showBackgroundNotification(message);
  }

  sendFCM(String token) async {
    final user = await SharedPreferenceUtils.getUserModel();
    if (user == null) return;

    final docRef = firestore.collection('users').doc(user.id);

    await docRef.update({
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> showNotification(String data) async {
    try {
      data = data.substring(1, data.length - 1);

      // Split the string by commas to separate the key-value pairs
      List<String> pairs = data.split(', ');

      // Create a map to store the key-value pairs
      Map<String, String> parsedData = {};

      // Iterate through each pair
      for (var pair in pairs) {
        // Split each pair into key and value
        var keyValue = pair.split(': ');
        if (keyValue.length == 2) {
          parsedData[keyValue[0].toString()] = keyValue[1].toString();
        }
      }
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            '',
            'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            showWhen: false,
          );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        "${parsedData['sender_name']}",
        "${parsedData['message']}",
        platformChannelSpecifics,
        payload: '${parsedData['conversation']}',
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> showBackgroundNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            '',
            'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            showWhen: false,
          );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: 'item x',
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
