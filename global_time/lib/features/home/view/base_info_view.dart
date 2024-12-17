import 'package:flutter/material.dart';
import 'package:global_time/core/utils/time_zone_formatter.dart';
import 'package:global_time/features/home/provider/time_zone_provider.dart';
import 'package:global_time/features/home/view/modal/calendar_modal.dart';
import 'package:provider/provider.dart';

class BaseInfoView extends StatelessWidget {
  const BaseInfoView({super.key});

  void _showCalendarModal(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      builder: (context) => const CalendarModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final timeZoneProvider = context.watch<TimeZoneProvider>();
    final baseTimezone = TimeZoneProvider.localTimeZone;
    final baseTime = TimeZoneFormatter.formatTime12Hour(
        timeZoneProvider.getCurrentTime(baseTimezone));
    final baseDate = TimeZoneFormatter.formatTimezoneDateTime(
        timeZoneProvider.getCurrentTime(baseTimezone));
    final baseTimezoneName = TimeZoneFormatter.formatTimeZoneName(baseTimezone);

    return InkWell(
      onTap: () => _showCalendarModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(baseTimezoneName),
            const SizedBox(width: 8),
            const Text('|'),
            const SizedBox(width: 8),
            Text(baseTime),
            const SizedBox(width: 8),
            const Text('|'),
            const SizedBox(width: 8),
            Text(baseDate),
          ],
        ),
      ),
    );
  }
}
