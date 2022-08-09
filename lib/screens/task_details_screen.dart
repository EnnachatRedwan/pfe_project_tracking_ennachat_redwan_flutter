import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/task.dart';
import '../models/period.dart';
import '../widgets/task_buttons.dart';
import '../widgets/level_bar.dart';
import '../widgets/step_tile.dart';
import '../providers/tasks.dart';
import './choose_employee_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({Key? key}) : super(key: key);

  void _openTaskBottomSheet(BuildContext context) {
    final descNode = FocusNode();

    String title = '';
    String desc = '';
    final formKey = GlobalKey<FormState>();

    void save() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Provider.of<TaskProvider>(context, listen: false)
            .addTaskStep(title, desc);
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
                          labelText: 'عنوان الخطوة',
                        ),
                        textDirection: TextDirection.ltr,
                        autofocus: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم عنوان صالح';
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم وصف صحيح';
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TaskProvider task = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: ApplicationAppBar(
        title: 'مهمة',
        acts: [
          PopupMenuButton(
            itemBuilder: (ctx) => const [
              PopupMenuItem<int>(
                value: 0,
                child: Text('حذف'),
              ),
              PopupMenuItem(
                value: 1,
                child: Text('إضافة خطوة'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('إضافة موظفين'),
              ),
            ],
            onSelected: (val) {
              switch (val) {
                case 0:
                  Provider.of<TasksProvider>(context, listen: false)
                      .deleteTask(task);
                  Navigator.of(context).pop();
                  break;
                case 1:
                  _openTaskBottomSheet(context);
                  break;
                case 2:
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ChangeNotifierProvider.value(
                          value: task, child: const ChooseEmployeesScreen()),
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
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  getPeriod(task.startingDate, task.endingDate),
                  style: const TextStyle(
                    color: Style.grey,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: task.steps.length,
                  itemBuilder: (ctx, i) => InkWell(
                    onTap: () {},
                    child: ChangeNotifierProvider.value(
                      value: task.steps[i],
                      child: const StepTile(),
                    ),
                  ),
                ),
              ),
              if (task.isStarted)
                Center(
                  child: LevelBar(
                    level: task.level,
                    width: 300,
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              const Directionality(
                textDirection: TextDirection.rtl,
                child: TaskButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
