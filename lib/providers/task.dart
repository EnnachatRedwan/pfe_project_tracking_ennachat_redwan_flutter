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
    required this.level,
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

  final double level;

  ProgressState state;

  DateTime? startingDate;

  DateTime? endingDate;

  DateTime addedIn;

  String title;

  bool isArchived = false;

  bool isStarted;

  void editTask(String title, DateTime addedIn) {
    this.title = title;
    this.addedIn = addedIn;
    notifyListeners();
  }

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

  Future<void> fetchSteps() async {
    steps.clear();
    final url = Uri.parse('$host/steps/$token/$id');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      for (var record in data) {
        steps.add(
          StepProvider(
            id: record["id_step"],
            title: record["title"],
            details: record["description"],
            isCompleted: record["isDone"] == 1,
          ),
        );
      }
      updateState();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addStep(String title, String desc) async {
    final StepProvider initialStep = StepProvider(
      id: 0,
      title: title,
      details: desc,
    );
    steps.add(initialStep);
    int index = steps.indexOf(initialStep);
    updateState();

    final url = Uri.parse('$host/steps/$token');
    final body = jsonEncode({
      "taskId": id,
      "title": title,
      "desc": desc,
    });

    try {
      final response = await http.post(url,
          headers: {'content-type': 'application/json'}, body: body);
      final id = jsonDecode(response.body)[0]["id"];
      final StepProvider s = StepProvider(id: id, title: title, details: desc);
      steps.remove(initialStep);
      steps.insert(index, s);
    } catch (err) {
      steps.remove(initialStep);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleStep(StepProvider step) async {
    if (step.isCompleted) {
      step.uncheck();
      updateState();
      final url = Uri.parse('$host/steps/uncheck/$token/${step.id}');
      try {
        await http.post(url);
      } catch (err) {
        step.check();
        updateState();
        rethrow;
      }
    } else {
      step.check();
      updateState();
      final url = Uri.parse('$host/steps/check/$token/${step.id}');
      try {
        await http.post(url);
      } catch (err) {
        step.uncheck();
        updateState();
        rethrow;
      }
    }
  }

  Future<void> deleteStep(StepProvider step) async {
    int index = steps.indexOf(step);
    steps.remove(step);
    updateState();
    try {
      final url = Uri.parse('$host/steps/$token');
      final body = jsonEncode({"id": step.id});
      await http.delete(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      steps.insert(index, step);
      updateState();
      rethrow;
    }
  }

  Future<void> editStep(StepProvider step, String title, String desc) async {
    final String oldTitle = step.title;
    final String oldDesc = step.details;

    step.title = title;
    step.details = desc;
    updateState();
    try {
      final url = Uri.parse('$host/steps/$token');
      final body = jsonEncode({
        "id": step.id,
        "title": title,
        "desc": desc,
      });
      await http.put(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      step.title = oldTitle;
      step.details = oldDesc;
      updateState();
      rethrow;
    }
  }

  List<EmployeeProvider> getEmployees(EmployeesProvider emp, String tag) {
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

  void updateState() {
    if (level == 1) {
      state = ProgressState.done;
      endingDate = DateTime.now();
    } else {
      state = ProgressState.inProgress;
      endingDate = null;
    }
    notifyListeners();
  }

  void start() {
    isStarted = true;
    startingDate = DateTime.now();
    updateState();
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
    // steps.add(StepProvider(UniqueKey().toString(), title, desc));
    // notifyListeners();
  }

  void addTaskEmployee(EmployeeProvider emp) {
    employeesUsename.add(emp.username);
    notifyListeners();
  }

  void deleteTaskEmployee(EmployeeProvider emp) {
    employeesUsename.remove(emp.username);
    notifyListeners();
  }

  void updateStep(int id, String newTitle, String newDesc) {
    // final stp = steps.firstWhere((step) => step.id == id);
    // stp.title = newTitle;
    // stp.details = newDesc;
    // notifyListeners();
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
