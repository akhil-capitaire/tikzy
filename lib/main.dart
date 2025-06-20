import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

import '../../utils/routes.dart';
import '../../utils/screen_size.dart';
import '../../utils/theme.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeFirebase(); // ✅ Properly awaited
  if (!kIsWeb) await initializePushy(); // ✅ Awaited before runApp

  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    ),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onNotificationResponse,
    onDidReceiveBackgroundNotificationResponse:
        _onBackgroundNotificationResponse,
  );

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    rethrow;
  }
}

Future<void> initializePushy() async {
  try {
    // Start Pushy service and listen for notifications
    Pushy.listen();

    // Register background notification listener
    Pushy.setNotificationListener(backgroundNotificationListener);

    // Optional: Get the device token
    final token = await Pushy.appId;
    debugPrint('Pushy Device Token: $token');
  } catch (e) {
    debugPrint('Pushy initialization error: $e');
    rethrow;
  }
}

void onNotificationResponse(NotificationResponse notificationResponse) {
  // Handle foreground tap
  final payload = notificationResponse.payload;
  debugPrint('Notification tapped: $payload');
}

@pragma('vm:entry-point')
void _onBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) {
  final payload = notificationResponse.payload;
  debugPrint('Background notification tapped: $payload');
}

@pragma('vm:entry-point')
void backgroundNotificationListener(Map<String, dynamic> data) {
  // Handle background message
  debugPrint('Background Pushy notification: $data');
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'tikzy',
      theme: AppTheme.lightTheme.copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      themeMode: ThemeMode.light,
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
