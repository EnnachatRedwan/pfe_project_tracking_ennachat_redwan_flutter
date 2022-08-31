import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/projects_overview_screen.dart';
import '../screens/splash_screen.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider auth = Provider.of<AuthProvider>(context);
    return auth.isAuth
        ? const ProjectsScreen()
        : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: ((context, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting
                    ? const SplashScreen()
                    : const AuthScreen()),
          );
  }
}
