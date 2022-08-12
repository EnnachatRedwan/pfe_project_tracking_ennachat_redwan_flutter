import 'package:flutter/cupertino.dart';

import './project.dart';
import '../models/state.dart';
import './tasks.dart';
import './task.dart';

class ProjectsProvider with ChangeNotifier {
  final List<ProjectProvider> _projects = [
    ProjectProvider(
      id: '1',
      title: 'New Web Application',
      state: ProgressState.inProgress,
      type: 'Web application',
      createdIn: DateTime.now(),
      tasks: TasksProvider(
        tasks: [
          TaskProvider(
            id: UniqueKey().toString(),
            title: 'front-end',
            state: ProgressState.inProgress,
            addedIn: DateTime.now(),
            steps: [],
            employees: [],
          )
        ],
      ),
    ),
    ProjectProvider(
      id: '2',
      title: 'New Web Application',
      state: ProgressState.inProgress,
      type: 'Web application',
      createdIn: DateTime.now(),
      tasks: TasksProvider(
        tasks: [
          TaskProvider(
            id: UniqueKey().toString(),
            title: 'Front-end',
            state: ProgressState.inProgress,
            addedIn: DateTime.now(),
            steps: [],
            employees: [],
          ),
          TaskProvider(
            id: UniqueKey().toString(),
            title: 'Back-end',
            state: ProgressState.done,
            addedIn: DateTime.now(),
            steps: [],
            employees: [],
          ),
          TaskProvider(
            id: UniqueKey().toString(),
            title: 'Database',
            state: ProgressState.done,
            addedIn: DateTime.now(),
            steps: [],
            employees: [],
          ),
        ],
      ),
    ),
    ProjectProvider(
      id: '3',
      title: 'New Web Application',
      state: ProgressState.inProgress,
      type: 'Web application',
      createdIn: DateTime.now(),
      tasks: TasksProvider(
        tasks: [
          TaskProvider(
            id: UniqueKey().toString(),
            title: 'front-end',
            state: ProgressState.inProgress,
            addedIn: DateTime.now(),
            steps: [],
            employees: [],
          )
        ],
      ),
    ),
    ProjectProvider(
      id: '4',
      title: 'New Web Application',
      state: ProgressState.inProgress,
      type: 'Web application',
      createdIn: DateTime.now(),
      tasks: TasksProvider(
        tasks: [
          TaskProvider(
            id: UniqueKey().toString(),
            title: 'front-end',
            state: ProgressState.inProgress,
            addedIn: DateTime.now(),
            steps: [],
            employees: [],
          )
        ],
      ),
    ),
  ];

  List<ProjectProvider> notArchivedProjects(String tag) {
    if (tag.isEmpty) {
      return _projects.where((p) => !p.isArchived).toList();
    }
    return _projects.where((p) => !p.isArchived&&p.title.toLowerCase().contains(tag.toLowerCase())).toList();
  }

  // List<ProjectProvider> get archivedProjects {
  //   return _projects.where((p) => p.isArchived).toList();
  // }

  List<ProjectProvider> archivedProjects(String tag) {
    if (tag.isEmpty) {
      return _projects.where((p) => p.isArchived).toList();
    }
    return _projects.where((p) => p.isArchived&&p.title.toLowerCase().contains(tag.toLowerCase())).toList();
  }

  List<TaskProvider> archivedProjectTasks(String tag) {
    List<TaskProvider> tasks = [];
    for (var p in _projects) {
      tasks.addAll(p.tasks.archivedTasks(tag));
    }
    return tasks;
  }

  void deleteProject(ProjectProvider p) {
    _projects.remove(p);
    notifyListeners();
  }

  void addProject(String title, String type, DateTime createdIn) {
    _projects.add(
      ProjectProvider(
        id: UniqueKey().toString(),
        title: title,
        state: ProgressState.inProgress,
        type: type,
        tasks: TasksProvider(tasks: []),
        createdIn: createdIn,
      ),
    );
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
