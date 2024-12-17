import 'package:flutter/material.dart';
import 'package:global_time/core/utils/time_zone_formatter.dart';
import 'package:global_time/features/home/provider/time_zone_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

class TimeZoneCard extends StatelessWidget {
  final MapEntry<String, tz.Location> timeZone;

  const TimeZoneCard({super.key, required this.timeZone});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final timeZoneProvider = context.read<TimeZoneProvider>();
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timeZone.key.split('/').last, style: textTheme.headlineSmall),
          Text(timeZone.value.name, style: textTheme.bodyMedium),
          // GMT Diff
          Text(
              TimeZoneFormatter.formatTimezoneGmtOffset(
                  timeZoneProvider.getGmtOffset(timeZone.value)),
              style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
