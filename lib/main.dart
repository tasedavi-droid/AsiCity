import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/routes.dart';
import 'theme/theme.dart';

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
      title: "AsiCity",

      debugShowCheckedModeBanner: false,

      theme: AppTheme.darkTheme,

      routes: AppRoutes.routes,

      initialRoute: "/login",

      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: child!,
        );
      },
    );
  }
}