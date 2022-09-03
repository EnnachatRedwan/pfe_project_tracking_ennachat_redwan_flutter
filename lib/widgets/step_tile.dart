import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/confirm.dart';
import '../providers/step.dart';
import '../style/style.dart';
import '../providers/task.dart';
import '../screens/step_details_screen.dart';

class StepTile extends StatelessWidget {
  const StepTile({
    Key? key,
    required this.delete,
  }) : super(key: key);

  final Function delete;

  @override
  Widget build(BuildContext context) {
    final StepProvider step = Provider.of<StepProvider>(context);
    final TaskProvider task = Provider.of<TaskProvider>(context, listen: false);

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

    void _toggleStep() async {
      try {
        await task.toggleStep(step);
      } catch (err) {
        _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
      }
    }

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (ctx) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: step),
                    ChangeNotifierProvider.value(value: task),
                  ],
                  child: StepDetailsScreen(delete:delete),
                ),
              ),
            )
            .then(
              (value) => task.refresh(),
            );
      },
      child: Dismissible(
        onDismissed: (_) {
          delete();
        },
        confirmDismiss: (_) async {
          final bool confirmed =
              await Confirm.confirmDelete(context, step.title) ?? false;
          return confirmed;
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
                _toggleStep();
              }
            },
          ),
        ),
      ),
    );
  }
}
