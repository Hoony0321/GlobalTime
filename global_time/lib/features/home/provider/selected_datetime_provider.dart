import 'package:flutter/material.dart';

class SelectedDatetimeProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isRealTime = true;

  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isRealTime => _isRealTime;

  void setIsRealTime(bool isRealTime) {
    _isRealTime = isRealTime;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _isRealTime = false;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    _isRealTime = false;
    notifyListeners();
  }
}
