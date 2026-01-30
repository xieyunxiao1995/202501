import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const ShanhaiApp());
}

class ShanhaiApp extends StatelessWidget {
  const ShanhaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '山海：洪荒纪元',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        brightness: Brightness.dark,
        fontFamily: '', // 使用系统默认字体
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0F172A),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSub,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const SplashPage(),
    );
  }
}
