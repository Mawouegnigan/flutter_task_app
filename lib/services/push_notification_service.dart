import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Handler pour les messages reçus en arrière-plan
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Message reçu en arrière-plan : ${message.notification?.title}');
}

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Demander la permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handler arrière-plan
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialiser les notifications locales
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotifications.initialize(const InitializationSettings(android: android));

    // Créer le canal de notification Android
    const channel = AndroidNotificationChannel(
      'taskflow_channel',
      'TaskFlow Notifications',
      description: 'Notifications de TaskFlow',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation
            <AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Écouter les messages quand l'app est au premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'taskflow_channel',
              'TaskFlow Notifications',
              channelDescription: 'Notifications de TaskFlow',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // Récupérer le token FCM
    final token = await _messaging.getToken();
    print('FCM Token: $token');
  }

  // Récupérer le token de l'appareil
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}