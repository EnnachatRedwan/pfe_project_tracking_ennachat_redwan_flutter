import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appbar.dart';
import '../widgets/cards/task_card.dart';
import '../widgets/search_banner.dart';
import '../models/state.dart';
import '../providers/tasks.dart';
import '../providers/task.dart';
import '../style/style.dart';

class ProjectTaskScreen extends StatelessWidget {
  const ProjectTaskScreen({Key? key}) : super(key: key);

  static const String routeName = '/projects-task';

  @override
  Widget build(BuildContext context) {
    final TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    return Scaffold(
      appBar: const ApplicationAppBar(
        title: 'المهام',
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const SearchBanner(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  maxCrossAxisExtent: 650,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: tasksProvider.tasks.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: tasksProvider.tasks[i],
                  child: TaskCard(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Style.primaryColor,
        child: const Icon(
          Icons.add,
          color: Style.secondaryColor,
        ),
      ),
    );
  }
}
