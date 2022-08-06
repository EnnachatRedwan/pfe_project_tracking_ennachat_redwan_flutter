import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../style/style.dart';
import '../button.dart';
import '../level_bar.dart';
import '../../models/state.dart';
import '../../providers/task.dart';
import '../../providers/tasks.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final TaskProvider task = Provider.of<TaskProvider>(context);
    String projectPeriod;
    if (task.startingDate == null) {
      projectPeriod = 'لم تبدأ بعد';
    } else if (task.endingDate == null) {
      projectPeriod =
          'بدأت في ${DateFormat.yMMMd().format(task.startingDate!)}';
    } else {
      projectPeriod =
          'بدأت في ${DateFormat.yMMMd().format(task.startingDate!)} وانتهى في ${DateFormat.yMMMd().format(task.endingDate!)}';
    }
    return Dismissible(
      background: Container(
        decoration: const BoxDecoration(
          color: Style.red,
        ),
        child: Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Style.backgroundColor,
              size: 40,
            )
          ],
        ),
      ),
      onDismissed: (_){
        Provider.of<TasksProvider>(context,listen: false).deleteTask(task);
      },
      direction: DismissDirection.startToEnd,
      key: Key(DateTime.now().toString()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Style.backgroundColor,
          boxShadow: const [
            BoxShadow(blurRadius: 18, color: Style.shadowColor)
          ],
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
                projectPeriod,
                style: const TextStyle(
                  color: Style.grey,
                  fontSize: 15,
                ),
              ),
            ),
            if (task.state != ProgressState.notStarted)
              Center(
                child: LevelBar(
                  level: task.level,
                  width: 300,
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                if (task.state == ProgressState.notStarted)
                  Expanded(
                    child: ApplicationButton(
                      color: Style.green,
                      title: 'بدء',
                      onClick: () {},
                      verPad: 5,
                    ),
                  ),
                if (task.state == ProgressState.inProgress)
                  Expanded(
                    child: ApplicationButton(
                      color: Style.secondaryColor,
                      title: 'قيد الإنجاز',
                      onClick: () {},
                      verPad: 5,
                    ),
                  ),
                if (task.state == ProgressState.done)
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
            ),
          ],
        ),
      ),
    );
  }
}
