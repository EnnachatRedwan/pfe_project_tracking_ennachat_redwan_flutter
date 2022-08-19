import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../style/style.dart';
import '../button.dart';
import '../level_bar.dart';
import '../../providers/projects.dart';
import '../../providers/project.dart';
import '../../models/period.dart';

class ProjectArchiveCard extends StatelessWidget {
  const ProjectArchiveCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectProvider project = Provider.of<ProjectProvider>(context);
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
          ApplicationButton(
            color: Style.secondaryColor,
            isLoading: false,
            title: 'إرجاع',
            onClick: () {
              project.disArchive();
              Provider.of<ProjectsProvider>(context, listen: false).refresh();
            },
            verPad: 5,
          ),
        ],
      ),
    );
  }
}
