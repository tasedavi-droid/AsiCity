import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/create_report_screen.dart';
import '../screens/report_list_screen.dart';
import '../screens/chat_screen.dart';

Map<String, WidgetBuilder> appRoutes = {
  "/login": (_) => const LoginScreen(),
  "/register": (_) => const RegisterScreen(),
  "/home": (_) => const HomeScreen(),
  "/create": (_) => const CreateReportScreen(),
  "/reports": (_) => ReportListScreen(),
  "/chat": (_) =>  ChatScreen(),
};
