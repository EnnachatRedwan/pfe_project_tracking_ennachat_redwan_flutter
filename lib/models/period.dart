import 'package:intl/intl.dart';

String getPeriod(DateTime? startingDate,DateTime? endingDate){
  String projectPeriod;
    if (startingDate == null) {
      projectPeriod = 'لم تبدأ بعد';
    } else if (endingDate == null) {
      projectPeriod =
          'بدأت في ${DateFormat.yMMMd().format(startingDate)}';
    } else {
      projectPeriod =
          'بدأت في ${DateFormat.yMMMd().format(startingDate)} وانتهى في ${DateFormat.yMMMd().format(endingDate)}';
    }
    return projectPeriod;
}