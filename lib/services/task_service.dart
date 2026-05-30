import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_task_app/config/api_config.dart';
import 'package:flutter_task_app/models/task_api_model.dart';

class TaskService {
  // GET — Récupérer toutes les tâches
  static Future<List<TaskApiModel>> getTasks() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.tasks));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TaskApiModel.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des tâches');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  // POST — Créer une tâche
  static Future<TaskApiModel> createTask(TaskApiModel task) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.tasks),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 201) {
        return TaskApiModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erreur lors de la création de la tâche');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  // PUT — Modifier une tâche
  static Future<TaskApiModel> updateTask(int id, TaskApiModel task) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.taskById(id)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 200) {
        return TaskApiModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erreur lors de la modification de la tâche');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  // DELETE — Supprimer une tâche
  static Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConfig.taskById(id)),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression de la tâche');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}