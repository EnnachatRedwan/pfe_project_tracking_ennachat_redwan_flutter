import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/emplyees.dart';
import '../widgets/choose_employee_tile.dart';
import '../providers/task.dart';

class ChooseEmployeesScreen extends StatelessWidget {
  const ChooseEmployeesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EmployeesProvider employeesProvider =
        Provider.of<EmployeesProvider>(context);
    final TaskProvider task = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: const ApplicationAppBar(title: 'إضافة موظفين'),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
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
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'بحث',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, i) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(
                        value: employeesProvider.emplyees[i],
                      ),
                      ChangeNotifierProvider.value(
                        value: task,
                      ),
                    ],
                    child: const ChooseEmployeeTile(
                    ),
                  ),
                  itemCount: employeesProvider.emplyees.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
