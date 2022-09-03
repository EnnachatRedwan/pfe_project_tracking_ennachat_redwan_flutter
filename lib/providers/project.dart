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
    required this.createdIn,
    required this.level,
    this.isStarted = false,
    this.isArchived = false,
    this.startingDate,
    this.endingDate,
  });

  ProgressState state;

  DateTime? startingDate;

  DateTime? endingDate;

  String title;

  final int id;

  final double level;

  String type;

  DateTime createdIn;

  bool isStarted = false;

  bool isArchived = false;

  final TasksProvider tasks;

  void updateState() {
    if (level == 1) {
      state = ProgressState.done;
      endingDate = DateTime.now();
    } else {
      state = ProgressState.inProgress;
      endingDate = null;
    }
  }

  void editTask(String title, DateTime createdIn, String type) {
    this.title = title;
    this.createdIn = createdIn;
    this.type = type;
    notifyListeners();
  }

  void start() {
    isStarted = true;
    updateState();
    startingDate = DateTime.now();
    notifyListeners();
  }

  void rollStartBack() {
    isStarted = false;
    updateState();
    startingDate = null;
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

  void refresh() {
    updateState();
    notifyListeners();
  }
}
