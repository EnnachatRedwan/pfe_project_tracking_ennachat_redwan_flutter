import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/emplyee.dart';
import '../widgets/button.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  const EmployeeDetailsScreen({Key? key}) : super(key: key);

  static const String routeName = '/emplyee-Details';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EmployeeProvider employee = Provider.of<EmployeeProvider>(context);
    final Color color = ModalRoute.of(context)!.settings.arguments as Color;

    return Scaffold(
      appBar: const ApplicationAppBar(title: 'تعديل موظف'),
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
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 60,
                  child: const Icon(
                    Icons.person,
                    color: Style.backgroundColor,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  employee.fullName,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10,),
                Text(
                  employee.secWord,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10,),
                ApplicationButton(
                  color: Style.blue,
                  title: 'إعادة تعيين كلمة المرور',
                  onClick: () {},
                  verPad: 5,
                ),
                const SizedBox(height: 10,),
                ApplicationButton(
                  color: Style.green,
                  title: 'حفظ',
                  onClick: () {},
                  verPad: 5,
                ),
              ],
            )),
      ),
    );
  }
}
