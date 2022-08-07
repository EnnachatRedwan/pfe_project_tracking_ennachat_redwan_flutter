import 'package:flutter/cupertino.dart';

class StepProvider with ChangeNotifier{
  final String title;
  bool isCompleted=false;
  StepProvider(this.title);

  void toggleState(){
    isCompleted=!isCompleted;
    notifyListeners();
  }
}