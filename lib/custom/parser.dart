import 'package:intl/intl.dart';

class Parser {
  static String parseDateTime(String dateTime) {
    return DateFormat('dd-MM-yyyy – kk:mm')
        .format(DateTime.parse(dateTime).toLocal());
  }

  static String getTimeFromDateTimeString(String dateTime) {
    return DateFormat('kk:mm').format(DateTime.parse(dateTime).toLocal());
  }

  static String parseEmail(String email) {
    return email.toString().split("@")[0];
  }
}
