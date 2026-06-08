import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// 三国谋定天下 App 根组件
///
/// 配置 MaterialApp.router，集成：
/// - GoRouter 路由系统
/// - 国风暗色主题
/// - 国际化支持
class SanguoApp extends ConsumerWidget {
  const SanguoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      // 应用标题
      title: '三国谋定天下',

      // 国风暗色主题（默认）
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // 路由配置
      routerConfig: router,

      // 国际化
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('zh'),

      // 调试标志
      debugShowCheckedModeBanner: false,
    );
  }
}
