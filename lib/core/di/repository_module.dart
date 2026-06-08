import 'package:get_it/get_it.dart';

/// 仓库依赖注册
///
/// 注册所有 Repository 实现为懒加载单例。
/// 每个 Repository 对应一个领域模块的数据访问入口。
///
/// 懒加载单例：首次获取时创建，之后复用同一实例。
///
/// TODO: 等待 Data 层创建后补充所有 14 个 Repository 的注册实现
class RepositoryModule {
  RepositoryModule._();

  /// 注册所有仓库
  ///
  /// 按领域模块注册所有 Repository 实现。
  static void register(GetIt injector) {
    _registerUserRepositories(injector);
    _registerGeneralRepositories(injector);
    _registerBattleRepositories(injector);
    _registerBackpackRepositories(injector);
    _registerShopRepositories(injector);
    _registerAllianceRepositories(injector);
    _registerQuestRepositories(injector);
    _registerMailRepositories(injector);
    _registerChatRepositories(injector);
    _registerRankingRepositories(injector);
    _registerEventRepositories(injector);
    _registerSystemRepositories(injector);
    _registerSocialRepositories(injector);
    _registerPaymentRepositories(injector);
  }

  /// 用户仓库
  ///
  /// TODO: 注册 UserRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<UserRepository>(
  ///   () => UserRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///     localDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerUserRepositories(GetIt injector) {
    // TODO: 注入用户模块的 Repository 实现
  }

  /// 武将仓库
  ///
  /// TODO: 注册 GeneralRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<GeneralRepository>(
  ///   () => GeneralRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///     localDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerGeneralRepositories(GetIt injector) {
    // TODO: 注入武将模块的 Repository 实现
  }

  /// 战斗仓库
  ///
  /// TODO: 注册 BattleRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<BattleRepository>(
  ///   () => BattleRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerBattleRepositories(GetIt injector) {
    // TODO: 注入战斗模块的 Repository 实现
  }

  /// 背包仓库
  ///
  /// TODO: 注册 BackpackRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<BackpackRepository>(
  ///   () => BackpackRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///     localDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerBackpackRepositories(GetIt injector) {
    // TODO: 注入背包模块的 Repository 实现
  }

  /// 商店仓库
  ///
  /// TODO: 注册 ShopRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<ShopRepository>(
  ///   () => ShopRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerShopRepositories(GetIt injector) {
    // TODO: 注入商店模块的 Repository 实现
  }

  /// 联盟仓库
  ///
  /// TODO: 注册 AllianceRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<AllianceRepository>(
  ///   () => AllianceRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///     localDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerAllianceRepositories(GetIt injector) {
    // TODO: 注入联盟模块的 Repository 实现
  }

  /// 任务仓库
  ///
  /// TODO: 注册 QuestRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<QuestRepository>(
  ///   () => QuestRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///     localDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerQuestRepositories(GetIt injector) {
    // TODO: 注入任务模块的 Repository 实现
  }

  /// 邮件仓库
  ///
  /// TODO: 注册 MailRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<MailRepository>(
  ///   () => MailRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///     localDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerMailRepositories(GetIt injector) {
    // TODO: 注入邮件模块的 Repository 实现
  }

  /// 聊天仓库
  ///
  /// TODO: 注册 ChatRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<ChatRepository>(
  ///   () => ChatRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerChatRepositories(GetIt injector) {
    // TODO: 注入聊天模块的 Repository 实现
  }

  /// 排行仓库
  ///
  /// TODO: 注册 RankingRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<RankingRepository>(
  ///   () => RankingRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerRankingRepositories(GetIt injector) {
    // TODO: 注入排行模块的 Repository 实现
  }

  /// 活动仓库
  ///
  /// TODO: 注册 EventRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<EventRepository>(
  ///   () => EventRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerEventRepositories(GetIt injector) {
    // TODO: 注入活动模块的 Repository 实现
  }

  /// 系统仓库
  ///
  /// TODO: 注册 SystemRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<SystemRepository>(
  ///   () => SystemRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///     localDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerSystemRepositories(GetIt injector) {
    // TODO: 注入系统模块的 Repository 实现
  }

  /// 社交仓库
  ///
  /// TODO: 注册 SocialRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<SocialRepository>(
  ///   () => SocialRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerSocialRepositories(GetIt injector) {
    // TODO: 注入社交模块的 Repository 实现
  }

  /// 支付仓库
  ///
  /// TODO: 注册 PaymentRepository 实现
  /// ```dart
  /// injector.registerLazySingleton<PaymentRepository>(
  ///   () => PaymentRepositoryImpl(
  ///     remoteDataSource: injector(),
  ///     localDataSource: injector(),
  ///   ),
  /// );
  /// ```
  static void _registerPaymentRepositories(GetIt injector) {
    // TODO: 注入支付模块的 Repository 实现
  }
}
