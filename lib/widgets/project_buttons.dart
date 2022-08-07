import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/state.dart';
import '../providers/project.dart';
import '../style/style.dart';
import 'button.dart';

class ProjectButtons extends StatelessWidget {
  const ProjectButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectProvider project = Provider.of<ProjectProvider>(context);
    return Row(
      children: [
        if (!project.isStarted)
          Expanded(
            child: ApplicationButton(
              color: Style.green,
              title: 'بدء',
              onClick: () {
                project.start();
              },
              verPad: 5,
            ),
          ),
        if (project.isStarted && project.state == ProgressState.inProgress)
          Expanded(
            child: ApplicationButton(
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
    );
  }
}
