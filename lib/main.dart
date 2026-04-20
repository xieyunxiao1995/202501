import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/theme.dart';
import 'pages/splash_page.dart';
import 'models/data.dart';

void main() async {
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 强制竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 异步初始化全局状态（加载 Hive 数据）
  await AppState.instance.initialize();

  runApp(const MoodStyleApp());
}

class MoodStyleApp extends StatelessWidget {
  const MoodStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodStyle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorScheme: ColorScheme.light(
          surface: AppColors.backgroundLight,
          primary: AppColors.primary,
        ),
      ),
      home: const SplashPage(),
    );
  }
}
