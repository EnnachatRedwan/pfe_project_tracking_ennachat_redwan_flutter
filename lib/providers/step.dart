import 'package:flutter/cupertino.dart';

class StepProvider with ChangeNotifier {
  final int id;
  String title;
  String details;
  bool isCompleted;
  StepProvider({
    required this.id,
    required this.title,
    required this.details,
    this.isCompleted = false,
  });

  void check() {
    isCompleted = true;
    notifyListeners();
  }

  void uncheck() {
    isCompleted = false;
    notifyListeners();
  }
}
