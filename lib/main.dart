import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firebase
import 'firebase_options.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/report_list_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/create_report_screen.dart';
import 'screens/community_chat_screen.dart';
import 'screens/create_username_screen.dart';
import 'screens/home_screen.dart';
import 'screens/main_navigation.dart';

// Services
import 'services/auth_service.dart';


// Theme
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
      home: const AuthWrapper(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/reports': (_) => const ReportListScreen(),
        '/chat': (_) => const ChatScreen(reportId: ''),
        '/create_report': (_) => const CreateReportScreen(),
        '/community_chat': (_) => const CommunityChatScreen(),
        '/create_username': (_) => const CreateUsernameScreen(),
        '/home': (_) => const HomeScreen(),
        '/main_nav': (_) => const MainNavigation(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
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
    );
  }
}
