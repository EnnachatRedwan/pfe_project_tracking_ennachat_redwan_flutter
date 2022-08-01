import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
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
          children: const [
            SearchBanner()
          ],
        ),
      ),
    );
  }
}
