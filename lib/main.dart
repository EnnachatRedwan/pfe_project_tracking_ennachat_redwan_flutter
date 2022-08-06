import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/auth.dart';
import './screens/projects_overview_screen.dart';
import './screens/project_archive.dart';
import 'screens/tasks_overview.dart';
import './screens/employees_overview_screen.dart';
import './screens/employee_details.dart';

import './style/style.dart';

import './providers/emplyees.dart';
import './providers/projects.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => EmployeesProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProjectsProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          fontFamily: 'cairo',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Style.primaryColor,
            secondary: Style.secondaryColor,
            background: Style.backgroundColor,
          ),
        ),
        initialRoute: ProjectsScreen.routeName,
        routes: {
          AuthScreen.routeName: (context) => const AuthScreen(),
          ProjectsScreen.routeName: (context) => const ProjectsScreen(),
          ProjectArchiveScreen.routeName: (context) =>
              const ProjectArchiveScreen(),
          ProjectTaskScreen.routeName: (context) => const ProjectTaskScreen(),
          EmployeesScreen.routeName: (context) => const EmployeesScreen(),
          EmployeeDetailsScreen.routeName: (context) =>
              const EmployeeDetailsScreen()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
