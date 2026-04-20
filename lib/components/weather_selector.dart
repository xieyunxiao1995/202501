import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class WeatherSelector extends StatelessWidget {
  final String selectedWeather;
  final ValueChanged<String> onWeatherSelected;

  const WeatherSelector({
    super.key,
    required this.selectedWeather,
    required this.onWeatherSelected,
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
        children: _weatherOptions.map((weather) {
          final isSelected = selectedWeather == weather['icon'];
          return GestureDetector(
            onTap: () => onWeatherSelected(weather['icon']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getWeatherIconData(weather['icon']!),
                    color: isSelected
                        ? AppColors.primaryDark
                        : Colors.grey.shade400,
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather['label']!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryDark
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

  IconData _getWeatherIconData(String icon) {
    switch (icon) {
      case 'wb_sunny':
        return Icons.wb_sunny_rounded;
      case 'cloud':
        return Icons.cloud_rounded;
      case 'rainy':
        return Icons.grain_rounded;
      case 'nightlight':
        return Icons.nightlight_round;
      default:
        return Icons.wb_sunny_rounded;
    }
  }
}

const List<Map<String, String>> _weatherOptions = [
  {'icon': 'wb_sunny', 'label': '晴天'},
  {'icon': 'cloud', 'label': '多云'},
  {'icon': 'rainy', 'label': '雨天'},
  {'icon': 'nightlight', 'label': '夜晚'},
];
