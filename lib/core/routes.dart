import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/create_report_screen.dart';

import 'auth_guard.dart';

class AppRoutes {

  static Map<String, WidgetBuilder> routes = {

    "/login": (context) => const LoginScreen(),

    "/register": (context) => const RegisterScreen(),

    "/home": (context) => AuthGuard(
      child: const HomeScreen(),
    ),

    "/createReport": (context) => AuthGuard(
      child: const CreateReportScreen(),
    ),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {

    if (settings.name == "/chat") {

      final reportId = settings.arguments as String;

      return MaterialPageRoute(
        builder: (_) => AuthGuard(
          child: ChatScreen(reportId: reportId),
        ),
      );
    }

    return null;
  }
}