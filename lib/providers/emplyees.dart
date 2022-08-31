import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_project_tracking_ennachat_redwan/models/http_exception.dart';

import './emplyee.dart';
import '../models/host_ip.dart';

class EmployeesProvider with ChangeNotifier {
  final String? token;

  EmployeesProvider({this.token});

  final List<EmployeeProvider> _employees = [];

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
          isActivated: emp["isActivated"] == 1,
        ));
      }
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> deleteEmployee(EmployeeProvider emp) async {
    final index = _employees.indexOf(emp);
    _employees.remove(emp);
    notifyListeners();
    final url = Uri.parse('$host/employees/$token');
    final body = jsonEncode({"username": emp.username});
    try {
      await http.delete(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      _employees.insert(index, emp);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resetKey(EmployeeProvider emp) async {
    emp.toggleAcivation(false);
    final url = Uri.parse('$host/employees/$token');
    final body = jsonEncode({"username": emp.username});
    try {
      final response = await http.put(url,
          headers: {'content-type': 'application/json'}, body: body);
      final data = jsonDecode(response.body);
      emp.setKey(data["key"]);
    } catch (err) {
      emp.toggleAcivation(true);
      rethrow;
    }
  }

  Future<void> editName(EmployeeProvider emp, String fullname) async {
    final String oldFullname = emp.fullName;
    emp.editFullname(fullname);

    final url = Uri.parse('$host/employees/$token');
    final body = jsonEncode({"username": emp.username, "fullname": fullname});
    try {
      await http.patch(url,
          headers: {'content-type': 'application/json'}, body: body);
    } catch (err) {
      emp.editFullname(oldFullname);
      rethrow;
    }
  }

  List<EmployeeProvider> employees(String tag) {
    return _employees
        .where((e) => e.fullName.toLowerCase().contains(tag.toLowerCase()))
        .toList();
  }

  Future<void> addEmployee(String username, String fullname) async {
    final emp = EmployeeProvider(
      username: username,
      fullName: fullname,
      isActivated: false,
    );
    _employees.add(emp);
    notifyListeners();
    try {
      final url = Uri.parse('$host/employees/$token');
      final body = jsonEncode({"username": username, "fullname": fullname});
      final response = await http.post(url,
          headers: {'content-type': 'application/json'}, body: body);
      if (response.statusCode == 409) {
        throw HttpException('409');
      }
      final data = jsonDecode(response.body);
      emp.setKey(data["key"]);
    } catch (err) {
      _employees.remove(emp);
      notifyListeners();
      rethrow;
    }
  }
}
