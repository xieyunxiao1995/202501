import 'dart:io';

import 'package:flutter/material.dart';

import '../app/app_theme.dart';

class LocalImage extends StatelessWidget {
  const LocalImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.icon = Icons.checkroom_rounded,
  });

  final String path;
  final BoxFit fit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty || !File(path).existsSync()) return _fallback();
    return Image.file(
      File(path),
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.mistBlue, Colors.white, AppColors.blush],
        ),
      ),
      child: Center(child: Icon(icon, color: AppColors.primary, size: 40)),
    );
  }
}
