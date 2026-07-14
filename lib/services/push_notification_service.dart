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
      'Yoon Notifications',
      description: 'Notifications de Yoon',
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
              'Yoon Notifications',
              channelDescription: 'Notifications de Yoon',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // Récupérer le token FCM
    try {
      final token = await _messaging.getToken();
      print('FCM Token: $token');
    } catch (e) {
      print('FCM token indisponible (émulateur sans Google Play ?) : $e');
    }
  }

  // Récupérer le token de l'appareil
  static Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('FCM token indisponible : $e');
      return null;
    }
  }
}