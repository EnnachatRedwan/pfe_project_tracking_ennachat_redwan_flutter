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

  List<TaskProvider> get notArchivedTasks{
    return tasks.where((t) => !t.isArchived).toList();
  }

  List<TaskProvider> get archivedTasks{
    return tasks.where((t) => t.isArchived).toList();
  }

  void deleteTask(TaskProvider t){
    tasks.remove(t);
    notifyListeners();
  }

  void addTask(title){
    tasks.add(TaskProvider(title: title, state: ProgressState.inProgress, steps: [], employees: []));
    notifyListeners();
  }
  
  void refresh(){
    notifyListeners();
  }

}