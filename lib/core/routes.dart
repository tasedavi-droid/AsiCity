import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/create_report_screen.dart';

import 'auth_guard.dart';

class AppRoutes {

  static Map<String, WidgetBuilder> routes = {

    "/login": (context) => const LoginScreen(),

    "/register": (context) => const RegisterScreen(),

    "/home": (context) => const AuthGuard(
      child: HomeScreen(),
    ),

    "/createReport": (context) => const AuthGuard(
      child: CreateReportScreen(),
    ),
  };
}
