import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/style/style.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        MediaQuery.of(context).size.width < 700 ? Colors.white : Colors.black;
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Image.asset(
            'assets/images/MoroccanKingdom.png',
            width: 100,
            height: 100,
          ),
          Text(
            'المملكة المغربية',
            style: TextStyle(
              fontFamily: 'arabswell',
              fontSize: 20,
              color: textColor,
              shadows: const [Shadow(color: Style.shadowColor,blurRadius: 10)]
            ),
          ),
          Text(
            'وزارة العدل والحريات',
            style: TextStyle(
              fontFamily: 'arabswell',
              fontSize: 25,
              color: textColor,
              shadows: const [Shadow(color: Style.shadowColor,blurRadius: 10)]
            ),
          ),
        ],
      ),
    );
  }
}
