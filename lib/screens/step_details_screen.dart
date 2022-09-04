import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/confirm.dart';
import '../providers/auth.dart';
import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/step.dart';
import '../widgets/button.dart';
import '../providers/task.dart';

class StepDetailsScreen extends StatefulWidget {
  const StepDetailsScreen({
    Key? key,
    required this.delete,
  }) : super(key: key);

  final Function delete;

  static const String routeName = '/emplyee-Details';

  @override
  State<StepDetailsScreen> createState() => _StepDetailsScreenState();
}

class _StepDetailsScreenState extends State<StepDetailsScreen> {
  void _openStepBottomSheet(BuildContext context, StepProvider step) {
    final descNode = FocusNode();

    String title = step.title;
    String desc = step.details;
    final formKey = GlobalKey<FormState>();

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

    void save() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        try {
          Provider.of<TaskProvider>(context, listen: false)
              .editStep(step, title.trim(), desc.trim());
        } catch (err) {
          _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
        } finally {
          Navigator.of(context).pop();
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
                        labelText: 'عنوان الخطوة',
                      ),
                      initialValue: title,
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.next,
                      maxLength: 50,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى تقديم عنوان صالح';
                        }
                        if (value.length > 50) {
                          return 'يجب ألا يزيد عنوان الخطوة عن 50 حرفًا';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        descNode.requestFocus();
                      },
                      onSaved: (value) {
                        title = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'تفاصيل الخطوة',
                      ),
                      initialValue: desc,
                      textDirection: TextDirection.ltr,
                      focusNode: descNode,
                      maxLength: 1000,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى تقديم وصف صحيح';
                        }
                        if (value.length > 1000) {
                          return 'يجب ألا يزيد وصف الخطوة عن 1000 حرف';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        save();
                      },
                      onSaved: (value) {
                        desc = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        save();
                      },
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final StepProvider step = Provider.of<StepProvider>(context);
    final task = Provider.of<TaskProvider>(context);

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

    void _toggleStep() async {
      try {
        await task.toggleStep(step);
      } catch (err) {
        _showSnackBar('حصل خطأ ،المرجو التحقق من الإتصال بالإنترنت');
      }
    }

    return Scaffold(
      appBar: const ApplicationAppBar(title: 'خطوة'),
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
                backgroundColor: step.isCompleted ? Style.blue : Style.red,
                radius: 60,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                step.title,
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
                step.details,
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('اكتمل'),
                  Checkbox(
                    value: step.isCompleted,
                    onChanged: (_) {
                      if (task.isStarted) {
                        _toggleStep();
                      }
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (Provider.of<AuthProvider>(context, listen: false).isLeader)
                Row(
                  children: [
                    Expanded(
                      child: ApplicationButton(
                        isLoading: false,
                        color: Style.red,
                        title: 'حذف',
                        onClick: () async {
                          final bool confirmed = await Confirm.confirmDelete(
                                  context,'الحذف', step.title) ??
                              false;
                          if (confirmed && mounted) {
                            widget.delete();
                            Navigator.of(context).pop();
                          }
                        },
                        verPad: 5,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ApplicationButton(
                        color: Style.green,
                        title: 'تعديل',
                        isLoading: false,
                        onClick: () {
                          _openStepBottomSheet(context, step);
                        },
                        verPad: 5,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
