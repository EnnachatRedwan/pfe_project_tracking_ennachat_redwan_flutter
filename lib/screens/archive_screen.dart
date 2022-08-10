import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/drawer.dart';
import '../widgets/search_banner.dart';
import './project_archive_screen.dart';
import './task_archive_screen.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  static const String routeName = '/archive';

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
          children: const [
            SearchBanner(),
            Expanded(
              child: TabBarView(
                children: [
                  ProjectArchiveScreen(),
                  TaskArchiveScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
