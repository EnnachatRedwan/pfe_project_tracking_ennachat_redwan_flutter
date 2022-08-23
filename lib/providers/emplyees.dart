import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import './emplyee.dart';
import '../models/host_ip.dart';

class EmployeesProvider with ChangeNotifier {
  final String token;

  EmployeesProvider(this.token);

  final List<EmployeeProvider> _employees = [
    //   EmployeeProvider(
    //       userID: '1', fullName: 'Ennachat Redwan', secWord: '4DJ8GD'),
    //   EmployeeProvider(
    //       userID: '2', fullName: 'Ennachat Meryem', secWord: 'GD6HD6'),
    //   EmployeeProvider(userID: '3', fullName: 'Abli Nawal', secWord: 'GD7DRS'),
  ];

  Future<void> fetchEmployees() async {
    _employees.clear();
    final url = Uri.parse('$host/employees/$token');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      for (var emp in data) {
        _employees.add(EmployeeProvider(
          username: emp["username"],
          fullName: emp["fullname"],
          secWord: emp["empKey"],
        ));
      }
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  List<EmployeeProvider> employees(String tag) {
    return _employees
        .where((e) => e.fullName.toLowerCase().contains(tag.toLowerCase()))
        .toList();
  }

  void addEmployee(String fullName) {
    _employees.add(EmployeeProvider(
        username: UniqueKey().toString(),
        fullName: fullName,
        secWord: UniqueKey().toString()));
    notifyListeners();
  }

  void deleteEmployee(EmployeeProvider e) {
    _employees.remove(e);
    notifyListeners();
  }

  void updateEmployee(String username, String newFullName) {
    _employees.firstWhere((emp) => emp.username == username).fullName = newFullName;
    notifyListeners();
  }
}
