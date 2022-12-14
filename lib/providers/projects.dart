import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import './project.dart';
import '../models/state.dart';
import './tasks.dart';
import './task.dart';
import '../models/host_ip.dart';

class ProjectsProvider with ChangeNotifier {
  final List<ProjectProvider> _projects = [
    //   ProjectProvider(
    //     id: '1',
    //     title: 'New Web Application',
    //     state: ProgressState.inProgress,
    //     type: 'Web application',
    //     createdIn: DateTime.now(),
    //     tasks: TasksProvider(
    //       tasks: [
    //         TaskProvider(
    //           id: UniqueKey().toString(),
    //           title: 'front-end',
    //           state: ProgressState.inProgress,
    //           addedIn: DateTime.now(),
    //           steps: [],
    //           employees: [],
    //         )
    //       ],
    //     ),
    //   ),
    //   ProjectProvider(
    //     id: '2',
    //     title: 'New Web Application',
    //     state: ProgressState.inProgress,
    //     type: 'Web application',
    //     createdIn: DateTime.now(),
    //     tasks: TasksProvider(
    //       tasks: [
    //         TaskProvider(
    //           id: UniqueKey().toString(),
    //           title: 'Front-end',
    //           state: ProgressState.inProgress,
    //           addedIn: DateTime.now(),
    //           steps: [],
    //           employees: [],
    //         ),
    //         TaskProvider(
    //           id: UniqueKey().toString(),
    //           title: 'Back-end',
    //           state: ProgressState.done,
    //           addedIn: DateTime.now(),
    //           steps: [],
    //           employees: [],
    //         ),
    //         TaskProvider(
    //           id: UniqueKey().toString(),
    //           title: 'Database',
    //           state: ProgressState.done,
    //           addedIn: DateTime.now(),
    //           steps: [],
    //           employees: [],
    //         ),
    //       ],
    //     ),
    //   ),
    //   ProjectProvider(
    //     id: '3',
    //     title: 'New Web Application',
    //     state: ProgressState.inProgress,
    //     type: 'Web application',
    //     createdIn: DateTime.now(),
    //     tasks: TasksProvider(
    //       tasks: [
    //         TaskProvider(
    //           id: UniqueKey().toString(),
    //           title: 'front-end',
    //           state: ProgressState.inProgress,
    //           addedIn: DateTime.now(),
    //           steps: [],
    //           employees: [],
    //         )
    //       ],
    //     ),
    //   ),
    //   ProjectProvider(
    //     id: '4',
    //     title: 'New Web Application',
    //     state: ProgressState.inProgress,
    //     type: 'Web application',
    //     createdIn: DateTime.now(),
    //     tasks: TasksProvider(
    //       tasks: [
    //         TaskProvider(
    //           id: UniqueKey().toString(),
    //           title: 'front-end',
    //           state: ProgressState.inProgress,
    //           addedIn: DateTime.now(),
    //           steps: [],
    //           employees: [],
    //         )
    //       ],
    //     ),
    //   ),
  ];

  final String? token;

  ProjectsProvider({this.token});

  Future<void> fetchProjects() async {
    _projects.clear();
    final url = Uri.parse('$host/projects/$token');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      for (var p in data) {
        _projects.add(
          ProjectProvider(
              id: p["id_prj"],
              title: p["title"],
              isStarted: p["isStarted"] == 1,
              state: p["state"] == 1
                  ? ProgressState.inProgress
                  : ProgressState.done,
              type: p["type"],
              level: double.parse(p["percentage"].toString()),
              isArchived: p["archived"] == 1,
              tasks: TasksProvider(
                  token: token, projectId: p["id_prj"], tasks: []),
              createdIn: DateTime.parse(p["addingDate"]),
              startingDate: p["startingDate"] != null
                  ? DateTime.parse(p["startingDate"])
                  : null,
              endingDate: p["endingDate"] != null
                  ? DateTime.parse(p["endingDate"])
                  : null),
        );
      }
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addProject(String title, String type, DateTime createdIn) async {
    final ProjectProvider initialProject = ProjectProvider(
      id: 0,
      title: title,
      state: ProgressState.inProgress,
      type: type,
      tasks: TasksProvider(token: token, projectId: 0, tasks: []),
      createdIn: createdIn,
      level: 0.0,
    );
    _projects.add(initialProject);
    int index = _projects.indexOf(initialProject);
    notifyListeners();

    final url = Uri.parse('$host/projects/$token');
    final body = jsonEncode({
      "title": title,
      "type": type,
      "addingDate": intl.DateFormat('yyyy-MM-dd').format(createdIn)
    });

    try {
      final response = await http.post(url,
          headers: {'content-type': 'application/json'}, body: body);
      final id = jsonDecode(response.body)[0]["id"];
      final ProjectProvider p = ProjectProvider(
        id: id,
        title: title,
        state: ProgressState.inProgress,
        type: type,
        tasks: TasksProvider(token: token, projectId: id, tasks: []),
        createdIn: createdIn,
        level: 0.0,
      );
      _projects.remove(initialProject);
      _projects.insert(index, p);
    } catch (err) {
      _projects.remove(initialProject);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> editProject(String newTitle, DateTime newCreatedIn,
      String newType, ProjectProvider project) async {
    final String oldTitle = project.title;
    final DateTime oldDate = project.createdIn;
    final String oldType = project.type;
    project.editTask(newTitle, newCreatedIn, newType);
    try {
      final url = Uri.parse('$host/projects/$token');
      final body = jsonEncode({
        "id": project.id,
        "title": project.title,
        "addingDate": intl.DateFormat('yyyy-MM-dd').format(newCreatedIn),
        "type": newType,
      });
      await http.patch(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      project.editTask(oldTitle, oldDate, oldType);
    }
  }

  Future<void> deleteProject(ProjectProvider p) async {
    int index = _projects.indexOf(p);
    _projects.remove(p);
    notifyListeners();
    try {
      final url = Uri.parse('$host/projects/$token');
      final body = jsonEncode({"id": p.id});
      await http.delete(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      _projects.insert(index, p);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> startProject(ProjectProvider p) async {
    p.start();
    final url = Uri.parse('$host/projects/start-project/$token');
    final body = jsonEncode({"id": p.id});
    try {
      await http.post(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      p.rollStartBack();
      rethrow;
    }
  }

  Future<void> archiveProject(ProjectProvider p) async {
    p.archive();
    notifyListeners();
    final url = Uri.parse('$host/projects/archive/$token');
    final body = jsonEncode({"id": p.id});
    try {
      await http.post(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      p.unArchive();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> unarchiveProject(ProjectProvider p) async {
    p.unArchive();
    notifyListeners();
    final url = Uri.parse('$host/projects/unarchive/$token');
    final body = jsonEncode({"id": p.id});
    try {
      await http.post(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      p.archive();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> unarchiveTask(TaskProvider t) async {
    t.unArchive();
    notifyListeners();
    final url = Uri.parse('$host/tasks/unarchive/$token');
    final body = jsonEncode({"id": t.id});
    try {
      await http.post(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      t.archive();
      notifyListeners();
      rethrow;
    }
  }

  List<ProjectProvider> notArchivedProjects(String tag) {
    if (tag.isEmpty) {
      return _projects.where((p) => !p.isArchived).toList();
    }
    return _projects
        .where((p) =>
            !p.isArchived &&
                p.title.toLowerCase().contains(tag.toLowerCase()) ||
            !p.isArchived && p.type.toLowerCase().contains(tag.toLowerCase()))
        .toList();
  }

  List<ProjectProvider> archivedProjects(String tag) {
    if (tag.isEmpty) {
      return _projects.where((p) => p.isArchived).toList();
    }
    return _projects
        .where((p) =>
            p.isArchived && p.title.toLowerCase().contains(tag.toLowerCase()) ||
            p.type.toLowerCase().contains(tag.toLowerCase()))
        .toList();
  }

  List<TaskProvider> archivedProjectTasks(String tag) {
    List<TaskProvider> tasks = [];
    for (var p in _projects) {
      tasks.addAll(p.tasks.archivedTasks(tag));
    }
    return tasks;
  }

  // int i = 100;

  // void addProject(String title, String type, DateTime createdIn) {
  //   _projects.add(
  //     ProjectProvider(
  //       id: 1 + i,
  //       title: title,
  //       state: ProgressState.inProgress,
  //       type: type,
  //       tasks: TasksProvider(tasks: []),
  //       createdIn: createdIn,
  //     ),
  //   );
  //   i++;
  //   notifyListeners();
  // }

  void refresh() {
    notifyListeners();
  }
}
