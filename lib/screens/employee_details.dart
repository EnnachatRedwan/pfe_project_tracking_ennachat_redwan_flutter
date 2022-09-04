import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/confirm.dart';
import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/emplyee.dart';
import '../providers/emplyees.dart';
import '../widgets/button.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({
    Key? key,
    required this.delete,
  }) : super(key: key);

  static const String routeName = '/emplyee-Details';

  final Function delete;

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  void _showSnackBar(String message, {Color color = Style.red}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: color,
      ),
    );
  }

  bool isLoadingReset = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EmployeeProvider employee = Provider.of<EmployeeProvider>(context);
    final color = employee.isActivated ? Style.greenishYellow : Style.grey;

    void _openEmployeeBottomSheet(BuildContext context) {
      String fullName = '';
      final formKey = GlobalKey<FormState>();

      void save() async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          Navigator.of(context).pop();
          try {
            await Provider.of<EmployeesProvider>(context, listen: false)
                .editName(employee, fullName);
          } catch (err) {
            _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
          }
        }
      }

      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'اسم الموظف',
                        ),
                        textDirection: TextDirection.ltr,
                        initialValue: employee.fullName,
                        maxLength: 50,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم اسم موظف صالح';
                          }
                          if (value.length > 50) {
                            return 'يجب ألا يزيد الاسم الكامل عن 50 حرفًا';
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
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
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
                SelectableText(
                  employee.username,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                employee.secWord == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SelectableText(
                        employee.secWord!,
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
                  isLoading: isLoadingReset,
                  onClick: () async {
                    final bool confirmed = await Confirm.confirmDelete(
                            context, 'إعادة تعيين كلمة المرور', null) ??
                        false;
                    if (confirmed && mounted) {
                      setState(() {
                        isLoadingReset = true;
                      });
                      try {
                        await Provider.of<EmployeesProvider>(context,
                                listen: false)
                            .resetKey(employee);
                      } catch (err) {
                        _showSnackBar(
                            'حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
                      } finally {
                        setState(() {
                          isLoadingReset = false;
                        });
                      }
                    }
                  },
                  verPad: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                ApplicationButton(
                  color: Style.green,
                  title: 'تعديل',
                  isLoading: false,
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
                  isLoading: false,
                  onClick: () async {
                    final bool confirmed = await Confirm.confirmDelete(
                            context, 'الحذف', employee.fullName) ??
                        false;
                    if (confirmed && mounted) {
                      widget.delete();
                      Navigator.of(context).pop();
                    }
                  },
                  verPad: 5,
                ),
              ],
            )),
      ),
    );
  }
}
