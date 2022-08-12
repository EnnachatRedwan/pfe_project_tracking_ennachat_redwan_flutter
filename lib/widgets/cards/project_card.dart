import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../style/style.dart';
import '../project_buttons.dart';
import '../level_bar.dart';
import '../../providers/project.dart';
import '../../screens/tasks_overview.dart';
import '../../providers/projects.dart';
import '../../models/period.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectProvider project = Provider.of<ProjectProvider>(context);
    return Dismissible(
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
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (ctx) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider.value(
                          value: project.tasks,
                        ),
                        ChangeNotifierProvider.value(
                          value: project,
                        ),
                      ],
                      child: const ProjectTaskScreen(),
                    ),
                  ),
                )
                .then((value) => project.refresh());
          },
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
                  getPeriod(project.startingDate, project.endingDate),
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
              SizedBox(
                width: double.infinity,
                child: Text(
                  'أضيف في ${DateFormat.yMMMd().format(project.createdIn)}',
                  style: const TextStyle(
                    color: Style.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              if (project.isStarted)
                Center(
                  child: LevelBar(
                    level: project.tasks.level,
                    width: 300,
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              const ProjectButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
