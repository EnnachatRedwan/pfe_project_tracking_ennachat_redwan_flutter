import 'package:flutter/material.dart';

import './screens/auth.dart';
import './screens/projects_overview_screen.dart';
import './style/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: ProjectScreen.routeName,
      routes: {
        AuthScreen.routeName: (context) => const AuthScreen(),
        ProjectScreen.routeName:(context) => const ProjectScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}