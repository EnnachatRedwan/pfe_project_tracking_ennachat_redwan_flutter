import 'package:flutter/cupertino.dart';

class TopLeftCircle extends StatelessWidget {
  const TopLeftCircle({
    Key? key,
    required this.color,
    required this.rad,
  }) : super(key: key);

  final Color color;
  final double rad;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top:-rad,
        left: -rad/2,
        child: Container(
          width: rad*2,
          height: rad*2,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ));
  }
}
