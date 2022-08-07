import 'package:flutter/cupertino.dart';

import '../models/state.dart';
import './tasks.dart';

class ProjectProvider with ChangeNotifier {
  ProjectProvider({
    required this.id,
    required this.title,
    required this.state,
    required this.type,
    required this.tasks,
    this.startingDate,
    this.endingDate,
  });

  ProgressState state;

  DateTime? startingDate;

  DateTime? endingDate;

  final String title;

  final String id;

  final String type;

  bool isStarted=false;

  bool isArchived = false;

  final TasksProvider tasks;

  void updateState() {
    if (tasks.level == 1) {
      state = ProgressState.done;
      endingDate=DateTime.now();
    } else {
      state = ProgressState.inProgress;
    }
  }

  void start() {
    isStarted = true;
    updateState();
    startingDate=DateTime.now();
    notifyListeners();
  }

  void refresh() {
    updateState();
    notifyListeners();
  }
}
