import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';

/// 启动页
///
/// 应用启动时显示的过渡页面，展示游戏 Logo 和加载进度。
/// 加载完成后自动跳转到登录页或主城页。
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// 初始化应用并跳转
  Future<void> _initializeApp() async {
    // TODO: 实际初始化逻辑（加载配置、检查更新、自动登录等）
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.go(RoutePaths.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo 占位
            Icon(
              Icons.flag,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              '三国谋定天下',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}
