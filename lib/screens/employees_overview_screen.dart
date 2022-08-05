import 'dart:math';

import 'package:flutter/material.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  static const String routeName = '/emplyees';

  void _openEmployeeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'الاسم الكامل',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
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
        });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const List<Color> colors = [
      Color.fromARGB(255, 11, 174, 174),
      Color.fromARGB(255, 174, 11, 101),
      Color.fromARGB(255, 11, 174, 46),
      Color.fromARGB(255, 180, 188, 12),
    ];
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
                child: ListView.builder(
                  itemBuilder: (ctx, i) => Dismissible(
                    background: Container(
                      decoration: const BoxDecoration(
                        color: Style.red,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Style.backgroundColor,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    key: Key(DateTime.now().toString()),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                colors[Random().nextInt(colors.length)],
                            radius: 30,
                            child: const Icon(
                              Icons.person,
                              color: Style.backgroundColor,
                            ),
                          ),
                          title: const Text('ENNACHAT Redwan'),
                        ),
                        const Divider()
                      ],
                    ),
                  ),
                  itemCount: 20,
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
