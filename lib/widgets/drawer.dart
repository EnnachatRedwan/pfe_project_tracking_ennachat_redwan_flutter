import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import './drawer_item.dart';
import '../screens/projects_overview_screen.dart';
import '../screens/employees_overview_screen.dart';
import '../screens/archive_screen.dart';

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
            title: 'الموظفين',
            icon: Icons.people,
            action: () => Navigator.of(context)
                .pushReplacementNamed(EmployeesScreen.routeName),
          ),
          DraweItem(
            title: 'المشاريع',
            icon: Icons.work,
            action: () => Navigator.of(context)
                .pushReplacementNamed(ProjectsScreen.routeName),
          ),
          DraweItem(
            title: 'الأرشيف',
            icon: Icons.archive,
            action: () => Navigator.of(context)
                .pushReplacementNamed(ArchiveScreen.routeName),
          ),
          DraweItem(
            title: 'تسجيل خروج',
            icon: Icons.logout,
            action: () =>
                Provider.of<AuthProvider>(context, listen: false).logout(),
          ),
        ],
      ),
    );
  }
}
