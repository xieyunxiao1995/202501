import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

class OnboardingSlideData {
  const OnboardingSlideData({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.assetPath,
    required this.semanticLabel,
  });

  final String eyebrow;
  final String title;
  final String description;
  final String assetPath;
  final String semanticLabel;
}

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({super.key, required this.data, required this.index});

  final OnboardingSlideData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '第 ${index + 1} 页，共 4 页。${data.title}',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = (constraints.maxHeight * 0.61).clamp(
            280.0,
            450.0,
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: imageHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(38),
                    border: Border.all(color: AppColors.divider),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x337C3AED),
                        blurRadius: 34,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    data.assetPath,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    semanticLabel: data.semanticLabel,
                    errorBuilder: (_, _, _) => const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4C1D95), Color(0xFF6D28D9)],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.checkroom_rounded,
                          size: 72,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  data.eyebrow,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 11),
                Text(
                  data.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
