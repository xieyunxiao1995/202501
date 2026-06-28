import 'package:flutter/material.dart';

import '../app/app_theme.dart';

class ChoiceField extends StatelessWidget {
  const ChoiceField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map((option) {
                final selected = option == value;
                return ChoiceChip(
                  selected: selected,
                  label: Text(option),
                  showCheckmark: false,
                  selectedColor: AppColors.primary,
                  backgroundColor: const Color(0xFFF5F7FB),
                  side: BorderSide.none,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.muted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (_) => onChanged(option),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }
}
