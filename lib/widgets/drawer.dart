import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/screens/archive_screen.dart';

import './drawer_item.dart';
import '../screens/projects_overview_screen.dart';
import '../screens/employees_overview_screen.dart';

class ApplicationDrawer extends StatelessWidget {
  const ApplicationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        children: [
          DraweItem(
            title: 'المشاريع',
            icon: Icons.work,
            action: () => Navigator.of(context)
                .pushReplacementNamed(ProjectsScreen.routeName),
          ),
          DraweItem(
            title: 'الموظفين',
            icon: Icons.people,
            action: () => Navigator.of(context)
                .pushReplacementNamed(EmployeesScreen.routeName),
          ),
          DraweItem(
            title: 'الأرشيف',
            icon: Icons.archive,
            action: () => Navigator.of(context)
                .pushReplacementNamed(ArchiveScreen.routeName),
          ),
        ],
      ),
    );
  }
}
