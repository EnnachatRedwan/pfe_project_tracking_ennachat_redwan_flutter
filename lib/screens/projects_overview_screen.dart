import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/style/style.dart';

import '../widgets/appbar.dart';
import '../widgets/card.dart';
import '../widgets/search_banner.dart';
import '../widgets/button.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  static const String routeName = '/projects';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ApplicationAppBar(
        title: 'المشاريع',
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const SearchBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                children: const [
                  ProjectCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

