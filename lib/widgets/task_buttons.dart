import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../style/style.dart';
import './button.dart';
import '../providers/task.dart';
import '../providers/tasks.dart';
import '../providers/project.dart';
import '../models/state.dart';

class TaskButtons extends StatelessWidget {
  const TaskButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskProvider task = Provider.of<TaskProvider>(context);
    final bool isProjectStarted =
        Provider.of<ProjectProvider>(context).isStarted;
    return Row(
      children: [
        if (!task.isStarted &&
            Provider.of<AuthProvider>(context, listen: false).isLeader)
          Expanded(
            child: ApplicationButton(
              color: isProjectStarted ? Style.green : Style.grey,
              title: 'بدء',
              isLoading: false,
              onClick: () {
                if (isProjectStarted) {
                  task.start();
                }
              },
              verPad: 5,
            ),
          ),
        if (task.isStarted && task.state == ProgressState.inProgress)
          Expanded(
            child: ApplicationButton(
              color: Style.secondaryColor,
              title: 'قيد الإنجاز',
              isLoading: false,
              onClick: () {},
              verPad: 5,
            ),
          ),
        if (task.isStarted && task.state == ProgressState.done)
          Expanded(
            child: ApplicationButton(
              color: Style.blue,
              isLoading: false,
              title: 'منجز',
              onClick: () {},
              verPad: 5,
            ),
          ),
        if (Provider.of<AuthProvider>(context, listen: false).isLeader)
          const SizedBox(
            width: 10,
          ),
        Expanded(
          child: ApplicationButton(
            color: Style.grey,
            isLoading: false,
            title: 'أرشيف',
            onClick: () {
              task.archive();
              Provider.of<TasksProvider>(context, listen: false).refresh();
            },
            verPad: 5,
          ),
        ),
      ],
    );
  }
}
