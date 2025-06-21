import 'package:intl/intl.dart';

class DateUtilsX {
  static String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d').format(date);
  }
}
