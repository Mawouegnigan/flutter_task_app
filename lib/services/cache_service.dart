import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_task_app/models/task_api_model.dart';

class CacheService {
  static const String _boxName = 'tasks_cache';
  static const String _queueBoxName = 'pending_tasks_queue';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_boxName);
    await Hive.openBox<Map>(_queueBoxName);
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

  // ── File d'attente des taches creees hors ligne ──────────────────────────
  // Permet de ne pas perdre une tache ajoutee sans reseau : elle est stockee
  // ici en attendant d'etre synchronisee avec le backend (voir
  // TaskService.syncQueuedTasks()).

  /// Ajoute une tache a la file d'attente. Retourne l'identifiant local
  /// genere pour cette entree.
  static Future<String> queueTask(TaskApiModel task) async {
    final box = Hive.box<Map>(_queueBoxName);
    final localId = 'local_${DateTime.now().millisecondsSinceEpoch}';
    await box.put(localId, task.toJson());
    return localId;
  }

  /// Liste les taches en attente de synchronisation, avec leur identifiant
  /// local (necessaire pour les retirer de la file une fois synchronisees).
  static List<MapEntry<String, TaskApiModel>> getQueuedTasks() {
    final box = Hive.box<Map>(_queueBoxName);
    return box.keys.map((key) {
      final map = Map<String, dynamic>.from(box.get(key) as Map);
      return MapEntry(key.toString(), TaskApiModel.fromJson(map));
    }).toList();
  }

  static Future<void> removeQueuedTask(String localId) async {
    final box = Hive.box<Map>(_queueBoxName);
    await box.delete(localId);
  }

  static bool get hasQueuedTasks {
    final box = Hive.box<Map>(_queueBoxName);
    return box.isNotEmpty;
  }
}