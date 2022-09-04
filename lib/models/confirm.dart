import 'package:flutter/material.dart';

class Confirm {
  static Future<bool?> confirmDelete(
      BuildContext context, String title, String? content) {
    return showDialog<bool>(
      context: context,
      builder: ((ctx) => AlertDialog(
            title: Text('تأكيد $title'),
            content: content != null
                ? Text('؟ $content متأكد من حذف')
                : const Text(''),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('نعم')),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('لا'),
              ),
            ],
          )),
    );
  }
}
