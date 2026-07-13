import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_task_app/services/auth_service.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialNom;
  final String initialPrenom;
  final String initialEmail;
  final String? initialPhotoUrl;

  const EditProfileScreen({
    super.key,
    required this.initialNom,
    required this.initialPrenom,
    required this.initialEmail,
    this.initialPhotoUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _nomCtrl       = TextEditingController();
  final _prenomCtrl    = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _confirmCtrl   = TextEditingController();

  File?   _photoFile;       // nouvelle photo choisie localement
  bool    _isSaving        = false;
  bool    _showPassword    = false;
  bool    _showConfirm     = false;

  @override
  void initState() {
    super.initState();
    _nomCtrl.text    = widget.initialNom;
    _prenomCtrl.text = widget.initialPrenom;
    _emailCtrl.text  = widget.initialEmail.contains('@')
        ? widget.initialEmail
        : '';
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Choisir une photo ───────────────────────────────────────────────────────
  Future<void> _pickPhoto(ImageSource source) async {
    Navigator.pop(context); // ferme le bottom sheet
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (picked != null) {
      setState(() => _photoFile = File(picked.path));
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text('edit_profile_take_photo'.tr(context)),
                onTap: () => _pickPhoto(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('edit_profile_gallery'.tr(context)),
                onTap: () => _pickPhoto(ImageSource.gallery),
              ),
              if (_photoFile != null || widget.initialPhotoUrl != null)
                ListTile(
                  leading: Icon(Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error),
                  title: Text('edit_profile_delete_photo'.tr(context),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                  onTap: () {
                    setState(() => _photoFile = null);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sauvegarde ──────────────────────────────────────────────────────────────
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordCtrl.text.trim();

    setState(() => _isSaving = true);

    final success = await AuthService.updateProfil(
      nom:       _nomCtrl.text.trim(),
      prenom:    _prenomCtrl.text.trim(),
      email:     _emailCtrl.text.trim(),
      password:  password.isNotEmpty ? password : null,
      photoFile: _photoFile,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('edit_profile_success'.tr(context)),
          backgroundColor: AppColors.priorityLow,
        ),
      );
      Navigator.pop(context, true); // true = profil modifié, à recharger
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('edit_profile_error'.tr(context)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  // ── Avatar preview ──────────────────────────────────────────────────────────
  Widget _buildAvatar() {
    final initials = () {
      final parts = '${_prenomCtrl.text} ${_nomCtrl.text}'
          .trim()
          .split(' ')
          .where((p) => p.isNotEmpty)
          .toList();
      if (parts.isEmpty) return '?';
      if (parts.length == 1) return parts[0][0].toUpperCase();
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }();

    ImageProvider? imageProvider;
    if (_photoFile != null) {
      imageProvider = FileImage(_photoFile!);
    } else if (widget.initialPhotoUrl != null &&
        widget.initialPhotoUrl!.isNotEmpty) {
      imageProvider = NetworkImage(widget.initialPhotoUrl!);
    }

    return GestureDetector(
      onTap: _showPhotoOptions,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: const Icon(Icons.camera_alt_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ── Champ texte réutilisable ────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    bool? showObscure,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller:   controller,
      obscureText:  obscure && !(showObscure ?? false),
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textDarkPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: AppColors.textDarkSecondary),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  (showObscure ?? false)
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.textDarkSecondary,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: AppColors.textDarkSecondary.withValues(alpha: 0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.textDarkSecondary.withValues(alpha: 0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error, width: 1.5),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textDarkSecondary,
          fontSize: 14,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('edit_profile_title'.tr(context)),
        centerTitle: true,
        actions: [
          // Bouton Sauvegarder dans l'AppBar
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: _save,
                  child: Text(
                    'edit_profile_save'.tr(context),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Avatar ───────────────────────────────────────
              Center(child: _buildAvatar()),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _showPhotoOptions,
                  child: Text(
                    'edit_profile_change_photo'.tr(context),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Informations personnelles ─────────────────────
              _sectionTitle('edit_profile_personal_info'.tr(context)),
              const SizedBox(height: 12),

              _buildField(
                controller: _prenomCtrl,
                label: 'register_first_name'.tr(context),
                icon: Icons.person_outline,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'edit_profile_field_required'.tr(context)
                    : null,
              ),
              const SizedBox(height: 12),

              _buildField(
                controller: _nomCtrl,
                label: 'register_last_name'.tr(context),
                icon: Icons.person_outline,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'edit_profile_field_required'.tr(context)
                    : null,
              ),
              const SizedBox(height: 12),

              _buildField(
                controller: _emailCtrl,
                label: 'register_email'.tr(context),
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'edit_profile_field_required'.tr(context);
                  }
                  if (!v.contains('@')) {
                    return 'edit_profile_invalid_email'.tr(context);
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              // ── Mot de passe ──────────────────────────────────
              _sectionTitle('edit_profile_change_password_title'.tr(context)),
              const SizedBox(height: 4),
              Text(
                'edit_profile_password_hint'.tr(context),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDarkSecondary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),

              _buildField(
                controller:      _passwordCtrl,
                label:           'forgot_new_password'.tr(context),
                icon:            Icons.lock_outline,
                obscure:         true,
                showObscure:     _showPassword,
                onToggleObscure: () =>
                    setState(() => _showPassword = !_showPassword),
                validator: (v) {
                  if (v == null || v.isEmpty) return null; // optionnel
                  if (v.length < 6) {
                    return 'edit_profile_password_min'.tr(context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              _buildField(
                controller:      _confirmCtrl,
                label:           'register_confirm_password'.tr(context),
                icon:            Icons.lock_outline,
                obscure:         true,
                showObscure:     _showConfirm,
                onToggleObscure: () =>
                    setState(() => _showConfirm = !_showConfirm),
                validator: (v) {
                  if (_passwordCtrl.text.isEmpty) return null;
                  if (v != _passwordCtrl.text) {
                    return 'register_passwords_mismatch'.tr(context);
                  }
                  return null;
                },
              ),

              const SizedBox(height: 36),

              // ── Bouton principal ──────────────────────────────
              SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'edit_profile_save_changes'.tr(context),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textDarkSecondary,
        letterSpacing: 0.4,
      ),
    );
  }
}