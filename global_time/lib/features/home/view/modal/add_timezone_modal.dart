import 'package:flutter/material.dart';
import 'package:global_time/core/utils/time_zone_formatter.dart';
import 'package:global_time/features/home/model/country_info_item.dart';
import 'package:global_time/features/home/view/modal/time_zone_card.dart';
import 'package:global_time/features/home/provider/country_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

class AddTimezoneModal extends StatefulWidget {
  const AddTimezoneModal({super.key});

  @override
  State<StatefulWidget> createState() => _AddTimezoneModalState();
}

class _AddTimezoneModalState extends State<AddTimezoneModal> {
  late final Map<String, tz.Location> _timeZones;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _timeZones = tz.timeZoneDatabase.locations;
  }

  // 필터링된 리스트를 반환하는 getter
  List<MapEntry<String, tz.Location>> get filteredTimeZones {
    if (_searchQuery.isEmpty) {
      return _timeZones.entries.toList();
    }
    return _timeZones.entries.where((timezone) {
      final name = timezone.key.toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  _buildDragHandle(BuildContext context) {
    return Container(
      width: 32,
      height: 4,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary),
    );
  }

  _buildSearchBar(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Input city name',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.onPrimary),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  _buildTimeZoneCardList(BuildContext context) {
    final countryInfoProvider = context.read<CountryInfoProvider>();
    return Expanded(
      child: ListView.separated(
        itemCount: filteredTimeZones.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              countryInfoProvider.addItem(CountryInfoItem(
                  name: TimeZoneFormatter.formatTimeZoneName(
                      filteredTimeZones[index].value),
                  timeZone: filteredTimeZones[index].value));
              Navigator.pop(context);
            },
            child: TimeZoneCard(
              timeZone: filteredTimeZones[index],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildDragHandle(context),
          const SizedBox(height: 24),
          _buildSearchBar(context),
          const SizedBox(height: 24),
          _buildTimeZoneCardList(context),
        ],
      ),
    );
  }
}
