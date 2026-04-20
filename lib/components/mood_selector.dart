import 'package:flutter/material.dart';
import '../../models/data.dart';
import '../../theme/theme.dart';

class MoodSelector extends StatelessWidget {
  final MoodType selectedMood;
  final ValueChanged<MoodType> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _moodOptions.map((mood) {
          final isSelected = selectedMood == mood['type'];
          return GestureDetector(
            onTap: () => onMoodSelected(mood['type'] as MoodType),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? _getMoodColor(mood['type'] as MoodType)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? _getMoodColor(mood['type'] as MoodType)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    mood['icon'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mood['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: isSelected
                          ? AppColors.textMain
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getMoodColor(MoodType type) {
    switch (type) {
      case MoodType.happy:
        return AppColors.moodHappy;
      case MoodType.chill:
        return AppColors.moodChill;
      case MoodType.excited:
        return AppColors.moodExcited;
      case MoodType.sad:
        return AppColors.moodSad;
    }
  }
}

const List<Map<String, dynamic>> _moodOptions = [
  {'type': MoodType.happy, 'icon': '😊', 'label': '开心'},
  {'type': MoodType.chill, 'icon': '😌', 'label': '放松'},
  {'type': MoodType.excited, 'icon': '🎉', 'label': '兴奋'},
  {'type': MoodType.sad, 'icon': '😢', 'label': '难过'},
];
