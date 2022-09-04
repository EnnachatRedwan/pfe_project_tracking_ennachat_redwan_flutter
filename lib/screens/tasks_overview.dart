import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/providers/task.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

import '../providers/auth.dart';
import '../providers/project.dart';
import '../providers/projects.dart';
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
  void _showSnackBar(String message, {Color color = Style.red}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: color,
      ),
    );
  }

  bool isLoading = false;
  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<TasksProvider>(context, listen: false).fetchTasks();
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchTasks();
    super.initState();
  }

  void _openTaskBottomSheet(BuildContext context) {
    String taskTitle = '';
    DateTime addedIn = DateTime.now();
    final dateController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    void save() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Navigator.of(context).pop();
        try {
          await Provider.of<TasksProvider>(context, listen: false)
              .addTask(taskTitle, addedIn);
        } catch (err) {
          _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
        }
      }
    }

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'عنوان المهمة',
                      ),
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.done,
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
                      textDirection: TextDirection.ltr,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return DatePickerDialog(
                                initialDate: DateTime.now(),
                                firstDate: Provider.of<ProjectProvider>(context,
                                        listen: false)
                                    .createdIn,
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
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
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

  void _openEditProjectBottomSheet(
      BuildContext context, ProjectProvider project) {
    String title = project.title;
    String type = project.type;
    DateTime createdIn = project.createdIn;
    final dateController = TextEditingController(
        text: intl.DateFormat.yMMMd().format(project.createdIn).toString());
    final formKey = GlobalKey<FormState>();
    final typeFocusNode = FocusNode();

    void save() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Navigator.of(context).pop();
        try {
          await Provider.of<ProjectsProvider>(context, listen: false)
              .editProject(title, createdIn, type, project);
        } catch (err) {
          _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
        }
      }
    }

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'عنوان المشروع',
                        ),
                        textDirection: TextDirection.ltr,
                        initialValue: project.title,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          typeFocusNode.requestFocus();
                        },
                        maxLength: 50,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم عنوان مشروع صالح';
                          }
                          if (value.length > 50) {
                            return 'يجب ألا يزيد عنوان المشروع عن 50 حرفًا';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          title = value!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'نوع المشروع',
                        ),
                        textDirection: TextDirection.ltr,
                        initialValue: project.type,
                        focusNode: typeFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => save(),
                        maxLength: 50,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم نوع مشروع صالح';
                          }
                          if (value.length > 50) {
                            return 'يجب ألا يزيد نوع المشروع عن 50 حرفًا';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          type = value!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'أضيف في',
                        ),
                        controller: dateController,
                        readOnly: true,
                        textDirection: TextDirection.ltr,
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
                              }).then(
                            (value) {
                              if (value != null) {
                                createdIn =
                                    DateTime.tryParse(value.toString())!;
                                dateController.text = intl.DateFormat.yMMMd()
                                    .format(createdIn)
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
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  String taskToSearch = '';

  void deleteTask(TaskProvider task) async {
    try {
      await Provider.of<TasksProvider>(context, listen: false).deleteTask(task);
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
    }
  }

  void archive(TaskProvider task) async {
    try {
      await Provider.of<TasksProvider>(context, listen: false)
          .archiveTask(task);
      fetchTasks();
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    final ProjectProvider project = Provider.of<ProjectProvider>(context);

    void search(String value) {
      taskToSearch = value;
      tasksProvider.refresh();
    }

    return Scaffold(
      appBar: ApplicationAppBar(
        title: 'المهام',
        acts: [
          IconButton(onPressed: fetchTasks, icon: const Icon(Icons.refresh)),
          if (Provider.of<AuthProvider>(context, listen: false).isLeader)
            IconButton(
                onPressed: () => _openEditProjectBottomSheet(context, project),
                icon: const Icon(Icons.edit))
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            SearchBanner(
              search: search,
            ),
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: fetchTasks,
                      child: GridView.builder(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 20,
                          bottom: 10,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          maxCrossAxisExtent: 650,
                          childAspectRatio: 3 / 2,
                        ),
                        itemCount:
                            tasksProvider.notArchivedTasks(taskToSearch).length,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                          value:
                              tasksProvider.notArchivedTasks(taskToSearch)[i],
                          child: TaskCard(
                            delete: () => deleteTask(
                              tasksProvider.notArchivedTasks(taskToSearch)[i],
                            ),
                            archive: () => archive(
                              tasksProvider.notArchivedTasks(taskToSearch)[i],
                            ),
                            fetchTasks: () => fetchTasks(),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton:
          Provider.of<AuthProvider>(context, listen: false).isLeader
              ? FloatingActionButton(
                  onPressed: () => _openTaskBottomSheet(context),
                  backgroundColor: Style.primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: Style.secondaryColor,
                  ),
                )
              : null,
    );
  }
}
