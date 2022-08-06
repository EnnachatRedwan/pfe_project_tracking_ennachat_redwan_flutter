import 'package:flutter/material.dart';

import './task.dart';
import '../models/state.dart';

class TasksProvider with ChangeNotifier{
  TasksProvider({
    required this.tasks,
  });
  final List<TaskProvider> tasks;

  double get level {
    if(tasks.isEmpty)
    {
      return 0;
    }
    int completedTasks =
        tasks.where((t) => t.state == ProgressState.done).length;
    return completedTasks / tasks.length;
  }

  void deleteTask(TaskProvider t){
    tasks.remove(t);
    notifyListeners();
  }

}