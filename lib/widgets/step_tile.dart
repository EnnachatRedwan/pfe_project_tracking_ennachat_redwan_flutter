import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/step.dart';
import '../style/style.dart';
import '../providers/task.dart';

class StepTile extends StatelessWidget {
  const StepTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StepProvider step = Provider.of<StepProvider>(context);
    return InkWell(
      onTap: () {
        step.toggleState();
        Provider.of<TaskProvider>(context,listen: false).refresh();
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: step.isCompleted ? Style.blue : Style.red,
          radius: 20,
        ),
        title: Text(step.title),
        trailing: Checkbox(
          value: step.isCompleted,
          onChanged: (_) {
            step.toggleState();
            Provider.of<TaskProvider>(context,listen: false).refresh();
          },
        ),
      ),
    );
  }
}
