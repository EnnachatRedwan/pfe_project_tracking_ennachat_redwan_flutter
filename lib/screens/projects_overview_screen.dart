import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/style/style.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

import '../providers/projects.dart';

import '../widgets/appbar.dart';
import '../widgets/cards/project_card.dart';
import '../widgets/drawer.dart';
import '../widgets/search_banner.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  static const String routeName = '/projects';

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  void _openProjectBottomSheet(BuildContext context) {
    String title = '';
    String type = '';
    DateTime createdIn = DateTime.now();
    final dateController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final typeFocusNode = FocusNode();

    void save() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Provider.of<ProjectsProvider>(context, listen: false)
            .addProject(title, type, createdIn);
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
                          labelText: 'عنوان المشروع',
                        ),
                        textAlign: TextAlign.end,
                        autofocus: true,
                        onFieldSubmitted: (_) {
                          typeFocusNode.requestFocus();
                        },
                        maxLength: 50,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم عنوان مشروع صالح';
                          }
                          if (value.length > 50) {
                            return 'يجب ألا يزيد عنوان المشروع عن 50 حرفًا';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          title = value!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'نوع المشروع',
                        ),
                        focusNode: typeFocusNode,
                        textAlign: TextAlign.end,
                        onFieldSubmitted: (_) => save(),
                        maxLength: 50,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يرجى تقديم نوع مشروع صالح';
                          }
                          if (value.length > 50) {
                            return 'يجب ألا يزيد نوع المشروع عن 50 حرفًا';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          type = value!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'أضيف في',
                        ),
                        controller: dateController,
                        textAlign: TextAlign.end,
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
                              }).then(
                            (value) {
                              if (value != null) {
                                createdIn =
                                    DateTime.tryParse(value.toString())!;
                                dateController.text = intl.DateFormat.yMMMd()
                                    .format(createdIn)
                                    .toString();
                              }
                            },
                          );
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
        });
  }

  String projectToSearch = '';

  @override
  Widget build(BuildContext context) {
    final ProjectsProvider projectsProvider =
        Provider.of<ProjectsProvider>(context);

    void search(String value) {
      projectToSearch = value;
      projectsProvider.refresh();
    }

    return Scaffold(
      appBar: const ApplicationAppBar(
        title: 'المشاريع',
      ),
      drawer: const ApplicationDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            SearchBanner(search: search),
            Expanded(
              child: GridView.builder(
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  maxCrossAxisExtent: 650,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: projectsProvider.notArchivedProjects(projectToSearch).length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value:
                      projectsProvider.notArchivedProjects(projectToSearch)[i],
                  child: const ProjectCard(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openProjectBottomSheet(context),
        backgroundColor: Style.primaryColor,
        child: const Icon(
          Icons.add,
          color: Style.secondaryColor,
        ),
      ),
    );
  }
}
