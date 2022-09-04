import 'package:flutter/material.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

class DeveloperDetailsScreen extends StatelessWidget {
  const DeveloperDetailsScreen({Key? key}) : super(key: key);

  static const String routeName = '/developer-details';
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const color = Style.secondaryColor;

    return Scaffold(
      appBar: const ApplicationAppBar(title: 'معلومات المطور'),
      drawer: const ApplicationDrawer(),
      body: Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            width: size.width * .95,
            height: size.height * .80,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Style.backgroundColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(blurRadius: 10, color: Style.shadowColor)
              ],
            ),
            child: ListView(
              children: const [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 60,
                  child: Icon(
                    Icons.person,
                    color: Style.backgroundColor,
                    size: 60,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'الإسم : رضوان الناشط',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'J110004173 : كود مسار',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'AD319543 : البطاقة الوطنية',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'université chouaib doukkali',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'faculte des science',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'licence professionnelle',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'administrateur de base de données',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      ),
    );
  }
}
