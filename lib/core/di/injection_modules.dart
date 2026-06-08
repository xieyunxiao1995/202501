import 'package:get_it/get_it.dart';

/// 各模块依赖注册编排
///
/// 按模块组织数据源的注册，确保依赖顺序正确。
/// 各模块的注册方法按领域划分，便于维护和扩展。
///
/// TODO: 等待 Data 层各模块创建后逐步补充数据源注册
class InjectionModules {
  InjectionModules._();

  /// 注册所有数据源
  ///
  /// 按模块顺序调用各数据源注册方法。
  static Future<void> registerDataSources(GetIt injector) async {
    // 用户模块数据源
    _registerUserDataSources(injector);
    // 武将模块数据源
    _registerGeneralDataSources(injector);
    // 战斗模块数据源
    _registerBattleDataSources(injector);
    // 背包模块数据源
    _registerBackpackDataSources(injector);
    // 商店模块数据源
    _registerShopDataSources(injector);
    // 联盟模块数据源
    _registerAllianceDataSources(injector);
    // 任务模块数据源
    _registerQuestDataSources(injector);
    // 邮件模块数据源
    _registerMailDataSources(injector);
    // 聊天模块数据源
    _registerChatDataSources(injector);
    // 排行模块数据源
    _registerRankingDataSources(injector);
    // 活动模块数据源
    _registerEventDataSources(injector);
    // 系统模块数据源
    _registerSystemDataSources(injector);
    // 社交模块数据源
    _registerSocialDataSources(injector);
    // 支付模块数据源
    _registerPaymentDataSources(injector);
  }

  /// 用户模块数据源
  ///
  /// TODO: 注册用户相关的远程数据源和本地数据源
  static void _registerUserDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<UserRemoteDataSource>(
    //   () => UserRemoteDataSourceImpl(dio: injector()),
    // );
    // TODO: injector.registerLazySingleton<UserLocalDataSource>(
    //   () => UserLocalDataSourceImpl(hive: injector()),
    // );
  }

  /// 武将模块数据源
  ///
  /// TODO: 注册武将相关的远程数据源和本地数据源
  static void _registerGeneralDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<GeneralRemoteDataSource>(
    //   () => GeneralRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 战斗模块数据源
  ///
  /// TODO: 注册战斗相关的远程数据源和本地数据源
  static void _registerBattleDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<BattleRemoteDataSource>(
    //   () => BattleRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 背包模块数据源
  ///
  /// TODO: 注册背包相关的远程数据源和本地数据源
  static void _registerBackpackDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<BackpackRemoteDataSource>(
    //   () => BackpackRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 商店模块数据源
  ///
  /// TODO: 注册商店相关的远程数据源和本地数据源
  static void _registerShopDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<ShopRemoteDataSource>(
    //   () => ShopRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 联盟模块数据源
  ///
  /// TODO: 注册联盟相关的远程数据源和本地数据源
  static void _registerAllianceDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<AllianceRemoteDataSource>(
    //   () => AllianceRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 任务模块数据源
  ///
  /// TODO: 注册任务相关的远程数据源和本地数据源
  static void _registerQuestDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<QuestRemoteDataSource>(
    //   () => QuestRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 邮件模块数据源
  ///
  /// TODO: 注册邮件相关的远程数据源和本地数据源
  static void _registerMailDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<MailRemoteDataSource>(
    //   () => MailRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 聊天模块数据源
  ///
  /// TODO: 注册聊天相关的远程数据源和本地数据源
  static void _registerChatDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<ChatRemoteDataSource>(
    //   () => ChatRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 排行模块数据源
  ///
  /// TODO: 注册排行相关的远程数据源和本地数据源
  static void _registerRankingDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<RankingRemoteDataSource>(
    //   () => RankingRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 活动模块数据源
  ///
  /// TODO: 注册活动相关的远程数据源和本地数据源
  static void _registerEventDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<EventRemoteDataSource>(
    //   () => EventRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 系统模块数据源
  ///
  /// TODO: 注册系统相关的远程数据源和本地数据源
  static void _registerSystemDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<SystemRemoteDataSource>(
    //   () => SystemRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 社交模块数据源
  ///
  /// TODO: 注册社交相关的远程数据源和本地数据源
  static void _registerSocialDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<SocialRemoteDataSource>(
    //   () => SocialRemoteDataSourceImpl(dio: injector()),
    // );
  }

  /// 支付模块数据源
  ///
  /// TODO: 注册支付相关的远程数据源和本地数据源
  static void _registerPaymentDataSources(GetIt injector) {
    // TODO: injector.registerLazySingleton<PaymentRemoteDataSource>(
    //   () => PaymentRemoteDataSourceImpl(dio: injector()),
    // );
  }
}
