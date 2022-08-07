import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import './button.dart';
import '../providers/task.dart';
import '../models/state.dart';

class TaskButtons extends StatelessWidget {
  const TaskButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskProvider task = Provider.of<TaskProvider>(context);
    return Row(
      children: [
        if (!task.isStarted)
          Expanded(
            child: ApplicationButton(
              color: Style.green,
              title: 'بدء',
              onClick: () {
                task.start();
              },
              verPad: 5,
            ),
          ),
        if (task.isStarted && task.state == ProgressState.inProgress)
          Expanded(
            child: ApplicationButton(
              color: Style.secondaryColor,
              title: 'قيد الإنجاز',
              onClick: () {},
              verPad: 5,
            ),
          ),
        if (task.isStarted && task.state == ProgressState.done)
          Expanded(
            child: ApplicationButton(
              color: Style.blue,
              title: 'منجز',
              onClick: () {},
              verPad: 5,
            ),
          ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ApplicationButton(
            color: Style.grey,
            title: 'أرشيف',
            onClick: () {},
            verPad: 5,
          ),
        ),
      ],
    );
  }
}
