import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_task_app/config/api_config.dart';

class AuthService {
  // POST — Inscription
  static Future<bool> register({
    required String username,
    required String nom,
    required String prenom,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
        }),
      );

      return response.statusCode != 400 && response.statusCode != 409;
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  // POST — Connexion
  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['access_token']);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  // Récupérer le token sauvegardé
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Déconnexion — supprimer le token
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}