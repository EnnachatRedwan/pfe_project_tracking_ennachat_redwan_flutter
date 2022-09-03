import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import './button.dart';
import '../providers/auth.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.size,
    required this.update,
  }) : super(key: key);

  final Function update;
  final Size size;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String username = '';
  String password = '';
  final passFocus = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passFocus.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color color = Style.red}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: color,
      ),
    );
  }

  bool isLoading = false;

  void save() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        String fullname =
            await Provider.of<AuthProvider>(context, listen: false)
                .login(username, password);
        _showSnackBar('$fullname مرحبا', color: Style.green);
      } catch (err) {
        if (err.toString() == '401') {
          _showSnackBar('اسم المستخدم أو كلمة المرور خاطئة');
        } else if (err.toString() == '302') {
          widget.update(false);
        } else {
          _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      width: widget.size.width * .9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Style.backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(blurRadius: 10, spreadRadius: 10, color: Style.shadowColor)
        ],
      ),
      child: Form(
        key: formKey,
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
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'اسم االمستخدم',
              ),
              textDirection: TextDirection.ltr,
              autofocus: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'يرجى تقديم اسم مستخدم صالح';
                }
                if (value.length > 30) {
                  return 'يجب ألا يزيد الاسم عن 30 حرفًا';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                passFocus.requestFocus();
              },
              onSaved: (value) {
                username = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'كلمة مرور',
              ),
              textDirection: TextDirection.ltr,
              autofocus: true,
              focusNode: passFocus,
              obscureText: true,
              autocorrect: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'يرجى تقديم كلمة مرور';
                }
                if (value.length < 5) {
                  return 'يجب أن لا تقل كلمة المرور عن خمس حروف';
                }
                if (value.length > 30) {
                  return 'يجب ألا تزيد كلمة مرور عن 30 حرفًا';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                save();
              },
              onSaved: (value) {
                password = value!;
              },
            ),
            const SizedBox(
              height: 50,
            ),
            ApplicationButton(
              color: Style.grey,
              title: 'دخول',
              isLoading: isLoading,
              verPad: 5,
              onClick: save,
            ),
          ],
        ),
      ),
    );
  }
}
