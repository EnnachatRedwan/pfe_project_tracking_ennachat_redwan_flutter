import 'package:flutter/cupertino.dart';

import './project.dart';
import '../models/state.dart';
import './tasks.dart';
import './task.dart';
import './step.dart';

class ProjectsProvider with ChangeNotifier {
  final List<ProjectProvider> _projects = [
    ProjectProvider(
      id: '1',
      title: 'New Web Application',
      state: ProgressState.inProgress,
      type: 'Web application',
      tasks: TasksProvider(
        tasks: [
          TaskProvider(
            title: 'front-end',
            state: ProgressState.inProgress,
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
      tasks: TasksProvider(
        tasks: [
          TaskProvider(
            title: 'Front-end',
            state: ProgressState.inProgress,
            steps: [],
            employees: [],
          ),
          TaskProvider(
            title: 'Back-end',
            state: ProgressState.done,
            steps: [],
            employees: [],
          ),
          TaskProvider(
            title: 'Database',
            state: ProgressState.done,
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
      tasks: TasksProvider(
        tasks: [
          TaskProvider(
            title: 'front-end',
            state: ProgressState.inProgress,
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
      tasks: TasksProvider(
        tasks: [
          TaskProvider(
            title: 'front-end',
            state: ProgressState.inProgress,
            steps: [],
            employees: [],
          )
        ],
      ),
    ),
  ];

  List<ProjectProvider> get projects {
    return [..._projects];
  }

  void deleteProject(ProjectProvider p) {
    _projects.remove(p);
    notifyListeners();
  }
}
