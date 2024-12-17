import 'dart:async';
import 'package:flutter/material.dart';
import 'package:global_time/features/home/provider/selected_datetime_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneProvider extends ChangeNotifier {
  static late final tz.Location localTimeZone;
  final SelectedDatetimeProvider _selectedDatetimeProvider;
  late tz.TZDateTime _baseDateTime;
  Timer? _timer;

  TimeZoneProvider({required SelectedDatetimeProvider selectedDatetimeProvider})
      : _selectedDatetimeProvider = selectedDatetimeProvider {
    _selectedDatetimeProvider.addListener(_onSelectedDatetimeChanged);
    _updateBaseDateTime();
    _initializeTimezone();
  }

  void _initializeTimezone() {
    final now = DateTime.now();
    final secondsUntilNextMinute = 60 - now.second;
    debugPrint('secondsUntilNextMinute: $secondsUntilNextMinute');

    Timer(Duration(seconds: secondsUntilNextMinute), () {
      _updateBaseRealTime();

      // 1 minute later
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        if (_selectedDatetimeProvider.isRealTime) {
          _updateBaseRealTime();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateBaseRealTime() {
    _baseDateTime = tz.TZDateTime.now(localTimeZone);
    notifyListeners();
  }

  void _updateBaseDateTime() {
    _baseDateTime = tz.TZDateTime(
      localTimeZone,
      _selectedDatetimeProvider.selectedDate.year,
      _selectedDatetimeProvider.selectedDate.month,
      _selectedDatetimeProvider.selectedDate.day,
      _selectedDatetimeProvider.selectedTime.hour,
      _selectedDatetimeProvider.selectedTime.minute,
    );
    notifyListeners();
  }

  static Future<void> init() async {
    tz.initializeTimeZones();
    localTimeZone = tz.getLocation(tz.local.name);
  }

  void _onSelectedDatetimeChanged() {
    _updateBaseDateTime();
  }

  tz.TZDateTime getCurrentTime(tz.Location timeZone) {
    return tz.TZDateTime.from(
      _baseDateTime,
      timeZone,
    );
  }

  int getTimeDifference(tz.Location timeZone) {
    final localTime = getCurrentTime(localTimeZone);
    final timeZoneTime = getCurrentTime(timeZone);
    final localTimeOffset = localTime.timeZoneOffset.inHours;
    final timeZoneOffset = timeZoneTime.timeZoneOffset.inHours;
    final offset = timeZoneOffset - localTimeOffset;
    return offset;
  }

  int getGmtOffset(tz.Location timeZone) {
    final now = getCurrentTime(timeZone);
    final offset = now.timeZoneOffset.inHours;
    return offset;
  }

  void restoreTime() {
    _baseDateTime = tz.TZDateTime.now(localTimeZone);
    notifyListeners();
  }
}
