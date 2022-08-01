import 'package:flutter/material.dart';

class ApplicationButton extends StatelessWidget {
  const ApplicationButton({
    Key? key,
    required this.color,
    required this.title,
    required this.onClick,
    this.verPad = 0.0,
    this.horPad = 0.0,
  }) : super(key: key);

  final Color color;
  final String title;
  final double verPad;
  final double horPad;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horPad, vertical: verPad),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
