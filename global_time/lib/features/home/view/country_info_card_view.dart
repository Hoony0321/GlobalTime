import 'package:flutter/material.dart';
import 'package:global_time/core/utils/time_zone_formatter.dart';
import 'package:global_time/features/home/model/country_info_item.dart';
import 'package:global_time/features/home/provider/time_zone_provider.dart';
import 'package:provider/provider.dart';

class CountryInfoCardView extends StatelessWidget {
  final CountryInfoItem countryInfoItem;
  const CountryInfoCardView({super.key, required this.countryInfoItem});

  // 시간에 따른 배경색 계산
  Color _getBackgroundColor(TimeZoneProvider timeZoneProvider) {
    // 시작색과 끝색 정의
    const startColor = Color(0xFF2C2754); // 12AM 색상
    const endColor = Color(0xFF1D7BC3); // 12PM 색상

    // 24시간을 기준으로 두 색상 사이의 비율 계산
    double ratio =
        timeZoneProvider.getCurrentTime(countryInfoItem.timeZone).hour / 24;

    // 두 색상을 비율에 따라 보간
    return Color.lerp(startColor, endColor, ratio)!;
  }

  @override
  Widget build(BuildContext context) {
    final timeZoneProvider = context.watch<TimeZoneProvider>();
    final textTheme = Theme.of(context).textTheme;

    final formattedTimeDifference = TimeZoneFormatter.formatTimezoneDifference(
        timeZoneProvider.getTimeDifference(countryInfoItem.timeZone));
    final formattedTime12Hour = TimeZoneFormatter.formatTime12Hour(
        timeZoneProvider.getCurrentTime(countryInfoItem.timeZone));
    final formattedDate = TimeZoneFormatter.formatTimezoneDateTime(
        timeZoneProvider.getCurrentTime(countryInfoItem.timeZone));

    return Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(timeZoneProvider),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(countryInfoItem.name, style: textTheme.headlineSmall),
              Text(formattedTimeDifference, style: textTheme.bodySmall),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formattedTime12Hour, style: textTheme.headlineMedium),
              Text(formattedDate, style: textTheme.bodySmall),
            ],
          )
        ]));
  }
}
