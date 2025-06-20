import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:pushy_flutter/pushy_flutter.dart';

import '../utils/shared_preference.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  NotificationService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : auth = auth ?? FirebaseAuth.instance,
      firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> init() async {
    // Initialize Pushy listener
    // await FirebaseMessaging().requestPermission();
    Pushy.listen();

    // Get device token from Pushy and save to Firestore
    final String deviceToken = await Pushy.register();
    debugPrint('Pushy Device Token: $deviceToken');
    await saveDeviceToken(deviceToken);
    // sendPushyNotification(
    //   deviceToken: deviceToken,
    //   title: 'Welcome',
    //   message: 'You have successfully registered for notifications.',
    // );

    // Initialize flutter local notifications
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

    // Register a listener for incoming push notifications
    Pushy.setNotificationListener(onPushNotificationReceived);
  }

  Future<void> saveDeviceToken(String token) async {
    final user = await SharedPreferenceUtils.getUserModel();
    if (user == null) return;

    final docRef = firestore.collection('users').doc(user.id);
    await docRef.update({
      'pushyToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> sendPushyNotification({
    required String deviceToken,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    const String apiKey =
        '9327c489f3791c816bc47cce13dce18e6790d014535a530d2505b29252c91b57';
    final url = Uri.parse('https://api.pushy.me/push?api_key=$apiKey');

    final Map<String, dynamic> payload = {
      'to': deviceToken,
      'data': {
        'title': title,
        'message': message,
        ...?data, // Merge custom data if any
      },
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print('✅ Push sent successfully: ${response.body}');
      return true;
    } else {
      print('❌ Push send failed: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  void onPushNotificationReceived(Map<String, dynamic> data) {
    debugPrint('Received Pushy notification: $data');

    final title = data['title'] ?? 'Notification';
    final message = data['message'] ?? '';

    _showLocalNotification(title, message, data);
  }

  Future<void> _showLocalNotification(
    String title,
    String message,
    Map<String, dynamic> data,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'pushy_channel_id',
      'Pushy Notifications',
      channelDescription: 'Pushy notification channel',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      showWhen: false,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformDetails,
      payload: data.toString(),
    );
  }
}
