import 'package:flutter/material.dart';

import '../style/style.dart';
import './button.dart';

class ActivationForm extends StatefulWidget {
  const ActivationForm({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  State<ActivationForm> createState() => _ActivationFormState();
}

class _ActivationFormState extends State<ActivationForm> {
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
            'تفعيل الحساب',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const TextField(
            decoration: InputDecoration(labelText: 'كلمة المرور القديمة'),
          ),
          const TextField(
            decoration: InputDecoration(labelText: 'كلمة المرور الجديدة'),
          ),
          const TextField(
            decoration: InputDecoration(labelText: 'تأكيد كلمة المرور الجديدة'),
          ),
          const SizedBox(
            height: 50,
          ),
          ApplicationButton(
            color: Style.grey,
            title: 'تفعيل',
            verPad: 5,
            onClick: () {},
          ),
        ],
      ),
    );
  }
}
