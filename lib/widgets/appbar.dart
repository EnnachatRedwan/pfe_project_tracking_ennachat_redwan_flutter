import 'package:flutter/material.dart';

class ApplicationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ApplicationAppBar({Key? key, required this.title }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Image.asset(
          'assets/images/MoroccanKingdom.png',
          width: 40,
          height: 40,
        ),
        centerTitle: true,
        actions: [
          Center(child: Text(title)),
          const SizedBox(
            width: 10,
          ),
        ],
        elevation: 0.0,
      );
  }
  
  @override
  Size get preferredSize => AppBar().preferredSize;
}