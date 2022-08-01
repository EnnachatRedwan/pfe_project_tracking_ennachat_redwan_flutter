import 'package:flutter/cupertino.dart';

class BottomLeftCircle extends StatelessWidget {
  const BottomLeftCircle({
    Key? key,
    required this.color,
    required this.rad,
  }) : super(key: key);

  final Color color;
  final double rad;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom:-rad,
        right: -rad,
        child: Container(
          width: rad*2,
          height: rad*2,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ));
  }
}
