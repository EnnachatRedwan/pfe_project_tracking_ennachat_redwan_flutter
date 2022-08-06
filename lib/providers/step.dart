import 'package:flutter/cupertino.dart';

class Step with ChangeNotifier{
  final String title;
  bool isCompleted=false;
  Step(this.title);
}