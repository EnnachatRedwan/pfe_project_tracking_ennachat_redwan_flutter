import 'package:flutter/cupertino.dart';

import './emplyee.dart';

class EmployeesProvider with ChangeNotifier {
  final List<EmployeeProvider> _employees = [
    EmployeeProvider(id: '1', fullName: 'Ennachat Redwan', secWord: '4DJ8GD'),
    EmployeeProvider(id: '2', fullName: 'Ennachat Meryem', secWord: 'GD6HD6'),
    EmployeeProvider(id: '3', fullName: 'Abli Nawal', secWord: 'GD7DRS'),
  ];

  List<EmployeeProvider> get emplyees {
    return [..._employees];
  }
}
