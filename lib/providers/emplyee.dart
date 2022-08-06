import 'package:flutter/cupertino.dart';

class EmployeeProvider with ChangeNotifier {
  final String id;
  final String fullName;
  final String secWord;

  EmployeeProvider({
    required this.id,
    required this.fullName,
    required this.secWord,
  });
}
