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

  final List<Step> steps;

  final ProgressState state;

  final DateTime? startingDate;

  final DateTime? endingDate;

  final String title;

  bool isArchived = false;

  List<EmployeeProvider> get Employees {
    return [...employees];
  }

  List<Step> get Steps {
    return [...steps];
  }

  double get level {
    if(steps.isEmpty)
    {
      return 0;
    }
    int completedTasks =
        steps.where((t) => t.isCompleted).length;
    return completedTasks / steps.length;
  }
}
