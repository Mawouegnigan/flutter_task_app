import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/widgets/cta_button_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({ super.key });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),

              // une illustration SVG pour le onboarding
              SvgPicture.asset("assets/images/onboarding_illusrtation_1.svg"),

              // titre accrocheur et une desction claire de l'application
              Text(
                'Prenez le contrôle de votre journée',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDarkPrimary,
                  fontSize: 24
                ),
              ),
              SizedBox(height: 4),
              Text("Votre productivité, simplifiée. Organisez vos tâches, planifiez vos journées et capturez vos idées sans effort.", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  // fontWeight: FontWeight.w700,
                  color: AppColors.textDarkSecondary,
                  // fontSize: 2
                )
              ),
              Spacer(),

              // un boutton cta pour commencer à utiliser l'application
              CtaButtonWidget(
                text: "Démarrer", 
                onPressed: () {}
              )
            ],
          )
        )
      )
      
    );
  }
}