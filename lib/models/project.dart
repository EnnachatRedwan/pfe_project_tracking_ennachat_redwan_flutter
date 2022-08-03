import './state.dart';
import './task.dart';

class Project{
  final String id;
  final String title;
  final DateTime? startingDate;
  final DateTime? endingDate;
  final ProgressState state;
  final List<Task>? tasks;

  Project({
    required this.id,
    required this.title,
    required this.state,
    this.tasks,
    this.startingDate,
    this.endingDate,
  });
}