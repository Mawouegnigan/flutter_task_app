import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/controllers/auth/form_validator.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/home_screen.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';
import 'package:flutter_task_app/views/view/auth_header_view.dart';
import 'package:flutter_task_app/views/view/social_auth_section_view.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/widgets/show_snackbar_widget.dart';
import 'package:flutter_task_app/views/widgets/text_field_widget.dart';

// Le Notifier gère l'état (un booléen) et la logique pour le modifier
class PasswordVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // Valeur initiale : mot de passe masqué
  }

  void toggle() {
    state = !state; // Inverse l'état courant
  }
}
// Déclaration du provider global pour afficher ou masquer le mot de passe
final passwordVisibilityProvider = NotifierProvider<PasswordVisibilityNotifier, bool>(() {
  return PasswordVisibilityNotifier();
});

// Notifier pour gérer l'état de chargement de l'authentification
class AuthLoadingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // Par défaut, on ne charge pas
  }

  void setLoading(bool loading) {
    state = loading;
  }
}
// Le provider global pour le chargement
final authLoadingProvider = NotifierProvider<AuthLoadingNotifier, bool>(() {
  return AuthLoadingNotifier();
});

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Méthode asynchrone qui valide le formulaire et simule l'appel API 
  Future<void> _submitForm() async {
    // Validation des champs du formulaire
    if (_formKey.currentState!.validate()) {
      
      // Activer l'état de chargement
      ref.read(authLoadingProvider.notifier).setLoading(true);

      try {
        // Simulation de l'appel API attente de 2 secondes
        // A remplancer pr metre la logic de connection
        await Future.delayed(const Duration(seconds: 2));

        // En cas de reuissite de l'appel API Afficher un snackbar success
        if (!mounted) return;
        ShowSnackbarWidget.show(
          context: context,
          message: "Connexion avec succès",
          icon: Icons.check,
          color: AppColors.priorityLow,
        );

        // Une fois l'API réussie, on redirige
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      } catch (e) {
        // En cas d'erreur API
        if (!mounted) return;
        ShowSnackbarWidget.show(
          context: context,
          message: "Une erreur est survenue",
          icon: Icons.close,
          color: AppColors.priorityHigh,
        );
      } finally {
        // 5. Désactiver le chargement (quand c'est fini ou si ça échoue)
        if (mounted) {
          ref.read(authLoadingProvider.notifier).setLoading(false);
        }
      }
    }
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final isLoading = ref.watch(authLoadingProvider);


    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header de bienvenue avec logo, titre et subtitle
              AuthHeaderView(
                  title: "Bienvenue parmi nous !",
                  subtitle:
                      "Créez votre espace personnel pour organiser vos projets en toute simplicité."),
              SizedBox(height: 30),

              // Formulaire de connection avec champs de saisie et boutton de connection
              Form(
                key: _formKey,
                  child: Column(children: [
                // Champ de saisie du nom d'dutilisateur
                TextFieldWidget(
                  controller: _usernameController,
                  validator: (value) => FormValidator.validateUsername(value),
                  label: "Nom d'utilisateur",
                  placeholder: "John DOE",
                  prefixIcon: Icons.person_outline,
                ),
                SizedBox(height: 20),

                // Champ de saisie de l'email
                TextFieldWidget(
                  controller: _emailController,
                  validator: (value) => FormValidator.validateEmail(value),
                  label: "Email",
                  placeholder: "John.doe@exemple.com",
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: 20),

                // Champ de saisie du mot de passe
                TextFieldWidget(
                  controller: _passwordController,
                  validator: (value) => FormValidator.validatePassword(value),
                  isPassword: true,
                  isPasswordVisible: isPasswordVisible,
                  label: "Mot de passe",
                  placeholder: "Saisissez-votre mot de passe ici",
                  prefixIcon: Icons.lock_outline,
                   onSuffixIconPressed:() {
                    // Appel de la méthode toggle() du Notifier pour chager l'icone oeil du mot de pass et la visibilite du mot de passe
                    ref.read(passwordVisibilityProvider.notifier).toggle();
                  },
                ),
                SizedBox(height: 8),

                // Lien "Mot de passe oubliée ?" aligné à droite
                Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {},
                        child: const Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                              color: AppColors.textDarkSecondary,
                              fontSize: 14,
                              fontStyle: FontStyle.italic),
                        ))),
                SizedBox(height: 20),

                // Boutton de connexion
                CtaButtonWidget(
                  text: "S'inscrire",
                  onPressed: isLoading ? null : () => _submitForm()
                ),
              ])),
              SizedBox(height: 10),

              // Section de connection sociale avec les boutton Google et Facebook
              SocialAuthSectionView(isLoginScreen: false),
              SizedBox(height: 20),

              // Text d'invitation s'incrire
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Déjà membre ? "),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Connectez-vous ici",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
