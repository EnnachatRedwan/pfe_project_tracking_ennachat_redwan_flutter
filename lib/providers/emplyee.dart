import 'package:flutter/cupertino.dart';

class EmployeeProvider with ChangeNotifier {
  final String username;
  String fullName;
  String? secWord;
  bool isActivated;

  EmployeeProvider({
    required this.username,
    required this.fullName,
    required this.isActivated,
    this.secWord,
  });

  void toggleAcivation(bool act){
    isActivated=act;
    notifyListeners();
  }

  void setKey(String newKey) {
    secWord = newKey;
    notifyListeners();
  }

  void editFullname(String fullname){
    fullName=fullname;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
