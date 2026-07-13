import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_task_app/config/api_config.dart';
import 'package:flutter_task_app/models/task_api_model.dart';
import 'package:flutter_task_app/services/auth_service.dart';

class TaskService {
  // Headers avec token d'authentification
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // GET — Récupérer toutes les tâches
  static Future<List<TaskApiModel>> getTasks() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConfig.tasks),
        headers: headers,
      );

      print('GET TASKS STATUS: ${response.statusCode}');
      print('GET TASKS BODY: ${response.body}');

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
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(ApiConfig.tasks),
        headers: headers,
        body: jsonEncode(task.toJson()),
      );

      print('CREATE TASK STATUS: ${response.statusCode}');
      print('CREATE TASK BODY: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return TaskApiModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode != 400 && response.statusCode != 409) {
        // Backend peut retourner 500 même en cas de succès partiel
        try {
          return TaskApiModel.fromJson(jsonDecode(response.body));
        } catch (_) {
          throw Exception('Erreur lors de la création de la tâche');
        }
      } else {
        throw Exception('Erreur lors de la création de la tâche');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  // PATCH — Modifier une tâche
  static Future<TaskApiModel> updateTask(int id, TaskApiModel task) async {
    try {
      final headers = await _getHeaders();
      final response = await http.patch(
        Uri.parse(ApiConfig.taskById(id)),
        headers: headers,
        body: jsonEncode(task.toJson()),
      );

      print('UPDATE TASK STATUS: ${response.statusCode}');
      print('UPDATE TASK BODY: ${response.body}');

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
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse(ApiConfig.taskById(id)),
        headers: headers,
      );

      print('DELETE TASK STATUS: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression de la tâche');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}