import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class TimeZoneFormatter {
  static String formatTimeZoneName(tz.Location timeZone) {
    final cityName = timeZone.name.split('/').last;
    return cityName.replaceAll('_', '');
  }

  static String formatTime24Hour(tz.TZDateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String formatTime12Hour(tz.TZDateTime dateTime) {
    final isPM = dateTime.hour >= 12;
    int hour12 = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    hour12 = hour12 == 0 ? 12 : hour12;
    final minuteStr = dateTime.minute.toString().padLeft(2, '0');
    final period = isPM ? 'PM' : 'AM';
    return '$hour12:$minuteStr $period';
  }

  static String formatTimezoneDifference(int timeDiff) {
    if (timeDiff >= 0) {
      return "+$timeDiff";
    } else {
      return "$timeDiff";
    }
  }

  static String formatTimezoneDateTime(tz.TZDateTime dateTime) {
    return DateFormat('MMM d (E)').format(dateTime);
  }

  static String formatTimezoneGmtOffset(int gmtOffset) {
    return 'GMT $gmtOffset';
  }

  static String formatShareDateTime(tz.TZDateTime dateTime) {
    var formatTime12Hour = TimeZoneFormatter.formatTime12Hour(dateTime);
    var formatTimezoneDateTime =
        TimeZoneFormatter.formatTimezoneDateTime(dateTime);
    return '$formatTime12Hour $formatTimezoneDateTime ';
  }
}
