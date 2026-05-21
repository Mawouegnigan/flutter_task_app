import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_app/utils/constants.dart';
// import 'package:flutter_task_app/views/screens/onboarding_screen.dart';
// import 'package:flutter_task_app/views/screens/splash_screen.dart';
// import 'package:flutter_task_app/views/screens/login_screen.dart';
import 'package:flutter_task_app/views/screens/register_screen.dart';
// import 'package:flutter_task_app/views/screens/home_screen.dart';

void main() {
  // Configuration de la bare d'etat
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.background, 
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      theme: AppTheme.lightTheme,
      home: RegisterScreen(),  // OnboardingScreen() SplashScreen() LoginScreen() RegisterScreen() HomeScreen()
    );
  }
}
