import 'package:flutter/material.dart';

import '../providers/projects.dart';
import '../widgets/cards/project_archive_card.dart';
import 'package:provider/provider.dart';

class ProjectArchiveScreen extends StatelessWidget {
  const ProjectArchiveScreen({
    Key? key,
    required this.projectsToSearch,
  }) : super(key: key);

  final String projectsToSearch;

  @override
  Widget build(BuildContext context) {
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
        itemCount: projectsProvider.archivedProjects(projectsToSearch).length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: projectsProvider.archivedProjects(projectsToSearch)[i],
          child: const ProjectArchiveCard(),
        ),
      ),
    );
  }
}
