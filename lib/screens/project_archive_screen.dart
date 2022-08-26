import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/projects.dart';
import '../providers/project.dart';
import '../widgets/cards/project_archive_card.dart';
import '../style/style.dart';

class ProjectArchiveScreen extends StatelessWidget {
  const ProjectArchiveScreen({
    Key? key,
    required this.projectsToSearch,
  }) : super(key: key);

  final String projectsToSearch;

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

    void unarchive(ProjectProvider project) async {
      try {
        await Provider.of<ProjectsProvider>(context, listen: false)
            .unarchiveProject(project);
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
        itemCount: projectsProvider.archivedProjects(projectsToSearch).length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: projectsProvider.archivedProjects(projectsToSearch)[i],
          child: ProjectArchiveCard(
            unarchive: () => unarchive(
                projectsProvider.archivedProjects(projectsToSearch)[i]),
          ),
        ),
      ),
    );
  }
}
