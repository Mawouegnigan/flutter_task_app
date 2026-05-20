import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/widgets/auth_header_widget.dart';
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
              AuthHeaderWidget(
                title: "Bienvenue parmi nous !",
                subtitle: "Créez votre espace personnel pour organiser vos projets en toute simplicité."
              ),
              SizedBox(height: 20),

              Form(child: 
                Column(
                  children: [
                    // Champ de saisie du username
                    TextFieldWidget(
                      label: "Username",
                      placeholder: "Jhon DOE",
                    ),
                    SizedBox(height: 20),

                    // Champ de saisie de l'email
                    TextFieldWidget(
                      label: "Email",
                      placeholder: "Jhon.doe@exemple.com",
                    ),
                    SizedBox(height: 20),

                    // Champ de saisie du mot de passe
                    TextFieldWidget(
                      label: "Mot de passe",
                      placeholder: "Creez-votre mot de passe",
                      isPassword: true,
                    ),
                    SizedBox(height: 20),

                    // Champ de saisie de la confirmation du mot de passe
                    TextFieldWidget(
                      label: "Confirmation du mot de passe",
                      placeholder: "Confirmez votre mot de passe",
                      isPassword: true,
                    ),
                    SizedBox(height: 20),

                    // Boutton d'inscription
                    CtaButtonWidget(
                      text: "S'inscrire",
                      onPressed: () {}
                    ),
                    SizedBox(height: 20),

                    // Text d'invitation se connecter si l'utilisateur est déjà inscrit
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
                              fontWeight: FontWeight.w600
                            ),
                          )
                        )
                      ],
                    )

                  ]
                )
              )
              // Champ de saisie de l'email

            ],
          ),
        ),
      ),
    );
  }
}