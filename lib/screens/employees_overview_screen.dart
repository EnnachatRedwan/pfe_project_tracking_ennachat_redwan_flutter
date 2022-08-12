import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

import '../providers/emplyees.dart';
import '../widgets/employee_tile.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  static const String routeName = '/emplyees';

  void _openEmployeeBottomSheet(BuildContext context) {
    String fullName = '';
    final formKey = GlobalKey<FormState>();

    void save() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Provider.of<EmployeesProvider>(context, listen: false)
            .addEmployee(fullName);
        Navigator.of(context).pop();
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'الاسم الكامل',
                        hintTextDirection: TextDirection.rtl),
                    autofocus: true,
                    onFieldSubmitted: (_) => save(),
                    maxLength: 50,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'يرجى تقديم اسم كامل صالح';
                      }
                      if (value.length > 50) {
                        return 'يجب ألا يزيد الاسم الكامل عن 50 حرفًا';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      fullName = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: save,
                    icon: const Icon(Icons.save),
                    label: const Text('حفظ'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Style.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final EmployeesProvider employeesProvider =
        Provider.of<EmployeesProvider>(context);
    return Scaffold(
      appBar: const ApplicationAppBar(title: 'الموظفين'),
      drawer: const ApplicationDrawer(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          width: size.width * .95,
          height: size.height * .80,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Style.backgroundColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(blurRadius: 10, color: Style.shadowColor)
            ],
          ),
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'بحث',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: employeesProvider.employees[i],
                    child: const EmployeeTile(),
                  ),
                  itemCount: employeesProvider.employees.length,
                  separatorBuilder: (ctx,i)=> const Divider(),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEmployeeBottomSheet(context),
        backgroundColor: Style.primaryColor,
        child: const Icon(
          Icons.add,
          color: Style.secondaryColor,
        ),
      ),
    );
  }
}
