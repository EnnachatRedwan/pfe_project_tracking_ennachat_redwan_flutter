import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/widgets/bottom_left_circle.dart';

import '../widgets/auth_form.dart';
import '../widgets/auth_logo.dart';
import '../widgets/top_left_circle.dart.dart';
import '../widgets/activate_form.dart';
import '../style/style.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const String routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isActivated = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Stack(
            children: [
              const TopLeftCircle(
                rad: 300,
                color: Style.primaryColor,
              ),
              const BottomLeftCircle(
                rad: 200,
                color: Style.secondaryColor,
              ),
              SizedBox(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const AuthLogo(),
                      const SizedBox(
                        height: 50,
                      ),
                      isActivated
                          ? AuthForm(size: size)
                          : ActivationForm(size: size)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
