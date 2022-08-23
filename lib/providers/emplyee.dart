import 'package:flutter/cupertino.dart';

class EmployeeProvider with ChangeNotifier {
  final String username;
  String fullName;
  String secWord;

  EmployeeProvider({
    required this.username,
    required this.fullName,
    required this.secWord,
  });

  void refresh(){
    notifyListeners();
  }
}
