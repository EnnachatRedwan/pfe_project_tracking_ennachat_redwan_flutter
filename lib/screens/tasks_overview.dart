import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appbar.dart';
import '../widgets/cards/task_card.dart';
import '../widgets/search_banner.dart';
import '../providers/tasks.dart';
import '../style/style.dart';

class ProjectTaskScreen extends StatelessWidget {
  const ProjectTaskScreen({Key? key}) : super(key: key);

  static const String routeName = '/projects-task';

  void _openTaskBottomSheet(BuildContext context) {
    String taskTitle = '';
    final formKey = GlobalKey<FormState>();

    void save() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Provider.of<TasksProvider>(context, listen: false).addTask(taskTitle);
        Navigator.of(context).pop();
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'عنوان المهمة',
                      hintTextDirection: TextDirection.rtl
                    ),
                    autofocus: true,
                    onFieldSubmitted: (_) => save(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'يرجى تقديم عنوان المهمة صالح';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      taskTitle = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: save,
                    icon: const Icon(Icons.save),
                    label: const Text('حفظ'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Style.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
                itemCount: tasksProvider.notArchivedTasks.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: tasksProvider.notArchivedTasks[i],
                  child: const TaskCard(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskBottomSheet(context),
        backgroundColor: Style.primaryColor,
        child: const Icon(
          Icons.add,
          color: Style.secondaryColor,
        ),
      ),
    );
  }
}
