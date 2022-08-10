import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/emplyee.dart';
import '../providers/task.dart';
import '../style/style.dart';

class ChooseEmployeeTile extends StatelessWidget {
  const ChooseEmployeeTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmployeeProvider employee = Provider.of<EmployeeProvider>(context);
    final TaskProvider task = Provider.of<TaskProvider>(context);
    bool isSelected = task.employees.contains(employee);

    void toggleSelection() {
      if (isSelected) {
        isSelected = false;
        task.deleteTaskEmployee(employee);
      } else {
        isSelected = true;
        task.addTaskEmployee(employee);
      }
    }

    return InkWell(
      onTap: toggleSelection,
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Style.blue,
              radius: 30,
              child: Icon(
                Icons.person,
                color: Style.backgroundColor,
              ),
            ),
            title: Text(employee.fullName),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (_) {
                toggleSelection();
              },
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}