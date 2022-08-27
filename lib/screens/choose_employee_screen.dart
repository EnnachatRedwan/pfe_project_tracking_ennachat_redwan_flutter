import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/providers/emplyee.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/emplyees.dart';
import '../widgets/choose_employee_tile.dart';
import '../providers/task.dart';

class ChooseEmployeesScreen extends StatefulWidget {
  const ChooseEmployeesScreen({Key? key}) : super(key: key);

  @override
  State<ChooseEmployeesScreen> createState() => _ChooseEmployeesScreenState();
}

class _ChooseEmployeesScreenState extends State<ChooseEmployeesScreen> {
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
      await Provider.of<TaskProvider>(context, listen: false)
          .fetchEmployees();
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void affectEmployee(EmployeeProvider emp) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).affectTask(emp);
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
    }
  }

    void unaffectEmployee(EmployeeProvider emp) async {
    try {
      await Provider.of<TaskProvider>(context, listen: false).unaffectTask(emp);
    } catch (err) {
      _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
    }
  }

  @override
  void initState() {
    fetchEmployees();
    super.initState();
  }

  String employeesToSearch = '';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final employeesProvider =
        Provider.of<EmployeesProvider>(context);
    final TaskProvider task = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: const ApplicationAppBar(title: 'إضافة موظفين'),
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
                    : ListView.builder(
                        itemBuilder: (ctx, i) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(
                              value: task.getEmployees(employeesProvider, employeesToSearch)[i],
                            ),
                            ChangeNotifierProvider.value(
                              value: task,
                            ),
                          ],
                          child: ChooseEmployeeTile(
                            affect: () => affectEmployee(task.getEmployees(employeesProvider, employeesToSearch)[i]),
                            unaffect:()=>unaffectEmployee(task.getEmployees(employeesProvider, employeesToSearch)[i]),
                          ),
                        ),
                        itemCount: task.getEmployees(employeesProvider, employeesToSearch).length,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
