import 'package:flutter/material.dart';
import 'package:global_time/features/home/model/country_info_item.dart';
import 'package:global_time/features/home/view/country_info_card_view.dart';
import 'package:global_time/features/home/provider/country_info_provider.dart';
import 'package:provider/provider.dart';

class CountryInfoCardWrapperView extends StatelessWidget {
  final CountryInfoItem countryInfoItem;
  const CountryInfoCardWrapperView({
    super.key,
    required this.countryInfoItem,
  });

  @override
  Widget build(BuildContext context) {
    final countryInfoProvider = context.read<CountryInfoProvider>();

    return Dismissible(
      key: Key(countryInfoItem.timeZone.name),
      direction: DismissDirection.endToStart,
      background: Container(
        // 슬라이드 시 보이는 배경
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete,
          size: 32,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        countryInfoProvider.removeItem(countryInfoItem);
      },
      child: CountryInfoCardView(countryInfoItem: countryInfoItem),
    );
  }
}
