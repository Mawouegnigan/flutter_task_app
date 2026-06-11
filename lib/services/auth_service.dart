import 'dart:convert';
import 'dart:io';
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
          'nom':      nom,
          'prenom':   prenom,
          'email':    email,
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

  // GET — Récupérer le profil utilisateur
  static Future<Map<String, dynamic>?> getProfil() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(ApiConfig.profil),
        headers: {
          'Content-Type':  'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('PROFIL STATUS: ${response.statusCode}');
      print('PROFIL BODY: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('PROFIL ERREUR: $e');
      return null;
    }
  }

  // PUT — Mettre à jour le profil utilisateur
  // [photoFile] est optionnel : si fourni, on envoie en multipart
  static Future<bool> updateProfil({
    required String nom,
    required String prenom,
    required String email,
    String? password,
    File? photoFile,
  }) async {
    try {
      final token = await getToken();

      // ── Cas avec photo : multipart/form-data ──────────────────
      if (photoFile != null) {
        final request = http.MultipartRequest(
          'PUT',
          Uri.parse(ApiConfig.updateProfil),
        );

        request.headers['Authorization'] = 'Bearer $token';
        request.fields['nom']    = nom;
        request.fields['prenom'] = prenom;
        request.fields['email']  = email;
        if (password != null && password.isNotEmpty) {
          request.fields['password'] = password;
        }

        request.files.add(
          await http.MultipartFile.fromPath('photo', photoFile.path),
        );

        final streamed = await request.send();
        print('UPDATE PROFIL STATUS: ${streamed.statusCode}');
        return streamed.statusCode == 200 || streamed.statusCode == 201;
      }

      // ── Cas sans photo : JSON ─────────────────────────────────
      final body = <String, dynamic>{
        'nom':    nom,
        'prenom': prenom,
        'email':  email,
      };
      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }

      final response = await http.put(
        Uri.parse(ApiConfig.updateProfil),
        headers: {
          'Content-Type':  'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('UPDATE PROFIL STATUS: ${response.statusCode}');
      print('UPDATE PROFIL BODY: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('UPDATE PROFIL ERREUR: $e');
      return false;
    }
  }
}