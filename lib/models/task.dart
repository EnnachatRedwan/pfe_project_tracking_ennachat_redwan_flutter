import './state.dart';
import './emplyee.dart';

class Task {

  final String id;
  final String title;
  final String comment;
  final DateTime? startingDate;
  final DateTime? endingDate;
  final ProgressState state;
  final List<Emplyee>? emplyees;

  Task({
    required this.id,
    required this.title,
    required this.comment,
    required this.state,
    this.emplyees,
    this.startingDate,
    this.endingDate,
  });
}
