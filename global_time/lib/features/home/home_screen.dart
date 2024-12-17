import 'package:flutter/material.dart';
import 'package:global_time/features/home/view/base_info_view.dart';
import 'package:global_time/features/home/view/bottom_navigation_bar_view.dart';
import 'package:global_time/features/home/view/country_info_card_wrapper_view.dart';
import 'package:global_time/features/home/provider/country_info_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final countryInfoItems = context.watch<CountryInfoProvider>().items;

    buildCountryInfoList(BuildContext context) {
      return ReorderableListView.builder(
        itemCount: countryInfoItems.length,
        itemBuilder: (context, index) {
          return Padding(
            key: Key(countryInfoItems[index].timeZone.name),
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CountryInfoCardWrapperView(
              countryInfoItem: countryInfoItems[index],
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          final provider = context.read<CountryInfoProvider>();
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          provider.reorderItem(oldIndex, newIndex);
        },
      );
    }

    return Scaffold(
        backgroundColor: colors.primary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Expanded(
                  child: buildCountryInfoList(context),
                ),
                const SizedBox(height: 16),
                const BaseInfoView(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigationBarView());
  }
}
