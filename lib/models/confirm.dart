import 'package:flutter/material.dart';

class Confirm {
  static Future<bool?> confirmDelete(BuildContext context, String title) {
    return showDialog<bool>(
      context: context,
      builder: ((ctx) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text('$title هل متأكد من حذف'),
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
