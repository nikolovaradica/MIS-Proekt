import 'package:flutter/material.dart';

class MoodPicker extends StatelessWidget {
  final String? selectedMood;
  final Function(String) onMoodSelected;
  final bool readOnly;

  const MoodPicker({
    super.key, 
    required this.selectedMood,
    required this.onMoodSelected,
    this.readOnly = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Mood', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 1; i <= 5; i++)
              GestureDetector(
                onTap: readOnly
                    ? null
                    : () => onMoodSelected('mood_$i'),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Image.asset(
                    selectedMood == 'mood_$i'
                        ? 'assets/images/colored_mood_$i.png'
                        : 'assets/images/mood_$i.png',
                    key: ValueKey(selectedMood == 'mood_$i'
                        ? 'colored_$i'
                        : 'regular_$i'),
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}