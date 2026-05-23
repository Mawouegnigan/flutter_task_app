import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/splash_screen.dart';
import 'package:flutter_task_app/views/screens/login_screen.dart';
import 'package:flutter_task_app/views/screens/register_screen.dart';
import 'package:flutter_task_app/views/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.background,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: AppTheme.lightTheme,

      // POINT D’ENTRÉE UNIQUE
      home: const SplashScreen(),
    );
  }
}