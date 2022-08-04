import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/cards/project_archive_card.dart';
import '../widgets/drawer.dart';
import '../widgets/search_banner.dart';
import '../models/state.dart';

class ProjectArchiveScreen extends StatelessWidget {
  const ProjectArchiveScreen({Key? key}) : super(key: key);

  static const String routeName = '/projects-archive';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ApplicationAppBar(
        title: 'الأرشيف',
      ),
      drawer: const ApplicationDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const SearchBanner(),
            Expanded(
              child: GridView(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  maxCrossAxisExtent: 650,
                  childAspectRatio: 3 / 2,
                ),
                children: [
                  ProjectArchiveCard(
                    title: 'New tracking web application',
                    type: 'Application mobile',
                    startingDate: DateTime.now(),
                    endingDate: DateTime.now(),
                    level: .30,
                    state: ProgressState.inProgress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}