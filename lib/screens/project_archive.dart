import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/style/style.dart';

import '../widgets/appbar.dart';
import '../widgets/card.dart';
import '../widgets/drawer.dart';
import '../widgets/search_banner.dart';
import '../models/state.dart';

class ProjectArchiveScreen extends StatelessWidget {
  const ProjectArchiveScreen({Key? key}) : super(key: key);

  static const String routeName = '/projects-archive';

  void _openProjectBottomSheet(BuildContext context) {
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
                          labelText: 'عنوان المشروع',
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'نوع المشروع',
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'تاريخ البدء',
                        ),
                        readOnly: true,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return DatePickerDialog(
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .add(const Duration(days: -365)),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)));
                              }).then((value) => print(value));
                        },
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
    return Scaffold(
      appBar: const ApplicationAppBar(
        title: 'الأرشيف',
      ),
      drawer: const ApplicationDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const SearchBanner(),
            Expanded(
              child: GridView(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  maxCrossAxisExtent: 650,
                  childAspectRatio: 3 / 2,
                ),
                children: [
                  ApplicationCard.archive(
                    title: 'New tracking web application',
                    type: 'Application mobile',
                    startingDate: DateTime.now(),
                    endingDate: DateTime.now(),
                    level: .30,
                    state: ProgressState.inProgress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}