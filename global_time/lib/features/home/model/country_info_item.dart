import 'package:timezone/timezone.dart' as tz;

class CountryInfoItem {
  final String name;
  final tz.Location timeZone;

  CountryInfoItem({
    required this.name,
    required this.timeZone,
  });
}
