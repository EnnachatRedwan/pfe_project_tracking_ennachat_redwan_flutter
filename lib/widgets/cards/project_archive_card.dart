// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../style/style.dart';
// import '../button.dart';
// import '../level_bar.dart';
// import '../../models/state.dart';

// class ProjectArchiveCard extends StatelessWidget {
//   const ProjectArchiveCard({
//     Key? key,
//     required this.title,
//     required this.type,
//     required this.state,
//     this.level = 0,
//     this.startingDate,
//     this.endingDate,
//   }) : super(key: key);

//   final String title;
//   final String type;
//   final double level;
//   final ProgressState state;
//   final DateTime? startingDate;
//   final DateTime? endingDate;

//   @override
//   Widget build(BuildContext context) {
//     String projectPeriod;
//     if (startingDate == null) {
//       projectPeriod = 'لم تبدأ بعد';
//     } else if (endingDate == null) {
//       projectPeriod = 'بدأت في ${DateFormat.yMMMd().format(startingDate!)}';
//     } else {
//       projectPeriod =
//           'بدأت في ${DateFormat.yMMMd().format(startingDate!)} وانتهى في ${DateFormat.yMMMd().format(endingDate!)}';
//     }
//     return Dismissible(
//       background: Container(
//         decoration: const BoxDecoration(
//           color: Style.red,
//         ),
//         child: Row(
//           children: const [
//             SizedBox(
//               width: 20,
//             ),
//             Icon(
//               Icons.delete,
//               color: Style.backgroundColor,
//               size: 40,
//             )
//           ],
//         ),
//       ),
//       direction: DismissDirection.startToEnd,
//       key: Key(DateTime.now().toString()),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           color: Style.backgroundColor,
//           boxShadow: const [
//             BoxShadow(blurRadius: 18, color: Style.shadowColor)
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 23,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.end,
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 projectPeriod,
//                 style: const TextStyle(
//                   color: Style.grey,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 type,
//                 style: const TextStyle(
//                   color: Style.grey,
//                   fontSize: 15,
//                 ),
//                 textAlign: TextAlign.end,
//               ),
//             ),
//             if (state != ProgressState.notStarted)
//               Center(
//                 child: LevelBar(
//                   level: level,
//                   width: 300,
//                 ),
//               ),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 if (state == ProgressState.notStarted)
//                   Expanded(
//                     child: ApplicationButton(
//                       color: Style.green,
//                       title: 'بدء',
//                       onClick: () {},
//                       verPad: 5,
//                     ),
//                   ),
//                 if (state == ProgressState.inProgress)
//                   Expanded(
//                     child: ApplicationButton(
//                       color: Style.secondaryColor,
//                       title: 'قيد الإنجاز',
//                       onClick: () {},
//                       verPad: 5,
//                     ),
//                   ),
//                 if (state == ProgressState.done)
//                   Expanded(
//                     child: ApplicationButton(
//                       color: Style.blue,
//                       title: 'منجز',
//                       onClick: () {},
//                       verPad: 5,
//                     ),
//                   ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: ApplicationButton(
//                     color: Style.secondaryColor,
//                     title: 'إرجاع',
//                     onClick: () {},
//                     verPad: 5,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
