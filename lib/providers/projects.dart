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

  List<ProjectProvider> get notArchivedProjects {
    return _projects.where((p) => !p.isArchived).toList();
  }

  List<ProjectProvider> get archivedProjects {
    return _projects.where((p) => p.isArchived).toList();
  }

  List<TaskProvider> get archivedProjectTasks {
    List<TaskProvider> tasks = [];
    for (var p in _projects) {
      tasks.addAll(p.tasks.tasks.where((t) => t.isArchived));
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
