import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class SleepTimePicker extends StatelessWidget {
  final Function(TimeOfDay) onStartTimeChanged;
  final Function(TimeOfDay) onEndTimeChanged;

  const SleepTimePicker({
    super.key,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Text('From', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            TimePickerSpinner(
              normalTextStyle: const TextStyle(fontSize: 18, color: Colors.grey),
              highlightedTextStyle: const TextStyle(fontSize: 22, color: Colors.blue),
              spacing: 20,
              itemHeight: 40,
              isForce2Digits: true,
              onTimeChange: (time) {
                onStartTimeChanged(TimeOfDay.fromDateTime(time));
              }
            )
          ],
        ),
        Column(
          children: [
            const Text('To', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            TimePickerSpinner(
              normalTextStyle: const TextStyle(fontSize: 18, color: Colors.grey),
              highlightedTextStyle: const TextStyle(fontSize: 22, color: Colors.blue),
              spacing: 20,
              itemHeight: 40,
              isForce2Digits: true,
              onTimeChange: (time) {
                onEndTimeChanged(TimeOfDay.fromDateTime(time));
              },
            ),
          ],
        )
      ],
    );
  }
}