import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_app/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ super.key });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/task_flow_logo.svg",
              width: 250,
            ),
            SizedBox(height: 20),
            Text(
              "Organisez vos tâches facilement",
              style: TextStyle(
                color: AppColors.textDarkSecondary,
              ),
            )
          ]
        )
      )
    );
  }
}