import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

import '../widgets/appbar.dart';
import '../widgets/cards/task_card.dart';
import '../widgets/search_banner.dart';
import '../providers/tasks.dart';
import '../style/style.dart';

class ProjectTaskScreen extends StatefulWidget {
  const ProjectTaskScreen({Key? key}) : super(key: key);

  static const String routeName = '/projects-task';

  @override
  State<ProjectTaskScreen> createState() => _ProjectTaskScreenState();
}

class _ProjectTaskScreenState extends State<ProjectTaskScreen> {
  void _openTaskBottomSheet(BuildContext context) {
    String taskTitle = '';
    DateTime addedIn = DateTime.now();
    final dateController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    void save() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Provider.of<TasksProvider>(context, listen: false)
            .addTask(taskTitle, addedIn);
        Navigator.of(context).pop();
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
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
                      ),
                      textAlign: TextAlign.end,
                      autofocus: true,
                      onFieldSubmitted: (_) => save(),
                      maxLength: 50,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى تقديم عنوان مهمة صالح';
                        }
                        if (value.length > 50) {
                          return 'يجب ألا يزيد عنوان المهمة عن 50 حرفًا';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        taskTitle = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'أضيف في',
                      ),
                      textAlign: TextAlign.end,
                      controller: dateController,
                      readOnly: true,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return DatePickerDialog(
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .add(const Duration(days: -365)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)));
                          },
                        ).then(
                          (value) {
                            if (value != null) {
                              addedIn = DateTime.tryParse(value.toString())!;
                              dateController.text = intl.DateFormat.yMMMd()
                                  .format(addedIn)
                                  .toString();
                            }
                          },
                        );
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
          ),
        );
      },
    );
  }

  String taskToSearch = '';

  @override
  Widget build(BuildContext context) {
    final TasksProvider tasksProvider = Provider.of<TasksProvider>(context);

    void search(String value) {
      taskToSearch = value;
      tasksProvider.refresh();
    }

    return Scaffold(
      appBar: const ApplicationAppBar(
        title: 'المهام',
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            SearchBanner(
              search: search,
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  maxCrossAxisExtent: 650,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: tasksProvider.notArchivedTasks(taskToSearch).length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: tasksProvider.notArchivedTasks(taskToSearch)[i],
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
