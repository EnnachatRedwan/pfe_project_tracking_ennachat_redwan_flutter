import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../style/style.dart';
import '../button.dart';
import '../level_bar.dart';
import '../../providers/task.dart';
import '../../providers/projects.dart';
import '../../models/period.dart';

class TaskArchiveCard extends StatelessWidget {
  const TaskArchiveCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskProvider task = Provider.of<TaskProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Style.backgroundColor,
        boxShadow: const [BoxShadow(blurRadius: 18, color: Style.shadowColor)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              task.title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              getPeriod(task.startingDate, task.endingDate),
              style: const TextStyle(
                color: Style.grey,
                fontSize: 15,
              ),
            ),
          ),
          if (task.isStarted)
            Center(
              child: LevelBar(
                level: task.level,
                width: 300,
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          ApplicationButton(
            color: Style.secondaryColor,
            title: 'إرجاع',
            onClick: () {
              task.unArchive();
              Provider.of<ProjectsProvider>(context, listen: false).refresh();
            },
            verPad: 5,
          ),
        ],
      ),
    );
  }
}
