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

  bool get _isAsset => path.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return _fallback();
    if (_isAsset) {
      return Image.asset(
        path,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }
    if (!File(path).existsSync()) return _fallback();
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
          colors: [Color(0xFF2D1B4E), Color(0xFF1A1230), Color(0xFF4C1D95)],
        ),
      ),
      child: Center(child: Icon(icon, color: AppColors.primaryLight, size: 40)),
    );
  }
}
