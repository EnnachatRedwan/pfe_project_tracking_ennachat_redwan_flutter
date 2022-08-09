import 'package:flutter/material.dart';

class ApplicationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ApplicationAppBar({
    Key? key,
    required this.title,
    this.acts,
  }) : super(key: key);

  final String title;
  final List<Widget>? acts;

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
        Center(
            child: Text(
          title,
          style: const TextStyle(fontSize: 18),
        )),
        const SizedBox(
          width: 10,
        ),
        if (acts != null) ...acts!.map((e) => e).toList(),
      ],
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
