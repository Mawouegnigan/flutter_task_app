/// Système de traduction léger pour TaskFlow.
///
/// Usage : 'home_title'.tr(context)
///
/// Toutes les clés et leurs valeurs FR/EN sont centralisées ici.
/// Pour ajouter une nouvelle chaîne traduisible :
///   1. Choisir une clé unique en snake_case (ex: 'task_delete_success')
///   2. Ajouter l'entrée dans _translations avec les deux langues
///   3. Remplacer le texte en dur dans le widget par 'ma_cle'.tr(context)
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_app/providers/app_settings_provider.dart';

class AppTranslations {
  static const Map<String, Map<String, String>> _translations = {
    // ── Général / actions communes ─────────────────────────────
    'cancel': {'fr': 'Annuler', 'en': 'Cancel'},
    'confirm': {'fr': 'Confirmer', 'en': 'Confirm'},
    'delete': {'fr': 'Supprimer', 'en': 'Delete'},
    'edit': {'fr': 'Modifier', 'en': 'Edit'},
    'save': {'fr': 'Enregistrer', 'en': 'Save'},
    'add': {'fr': 'Ajouter', 'en': 'Add'},
    'error_generic': {
      'fr': 'Une erreur est survenue',
      'en': 'Something went wrong',
    },

    // ── Accueil (home_screen) ───────────────────────────────────
    'home_title': {'fr': 'Mes tâches', 'en': 'My tasks'},
    'home_search_hint': {
      'fr': 'Rechercher une tâche, un projet...',
      'en': 'Search a task, a project...',
    },
    'home_task_deleted': {
      'fr': 'Tâche supprimée avec succès',
      'en': 'Task deleted successfully',
    },
    'home_delete_error': {
      'fr': 'Erreur lors de la suppression',
      'en': 'Error while deleting',
    },
    'home_update_error': {
      'fr': 'Erreur lors de la mise à jour',
      'en': 'Error while updating',
    },
    'home_delete_task_title': {
      'fr': 'Supprimer la tâche',
      'en': 'Delete task',
    },
    'home_delete_task_confirm': {
      'fr': 'Voulez-vous vraiment supprimer "{title}" ?',
      'en': 'Do you really want to delete "{title}"?',
    },
    'home_sort_by': {'fr': 'Trier par', 'en': 'Sort by'},
    'home_add_category_title': {
      'fr': 'Ajouter une catégorie',
      'en': 'Add a category',
    },
    'home_select_existing_category': {
      'fr': 'Sélectionnez une catégorie existante :',
      'en': 'Select an existing category:',
    },

    // ── Ajout / édition de tâche (add_editing_task_screen) ──────
    'task_title_label': {'fr': 'Titre de la tâche', 'en': 'Task title'},
    'task_title_hint': {
      'fr': 'Ex : Préparer la présentation',
      'en': 'E.g.: Prepare the presentation',
    },
    'task_description_label': {
      'fr': 'Description de la tâche',
      'en': 'Task description',
    },
    'task_description_hint': {
      'fr': 'Décrivez votre tâche...',
      'en': 'Describe your task...',
    },
    'task_category_label': {'fr': 'Catégorie', 'en': 'Category'},
    'task_priority_label': {'fr': 'Priorité', 'en': 'Priority'},
    'task_deadline_label': {
      'fr': 'Date d\'échéance',
      'en': 'Due date',
    },
    'task_create_button': {'fr': 'Créer la tâche', 'en': 'Create task'},
    'task_save_button': {
      'fr': 'Enregistrer les modifications',
      'en': 'Save changes',
    },
    'task_priority_low': {'fr': 'Basse', 'en': 'Low'},
    'task_priority_medium': {'fr': 'Moyenne', 'en': 'Medium'},
    'task_priority_high': {'fr': 'Haute', 'en': 'High'},

    // ── Paramètres (settings_screen) ─────────────────────────────
    'settings_title': {'fr': 'Paramètres', 'en': 'Settings'},
    'settings_appearance': {'fr': 'Apparence', 'en': 'Appearance'},
    'settings_dark_mode': {'fr': 'Mode sombre', 'en': 'Dark mode'},
    'settings_enabled': {'fr': 'Activé', 'en': 'Enabled'},
    'settings_disabled': {'fr': 'Désactivé', 'en': 'Disabled'},
    'settings_language': {'fr': 'Langue', 'en': 'Language'},
    'settings_app_language': {
      'fr': 'Langue de l\'application',
      'en': 'App language',
    },
    'settings_tasks_section': {'fr': 'Tâches', 'en': 'Tasks'},
    'settings_categories': {'fr': 'Catégories', 'en': 'Categories'},
    'settings_categories_subtitle': {
      'fr': 'Gérer mes catégories de tâches',
      'en': 'Manage my task categories',
    },

    // ── Gestion des catégories (categories_settings_screen) ──────
    'categories_title': {'fr': 'Catégories', 'en': 'Categories'},
    'categories_empty': {
      'fr': 'Aucune catégorie. Appuie sur + pour en créer une.',
      'en': 'No categories yet. Tap + to create one.',
    },
    'categories_new_title': {
      'fr': 'Nouvelle catégorie',
      'en': 'New category',
    },
    'categories_name_hint': {
      'fr': 'Nom de la catégorie',
      'en': 'Category name',
    },
    'categories_invalid_or_duplicate': {
      'fr': 'Cette catégorie existe déjà ou le nom est invalide',
      'en': 'This category already exists or the name is invalid',
    },
    'categories_rename_title': {
      'fr': 'Renommer la catégorie',
      'en': 'Rename category',
    },
    'categories_new_name_hint': {'fr': 'Nouveau nom', 'en': 'New name'},
    'categories_invalid_name': {
      'fr': 'Ce nom existe déjà ou est invalide',
      'en': 'This name already exists or is invalid',
    },
    'categories_delete_confirm_title': {
      'fr': 'Supprimer la catégorie ?',
      'en': 'Delete category?',
    },
    'categories_delete_confirm_body': {
      'fr':
          'Les tâches existantes utilisant "{name}" garderont cette valeur, '
          'mais elle ne sera plus proposée pour les nouvelles tâches.',
      'en':
          'Existing tasks using "{name}" will keep this value, but it '
          'won\'t be suggested for new tasks anymore.',
    },
    'categories_reset_title': {
      'fr': 'Réinitialiser les catégories ?',
      'en': 'Reset categories?',
    },
    'categories_reset_body': {
      'fr':
          'Cela restaurera les 6 catégories par défaut (Travail, Personnel, '
          'Études, Santé, Courses, Autre).',
      'en':
          'This will restore the 6 default categories (Work, Personal, '
          'Studies, Health, Shopping, Other).',
    },
    'categories_reset_button': {'fr': 'Réinitialiser', 'en': 'Reset'},
  };

  static String of(String key, BuildContext context, {String? title, String? name}) {
    final langCode = context.read<AppSettingsProvider>().languageCode;
    final entry = _translations[key];
    if (entry == null) {
      // Clé manquante : on retourne la clé elle-même pour repérer
      // facilement les oublis pendant les tests, sans planter l'app.
      return key;
    }
    var text = entry[langCode] ?? entry['fr'] ?? key;
    if (title != null) text = text.replaceAll('{title}', title);
    if (name != null) text = text.replaceAll('{name}', name);
    return text;
  }
}

/// Extension pratique : 'home_title'.tr(context)
extension TranslateString on String {
  String tr(BuildContext context, {String? title, String? name}) {
    return AppTranslations.of(this, context, title: title, name: name);
  }
}
