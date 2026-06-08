import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../audio/ambient_player.dart';
import '../audio/audio_manager.dart';
import '../audio/audio_settings.dart';
import '../audio/bgm_player.dart';
import '../audio/sfx_player.dart';
import '../audio/voice_player.dart';
import 'injection_modules.dart';
import 'repository_module.dart';
import 'use_case_module.dart';

/// GetIt 依赖注入容器
///
/// 统一管理所有依赖的注册与获取。
/// 按层级顺序初始化：核心服务 -> 数据源 -> 仓库 -> 用例。
///
/// 使用方式：
/// ```dart
/// await ServiceLocator.init();
/// final audioManager = ServiceLocator.get<AudioManager>();
/// ```
///
/// 注意：由于 injectable_generator 需要代码生成，这里手动注册所有依赖。
/// 标注 @injectable 的类后续可通过 build_runner 自动注册。
@injectable
class ServiceLocator {
  ServiceLocator._();

  /// GetIt 单例实例
  static final GetIt _instance = GetIt.instance;

  /// 获取 GetIt 实例
  static GetIt get instance => _instance;

  /// 初始化所有依赖
  ///
  /// 按依赖关系顺序注册：
  /// 1. 核心服务（SharedPreferences、音频等）
  /// 2. 数据源（远程/本地数据源）
  /// 3. 仓库（Repository 实现）
  /// 4. 用例（UseCase）
  static Future<void> init() async {
    // 注册核心服务
    await _registerCoreServices();
    // 注册数据源
    await _registerDataSources();
    // 注册仓库
    _registerRepositories();
    // 注册用例
    _registerUseCases();
  }

  /// 注册核心服务
  ///
  /// 包括 SharedPreferences、音频播放器、音频管理器等基础服务。
  static Future<void> _registerCoreServices() async {
    // SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _instance.registerSingleton<SharedPreferences>(prefs);

    // 音频设置
    _instance.registerSingleton<AudioSettings>(
      AudioSettings(prefs: prefs),
    );

    // BGM 播放器
    _instance.registerSingleton<BgmPlayer>(BgmPlayer());

    // SFX 播放器
    _instance.registerSingleton<SfxPlayer>(SfxPlayer());

    // 语音播放器
    _instance.registerSingleton<VoicePlayer>(VoicePlayer());

    // 环境音播放器
    _instance.registerSingleton<AmbientPlayer>(AmbientPlayer());

    // 音频管理器
    _instance.registerSingleton<AudioManager>(
      AudioManager(
        bgmPlayer: _instance<BgmPlayer>(),
        sfxPlayer: _instance<SfxPlayer>(),
        voicePlayer: _instance<VoicePlayer>(),
        ambientPlayer: _instance<AmbientPlayer>(),
        settings: _instance<AudioSettings>(),
      ),
    );
  }

  /// 注册数据源
  ///
  /// TODO: 等待 Data 层创建后补充数据源注册
  static Future<void> _registerDataSources() async {
    // 数据源由 InjectionModules 按模块注册
    await InjectionModules.registerDataSources(_instance);
  }

  /// 注册仓库
  ///
  /// TODO: 等待 Data 层创建后补充仓库注册
  static void _registerRepositories() {
    // 仓库由 RepositoryModule 统一注册
    RepositoryModule.register(_instance);
  }

  /// 注册用例
  ///
  /// TODO: 等待 Domain 层创建后补充用例注册
  static void _registerUseCases() {
    // 用例由 UseCaseModule 统一注册
    UseCaseModule.register(_instance);
  }

  /// 便利方法：获取已注册的服务
  static T get<T extends Object>() => _instance.get<T>();

  /// 便利方法：检查服务是否已注册
  static bool isRegistered<T extends Object>() => _instance.isRegistered<T>();

  /// 重置容器（仅用于测试）
  static Future<void> reset() async {
    await _instance.reset();
  }
}
