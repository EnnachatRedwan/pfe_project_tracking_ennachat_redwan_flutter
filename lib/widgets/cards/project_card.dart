import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../style/style.dart';
import '../button.dart';
import '../level_bar.dart';
import '../../models/state.dart';
import '../../providers/project.dart';
import '../../screens/project_tasks_overview.dart';
import '../../providers/projects.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectProvider project = Provider.of<ProjectProvider>(context);

    String projectPeriod;
    if (project.startingDate == null) {
      projectPeriod = 'لم تبدأ بعد';
    } else if (project.endingDate == null) {
      projectPeriod =
          'بدأت في ${DateFormat.yMMMd().format(project.startingDate!)}';
    } else {
      projectPeriod =
          'بدأت في ${DateFormat.yMMMd().format(project.startingDate!)} وانتهى في ${DateFormat.yMMMd().format(project.endingDate!)}';
    }
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (ctx) => ChangeNotifierProvider.value(
                  value: project.tasks,
                  child: const ProjectTaskScreen(),
                ),
              ),
            )
            .then((value) => project.refresh());
      },
      child: Dismissible(
        onDismissed: ((_) {
          Provider.of<ProjectsProvider>(context, listen: false)
              .deleteProject(project);
        }),
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
        direction: DismissDirection.startToEnd,
        key: Key(project.id),
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
                  project.title,
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
              SizedBox(
                width: double.infinity,
                child: Text(
                  project.type,
                  style: const TextStyle(
                    color: Style.grey,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              if (project.state != ProgressState.notStarted)
                Center(
                  child: LevelBar(
                    level: project.tasks.level,
                    width: 300,
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  if (project.state == ProgressState.notStarted)
                    Expanded(
                      child: ApplicationButton(
                        color: Style.green,
                        title: 'بدء',
                        onClick: () {},
                        verPad: 5,
                      ),
                    ),
                  if (project.state == ProgressState.inProgress)
                    Expanded(
                      child: ApplicationButton(
                        color: Style.secondaryColor,
                        title: 'قيد الإنجاز',
                        onClick: () {},
                        verPad: 5,
                      ),
                    ),
                  if (project.state == ProgressState.done)
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
      ),
    );
  }
}
