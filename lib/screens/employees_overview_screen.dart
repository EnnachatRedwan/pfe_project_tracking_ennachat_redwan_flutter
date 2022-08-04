import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  static const String routeName='/emplyees';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(title: 'الموظفين'),
      drawer: ApplicationDrawer(),
    );
  }
}