import 'package:flutter/material.dart';

import '../style/style.dart';

class DraweItem extends StatelessWidget {
  const DraweItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.action,
  }) : super(key: key);

  final String title;
  final VoidCallback action;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: ListTile(
        leading: Icon(
          icon,
          color: Style.primaryColor,
        ),
        title: Text(title),
      ),
    );
  }
}
