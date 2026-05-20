import 'package:flutter/material.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/widgets/auth_header_widget.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';
import 'package:flutter_task_app/views/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ super.key });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
                title: "Bon retour !",
                subtitle: "Connectez-vous à votre espace et organisez votre journée en un clic."
              ),
              SizedBox(height: 20),

              Form(child: 
                Column(
                  children: [
                    TextFieldWidget(
                      label: "Email",
                      placeholder: "Jhon.doe@exemple.com",
                    ),
                    SizedBox(height: 20),

                    // Champ de saisie du mot de passe
                    TextFieldWidget(
                      label: "Mot de passe",
                      placeholder: "Saisissez-votre mot de passe ici",
                      isPassword: true,
                    ),
                    SizedBox(height: 4),

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
                      text: "Se Connecter",
                      onPressed: () {}
                    ),
                    SizedBox(height: 20),

                    // Text d'invitation s'incrire 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pas encore de compte ? "),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Inscrivez-vous",
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