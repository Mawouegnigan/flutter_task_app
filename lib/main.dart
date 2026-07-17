import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_app/providers/app_settings_provider.dart';
import 'package:flutter_task_app/providers/category_provider.dart';
import 'package:flutter_task_app/services/notification_service.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/splash_screen.dart';
import 'package:flutter_task_app/services/cache_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_app/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Connexion anonyme Firebase pour TOUS les utilisateurs (y compris ceux
  // inscrits par mail/username via le backend JWT), afin que request.auth
  // soit non-null côté règles Firestore (nécessaire pour le chat par tâche).
  // Ne fait rien si une session Firebase (ex: Google Sign-In) existe déjà.
  if (FirebaseAuth.instance.currentUser == null) {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      // On ne bloque pas le démarrage de l'app si ça échoue ; le chat
      // ne fonctionnera simplement pas tant que ce n'est pas résolu.
      debugPrint('Échec de la connexion anonyme Firebase: $e');
    }
  }

  await PushNotificationService.initialize();
  await NotificationService.initialize();
  await CacheService.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.background,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const TaskApp(),
    ),
  );
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yoon',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: const [Locale('fr'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}