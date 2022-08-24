import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import './task.dart';
import '../models/state.dart';
import '../models/host_ip.dart';

class TasksProvider with ChangeNotifier {
  TasksProvider({
    required this.tasks,
    required this.token,
    required this.projectId,
  });
  final List<TaskProvider> tasks;
  String? token;
  final int projectId;

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

  Future<void> fetchTasks() async {
    tasks.clear();
    final url = Uri.parse('$host/tasks/$projectId/$token');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    for (var t in data) {

      tasks.add(
        TaskProvider(
          id: t["id_task"],
          title: t["title"],
          state:
              t["state"] == 1 ? ProgressState.inProgress : ProgressState.done,
          projectId: t["project_id"],
          steps: [],
          employees: [],
          addedIn: DateTime.parse(t["addingDate"]),
          startingDate: t["startingDate"] != null
              ? DateTime.parse(t["startingDate"])
              : null,
          endingDate:
              t["endingDate"] != null ? DateTime.parse(t["endingDate"]) : null,
          isStarted: t["isStarted"] == 1,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> addTask(String title, DateTime createdIn) async {
    final TaskProvider initialTask = TaskProvider(
      id: 0,
      title: title,
      state: ProgressState.inProgress,
      addedIn: createdIn,
      projectId: projectId,
      steps: [],
      employees: [],
    );
    tasks.add(initialTask);
    int index = tasks.indexOf(initialTask);
    notifyListeners();

    final url = Uri.parse('$host/tasks/$token');
    final body = jsonEncode({
      "title": title,
      "addingDate": intl.DateFormat('yyyy-MM-dd').format(createdIn),
      "projectId": projectId,
    });

    try {
      final response = await http.post(url,
          headers: {'content-type': 'application/json'}, body: body);
      final id = jsonDecode(response.body)[0]["id"];
      final TaskProvider t = TaskProvider(
        id: id,
        title: title,
        state: ProgressState.inProgress,
        addedIn: createdIn,
        projectId: projectId,
        steps: [],
        employees: [],
      );
      tasks.remove(initialTask);
      tasks.insert(index, t);
    } catch (err) {
      tasks.remove(initialTask);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTask(TaskProvider task) async {
    int index = tasks.indexOf(task);
    tasks.remove(task);
    notifyListeners();
    try {
      final url = Uri.parse('$host/tasks/$token');
      final body = jsonEncode({"id": task.id});
      await http.delete(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      tasks.insert(index, task);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> startProject(TaskProvider task) async {
    task.start();
    final url = Uri.parse('$host/tasks/start-task/$token');
    final body = jsonEncode({"id": task.id});
    try {
      await http.post(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      task.rollStartBack();
      rethrow;
    }
  }

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

  // void addTask(String title, DateTime addedIn) {
  //   tasks.add(TaskProvider(
  //       id: 1,
  //       title: title,
  //       state: ProgressState.inProgress,
  //       steps: [],
  //       employees: [],
  //       addedIn: addedIn,
  //       projectId: 1));
  //   notifyListeners();
  // }

  void refresh() {
    notifyListeners();
  }
}
