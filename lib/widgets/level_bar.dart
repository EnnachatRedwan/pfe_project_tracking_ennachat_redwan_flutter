import 'package:flutter/material.dart';

import '../style/style.dart';

class LevelBar extends StatelessWidget {
  const LevelBar({
    Key? key,
    required this.level,
    required this.width,
  }) : super(key: key);

  final double width;
  final double level;

  @override
  Widget build(BuildContext context) {
    Color color;
    if (level <= .25) {
      color = Style.red;
    } else if (level > .25 && level <= .70) {
      color = Style.secondaryColor;
    }
    else{
      color=Style.green;
    }
    final width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(width>400)
            Text(
              '${(level * 100).toStringAsFixed(2)}%',
              style: TextStyle(color: color, fontSize: 17),
            ),
            Stack(
              children: [
                Container(
                  height: 3,
                  color: Style.grey,
                ),
                Positioned(
                  left: 0,
                  child: Container(
                    height: 3,
                    color: color,
                    width: 300*level,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
