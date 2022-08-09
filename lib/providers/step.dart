import 'package:flutter/cupertino.dart';

class StepProvider with ChangeNotifier {
  final String id;
  String title;
  String details;
  bool isCompleted = false;
  StepProvider(this.id, this.title, this.details);

  void toggleState() {
    isCompleted = !isCompleted;
    notifyListeners();
  }

  void refresh(){
    notifyListeners();
  }
}
