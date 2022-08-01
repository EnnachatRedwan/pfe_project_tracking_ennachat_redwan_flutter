import 'package:flutter/material.dart';

import '../style/style.dart';
import './button.dart';
import './level_bar.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'New tracking web application',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(
            width: double.infinity,
            child: Text(
              'لم تبدأ بعدن',
              style: TextStyle(
                color: Style.grey,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Application mobile',
              style: TextStyle(
                color: Style.grey,
                fontSize: 15,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          Center(
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
