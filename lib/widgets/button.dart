import 'package:flutter/material.dart';

class ApplicationButton extends StatelessWidget {
  const ApplicationButton({
    Key? key,
    required this.color,
    required this.title,
    required this.onClick,
    this.verPad = 0.0,
    this.horPad = 0.0,
  }) : super(key: key);

  final Color color;
  final String title;
  final double verPad;
  final double horPad;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horPad, vertical: verPad),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// if (state == ProgressState.notStarted)
                //   Expanded(
                //     child: ApplicationButton(
                //       color: Style.green,
                //       title: 'بدء',
                //       onClick: () {},
                //       verPad: 5,
                //     ),
                //   ),
                // if (state == ProgressState.inProgress)
                //   Expanded(
                //     child: ApplicationButton(
                //       color: Style.secondaryColor,
                //       title: 'قيد الإنجاز',
                //       onClick: () {},
                //       verPad: 5,
                //     ),
                //   ),
                // if (state == ProgressState.done)
                //   Expanded(
                //     child: ApplicationButton(
                //       color: Style.blue,
                //       title: 'منجز',
                //       onClick: () {},
                //       verPad: 5,
                //     ),
                //   ),
                // const SizedBox(
                //   width: 10,
                // ),
                // if(carsType==CardType.project) Expanded(
                //   child: ApplicationButton(
                //     color: Style.grey,
                //     title: 'أرشيف',
                //     onClick: () {},
                //     verPad: 5,
                //   ),
                // ),
                // if(carsType==CardType.archive) Expanded(
                //   child: ApplicationButton(
                //     color: Style.secondaryColor,
                //     title: 'إرجاع',
                //     onClick: () {},
                //     verPad: 5,
                //   ),
                // ),