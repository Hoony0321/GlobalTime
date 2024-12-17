import 'package:flutter/material.dart';
import 'package:global_time/core/utils/time_zone_formatter.dart';
import 'package:global_time/features/home/model/country_info_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class CountryInfoProvider extends ChangeNotifier {
  final List<CountryInfoItem> _items = [];
  static const String _storageKey = 'saved_countries';

  List<CountryInfoItem> get items => List.unmodifiable(_items);

  CountryInfoProvider() {
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList(_storageKey) ?? [];

    if (savedItems.isEmpty) {
      _items.addAll([
        CountryInfoItem(
            name: TimeZoneFormatter.formatTimeZoneName(
                tz.getLocation('America/New_York')),
            timeZone: tz.getLocation('America/New_York')),
        CountryInfoItem(
            name: TimeZoneFormatter.formatTimeZoneName(
                tz.getLocation('Asia/Seoul')),
            timeZone: tz.getLocation('Asia/Seoul')),
        CountryInfoItem(
            name: TimeZoneFormatter.formatTimeZoneName(
                tz.getLocation('Asia/Tokyo')),
            timeZone: tz.getLocation('Asia/Tokyo')),
        CountryInfoItem(
            name: TimeZoneFormatter.formatTimeZoneName(
                tz.getLocation('Europe/London')),
            timeZone: tz.getLocation('Europe/London')),
        CountryInfoItem(
            name: TimeZoneFormatter.formatTimeZoneName(
                tz.getLocation('Europe/Paris')),
            timeZone: tz.getLocation('Europe/Paris')),
      ]);
    } else {
      _items.addAll(savedItems.map((item) => CountryInfoItem(
            name: TimeZoneFormatter.formatTimeZoneName(tz.getLocation(item)),
            timeZone: tz.getLocation(item),
          )));
    }

    notifyListeners();
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = _items.map((item) => item.timeZone.name).toList();
    await prefs.setStringList(_storageKey, savedItems);
  }

  void addItem(CountryInfoItem item) {
    if (!_items.any((element) => element.timeZone.name == item.timeZone.name)) {
      _items.add(item);
      _saveItems();
      notifyListeners();
    }
  }

  void removeItem(CountryInfoItem item) {
    _items.remove(item);
    _saveItems();
    notifyListeners();
  }

  void reorderItem(int oldIndex, int newIndex) {
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    _saveItems();
    notifyListeners();
  }
}
