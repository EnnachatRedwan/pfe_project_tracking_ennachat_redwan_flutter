import 'package:flutter/cupertino.dart';

import './emplyee.dart';

class EmployeesProvider with ChangeNotifier {
  final List<EmployeeProvider> _employees = [
    EmployeeProvider(
        userID: '1', fullName: 'Ennachat Redwan', secWord: '4DJ8GD'),
    EmployeeProvider(
        userID: '2', fullName: 'Ennachat Meryem', secWord: 'GD6HD6'),
    EmployeeProvider(userID: '3', fullName: 'Abli Nawal', secWord: 'GD7DRS'),
  ];

  // List<EmployeeProvider> get employees {
  //   return [..._employees];
  // }

  List<EmployeeProvider> employees(String tag){
    return _employees.where((e) => e.fullName.toLowerCase().contains(tag.toLowerCase())).toList();
  }

  void addEmployee(String fullName) {
    _employees.add(EmployeeProvider(
        userID: UniqueKey().toString(),
        fullName: fullName,
        secWord: UniqueKey().toString()));
    notifyListeners();
  }

  void deleteEmployee(EmployeeProvider e) {
    _employees.remove(e);
    notifyListeners();
  }

  void updateEmployee(String userID, String newFullName) {
    _employees.firstWhere((emp) => emp.userID==userID).fullName=newFullName;
    notifyListeners();
  }
}
