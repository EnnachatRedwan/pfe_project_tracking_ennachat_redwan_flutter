import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/host_ip.dart';
import './emplyee.dart';
import './step.dart';
import '../models/state.dart';
import './emplyees.dart';

class TaskProvider with ChangeNotifier {
  TaskProvider({
    required this.id,
    required this.token,
    required this.title,
    required this.state,
    required this.steps,
    required this.addedIn,
    required this.projectId,
    this.isArchived = false,
    this.startingDate,
    this.endingDate,
    this.isStarted = false,
  });

  final int id;

  final String? token;

  final List<String> employeesUsename = [];

  final List<StepProvider> steps;

  final int projectId;

  ProgressState state;

  DateTime? startingDate;

  DateTime? endingDate;

  final DateTime addedIn;

  final String title;

  bool isArchived = false;

  bool isStarted;

  Future<void> fetchEmployees() async {
    final url = Uri.parse('$host/tasks/employees/$token/$id');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      for (var entery in data) {
        employeesUsename.add(entery["username"]);
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> affectTask(EmployeeProvider emp) async {
    final url = Uri.parse('$host/tasks/affect/$token');
    final body = jsonEncode({"taskId": id, "employeeUsername": emp.username});
    addTaskEmployee(emp);
    try {
      await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: body,
      );
    } catch (err) {
      deleteTaskEmployee(emp);
      rethrow;
    }
  }

  Future<void> unaffectTask(EmployeeProvider emp) async {
    final url = Uri.parse('$host/tasks/unaffect/$token');
    final body = jsonEncode({"taskId": id, "employeeUsername": emp.username});
    deleteTaskEmployee(emp);
    try {
      await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: body,
      );
    } catch (err) {
      addTaskEmployee(emp);
      rethrow;
    }
  }

  List<EmployeeProvider> getEmployees(EmployeesProvider emp,String tag) {
    List<EmployeeProvider> emps = [
      ...emp
          .employees(tag)
          .where((element) => !employeesUsename.contains(element.username))
    ];
    List<EmployeeProvider> taskEmps = [
      ...emp
          .employees(tag)
          .where((element) => employeesUsename.contains(element.username))
    ];
    for (var e in taskEmps) {
      emps.insert(0, e);
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
      endingDate = null;
    }
  }

  void start() {
    isStarted = true;
    startingDate = DateTime.now();
    updateState();
    notifyListeners();
  }

  void rollStartBack() {
    isStarted = false;
    updateState();
    startingDate = null;
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
    steps.add(StepProvider(UniqueKey().toString(), title, desc));
    notifyListeners();
  }

  void addTaskEmployee(EmployeeProvider emp) {
    employeesUsename.add(emp.username);
    notifyListeners();
  }

  void deleteTaskEmployee(EmployeeProvider emp) {
    employeesUsename.remove(emp.username);
    notifyListeners();
  }

  void updateStep(String id, String newTitle, String newDesc) {
    final stp = steps.firstWhere((step) => step.id == id);
    stp.title = newTitle;
    stp.details = newDesc;
    notifyListeners();
  }

  void archive() {
    isArchived = true;
    notifyListeners();
  }

  void unArchive() {
    isArchived = false;
    notifyListeners();
  }
}
