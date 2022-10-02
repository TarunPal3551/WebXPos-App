import 'package:intl/intl.dart';

class WebXConstant {
  static String currencySymbol = "₹";

  static String formatDateTime(String dateTime) {
    DateFormat formatter = DateFormat("hh:mm a");
    return formatter.format(DateTime.parse(dateTime));
  }

  static String formatDate(String dateTime) {
    DateFormat formatter = DateFormat("dd MMM, yyyy");
    return formatter.format(DateTime.parse(dateTime));
  }

  static DateTime formattedDateOnly(String dateTime) {
    DateFormat formatter = DateFormat("dd-MM-yyyy");
    return DateTime.parse(formatter.format(DateTime.parse(dateTime)));
  }
}
