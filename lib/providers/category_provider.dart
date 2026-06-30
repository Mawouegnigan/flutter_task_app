import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Catégories par défaut, identiques à l'ancienne liste codée en dur
/// (kCategories) afin de ne pas casser les tâches existantes qui
/// référencent déjà l'une de ces valeurs.
const List<String> kDefaultCategories = [
  'Travail',
  'Personnel',
  'Études',
  'Santé',
  'Courses',
  'Autre',
];

class CategoryProvider extends ChangeNotifier {
  static const String _storageKey = 'taskCategories';

  List<String> _categories = List.from(kDefaultCategories);

  List<String> get categories => List.unmodifiable(_categories);

  CategoryProvider() {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);
    if (stored != null) {
      try {
        final decoded = (jsonDecode(stored) as List).cast<String>();
        if (decoded.isNotEmpty) {
          _categories = decoded;
        }
      } catch (_) {
        // En cas de données corrompues, on garde les catégories par défaut.
      }
    } else {
      // Premier lancement : on initialise le stockage avec les valeurs par défaut.
      await _persist();
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_categories));
  }

  /// Ajoute une nouvelle catégorie. Retourne false si elle existe déjà
  /// (comparaison insensible à la casse) ou si le nom est vide.
  Future<bool> addCategory(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;
    final alreadyExists = _categories.any(
      (c) => c.toLowerCase() == trimmed.toLowerCase(),
    );
    if (alreadyExists) return false;

    _categories.add(trimmed);
    notifyListeners();
    await _persist();
    return true;
  }

  /// Renomme une catégorie existante. Retourne false si le nouveau nom
  /// est vide, déjà pris, ou si l'ancienne catégorie n'existe pas.
  Future<bool> renameCategory(String oldName, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return false;
    final index = _categories.indexOf(oldName);
    if (index == -1) return false;

    final alreadyExists = _categories.any(
      (c) => c.toLowerCase() == trimmed.toLowerCase() && c != oldName,
    );
    if (alreadyExists) return false;

    _categories[index] = trimmed;
    notifyListeners();
    await _persist();
    return true;
  }

  /// Supprime une catégorie. Les tâches déjà enregistrées avec cette
  /// catégorie conservent leur valeur telle quelle côté backend ; elles
  /// n'apparaîtront simplement plus dans la liste de sélection.
  Future<void> deleteCategory(String name) async {
    _categories.remove(name);
    notifyListeners();
    await _persist();
  }

  /// Réinitialise la liste aux 6 catégories par défaut.
  Future<void> resetToDefault() async {
    _categories = List.from(kDefaultCategories);
    notifyListeners();
    await _persist();
  }
}