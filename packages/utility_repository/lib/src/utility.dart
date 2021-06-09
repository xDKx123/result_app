import 'dart:async';
import 'package:intl/intl.dart';

///Other utility functions
class Utility{
  static const String dateFormat = 'dd.MM.yyyy';

  ///Get date from datetime
  static String getDate(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);
    return DateFormat(dateFormat).format(dateTime);
  }

}