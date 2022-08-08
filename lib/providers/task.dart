import 'package:flutter/cupertino.dart';

import './emplyee.dart';
import './step.dart';
import '../models/state.dart';

class TaskProvider with ChangeNotifier {
  TaskProvider({
    required this.title,
    required this.state,
    required this.steps,
    required this.employees,
    this.startingDate,
    this.endingDate,
  });

  final List<EmployeeProvider> employees;

  final List<StepProvider> steps;

  ProgressState state;

  DateTime? startingDate;

  DateTime? endingDate;

  final String title;

  bool isArchived = false;

  bool isStarted = false;

  List<EmployeeProvider> get Employees {
    return [...employees];
  }

  List<StepProvider> get Steps {
    return [...steps];
  }

  double get level {
    if (steps.isEmpty) {
      return 0;
    }
    int completedTasks = steps.where((t) => t.isCompleted).length;
    return completedTasks / steps.length;
  }

  void updateState() {
    if (level == 1) {
      state = ProgressState.done;
      endingDate = DateTime.now();
    } else {
      state = ProgressState.inProgress;
    }
  }

  void start() {
    isStarted = true;
    startingDate = DateTime.now();
    updateState();
    notifyListeners();
  }

  void refresh() {
    updateState();
    notifyListeners();
  }
}
