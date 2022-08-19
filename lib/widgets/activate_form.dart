import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import './button.dart';
import '../providers/auth.dart';

class ActivationForm extends StatefulWidget {
  const ActivationForm({
    Key? key,
    required this.size,
    required this.update,
  }) : super(key: key);

  final Size size;
  final Function update;

  @override
  State<ActivationForm> createState() => _ActivationFormState();
}

class _ActivationFormState extends State<ActivationForm> {
  String key = '';
  final password = TextEditingController();
  final passFocus = FocusNode();
  final confirmPassFocus = FocusNode();
  final formKey = GlobalKey<FormState>();

  void _showSnackBar(String message,{Color color=Style.red}) {
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
        await Provider.of<AuthProvider>(context, listen: false)
            .activateAccount(key, password.text);
        _showSnackBar('تم تفعيل الحساب',color: Style.green);
        widget.update(true);
      } catch (err) {
        if (err.toString() == '400') {
          _showSnackBar('حساب مفاعل أو قن خاطئ ');
        } else {
          _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
        }
      } finally {
        setState(() {
          isLoading = false;
        });
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
              'تفعيل الحساب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'القن السري'),
              textDirection: TextDirection.ltr,
              autofocus: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return ' يرجى تقديم قن السري';
                }
                if (value.length != 5) {
                  return 'يجب أن يتكون القن السري من خمس حروف';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                passFocus.requestFocus();
              },
              onSaved: (value) {
                key = value!;
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'كلمة المرور الجديدة'),
              focusNode: passFocus,
              textDirection: TextDirection.ltr,
              controller: password,
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
              onFieldSubmitted: (value) {
                confirmPassFocus.requestFocus();
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'تأكيد كلمة المرور الجديدة'),
              textDirection: TextDirection.ltr,
              obscureText: true,
              autocorrect: false,
              focusNode: confirmPassFocus,
              validator: (value) {
                print(password.text);
                if (value != password.text) {
                  return 'كلمة المرور غير مطابقة';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                save();
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ApplicationButton(
              color: Style.grey,
              isLoading: isLoading,
              title: 'تفعيل',
              verPad: 5,
              onClick: save,
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => widget.update(true),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }
}
