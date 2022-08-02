import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../style/style.dart';
import './button.dart';
import './level_bar.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
    required this.title,
    required this.type,
    this.startingDate,
    this.endingDate,
    this.buttons,
  }) : super(key: key);

  final String title;
  final String type;
  final DateTime? startingDate;
  final DateTime? endingDate;
  final List<Widget>? buttons;

  @override
  Widget build(BuildContext context) {
    String projectPeriod;
    if (startingDate == null) {
      projectPeriod = 'لم تبدأ بعد';
    } else if (endingDate == null) {
      projectPeriod = 'بدأت في ${DateFormat.yMMMd().format(startingDate!)}';
    } else {
      projectPeriod =
          'بدأت في ${DateFormat.yMMMd().format(startingDate!)} وانتهى في ${DateFormat.yMMMd().format(endingDate!)}';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Style.backgroundColor,
          boxShadow: const [
            BoxShadow(blurRadius: 18, color: Style.shadowColor)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              projectPeriod,
              style: const TextStyle(
                color: Style.grey,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              type,
              style: const TextStyle(
                color: Style.grey,
                fontSize: 15,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const Center(
            child: LevelBar(
              level: .50,
              width: 300,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: ApplicationButton(
                  color: Style.green,
                  title: 'بدء',
                  onClick: () {},
                  verPad: 5,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ApplicationButton(
                  color: Style.grey,
                  title: 'أرشيف',
                  onClick: () {},
                  verPad: 5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
