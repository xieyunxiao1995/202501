import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/service_locator.dart';
import 'core/error/crash_handler.dart';
import 'core/utils/logger.dart';

void main() {
  CrashHandler.runInZone(() async {
    // 确保 Flutter binding 初始化
    WidgetsFlutterBinding.ensureInitialized();

    // 初始化 Hive 存储
    await Hive.initFlutter();

    // 初始化依赖注入
    await ServiceLocator.init();

    AppLogger.info('无双魏蜀吴启动完成 - 环境: ${const AppConfig().environmentName}');

    // 使用 Riverpod ProviderScope 包裹应用
    runApp(
      const ProviderScope(
        child: SanguoApp(),
      ),
    );
  });
}
