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
    this.startingDate,
    this.endingDate,
  });

  ProgressState state;

  DateTime? startingDate;

  DateTime? endingDate;

  final String title;

  final String id;

  final String type;

  final DateTime createdIn;

  bool isStarted=false;

  bool isArchived = false;

  final TasksProvider tasks;

  void updateState() {
    if (tasks.level == 1) {
      state = ProgressState.done;
      endingDate=DateTime.now();
    } else {
      state = ProgressState.inProgress;
      endingDate=null;
    }
  }

  void start() {
    isStarted = true;
    updateState();
    startingDate=DateTime.now();
    notifyListeners();
  }

  void archive(){
    isArchived=true;
    notifyListeners();
  }

  void disArchive(){
    isArchived=false;
    notifyListeners();
  }

  void refresh() {
    updateState();
    notifyListeners();
  }
}
