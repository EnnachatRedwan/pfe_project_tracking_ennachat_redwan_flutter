import 'package:flutter/cupertino.dart';

import './emplyee.dart';
import './step.dart';
import '../models/state.dart';
import './emplyees.dart';

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

  List<EmployeeProvider> getEmployees(EmployeesProvider emp) {
    List<EmployeeProvider> emps = [];
    emps.addAll(emp.emplyees.where((element) => !employees.contains(element)));
    for (var element in employees) {
      emps.insert(0, element);
    }
    return emps;
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

  void deleteTaskStep(StepProvider s) {
    steps.remove(s);
    notifyListeners();
  }

  void addTaskStep(String title, String desc) {
    steps.add(StepProvider(UniqueKey().toString(),title, desc));
    notifyListeners();
  }

  void addTaskEmployee(EmployeeProvider emp) {
    employees.add(emp);
    notifyListeners();
  }

  void deleteTaskEmployee(EmployeeProvider emp) {
    employees.remove(emp);
    notifyListeners();
  }

  void updateStep(String id,String newTitle,String newDesc){
    final stp=steps.firstWhere((step) => step.id==id);
    stp.title=newTitle;
    stp.details=newDesc;
    notifyListeners();
  }
}
