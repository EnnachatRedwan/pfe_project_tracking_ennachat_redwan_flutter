import 'package:flutter/material.dart';

import './task.dart';
import '../models/state.dart';

class TasksProvider with ChangeNotifier {
  TasksProvider({
    required this.tasks,
  });
  final List<TaskProvider> tasks;

  double get level {
    if (tasks.isEmpty) {
      return 0;
    }
    int completedTasks =
        tasks.where((t) => t.state == ProgressState.done).length;
    return completedTasks / tasks.length;
  }

  // List<TaskProvider> get notArchivedTasks{
  //   return tasks.where((t) => !t.isArchived).toList();
  // }

  List<TaskProvider> notArchivedTasks(String tag) {
    if (tag.isEmpty) {
      return tasks.where((t) => !t.isArchived).toList();
    }
    return tasks
        .where((t) =>
            !t.isArchived && t.title.toLowerCase().contains(tag.toLowerCase()))
        .toList();
  }

  // List<TaskProvider> get archivedTasks {
  //   return tasks.where((t) => t.isArchived).toList();
  // }

  List<TaskProvider> archivedTasks(String tag) {
    if (tag.isEmpty) {
      return tasks.where((t) => t.isArchived).toList();
    }
    return tasks
        .where((t) =>
            t.isArchived && t.title.toLowerCase().contains(tag.toLowerCase()))
        .toList();
  }

  void deleteTask(TaskProvider t) {
    tasks.remove(t);
    notifyListeners();
  }

  void addTask(String title, DateTime addedIn) {
    tasks.add(TaskProvider(
        id: UniqueKey().toString(),
        title: title,
        state: ProgressState.inProgress,
        steps: [],
        employees: [],
        addedIn: addedIn));
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
