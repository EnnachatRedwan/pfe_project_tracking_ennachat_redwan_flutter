import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/widgets/cards/task_archive_card.dart';
import 'package:provider/provider.dart';

import '../providers/task.dart';
import '../providers/projects.dart';

class TaskArchiveScreen extends StatelessWidget {
  const TaskArchiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsProvider=Provider.of<ProjectsProvider>(context);
    final List<TaskProvider> tasks=Provider.of<ProjectsProvider>(context).tasks;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GridView.builder(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          maxCrossAxisExtent: 650,
          childAspectRatio: 3 / 2,
        ),
        itemCount: projectsProvider.tasksLength,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: tasks[i],
          child: const TaskArchiveCard(),
        ),
      ),
    );
  }
}
