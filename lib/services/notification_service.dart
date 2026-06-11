import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_task_app/models/task_api_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Initialiser le service de notifications
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  // Détails de la notification
  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'taskflow_channel',
        'TaskFlow Notifications',
        channelDescription: 'Rappels de tâches TaskFlow',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Programmer une notification pour une tâche
  static Future<void> scheduleTaskNotification(TaskApiModel task) async {
    if (task.dueDate == null || task.id == null) return;

    // Notifier 30 minutes avant l'échéance
    final notifyTime = task.dueDate!.subtract(const Duration(minutes: 30));

    // Ne pas programmer si la date est déjà passée
    if (notifyTime.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      task.id!,
      'Rappel : ${task.title}',
      'Votre tâche est due dans 30 minutes',
      tz.TZDateTime.from(notifyTime, tz.local),
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Annuler la notification d'une tâche
  static Future<void> cancelTaskNotification(int taskId) async {
    await _notifications.cancel(taskId);
  }

  // Annuler toutes les notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Afficher les tâches dont l'échéance approche (dans les prochaines 24h)
  static List<TaskApiModel> getUpcomingTasks(List<TaskApiModel> tasks) {
    final now = DateTime.now();
    final in24h = now.add(const Duration(hours: 24));

    return tasks.where((task) {
      if (task.dueDate == null) return false;
      if (task.color == '#9E9E9E') return false; // Ignorer les tâches terminées
      return task.dueDate!.isAfter(now) && task.dueDate!.isBefore(in24h);
    }).toList();
  }
}