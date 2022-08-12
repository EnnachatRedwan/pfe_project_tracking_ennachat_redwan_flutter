import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/step.dart';
import '../style/style.dart';
import '../providers/task.dart';
import '../screens/step_details_screen.dart';

class StepTile extends StatelessWidget {
  const StepTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StepProvider step = Provider.of<StepProvider>(context);
    final TaskProvider task = Provider.of<TaskProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        if (task.isStarted) {
          step.toggleState();
          task.refresh();
        }
      },
      onDoubleTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (ctx) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: step),
                    ChangeNotifierProvider.value(value: task),
                  ],
                  child: const StepDetailsScreen(),
                ),
              ),
            )
            .then((value) => task.refresh());
      },
      child: Dismissible(
        onDismissed: (_) {
          task.deleteTaskStep(step);
          task.refresh();
        },
        background: Container(
          decoration: const BoxDecoration(
            color: Style.red,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(
                Icons.delete,
                color: Style.backgroundColor,
                size: 30,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        direction: DismissDirection.endToStart,
        key: Key(DateTime.now().toString()),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: step.isCompleted ? Style.blue : Style.red,
            radius: 20,
          ),
          title: Text(step.title),
          trailing: Checkbox(
            value: step.isCompleted,
            onChanged: (_) {
              if (task.isStarted) {
                step.toggleState();
                Provider.of<TaskProvider>(context, listen: false).refresh();
              }
            },
          ),
        ),
      ),
    );
  }
}
