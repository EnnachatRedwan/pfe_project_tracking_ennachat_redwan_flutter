import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/emplyee.dart';
import '../providers/task.dart';
import '../style/style.dart';

class ChooseEmployeeTile extends StatelessWidget {
  const ChooseEmployeeTile({
    Key? key,
    required this.affect,
    required this.unaffect,
  }) : super(key: key);

  final Function affect;
  final Function unaffect;

  @override
  Widget build(BuildContext context) {
    final EmployeeProvider employee = Provider.of<EmployeeProvider>(context);
    final TaskProvider task = Provider.of<TaskProvider>(context);
    bool isSelected = task.employeesUsename.contains(employee.username);

    return InkWell(
      onTap: () => isSelected ? unaffect() : affect(),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: isSelected? Style.blue:Style.grey,
              radius: 30,
              child: const Icon(
                Icons.person,
                color: Style.backgroundColor,
              ),
            ),
            title: Text(employee.fullName),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (_) {
                isSelected ? unaffect() : affect();
              },
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
