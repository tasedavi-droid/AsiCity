import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';

class AuthGuard extends StatelessWidget {

  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {

        /// 🔄 Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        /// ❌ Não logado
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        /// ✅ Logado
        return child;
      },
    );
  }
}
