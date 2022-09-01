import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import './drawer_item.dart';
import '../screens/projects_overview_screen.dart';
import '../screens/employees_overview_screen.dart';
import '../screens/archive_screen.dart';
import './login_layout.dart';
import '../style/style.dart';

class ApplicationDrawer extends StatelessWidget {
  const ApplicationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        children: [
          ListTile(
            
            leading: Container(
              color: auth.isLeader ? Style.secondaryColor : Style.primaryColor,
              width: 10,
            ),
            title: Text(auth.username,style: const TextStyle(fontSize: 18),),
          ),
          const Divider(),
          if (auth.isLeader)
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
            action: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => const LoginLayout()),
                  (route) => false);
              auth.logout();
            },
          ),
        ],
      ),
    );
  }
}
