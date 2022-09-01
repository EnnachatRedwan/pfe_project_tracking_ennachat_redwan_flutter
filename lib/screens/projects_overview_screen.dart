import 'package:flutter/material.dart';
import 'package:pfe_project_tracking_ennachat_redwan/style/style.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

import '../providers/projects.dart';
import '../providers/project.dart';
import '../providers/auth.dart';

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
  bool isLoading = false;

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

  Future<void> fetchProjects() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ProjectsProvider>(context, listen: false)
          .fetchProjects();
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
    fetchProjects();
    super.initState();
  }

  // String title = '';
  // String type = '';
  // DateTime createdIn = DateTime.now();
  // final dateController = TextEditingController();
  // final formKey = GlobalKey<FormState>();
  // final typeFocusNode = FocusNode();

  // @override
  // void dispose() {
  //   dateController.dispose();
  //   typeFocusNode.dispose();
  //   super.dispose();
  // }

  void _openProjectBottomSheet(BuildContext context) {
    String title = '';
    String type = '';
    DateTime createdIn = DateTime.now();
    final dateController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final typeFocusNode = FocusNode();

    void save() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Navigator.of(context).pop();
        try {
          await Provider.of<ProjectsProvider>(context, listen: false)
              .addProject(title, type, createdIn);
        } catch (err) {
          _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
        }
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
                        textDirection: TextDirection.ltr,
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
                        textDirection: TextDirection.ltr,
                        focusNode: typeFocusNode,
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
                        readOnly: true,
                        textDirection: TextDirection.ltr,
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

  final GlobalKey<ScaffoldMessengerState> _scf =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final ProjectsProvider projectsProvider =
        Provider.of<ProjectsProvider>(context);

    void search(String value) {
      projectToSearch = value;
      projectsProvider.refresh();
    }

    void deleteProject(ProjectProvider project) async {
      try {
        await Provider.of<ProjectsProvider>(context, listen: false)
            .deleteProject(project);
      } catch (err) {
        _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
      }
    }

    void archive(ProjectProvider project) async {
      try {
        await Provider.of<ProjectsProvider>(context, listen: false)
            .archiveProject(project);
      } catch (err) {
        _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
      }
    }

    final width=MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scf,
      appBar: ApplicationAppBar(
        title: 'المشاريع',
        acts: [
          IconButton(onPressed: fetchProjects, icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: const ApplicationDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            SearchBanner(search: search),
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: fetchProjects,
                      child: GridView.builder(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 20,
                          bottom: 10,
                        ),
                        gridDelegate:
                         SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          maxCrossAxisExtent: width<780? 800: 600,
                          childAspectRatio: width<350? 1: 3 / 2,
                        ),
                        itemCount: projectsProvider
                            .notArchivedProjects(projectToSearch)
                            .length,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                          value: projectsProvider
                              .notArchivedProjects(projectToSearch)[i],
                          child: ProjectCard(
                            delete: () => deleteProject(projectsProvider
                                .notArchivedProjects(projectToSearch)[i]),
                            archive: () => archive(projectsProvider
                                .notArchivedProjects(projectToSearch)[i]),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton:
          Provider.of<AuthProvider>(context, listen: false).isLeader
              ? FloatingActionButton(
                  onPressed: () => _openProjectBottomSheet(context),
                  backgroundColor: Style.primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: Style.secondaryColor,
                  ),
                )
              : null,
    );
  }
}
