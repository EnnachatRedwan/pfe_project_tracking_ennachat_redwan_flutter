import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/drawer.dart';
import '../widgets/search_banner.dart';
import './project_archive_screen.dart';
import './task_archive_screen.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  static const String routeName = '/archive';

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  String toSearch = '';

  void search(String value) {
    setState(() {
      toSearch = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const List<Tab> tabs = [
      Tab(
        text: 'أرشيف المشاريع',
      ),
      Tab(
        text: 'أرشيف المهام',
      )
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const ApplicationAppBar(
          title: 'أرشيف',
          tabs: tabs,
        ),
        drawer: const ApplicationDrawer(),
        body: Column(
          children:  [
            SearchBanner(search: search),
            Expanded(
              child: TabBarView(
                children: [
                  ProjectArchiveScreen(projectsToSearch: toSearch),
                  TaskArchiveScreen(tasksToSearch: toSearch),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
