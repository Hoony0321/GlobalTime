import 'package:flutter/material.dart';
import 'package:global_time/features/home/provider/selected_datetime_provider.dart';
import 'package:provider/provider.dart';

class CalendarModal extends StatefulWidget {
  const CalendarModal({super.key});

  @override
  State<CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  late final selectedDatetimeProvider;

  @override
  void initState() {
    super.initState();
    selectedDatetimeProvider = context.read<SelectedDatetimeProvider>();
  }

  _buildDragHandle(BuildContext context) {
    return Container(
      width: 32,
      height: 4,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary),
    );
  }

  _buildDatePicker(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        datePickerTheme: DatePickerThemeData(
          todayForegroundColor:
              WidgetStateProperty.all(const Color.fromARGB(255, 134, 134, 134)),
        ),
      ),
      child: CalendarDatePicker(
        initialDate: selectedDatetimeProvider.selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        onDateChanged: (date) {
          selectedDatetimeProvider.setSelectedDate(date);
        },
      ),
    );
  }

  _buildTimePickerButton(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: selectedDatetimeProvider.selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  confirmButtonStyle: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(
                      colors.onPrimary,
                    ),
                  ),
                  cancelButtonStyle: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(
                      colors.onPrimary,
                    ),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          selectedDatetimeProvider.setSelectedTime(time);
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, color: colors.onPrimary),
            const SizedBox(width: 8),
            Text(
              selectedDatetimeProvider.selectedTime.format(context),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.onPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSaveButton(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('Close',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: colors.onPrimary, fontWeight: FontWeight.w600)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(context),
          const SizedBox(height: 16),
          _buildDatePicker(context),
          _buildTimePickerButton(context),
          const SizedBox(height: 24),
          _buildSaveButton(context),
        ],
      ),
    );
  }
}
