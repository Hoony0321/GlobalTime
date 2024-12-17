import 'package:flutter/material.dart';
import 'package:global_time/core/utils/time_zone_formatter.dart';
import 'package:global_time/features/home/provider/country_info_provider.dart';
import 'package:global_time/features/home/provider/selected_datetime_provider.dart';
import 'package:global_time/features/home/provider/time_zone_provider.dart';
import 'package:global_time/features/home/view/modal/add_timezone_modal.dart';
import 'package:global_time/features/home/view/modal/calendar_modal.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({super.key});

  void _showAddTimezoneModal(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      builder: (context) => const AddTimezoneModal(),
    );
  }

  void _handleRestore(BuildContext context) {
    final timeZoneProvider = context.read<TimeZoneProvider>();
    timeZoneProvider.restoreTime();
    context.read<SelectedDatetimeProvider>().setIsRealTime(true);
  }

  void _showCalendarModal(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      builder: (context) => const CalendarModal(),
    );
  }

  void _handleShare(BuildContext context) {
    final timeZoneProvider = context.read<TimeZoneProvider>();
    final countryInfoProvider = context.read<CountryInfoProvider>();
    final baseLocationName =
        TimeZoneFormatter.formatTimeZoneName(TimeZoneProvider.localTimeZone);
    final baseLocationTime = TimeZoneFormatter.formatTime12Hour(
        timeZoneProvider.getCurrentTime(TimeZoneProvider.localTimeZone));
    final otherCountries = countryInfoProvider.items;

    StringBuffer shareContent = StringBuffer();

    shareContent.writeln("🌍 Global Time Information\n");
    shareContent.writeln("🔹 Base Location:");
    shareContent.writeln("  $baseLocationName : $baseLocationTime\n");

    shareContent.writeln("🔹 Other Locations:");
    for (var element in otherCountries) {
      final formattedTime = TimeZoneFormatter.formatShareDateTime(
          timeZoneProvider.getCurrentTime(element.timeZone));
      shareContent.writeln("  - ${element.name} : $formattedTime");
    }

    shareContent
        .writeln("\n📲 Want to check these times? Try the 'Global Time' app!");

    // Share using SharePlus package
    Share.share(shareContent.toString(), subject: "Global Time Information");
  }

  void _handleOnTap(BuildContext context, int index) {
    if (index == 0) {
      _handleShare(context);
    } else if (index == 1) {
      _handleRestore(context);
    } else if (index == 2) {
      _showCalendarModal(context);
    } else if (index == 3) {
      _showAddTimezoneModal(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      onTap: (index) => _handleOnTap(context, index),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: colors.primary,
      type: BottomNavigationBarType.fixed,
      iconSize: 36,
      selectedItemColor: colors.onPrimary,
      unselectedItemColor: colors.onPrimary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.ios_share),
          label: 'Share',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restore),
          label: 'Restore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
      ],
    );
  }
}
