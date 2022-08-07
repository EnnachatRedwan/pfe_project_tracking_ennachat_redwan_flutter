import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/task.dart';
import '../models/period.dart';
import '../widgets/task_buttons.dart';
import '../widgets/level_bar.dart';
import '../widgets/step_tile.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({Key? key}) : super(key: key);

  void _openEmployeeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'الاسم الكامل',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
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
      appBar: const ApplicationAppBar(title: 'مهمة'),
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
              Text(
                getPeriod(task.endingDate, task.endingDate),
                style: const TextStyle(
                  color: Style.grey,
                  fontSize: 15,
                ),
                textAlign: TextAlign.right,
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
              const TaskButtons(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEmployeeBottomSheet(context),
        backgroundColor: Style.primaryColor,
        child: const Icon(
          Icons.add,
          color: Style.secondaryColor,
        ),
      ),
    );
  }
}
