import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_task_app/models/task_api_model.dart';

class CacheService {
  static const String _boxName = 'tasks_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_boxName);
  }

  static Future<void> cacheTasks(List<TaskApiModel> tasks) async {
    final box = Hive.box<Map>(_boxName);
    await box.clear();
    for (final task in tasks) {
      await box.put(task.id.toString(), task.toJson());
    }
  }

  static List<TaskApiModel> getCachedTasks() {
    final box = Hive.box<Map>(_boxName);
    return box.values
        .map((map) => TaskApiModel.fromJson(Map<String, dynamic>.from(map)))
        .toList();
  }

  static Future<void> clear() async {
    final box = Hive.box<Map>(_boxName);
    await box.clear();
  }
}