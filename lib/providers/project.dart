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

  final ProgressState state;

  final DateTime? startingDate;

  final DateTime? endingDate;

  final String title;

  final String id;

  final String type;

  bool isArchived = false;

  final TasksProvider tasks;

  void refresh(){
    notifyListeners();
  }

  
}
