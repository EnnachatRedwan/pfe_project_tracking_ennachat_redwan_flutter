import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_project_tracking_ennachat_redwan/widgets/task_buttons.dart';
import 'package:provider/provider.dart';

import '../../models/confirm.dart';
import '../../style/style.dart';
import '../level_bar.dart';
import '../../providers/task.dart';
import '../../providers/tasks.dart';
import '../../screens/task_details_screen.dart';
import '../../models/period.dart';
import '../../providers/project.dart';
import '../../providers/auth.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    Key? key,
    required this.delete,
    required this.archive,
    required this.fetchTasks,
  }) : super(key: key);

  final Function delete;
  final Function archive;
  final Function fetchTasks;

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
        delete();
      },
      confirmDismiss: (_) async {
        final bool confirmed =
            await Confirm.confirmDelete(context, 'الحذف', task.title) ?? false;
        return confirmed;
      },
      direction: Provider.of<AuthProvider>(context).isLeader
          ? DismissDirection.startToEnd
          : DismissDirection.none,
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
                      child: TaskDetailsScreen(
                        delete: delete,
                        archive: archive,
                      ),
                    ),
                  ),
                )
                .then((value) => fetchTasks());
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
              TaskButtons(
                archive: archive,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
