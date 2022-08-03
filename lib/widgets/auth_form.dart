import 'package:flutter/material.dart';

import '../style/style.dart';
import './button.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      width: widget.size.width * .8,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Style.backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(blurRadius: 10, spreadRadius: 10, color: Style.shadowColor)
        ],
      ),
      child: Column(
        children: [
          const Text(
            'تسجيل الدخول',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const TextField(
            decoration: InputDecoration(labelText: 'اسم االمستخدم'),
          ),
          const TextField(
            decoration: InputDecoration(labelText: 'كلمة مرور'),
          ),
          const SizedBox(
            height: 50,
          ),
          ApplicationButton(
            color: Style.grey,
            title: 'دخول',
            verPad: 5,
            onClick: () {},
          ),
        ],
      ),
    );
  }
}
