import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_project_tracking_ennachat_redwan/widgets/task_buttons.dart';
import 'package:provider/provider.dart';

import '../../style/style.dart';
import '../level_bar.dart';
import '../../providers/task.dart';
import '../../providers/tasks.dart';
import '../../screens/task_details_screen.dart';
import '../../models/period.dart';
import '../../providers/project.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TasksProvider tasks = Provider.of<TasksProvider>(context);
    final TaskProvider task = Provider.of<TaskProvider>(context);
    final project = Provider.of<ProjectProvider>(context);
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
      onDismissed: (_) {
        tasks.deleteTask(task);
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
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (ctx) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider.value(value: task),
                        ChangeNotifierProvider.value(value: tasks),
                        ChangeNotifierProvider.value(value: project),
                      ],
                      child: const TaskDetailsScreen(),
                    ),
                  ),
                )
                .then((value) => task.refresh());
          },
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
              SizedBox(
                width: double.infinity,
                child: Text(
                  'أضيف في ${DateFormat.yMMMd().format(task.addedIn)}',
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
              const TaskButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
