import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/emplyee.dart';
import '../style/style.dart';
import '../screens/employee_details.dart';

class EmployeeTile extends StatelessWidget {
  const EmployeeTile({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    final EmployeeProvider employee = Provider.of<EmployeeProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                    value: employee,
                    child: const EmployeeDetailsScreen(),
                  ),
              settings: RouteSettings(arguments: color)),
        );
      },
      child: Dismissible(
        background: Container(
          decoration: const BoxDecoration(
            color: Style.red,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(
                Icons.delete,
                color: Style.backgroundColor,
                size: 30,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        direction: DismissDirection.endToStart,
        key: Key(DateTime.now().toString()),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                radius: 30,
                child: const Icon(
                  Icons.person,
                  color: Style.backgroundColor,
                ),
              ),
              title: Text(employee.fullName),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
