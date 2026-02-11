import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/create_report_screen.dart';
import 'auth_guard.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    "/login": (_) => const LoginScreen(),
    "/register": (_) => const RegisterScreen(),

    "/home": (_) => const AuthGuard(
          child: HomeScreen(),
        ),

    "/chat": (_) => const AuthGuard(
          child: ChatScreen(),
        ),

    "/createReport": (_) => const AuthGuard(
          child: CreateReportScreen(),
        ),
  };
}