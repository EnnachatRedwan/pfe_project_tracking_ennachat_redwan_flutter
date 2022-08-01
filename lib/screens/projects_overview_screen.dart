import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/card.dart';
import '../widgets/search_banner.dart';

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
              child: GridView(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    maxCrossAxisExtent: 650,
                    childAspectRatio: 3 / 2),
                children: const [
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                  ProjectCard(),
                ],
              ),
              // child: ListView(
              //   padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              //   children: const [
              //     ProjectCard(),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
