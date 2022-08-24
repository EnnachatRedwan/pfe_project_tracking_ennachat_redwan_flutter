import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/emplyee.dart';
import '../style/style.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

import '../providers/emplyees.dart';
import '../widgets/employee_tile.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  static const String routeName = '/emplyees';

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Style.red,
      ),
    );
  }

  bool isLoading = false;

  Future<void> fetchEmployees() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<EmployeesProvider>(context, listen: false)
          .fetchEmployees();
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchEmployees();
    super.initState();
  }

  void _openEmployeeBottomSheet(BuildContext context) {
    final fullNameNode = FocusNode();
    String fullName = '';
    String username = '';
    final formKey = GlobalKey<FormState>();

    void save() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Navigator.of(context).pop();
        try {
          await Provider.of<EmployeesProvider>(context, listen: false)
              .addEmployee(username, fullName);
        } catch (err) {
          if (err.toString() == '409') {
            _showSnackBar('اسم مستخدم مستعمل من قبل');
          } else {
            _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
          }
        }
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'اسم االمستخدم',
                      ),
                      textDirection: TextDirection.ltr,
                      autofocus: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى تقديم اسم مستخدم صالح';
                        }
                        if (value.length > 30) {
                          return 'يجب ألا يزيد الاسم عن 30 حرفًا';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        fullNameNode.requestFocus();
                      },
                      onSaved: (value) {
                        username = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكامل',
                      ),
                      textDirection: TextDirection.ltr,
                      focusNode: fullNameNode,
                      onFieldSubmitted: (_) => save(),
                      maxLength: 30,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى تقديم اسم كامل صالح';
                        }
                        if (value.length > 30) {
                          return 'يجب ألا يزيد الاسم الكامل عن 30 حرفًا';
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
          ),
        );
      },
    );
  }

  String employeesToSearch = '';

  void delete(EmployeeProvider emp) async {
    try {
      await Provider.of<EmployeesProvider>(context, listen: false)
          .deleteEmployee(emp);
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final EmployeesProvider employeesProvider =
        Provider.of<EmployeesProvider>(context);
    return Scaffold(
      appBar: ApplicationAppBar(
        title: 'الموظفين',
        acts: [
          IconButton(onPressed: fetchEmployees, icon: const Icon(Icons.refresh))
        ],
      ),
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
                  textDirection: TextDirection.ltr,
                  onChanged: (value) {
                    setState(() {
                      employeesToSearch = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                          value:
                              employeesProvider.employees(employeesToSearch)[i],
                          child: EmployeeTile(
                            delete: () => delete(employeesProvider
                                .employees(employeesToSearch)[i]),
                          ),
                        ),
                        itemCount: employeesProvider
                            .employees(employeesToSearch)
                            .length,
                        separatorBuilder: (ctx, i) => const Divider(),
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
