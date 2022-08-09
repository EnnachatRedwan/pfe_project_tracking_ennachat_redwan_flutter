import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../widgets/appbar.dart';
import '../providers/step.dart';
import '../widgets/button.dart';
import '../providers/task.dart';

class StepDetailsScreen extends StatelessWidget {
  const StepDetailsScreen({Key? key}) : super(key: key);

  static const String routeName = '/emplyee-Details';

  void _openStepBottomSheet(BuildContext context, StepProvider step) {
    final descNode = FocusNode();

    String title = step.title;
    String desc = step.details;
    final formKey = GlobalKey<FormState>();

    void save() {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        Provider.of<TaskProvider>(context, listen: false)
            .updateStep(step.id, title, desc);
            step.refresh();
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
                        labelText: 'عنوان الخطوة',
                      ),
                      initialValue: title,
                      textDirection: TextDirection.ltr,
                      autofocus: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى تقديم عنوان صالح';
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى تقديم وصف صحيح';
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
                      step.toggleState();
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ApplicationButton(
                      color: Style.red,
                      title: 'حذف',
                      onClick: () {
                        Provider.of<TaskProvider>(context, listen: false)
                            .deleteTaskStep(step);
                        Navigator.of(context).pop();
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
                      onClick: () {
                        _openStepBottomSheet(context,step);
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
