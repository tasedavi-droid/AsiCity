import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'services/auth_service.dart';
import 'core/routes.dart';
import 'theme/theme.dart';

import 'screens/login_screen.dart';
import 'screens/main_navigation.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AsiCityApp());
}

class AsiCityApp extends StatelessWidget {
  const AsiCityApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      /// 🎨 TEMA GLOBAL
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      routes: AppRoutes.routes,

      home: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return const MainNavigation();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
