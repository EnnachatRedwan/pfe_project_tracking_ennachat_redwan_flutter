import 'package:flutter/material.dart';

class ApplicationButton extends StatelessWidget {
  const ApplicationButton({
    Key? key,
    required this.color,
    required this.title,
    required this.onClick,
    required this.isLoading,
    this.verPad = 0.0,
    this.horPad = 0.0,
  }) : super(key: key);

  final Color color;
  final String title;
  final double verPad;
  final double horPad;
  final VoidCallback onClick;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: isLoading ? null : onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horPad, vertical: verPad),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: TextStyle(
                      color: Colors.white, fontSize: width < 400 ? 15 : 20),
                ),
        ),
      ),
    );
  }
}
