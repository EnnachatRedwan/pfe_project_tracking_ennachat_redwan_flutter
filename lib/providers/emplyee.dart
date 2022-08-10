import 'package:flutter/cupertino.dart';

class EmployeeProvider with ChangeNotifier {
  final String userID;
  String fullName;
  String secWord;

  EmployeeProvider({
    required this.userID,
    required this.fullName,
    required this.secWord,
  });

  void refresh(){
    notifyListeners();
  }
}
