import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/state.dart';
import '../providers/auth.dart';
import '../providers/project.dart';
import '../providers/projects.dart';
import '../style/style.dart';
import 'button.dart';

class ProjectButtons extends StatelessWidget {
  const ProjectButtons({
    Key? key,
    required this.archive,
  }) : super(key: key);

  final Function archive;

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

    final ProjectProvider project = Provider.of<ProjectProvider>(context);
    return Row(
      children: [
        if (!project.isStarted &&
            Provider.of<AuthProvider>(context, listen: false).isLeader)
          Expanded(
            child: ApplicationButton(
              color: Style.green,
              title: 'بدء',
              isLoading: false,
              onClick: () async {
                try {
                  await Provider.of<ProjectsProvider>(context, listen: false)
                      .startProject(project);
                } catch (err) {
                  _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
                }
              },
              verPad: 5,
            ),
          ),
        if (project.isStarted && project.state == ProgressState.inProgress)
          Expanded(
            child: ApplicationButton(
              isLoading: false,
              color: Style.secondaryColor,
              title: 'قيد الإنجاز',
              onClick: () {},
              verPad: 5,
            ),
          ),
        if (project.isStarted && project.state == ProgressState.done)
          Expanded(
            child: ApplicationButton(
              color: Style.blue,
              isLoading: false,
              title: 'منجز',
              onClick: () {},
              verPad: 5,
            ),
          ),
          if (!(Provider.of<AuthProvider>(context, listen: false).isLeader ==
                false &&
            !project.isStarted))
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ApplicationButton(
            isLoading: false,
            color: Style.grey,
            title: 'أرشيف',
            onClick: () => archive(),
            verPad: 5,
          ),
        ),
      ],
    );
  }
}
