import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../style/style.dart';
import '../button.dart';
import '../level_bar.dart';
import '../../providers/task.dart';
import '../../models/period.dart';

class TaskArchiveCard extends StatelessWidget {
  const TaskArchiveCard({
    Key? key,
    required this.unarchive,
  }) : super(key: key);

  final Function unarchive;

  @override
  Widget build(BuildContext context) {
    final TaskProvider task = Provider.of<TaskProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Style.backgroundColor,
        boxShadow: const [BoxShadow(blurRadius: 18, color: Style.shadowColor)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              task.title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              getPeriod(task.startingDate, task.endingDate),
              style: const TextStyle(
                color: Style.grey,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              'أضيف في ${DateFormat.yMMMd().format(task.addedIn)}',
              style: const TextStyle(
                color: Style.grey,
                fontSize: 15,
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
            height: 10,
          ),
          ApplicationButton(
            color: Style.secondaryColor,
            isLoading: false,
            title: 'إرجاع',
            onClick: ()=>unarchive(),
            verPad: 5,
          ),
        ],
      ),
    );
  }
}
