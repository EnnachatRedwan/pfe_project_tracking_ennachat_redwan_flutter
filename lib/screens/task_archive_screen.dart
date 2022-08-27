import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/providers/task.dart';
import 'package:pfe_project_tracking_ennachat_redwan/widgets/cards/task_archive_card.dart';
import 'package:provider/provider.dart';

import '../providers/projects.dart';
import '../style/style.dart';

class TaskArchiveScreen extends StatelessWidget {
  const TaskArchiveScreen({
    Key? key,
    required this.tasksToSearch,
  }) : super(key: key);

  final String tasksToSearch;

  @override
  Widget build(BuildContext context) {
    void _showSnackBar(String message) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Style.red,
        ),
      );
    }

    void unarchive(TaskProvider task) async {
      try {
        await Provider.of<ProjectsProvider>(context, listen: false)
            .unarchiveTask(task);
      } catch (err) {
        _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
      }
    }

    final projectsProvider = Provider.of<ProjectsProvider>(context);
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
        itemCount: projectsProvider.archivedProjectTasks(tasksToSearch).length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: projectsProvider.archivedProjectTasks(tasksToSearch)[i],
          child: TaskArchiveCard(
              unarchive: () => unarchive(
                  projectsProvider.archivedProjectTasks(tasksToSearch)[i])),
        ),
      ),
    );
  }
}
