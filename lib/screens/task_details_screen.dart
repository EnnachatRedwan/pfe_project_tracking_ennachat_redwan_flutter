import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

import '../providers/project.dart';
import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/task.dart';
import '../models/period.dart';
import '../widgets/task_buttons.dart';
import '../widgets/level_bar.dart';
import '../widgets/step_tile.dart';
import './choose_employee_screen.dart';
import '../providers/auth.dart';
import '../providers/step.dart';
import '../providers/tasks.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen(
      {Key? key, required this.delete, required this.archive, ret})
      : super(key: key);

  final Function delete;
  final Function archive;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isLoading = false;

  Future<void> fetchSteps() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<TaskProvider>(context, listen: false).fetchSteps();
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _deleteStep(StepProvider step) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).deleteStep(step);
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
    }
  }

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

  @override
  void initState() {
    fetchSteps();
    super.initState();
  }

  void _openAddStepBottomSheet(BuildContext context) {
    final descNode = FocusNode();

    String title = '';
    String desc = '';
    final formKey = GlobalKey<FormState>();

    void save() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        try {
          await Provider.of<TaskProvider>(context, listen: false)
              .addStep(title, desc);
        } catch (err) {
          _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
        } finally {
          Navigator.of(context).pop();
        }
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
                          labelText: 'عنوان الخطوة',
                        ),
                        textDirection: TextDirection.ltr,
                        autofocus: true,
                        maxLength: 50,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم عنوان خطوة صالح';
                          }
                          if (value.length > 50) {
                            return 'يجب ألا يزيد عنوان الخطوة عن 50 حرفًا';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          descNode.requestFocus();
                        },
                        onSaved: (value) {
                          title = value!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'تفاصيل الخطوة',
                        ),
                        textDirection: TextDirection.ltr,
                        focusNode: descNode,
                        maxLines: 3,
                        maxLength: 1000,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم وصف صحيح';
                          }
                          if (value.length > 1000) {
                            return 'يجب ألا يزيد وصف الخطوة عن 1000 حرف';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          save();
                        },
                        onSaved: (value) {
                          desc = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          save();
                        },
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
        });
  }

  void _openEditTaskBottomSheet(BuildContext context, TaskProvider task) {
    String taskTitle = task.title;
    DateTime addedIn = task.addedIn;
    final dateController = TextEditingController(
        text: intl.DateFormat.yMMMd().format(addedIn).toString());
    final formKey = GlobalKey<FormState>();

    void save() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Navigator.of(context).pop();
        try {
          await Provider.of<TasksProvider>(context, listen: false)
              .editTask(taskTitle, addedIn, task);
        } catch (err) {
          _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
        }
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
                      textDirection: TextDirection.ltr,
                      autofocus: true,
                      onFieldSubmitted: (_) => save(),
                      maxLength: 50,
                      initialValue: task.title,
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TaskProvider task = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: ApplicationAppBar(
        title: 'مهمة',
        acts: [
          if (Provider.of<AuthProvider>(context).isLeader)
            PopupMenuButton(
              itemBuilder: (ctx) => const [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('حذف'),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text('تعديل'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('إضافة خطوة'),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text('إضافة موظفين'),
                ),
              ],
              onSelected: (val) {
                switch (val) {
                  case 0:
                    Navigator.of(context).pop();
                    widget.delete();
                    break;
                  case 1:
                    _openEditTaskBottomSheet(context, task);
                    break;
                  case 2:
                    _openAddStepBottomSheet(context);
                    break;
                  case 3:
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ChangeNotifierProvider.value(
                          value: task,
                          child: const ChooseEmployeesScreen(),
                        ),
                      ),
                    );
                    break;
                }
              },
            )
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          width: size.width * .95,
          height: size.height * .80,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Style.backgroundColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(blurRadius: 10, color: Style.shadowColor)
            ],
          ),
          child: Column(
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Directionality(
              //   textDirection: TextDirection.rtl,
              //   child: Text(
              //     getPeriod(task.startingDate, task.endingDate),
              //     style: const TextStyle(
              //       color: Style.grey,
              //       fontSize: 15,
              //     ),
              //     textAlign: TextAlign.right,
              //   ),
              // ),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchSteps,
                        child: ListView.builder(
                          itemCount: task.steps.length,
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: task.steps[i],
                            child: StepTile(
                              delete: () => _deleteStep(task.steps[i]),
                            ),
                          ),
                        ),
                      ),
              ),
              // if (task.isStarted)
              //   Center(
              //     child: LevelBar(
              //       level: task.level,
              //       width: 300,
              //     ),
              //   ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Directionality(
              //   textDirection: TextDirection.rtl,
              //   child: TaskButtons(archive: widget.archive),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
