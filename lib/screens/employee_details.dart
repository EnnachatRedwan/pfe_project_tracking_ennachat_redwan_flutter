import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/emplyee.dart';
import '../providers/emplyees.dart';
import '../widgets/button.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  const EmployeeDetailsScreen({Key? key}) : super(key: key);

  static const String routeName = '/emplyee-Details';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EmployeeProvider employee = Provider.of<EmployeeProvider>(context);
    final Color color = ModalRoute.of(context)!.settings.arguments as Color;

    void _openEmployeeBottomSheet(BuildContext context) {
      String fullName = '';
      final formKey = GlobalKey<FormState>();

      void save() {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          Provider.of<EmployeesProvider>(context, listen: false).updateEmployee(employee.userID, fullName);
          employee.refresh();
          Navigator.of(context).pop();
        }
      }

      showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'اسم الموظف',
                        ),
                        textDirection: TextDirection.ltr,
                        initialValue: employee.fullName,
                        autofocus: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم اسم الموظف صحيح';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          save();
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
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: const ApplicationAppBar(title: 'تعديل موظف'),
      body: Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
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
            child: ListView(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 60,
                  child: const Icon(
                    Icons.person,
                    color: Style.backgroundColor,
                    size: 60,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  employee.fullName,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  employee.secWord,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                ApplicationButton(
                  color: Style.blue,
                  title: 'إعادة تعيين كلمة المرور',
                  onClick: () {},
                  verPad: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                ApplicationButton(
                  color: Style.green,
                  title: 'تعديل',
                  onClick: () {
                    _openEmployeeBottomSheet(context);
                  },
                  verPad: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                ApplicationButton(
                  color: Style.red,
                  title: 'حذف الموظف',
                  onClick: () {
                    Provider.of<EmployeesProvider>(context, listen: false)
                        .deleteEmployee(employee);
                    Navigator.of(context).pop();
                  },
                  verPad: 5,
                ),
              ],
            )),
      ),
    );
  }
}
