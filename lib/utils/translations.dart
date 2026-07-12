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
    'task_deadline_datetime_label': {
      'fr': "Date et heure d'échéance",
      'en': 'Due date and time',
    },
    'task_select_datetime': {
      'fr': 'Sélectionner une date et une heure',
      'en': 'Select a date and time',
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
    'settings_network': {'fr': 'Réseau', 'en': 'Network'},
    'settings_offline_mode': {'fr': 'Mode hors ligne', 'en': 'Offline mode'},
    'settings_offline_active': {
      'fr': 'Activé — données en cache utilisées',
      'en': 'Enabled — using cached data',
    },
    'settings_offline_inactive': {
      'fr': 'Désactivé — connexion internet utilisée',
      'en': 'Disabled — using internet connection',
    },
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

    // ── Catégories par défaut (affichage uniquement — la valeur stockée/
    // comparée en base reste le nom français d'origine, cf. kDefaultCategories
    // dans category_provider.dart, pour ne pas casser les tâches existantes) ─
    'category_default_work': {'fr': 'Travail', 'en': 'Work'},
    'category_default_personal': {'fr': 'Personnel', 'en': 'Personal'},
    'category_default_studies': {'fr': 'Études', 'en': 'Studies'},
    'category_default_health': {'fr': 'Santé', 'en': 'Health'},
    'category_default_shopping': {'fr': 'Courses', 'en': 'Shopping'},
    'category_default_other': {'fr': 'Autre', 'en': 'Other'},

    // ── Connexion (login_screen) ──────────────────────────────────
    'login_welcome': {'fr': 'Bon retour !', 'en': 'Welcome back!'},
    'login_subtitle': {
      'fr': 'Connectez-vous pour continuer',
      'en': 'Sign in to continue',
    },
    'login_username': {'fr': "Nom d'utilisateur", 'en': 'Username'},
    'login_password': {'fr': 'Mot de passe', 'en': 'Password'},
    'login_password_placeholder': {
      'fr': 'Saisissez votre mot de passe ici',
      'en': 'Enter your password here',
    },
    'login_no_account': {
      'fr': 'Pas encore de compte ? ',
      'en': 'No account yet? ',
    },
    'login_fill_fields': {
      'fr': 'Veuillez remplir tous les champs',
      'en': 'Please fill in all fields',
    },
    'login_wrong_credentials': {
      'fr': "Nom d'utilisateur ou mot de passe incorrect",
      'en': 'Incorrect username or password',
    },
    'login_server_error': {
      'fr': 'Erreur de connexion au serveur',
      'en': 'Server connection error',
    },

    // ── Inscription (register_screen) ────────────────────────────
    'register_welcome': {'fr': 'Bienvenue parmi nous !', 'en': 'Welcome!'},
    'register_subtitle': {
      'fr': 'Créez votre compte pour commencer',
      'en': 'Create your account to get started',
    },
    'register_last_name': {'fr': 'Nom', 'en': 'Last name'},
    'register_first_name': {'fr': 'Prénom', 'en': 'First name'},
    'register_username': {'fr': "Nom d'utilisateur", 'en': 'Username'},
    'register_email': {'fr': 'Email', 'en': 'Email'},
    'register_password': {'fr': 'Mot de passe', 'en': 'Password'},
    'register_confirm_password': {
      'fr': 'Confirmer le mot de passe',
      'en': 'Confirm password',
    },
    'register_already_member': {
      'fr': 'Déjà membre ? ',
      'en': 'Already a member? ',
    },
    'register_fill_fields': {
      'fr': 'Veuillez remplir tous les champs',
      'en': 'Please fill in all fields',
    },
    'register_username_taken': {
      'fr': "Ce nom d'utilisateur est déjà pris",
      'en': 'This username is already taken',
    },
    'register_passwords_mismatch': {
      'fr': 'Les mots de passe ne correspondent pas',
      'en': 'Passwords do not match',
    },
    'register_success': {
      'fr': 'Compte créé avec succès !',
      'en': 'Account created successfully!',
    },

    // ── Mot de passe oublié (forgot_password_screen) ─────────────
    'forgot_title': {'fr': 'Mot de passe oublié', 'en': 'Forgot password'},
    'forgot_new_password': {
      'fr': 'Nouveau mot de passe',
      'en': 'New password',
    },
    'forgot_confirm_password': {
      'fr': 'Confirmer le nouveau mot de passe',
      'en': 'Confirm new password',
    },
    'forgot_fill_fields': {
      'fr': 'Veuillez remplir tous les champs',
      'en': 'Please fill in all fields',
    },
    'forgot_passwords_mismatch': {
      'fr': 'Les mots de passe ne correspondent pas',
      'en': 'Passwords do not match',
    },
    'forgot_user_not_found': {
      'fr': "Nom d'utilisateur introuvable",
      'en': 'Username not found',
    },
    'forgot_success': {
      'fr': 'Mot de passe réinitialisé avec succès !',
      'en': 'Password reset successfully!',
    },
    'forgot_error': {
      'fr': 'Erreur lors de la réinitialisation',
      'en': 'Error during reset',
    },

    // ── Ajout / édition de tâche (add_editing_task_screen) ───────
    'task_fill_fields': {
      'fr': 'Veuillez remplir le titre et la description',
      'en': 'Please fill in the title and description',
    },
    'task_created_success': {
      'fr': 'Tâche créée avec succès !',
      'en': 'Task created successfully!',
    },
    'task_updated_success': {
      'fr': 'Tâche modifiée avec succès !',
      'en': 'Task updated successfully!',
    },
    'task_save_error': {
      'fr': "Erreur lors de l'enregistrement",
      'en': 'Error while saving',
    },
    'task_title_hint2': {
      'fr': 'Saisissez votre titre',
      'en': 'Enter your title',
    },

    // ── Textes login restants ─────────────────────────────────────
    'login_forgot_password': {
      'fr': 'Mot de passe oublié ?',
      'en': 'Forgot password?',
    },
    'login_button': {'fr': 'Se Connecter', 'en': 'Sign In'},
    'login_register_link': {'fr': 'Inscrivez-vous', 'en': 'Sign up'},

    // ── Textes register restants ──────────────────────────────────
    'register_photo_optional': {
      'fr': 'Photo de profil (optionnelle)',
      'en': 'Profile photo (optional)',
    },
    'register_username_taken_inline': {
      'fr': "Ce nom d'utilisateur est déjà pris",
      'en': 'This username is already taken',
    },
    'register_username_available': {
      'fr': "Nom d'utilisateur disponible",
      'en': 'Username available',
    },
    'register_button': {"fr": "S'inscrire", 'en': 'Sign Up'},
    'register_login_link': {'fr': 'Connectez-vous ici', 'en': 'Sign in here'},
    'register_error': {
      'fr': "Erreur lors de l'inscription. Vérifiez vos informations.",
      'en': 'Registration error. Please check your information.',
    },
    'register_password_special_examples': {
      'fr': 'Au moins un caractère spécial requis (!@#\$%^&*...)',
      'en': 'At least one special character required (!@#\$%^&*...)',
    },
    'register_strength_weak': {'fr': 'Faible', 'en': 'Weak'},
    'register_strength_medium': {'fr': 'Moyen', 'en': 'Medium'},
    'register_strength_strong': {'fr': 'Fort', 'en': 'Strong'},
    'register_password_placeholder': {
      'fr': 'Min. 8 car., maj., chiffre, symbole',
      'en': 'Min. 8 char., upper, digit, symbol',
    },
    'register_confirm_password_placeholder': {
      'fr': 'Confirmez votre mot de passe',
      'en': 'Confirm your password',
    },

    // ── Social auth (social_auth_section_view) ────────────────────
    'social_login_google': {
      'fr': 'Se connecter avec Google',
      'en': 'Sign in with Google',
    },
    'social_register_google': {
      'fr': "S'inscrire avec Google",
      'en': 'Sign up with Google',
    },
    'social_login_facebook': {
      'fr': 'Se connecter avec Facebook',
      'en': 'Sign in with Facebook',
    },
    'social_register_facebook': {
      'fr': "S'inscrire avec Facebook",
      'en': 'Sign up with Facebook',
    },
    'social_google_success': {
      'fr': 'Connecté en tant que {title}',
      'en': 'Signed in as {title}',
    },
    'social_google_cancelled': {
      'fr': 'Connexion Google annulée',
      'en': 'Google sign-in cancelled',
    },
    'social_facebook_unavailable': {
      'fr': 'Facebook non disponible pour le moment',
      'en': 'Facebook not available yet',
    },

    // ── Validation mot de passe ───────────────────────────────────
    'password_min_length': {
      'fr': 'Au moins 8 caractères requis',
      'en': 'At least 8 characters required',
    },
    'password_uppercase': {
      'fr': 'Au moins une lettre majuscule requise',
      'en': 'At least one uppercase letter required',
    },
    'password_lowercase': {
      'fr': 'Au moins une lettre minuscule requise',
      'en': 'At least one lowercase letter required',
    },
    'password_digit': {
      'fr': 'Au moins un chiffre requis',
      'en': 'At least one digit required',
    },
    'password_special': {
      'fr': 'Au moins un caractère spécial requis',
      'en': 'At least one special character required',
    },

    // ── forgot_password textes restants ───────────────────────────
    'forgot_screen_title': {
      'fr': 'Réinitialiser le mot de passe',
      'en': 'Reset password',
    },
    'forgot_screen_subtitle': {
      'fr': 'Entrez votre nom d\'utilisateur et votre nouveau mot de passe.',
      'en': 'Enter your username and your new password.',
    },
    'forgot_reset_button': {
      'fr': 'Réinitialiser',
      'en': 'Reset',
    },
    'forgot_username_placeholder': {
      'fr': "Votre nom d'utilisateur",
      'en': 'Your username',
    },

    // ── Vérification email (email_verification_screen) ────────────
    'email_verification_title': {
      'fr': 'Vérification email',
      'en': 'Email verification',
    },
    'email_verification_screen_title': {
      'fr': 'Vérifiez votre email',
      'en': 'Verify your email',
    },
    'email_verification_screen_subtitle': {
      'fr': 'Nous avons envoyé un code à 6 chiffres à {title}. Saisissez-le ci-dessous pour activer votre compte.',
      'en': 'We sent a 6-digit code to {title}. Enter it below to activate your account.',
    },
    'email_verification_code_label': {
      'fr': 'Code de vérification',
      'en': 'Verification code',
    },
    'email_verification_verify_button': {
      'fr': 'Vérifier',
      'en': 'Verify',
    },
    'email_verification_no_code': {
      'fr': "Vous n'avez rien reçu ? ",
      'en': "Didn't receive anything? ",
    },
    'email_verification_resend': {
      'fr': 'Renvoyer le code',
      'en': 'Resend code',
    },
    'email_verification_resend_countdown': {
      'fr': 'Renvoyer ({title}s)',
      'en': 'Resend ({title}s)',
    },
    'email_verification_code_resent': {
      'fr': 'Un nouveau code a été envoyé',
      'en': 'A new code has been sent',
    },
    'email_verification_invalid_length': {
      'fr': 'Le code doit contenir 6 chiffres',
      'en': 'The code must contain 6 digits',
    },
    'email_verification_wrong_code': {
      'fr': 'Code invalide ou expiré',
      'en': 'Invalid or expired code',
    },
    'email_verification_success': {
      'fr': 'Compte vérifié avec succès !',
      'en': 'Account successfully verified!',
    },
    'email_verification_error': {
      'fr': 'Une erreur est survenue, réessayez',
      'en': 'Something went wrong, please try again',
    },

    // ── Accueil (home_screen) ─────────────────────────────────────
    'home_my_tasks': {'fr': 'Mes tâches', 'en': 'My tasks'},
    'home_search_hint2': {
      'fr': 'Rechercher une tâche, un projet...',
      'en': 'Search a task, a project...',
    },
    'home_delete_success': {
      'fr': 'Tâche supprimée avec succès',
      'en': 'Task deleted successfully',
    },
    'home_delete_error2': {
      'fr': 'Erreur lors de la suppression',
      'en': 'Error while deleting',
    },
    'home_update_error2': {
      'fr': 'Erreur lors de la mise à jour',
      'en': 'Error while updating',
    },
    'home_delete_dialog_title': {
      'fr': 'Supprimer la tâche',
      'en': 'Delete task',
    },
    'home_delete_dialog_body': {
      'fr': 'Voulez-vous vraiment supprimer "{title}" ?',
      'en': 'Do you really want to delete "{title}"?',
    },
    'home_sort_title': {'fr': 'Trier par', 'en': 'Sort by'},
    'home_sort_priority_asc': {'fr': 'Priorité croissante', 'en': 'Priority ascending'},
    'home_sort_priority_desc': {'fr': 'Priorité décroissante', 'en': 'Priority descending'},
    'home_sort_date_asc': {'fr': 'Date croissante', 'en': 'Date ascending'},
    'home_sort_date_desc': {'fr': 'Date décroissante', 'en': 'Date descending'},
    'home_add_category': {
      'fr': 'Ajouter une catégorie',
      'en': 'Add a category',
    },
    'home_select_category': {
      'fr': 'Sélectionnez une catégorie existante :',
      'en': 'Select an existing category:',
    },
    'home_edit': {'fr': 'Modifier', 'en': 'Edit'},
    'home_delete': {'fr': 'Supprimer', 'en': 'Delete'},
    'home_offline_banner': {
      'fr': 'Mode hors ligne — données en cache',
      'en': 'Offline mode — cached data',
    },
    'home_no_tasks': {
      'fr': 'Aucune tâche pour le moment',
      'en': 'No tasks yet',
    },
    'home_loading': {'fr': 'Chargement...', 'en': 'Loading...'},
    'home_sort_none': {'fr': 'Aucun tri', 'en': 'No sorting'},
    'home_notifications_title': {'fr': 'Notifications', 'en': 'Notifications'},
    'home_no_upcoming_tasks': {
      'fr': 'Aucune tâche dans les prochaines 24h',
      'en': 'No tasks in the next 24h',
    },
    'home_due_prefix': {'fr': 'Échéance :', 'en': 'Due:'},
    'home_task_count_singular': {'fr': 'tâche', 'en': 'task'},
    'home_task_count_plural': {'fr': 'tâches', 'en': 'tasks'},
    'home_actions_tooltip': {'fr': 'Actions', 'en': 'Actions'},
    'home_filter_all': {'fr': 'Toutes les tâches', 'en': 'All tasks'},
    'home_filter_in_progress': {'fr': 'En cours', 'en': 'In progress'},
    'home_filter_done': {'fr': 'Terminées', 'en': 'Done'},

    // ── Notifications (notifications_settings_screen) ─────────────
    'notif_title': {'fr': 'Notifications', 'en': 'Notifications'},
    'notif_section_general': {'fr': 'Général', 'en': 'General'},
    'notif_section_types': {
      'fr': 'Types de notifications',
      'en': 'Notification types',
    },
    'notif_enable_title': {
      'fr': 'Activer les notifications',
      'en': 'Enable notifications',
    },
    'notif_enable_subtitle': {
      'fr': "Recevoir toutes les alertes de l'app",
      'en': 'Receive all app alerts',
    },
    'notif_reminders_title': {
      'fr': 'Rappels de tâches',
      'en': 'Task reminders',
    },
    'notif_reminders_subtitle': {
      'fr': "Alertes avant l'échéance d'une tâche",
      'en': 'Alerts before a task deadline',
    },
    'notif_deadlines_title': {
      'fr': "Alertes d'échéance",
      'en': 'Deadline alerts',
    },
    'notif_deadlines_subtitle': {
      'fr': 'Notification quand une tâche est en retard',
      'en': 'Notification when a task is overdue',
    },

    // ── Profil (profile_screen) ───────────────────────────────────
    'profile_title': {'fr': 'Profil', 'en': 'Profile'},
    'profile_default_name': {'fr': 'Utilisateur', 'en': 'User'},
    'profile_settings': {'fr': 'Paramètres', 'en': 'Settings'},
    'profile_settings_subtitle': {
      'fr': 'Stockage, langue, thème, police',
      'en': 'Storage, language, theme, font',
    },
    'profile_notif': {'fr': 'Rappels & Notifications', 'en': 'Reminders & Notifications'},
    'profile_notif_subtitle': {
      'fr': "Alertes, fréquence, heure de rappel",
      'en': 'Alerts, frequency, reminder time',
    },
    'profile_legal': {
      'fr': 'Conditions & Confidentialité',
      'en': 'Terms & Privacy',
    },
    'profile_legal_subtitle': {
      'fr': 'CGU, politique de confidentialité',
      'en': 'ToS, privacy policy',
    },
    'profile_support': {'fr': 'Aide & Support', 'en': 'Help & Support'},
    'profile_support_subtitle': {
      'fr': 'FAQ, contacter le support',
      'en': 'FAQ, contact support',
    },
    'profile_about': {'fr': 'À propos', 'en': 'About'},
    'profile_about_subtitle': {
      'fr': "Version, équipe, mentions légales",
      'en': 'Version, team, legal notices',
    },

    // ── Détail de tâche (task_detail_screen) ─────────────────────
    'task_detail_title': {'fr': 'Détail de la tâche', 'en': 'Task detail'},
    'task_detail_done': {'fr': 'Terminée', 'en': 'Done'},
    'task_detail_in_progress': {'fr': 'En cours', 'en': 'In progress'},
    'task_detail_created': {'fr': 'Créée le', 'en': 'Created on'},
    'task_detail_category': {'fr': 'Catégorie', 'en': 'Category'},
    'task_detail_priority': {'fr': 'Priorité', 'en': 'Priority'},
    'task_detail_deadline': {"fr": "Date d'échéance", 'en': 'Due date'},
    'task_detail_chat': {'fr': 'Discussion', 'en': 'Chat'},
    'task_detail_no_description': {
      'fr': 'Aucune description',
      'en': 'No description',
    },

    // ── Chat (task_chat_screen) ───────────────────────────────────
    'chat_hint': {'fr': 'Écrire un message...', 'en': 'Write a message...'},
    'chat_empty': {
      'fr': 'Aucun message. Soyez le premier à écrire !',
      'en': 'No messages yet. Be the first to write!',
    },

    // ── À propos (about_screen) ───────────────────────────────────
    'about_title': {'fr': 'À propos', 'en': 'About'},
    'about_version': {'fr': 'Version', 'en': 'Version'},
    'about_description_title': {'fr': 'Description', 'en': 'Description'},
    'about_description': {
      'fr': 'TaskFlow est une application mobile de gestion de tâches en équipe, développée dans le cadre de la formation FORCE-N (Formations Ouvertes pour le Renforcement des Compétences, de l\'Emploi et de l\'Entrepreneuriat dans le Numérique), un programme porté par l\'Université Numérique Cheikh Hamidou Kane (UN-CHK) et la Fondation Mastercard.',
      'en': 'TaskFlow is a mobile team task management app, developed as part of the FORCE-N training program (Open Training for Skills, Employment and Digital Entrepreneurship), a program led by the Cheikh Hamidou Kane Digital University (UN-CHK) and the Mastercard Foundation.',
    },
    'about_mentor': {'fr': 'Sous la direction de', 'en': 'Under the supervision of'},
    'about_team': {'fr': 'Équipe de développement', 'en': 'Development team'},
    'about_repo': {'fr': 'Dépôt source', 'en': 'Source repository'},
    'about_tech': {'fr': 'Technologies utilisées', 'en': 'Technologies used'},
    'about_mentor_role': {
      'fr':
          'Professeur Titulaire en Analyse, Statistique et Applications\n'
          'Département de Mathématiques et Informatique — FST/UCAD\n'
          'Directeur du Laboratoire de Mathématiques Appliquées (LMA)',
      'en':
          'Full Professor in Analysis, Statistics and Applications\n'
          'Department of Mathematics and Computer Science — FST/UCAD\n'
          'Director of the Applied Mathematics Laboratory (LMA)',
    },
    'about_role_dev': {
      'fr': 'Développeur Flutter — TaskFlow',
      'en': 'Flutter Developer — TaskFlow',
    },
    'about_role_dev_fem': {
      'fr': 'Développeuse Flutter — TaskFlow',
      'en': 'Flutter Developer — TaskFlow',
    },

    // ── Détail de tâche — compléments (task_detail_screen) ────────
    'task_detail_share': {'fr': 'Partager', 'en': 'Share'},
    'task_detail_at': {'fr': 'à', 'en': 'at'},

    // ── Support (support_screen) ──────────────────────────────────
    'support_title': {'fr': 'Aide & Support', 'en': 'Help & Support'},
    'support_faq_title': {'fr': 'Questions fréquentes', 'en': 'FAQ'},
    'support_contact_title': {'fr': 'Nous contacter', 'en': 'Contact us'},

    'support_faq_1_q': {
      'fr': 'Comment créer une tâche ?',
      'en': 'How do I create a task?',
    },
    'support_faq_1_a': {
      'fr':
          'Appuyez sur le bouton "+" sur l\'écran d\'accueil, remplissez le titre, la description, la priorité et la date d\'échéance, puis validez.',
      'en':
          'Tap the "+" button on the home screen, fill in the title, description, priority, and due date, then confirm.',
    },
    'support_faq_2_q': {
      'fr': 'Comment modifier une tâche existante ?',
      'en': 'How do I edit an existing task?',
    },
    'support_faq_2_a': {
      'fr':
          'Ouvrez la tâche en appuyant dessus, puis appuyez sur l\'icône de modification en haut à droite de l\'écran de détail.',
      'en':
          'Open the task by tapping it, then tap the edit icon at the top right of the detail screen.',
    },
    'support_faq_3_q': {
      'fr': 'Comment marquer une tâche comme terminée ?',
      'en': 'How do I mark a task as done?',
    },
    'support_faq_3_a': {
      'fr':
          'Dans le détail d\'une tâche, appuyez sur le bouton de complétion. La tâche passera en gris pour indiquer qu\'elle est terminée.',
      'en':
          "In the task's detail screen, tap the completion button. The task will turn gray to show it's done.",
    },
    'support_faq_4_q': {
      'fr': 'Comment partager une tâche ?',
      'en': 'How do I share a task?',
    },
    'support_faq_4_a': {
      'fr':
          'Ouvrez le détail d\'une tâche et appuyez sur l\'icône de partage dans la barre d\'actions. Vous pouvez partager via toutes les applications disponibles sur votre téléphone.',
      'en':
          "Open the task's detail screen and tap the share icon in the action bar. You can share through any app available on your phone.",
    },
    'support_faq_5_q': {
      'fr': 'Comment changer le thème de l\'application ?',
      'en': "How do I change the app's theme?",
    },
    'support_faq_5_a': {
      'fr':
          'Allez dans Profil → Paramètres → Mode sombre. Activez ou désactivez le switch selon votre préférence.',
      'en':
          'Go to Profile → Settings → Dark mode. Turn the switch on or off based on your preference.',
    },
    'support_faq_6_q': {
      'fr': 'Comment changer la langue de l\'application ?',
      'en': "How do I change the app's language?",
    },
    'support_faq_6_a': {
      'fr':
          'Allez dans Profil → Paramètres → Langue de l\'application, puis sélectionnez Français ou English dans le menu déroulant.',
      'en':
          'Go to Profile → Settings → App language, then select Français or English from the dropdown menu.',
    },
    'support_faq_7_q': {
      'fr': 'Comment supprimer une tâche ?',
      'en': 'How do I delete a task?',
    },
    'support_faq_7_a': {
      'fr':
          'Ouvrez le détail de la tâche et appuyez sur l\'icône de suppression. Une confirmation vous sera demandée avant la suppression définitive.',
      'en':
          "Open the task's detail screen and tap the delete icon. You'll be asked to confirm before it's permanently deleted.",
    },
    'support_faq_8_q': {
      'fr': 'Mes tâches sont-elles sauvegardées en ligne ?',
      'en': 'Are my tasks saved online?',
    },
    'support_faq_8_a': {
      'fr':
          'Oui, toutes vos tâches sont synchronisées avec notre serveur. Vous pouvez y accéder depuis n\'importe quel appareil en vous connectant avec votre compte.',
      'en':
          'Yes, all your tasks are synced with our server. You can access them from any device by signing in with your account.',
    },
    'support_faq_9_q': {
      'fr': 'Comment réinitialiser mon mot de passe ?',
      'en': 'How do I reset my password?',
    },
    'support_faq_9_a': {
      'fr':
          'La fonctionnalité de réinitialisation de mot de passe est en cours de développement. Contactez le support pour toute assistance.',
      'en':
          'The password reset feature is currently under development. Please contact support for any assistance.',
    },
    'support_faq_10_q': {
      'fr': 'Comment contacter le support ?',
      'en': 'How do I contact support?',
    },
    'support_faq_10_a': {
      'fr':
          'Vous pouvez nous contacter par e-mail à support@taskflow.app. Nous répondons généralement sous 24 à 48 heures ouvrées.',
      'en':
          'You can reach us by email at support@taskflow.app. We typically respond within 24 to 48 business hours.',
    },

    // ── Légal (legal_screen) ──────────────────────────────────────
    'legal_title': {
      'fr': 'Conditions & Confidentialité',
      'en': 'Terms & Privacy',
    },
    'legal_tab_cgu': {'fr': 'CGU', 'en': 'ToS'},
    'legal_tab_privacy': {'fr': 'Confidentialité', 'en': 'Privacy'},

    // ── CGU (legal_screen — onglet CGU) ────────────────────────────
    'legal_cgu_1_title': {
      'fr': '1. Acceptation des conditions',
      'en': '1. Acceptance of Terms',
    },
    'legal_cgu_1_body': {
      'fr':
          "En utilisant TaskFlow, vous acceptez les présentes conditions générales d'utilisation. Si vous n'acceptez pas ces conditions, veuillez ne pas utiliser l'application.",
      'en':
          'By using TaskFlow, you agree to these terms of service. If you do not agree, please do not use the app.',
    },
    'legal_cgu_2_title': {
      'fr': '2. Description du service',
      'en': '2. Service Description',
    },
    'legal_cgu_2_body': {
      'fr':
          "TaskFlow est une application de gestion de tâches permettant aux utilisateurs de créer, organiser et partager des tâches au sein d'une équipe.",
      'en':
          'TaskFlow is a task management app that lets users create, organize, and share tasks within a team.',
    },
    'legal_cgu_3_title': {
      'fr': '3. Compte utilisateur',
      'en': '3. User Account',
    },
    'legal_cgu_3_body': {
      'fr':
          'Vous êtes responsable de la confidentialité de vos identifiants de connexion. Toute activité effectuée depuis votre compte est sous votre responsabilité.',
      'en':
          'You are responsible for keeping your login credentials confidential. Any activity from your account is your responsibility.',
    },
    'legal_cgu_4_title': {
      'fr': '4. Utilisation acceptable',
      'en': '4. Acceptable Use',
    },
    'legal_cgu_4_body': {
      'fr':
          "Vous vous engagez à utiliser TaskFlow uniquement à des fins légales et conformément aux présentes conditions. Toute utilisation abusive est strictement interdite.",
      'en':
          'You agree to use TaskFlow only for lawful purposes and in accordance with these terms. Any misuse is strictly prohibited.',
    },
    'legal_cgu_5_title': {'fr': '5. Modifications', 'en': '5. Changes'},
    'legal_cgu_5_body': {
      'fr':
          "Nous nous réservons le droit de modifier ces conditions à tout moment. Les modifications entrent en vigueur dès leur publication dans l'application.",
      'en':
          'We reserve the right to modify these terms at any time. Changes take effect as soon as they are published in the app.',
    },

    // ── Politique de confidentialité (legal_screen — onglet Confidentialité) ─
    // Textes volontairement condensés par rapport à la version d'origine
    'legal_privacy_1_title': {
      'fr': '1. Données collectées',
      'en': '1. Data Collected',
    },
    'legal_privacy_1_body': {
      'fr':
          "TaskFlow collecte uniquement les données nécessaires au service : nom, prénom, email, nom d'utilisateur et vos tâches.",
      'en':
          'TaskFlow only collects the data needed to run the service: name, email, username, and your tasks.',
    },
    'legal_privacy_2_title': {
      'fr': '2. Utilisation des données',
      'en': '2. Use of Data',
    },
    'legal_privacy_2_body': {
      'fr':
          'Vos données servent uniquement à faire fonctionner TaskFlow. Elles ne sont jamais vendues ni partagées à des fins commerciales.',
      'en':
          'Your data is used solely to provide the TaskFlow service. It is never sold or shared with third parties for commercial purposes.',
    },
    'legal_privacy_3_title': {
      'fr': '3. Stockage et sécurité',
      'en': '3. Storage & Security',
    },
    'legal_privacy_3_body': {
      'fr':
          'Vos données sont stockées de façon sécurisée, avec des mesures de protection appropriées.',
      'en':
          'Your data is stored securely, with appropriate protection measures in place.',
    },
    'legal_privacy_4_title': {'fr': '4. Vos droits', 'en': '4. Your Rights'},
    'legal_privacy_4_body': {
      'fr':
          'Vous pouvez accéder à vos données, les corriger ou les supprimer en nous contactant via le support.',
      'en':
          'You can access, correct, or delete your data by contacting us through support.',
    },
    'legal_privacy_5_title': {
      'fr': '5. Cookies et stockage local',
      'en': '5. Cookies & Local Storage',
    },
    'legal_privacy_5_body': {
      'fr':
          "L'app utilise le stockage local de votre appareil (préférences, cache) — aucun cookie de suivi.",
      'en':
          'The app uses local storage on your device (preferences, cache) — no tracking cookies are used.',
    },

    // ── Déconnexion (logout_button_widget) ────────────────────────
    'logout_title': {'fr': 'Déconnexion', 'en': 'Sign out'},
    'logout_body': {
      'fr': 'Êtes-vous sûr de vouloir vous déconnecter ?\nVous devrez vous reconnecter pour accéder à vos tâches.',
      'en': 'Are you sure you want to sign out?\nYou will need to sign in again to access your tasks.',
    },
    'logout_confirm': {'fr': 'Se déconnecter', 'en': 'Sign out'},

    // ── En-tête profil (profile_header_view) ─────────────────────
    'profile_edit_button': {'fr': 'Modifier le profil', 'en': 'Edit profile'},

    // ── Calendrier (calendar_screen) ──────────────────────────────
    'calendar_title': {'fr': 'Calendrier', 'en': 'Calendar'},
    'calendar_tasks_of': {'fr': 'Tâches du', 'en': 'Tasks of'},
    'calendar_tasks_today': {
      'fr': "Tâches d'aujourd'hui",
      'en': "Today's tasks",
    },
    'calendar_no_tasks': {
      'fr': 'Aucune tâche ce jour',
      'en': 'No tasks this day',
    },

    // ── Édition profil (edit_profile_screen) ─────────────────────
    'edit_profile_title': {'fr': 'Modifier le profil', 'en': 'Edit profile'},
    'edit_profile_take_photo': {'fr': 'Prendre une photo', 'en': 'Take a photo'},
    'edit_profile_gallery': {
      'fr': 'Choisir depuis la galerie',
      'en': 'Choose from gallery',
    },
    'edit_profile_delete_photo': {
      'fr': 'Supprimer la photo',
      'en': 'Delete photo',
    },
    'edit_profile_success': {
      'fr': 'Profil mis à jour avec succès',
      'en': 'Profile updated successfully',
    },
    'edit_profile_error': {
      'fr': 'Échec de la mise à jour. Veuillez réessayer.',
      'en': 'Update failed. Please try again.',
    },
    'edit_profile_save': {'fr': 'Sauvegarder', 'en': 'Save'},
    'edit_profile_change_photo': {'fr': 'Changer la photo', 'en': 'Change photo'},
    'edit_profile_personal_info': {
      'fr': 'Informations personnelles',
      'en': 'Personal information',
    },
    'edit_profile_change_password_title': {
      'fr': 'Modifier le mot de passe',
      'en': 'Change password',
    },
    'edit_profile_password_hint': {
      'fr': 'Laissez vide pour conserver le mot de passe actuel',
      'en': 'Leave blank to keep your current password',
    },
    'edit_profile_field_required': {'fr': 'Champ requis', 'en': 'Required field'},
    'edit_profile_invalid_email': {'fr': 'Email invalide', 'en': 'Invalid email'},
    'edit_profile_password_min': {
      'fr': 'Minimum 6 caractères',
      'en': 'Minimum 6 characters',
    },
    'edit_profile_save_changes': {
      'fr': 'Sauvegarder les modifications',
      'en': 'Save changes',
    },

    // ── Erreur générique social auth ──────────────────────────────
    'social_error': {'fr': 'Erreur : ', 'en': 'Error: '},

    // ── Onboarding ────────────────────────────────────────────────
    'onboarding_skip': {'fr': 'Passer', 'en': 'Skip'},
    'onboarding_next': {'fr': 'Suivant', 'en': 'Next'},
    'onboarding_start': {'fr': 'Commencer', 'en': 'Get started'},
    'onboarding_title_main': {
      'fr': 'Prenez le contrôle de votre journée',
      'en': 'Take control of your day',
    },
    'onboarding_desc_main': {
      'fr': 'Votre productivité, simplifiée. Organisez vos tâches, planifiez vos journées et capturez vos idées sans effort.',
      'en': 'Your productivity, simplified. Organize your tasks, plan your days and capture your ideas effortlessly.',
    },
    'splash_tagline': {
      'fr': 'Organisez vos tâches facilement',
      'en': 'Organize your tasks easily',
    },

    'onboarding_title_1': {'fr': 'Organisez vos tâches', 'en': 'Organize your tasks'},
    'onboarding_desc_1': {
      'fr': 'Créez, modifiez et suivez vos tâches facilement. Classez-les par catégorie et priorité.',
      'en': 'Create, edit and track your tasks easily. Sort them by category and priority.',
    },
    'onboarding_title_2': {'fr': 'Travaillez en équipe', 'en': 'Work as a team'},
    'onboarding_desc_2': {
      'fr': 'Partagez vos tâches et discutez en temps réel grâce au chat intégré.',
      'en': 'Share your tasks and chat in real time with the built-in messaging.',
    },
    'onboarding_title_3': {'fr': 'Restez connecté', 'en': 'Stay connected'},
    'onboarding_desc_3': {
      'fr': 'Recevez des notifications et accédez à vos tâches même hors ligne grâce au cache local.',
      'en': 'Get notifications and access your tasks even offline thanks to local cache.',
    },
    'onboarding_title_4': {'fr': 'Personnalisez votre expérience', 'en': 'Customize your experience'},
    'onboarding_desc_4': {
      'fr': 'Choisissez votre langue, votre thème et gérez vos catégories selon vos besoins.',
      'en': 'Choose your language, theme and manage your categories as you need.',
    },
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

/// Traduit l'affichage d'une catégorie. Ne touche jamais à la valeur
/// stockée/comparée (kDefaultCategories, task.category côté backend) :
/// seules les 6 catégories par défaut ont un libellé traduit, les
/// catégories personnalisées créées par l'utilisateur restent affichées
/// telles quelles (ce sont des données, pas du texte de l'app).
String categoryLabel(String name, BuildContext context) {
  const defaultKeys = {
    'Travail': 'category_default_work',
    'Personnel': 'category_default_personal',
    'Études': 'category_default_studies',
    'Santé': 'category_default_health',
    'Courses': 'category_default_shopping',
    'Autre': 'category_default_other',
  };
  final key = defaultKeys[name];
  return key != null ? key.tr(context) : name;
}
