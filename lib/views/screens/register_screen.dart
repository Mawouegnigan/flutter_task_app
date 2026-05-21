import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/view/auth_header_view.dart';
import 'package:flutter_task_app/views/view/social_auth_section_view.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/widgets/text_field_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({ super.key });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header de bienvenue avec logo, titre et subtitle
              AuthHeaderView(
                title: "Bienvenue parmi nous !",
                subtitle: "Créez votre espace personnel pour organiser vos projets en toute simplicité."
              ),
              SizedBox(height: 40),
              
              // Formulaire de connection avec champs de saisie et boutton de connection
              Form(
                child: Column(
                  children: [
                    // Champ de saisie du nom d'dutilisateur
                    TextFieldWidget(
                      label: "Nom d'utilisateur",
                      placeholder: "John DOE",
                      prefixIcon: Icons.person_outline,
                    ),
                    SizedBox(height: 20),

                    // Champ de saisie de l'email
                    TextFieldWidget(
                      label: "Email",
                      placeholder: "John.doe@exemple.com",
                      prefixIcon: Icons.email_outlined,
                    ),
                    SizedBox(height: 20),

                    // Champ de saisie du mot de passe
                    TextFieldWidget(
                      isPassword: true,
                      label: "Mot de passe",
                      placeholder: "Saisissez-votre mot de passe ici",
                      prefixIcon: Icons.lock_outline,
                    ),
                    SizedBox(height: 8),

                    // Lien "Mot de passe oubliée ?" aligné à droite
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {},
                        child: const Text(
                          "Mot de passe oubliée ?",
                          style: TextStyle(
                            color: AppColors.textDarkSecondary,
                            fontSize: 14,
                            fontStyle: FontStyle.italic
                          ),
                        )
                      )
                    ), 
                    SizedBox(height: 20),

                    // Boutton de connexion
                    CtaButtonWidget(
                      text: "S'inscrire",
                      onPressed: () {}
                    ),
                  ]
                )
              ),
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
                    onTap: () {},
                    child: Text(
                      "Connectez-vous ici",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic
                      ),
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}