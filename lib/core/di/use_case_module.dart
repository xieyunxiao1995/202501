import 'package:get_it/get_it.dart';

/// 用例依赖注册
///
/// 注册所有 UseCase 为工厂模式（每次获取新实例）。
/// UseCase 是无状态的，每次获取新实例确保不会出现状态污染。
///
/// 工厂模式：每次 `get<T>()` 都创建新实例。
///
/// TODO: 等待 Domain 层创建后补充所有 50+ 个 UseCase 的注册实现
class UseCaseModule {
  UseCaseModule._();

  /// 注册所有用例
  ///
  /// 按领域模块注册所有 UseCase。
  static void register(GetIt injector) {
    // 用户模块
    _registerUserUseCases(injector);
    // 武将模块
    _registerGeneralUseCases(injector);
    // 战斗模块
    _registerBattleUseCases(injector);
    // 背包模块
    _registerBackpackUseCases(injector);
    // 商店模块
    _registerShopUseCases(injector);
    // 联盟模块
    _registerAllianceUseCases(injector);
    // 任务模块
    _registerQuestUseCases(injector);
    // 邮件模块
    _registerMailUseCases(injector);
    // 聊天模块
    _registerChatUseCases(injector);
    // 排行模块
    _registerRankingUseCases(injector);
    // 活动模块
    _registerEventUseCases(injector);
    // 系统模块
    _registerSystemUseCases(injector);
    // 社交模块
    _registerSocialUseCases(injector);
    // 支付模块
    _registerPaymentUseCases(injector);
  }

  /// 用户模块用例
  ///
  /// TODO: 注册用户相关的所有 UseCase
  /// 预计包含：
  /// - LoginUseCase：登录
  /// - RegisterUseCase：注册
  /// - GuestLoginUseCase：游客登录
  /// - LogoutUseCase：登出
  /// - GetUserInfoUseCase：获取用户信息
  /// - UpdateUserInfoUseCase：更新用户信息
  /// - ChangePasswordUseCase：修改密码
  static void _registerUserUseCases(GetIt injector) {
    // TODO: injector.registerFactory<LoginUseCase>(
    //   () => LoginUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<RegisterUseCase>(
    //   () => RegisterUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GuestLoginUseCase>(
    //   () => GuestLoginUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<LogoutUseCase>(
    //   () => LogoutUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetUserInfoUseCase>(
    //   () => GetUserInfoUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<UpdateUserInfoUseCase>(
    //   () => UpdateUserInfoUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<ChangePasswordUseCase>(
    //   () => ChangePasswordUseCase(repository: injector()),
    // );
  }

  /// 武将模块用例
  ///
  /// TODO: 注册武将相关的所有 UseCase
  /// 预计包含：
  /// - GetGeneralListUseCase：获取武将列表
  /// - GetGeneralDetailUseCase：获取武将详情
  /// - UpgradeGeneralUseCase：升级武将
  /// - AwakenGeneralUseCase：觉醒武将
  /// - StarUpGeneralUseCase：升星武将
  /// - BreakthroughGeneralUseCase：突破武将
  /// - EquipTacticUseCase：装备战法
  /// - UnequipTacticUseCase：卸下战法
  static void _registerGeneralUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetGeneralListUseCase>(
    //   () => GetGeneralListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetGeneralDetailUseCase>(
    //   () => GetGeneralDetailUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<UpgradeGeneralUseCase>(
    //   () => UpgradeGeneralUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<AwakenGeneralUseCase>(
    //   () => AwakenGeneralUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<StarUpGeneralUseCase>(
    //   () => StarUpGeneralUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<BreakthroughGeneralUseCase>(
    //   () => BreakthroughGeneralUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<EquipTacticUseCase>(
    //   () => EquipTacticUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<UnequipTacticUseCase>(
    //   () => UnequipTacticUseCase(repository: injector()),
    // );
  }

  /// 战斗模块用例
  ///
  /// TODO: 注册战斗相关的所有 UseCase
  /// 预计包含：
  /// - StartBattleUseCase：开始战斗
  /// - GetBattleResultUseCase：获取战斗结果
  /// - SweepBattleUseCase：扫荡战斗
  /// - GetBattleReportUseCase：获取战报
  /// - SimulateBattleUseCase：模拟战斗
  /// - GetChapterListUseCase：获取章节列表
  /// - GetStageDetailUseCase：获取关卡详情
  static void _registerBattleUseCases(GetIt injector) {
    // TODO: injector.registerFactory<StartBattleUseCase>(
    //   () => StartBattleUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetBattleResultUseCase>(
    //   () => GetBattleResultUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<SweepBattleUseCase>(
    //   () => SweepBattleUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetBattleReportUseCase>(
    //   () => GetBattleReportUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<SimulateBattleUseCase>(
    //   () => SimulateBattleUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetChapterListUseCase>(
    //   () => GetChapterListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetStageDetailUseCase>(
    //   () => GetStageDetailUseCase(repository: injector()),
    // );
  }

  /// 背包模块用例
  ///
  /// TODO: 注册背包相关的所有 UseCase
  /// 预计包含：
  /// - GetItemListUseCase：获取物品列表
  /// - UseItemUseCase：使用物品
  /// - SellItemUseCase：出售物品
  /// - GetEquipmentListUseCase：获取装备列表
  /// - EquipItemUseCase：装备物品
  /// - UnequipItemUseCase：卸下装备
  static void _registerBackpackUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetItemListUseCase>(
    //   () => GetItemListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<UseItemUseCase>(
    //   () => UseItemUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<SellItemUseCase>(
    //   () => SellItemUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetEquipmentListUseCase>(
    //   () => GetEquipmentListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<EquipItemUseCase>(
    //   () => EquipItemUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<UnequipItemUseCase>(
    //   () => UnequipItemUseCase(repository: injector()),
    // );
  }

  /// 商店模块用例
  ///
  /// TODO: 注册商店相关的所有 UseCase
  /// 预计包含：
  /// - GetShopItemListUseCase：获取商品列表
  /// - BuyItemUseCase：购买商品
  /// - GetShopRefreshTimeUseCase：获取刷新时间
  /// - RefreshShopUseCase：刷新商店
  static void _registerShopUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetShopItemListUseCase>(
    //   () => GetShopItemListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<BuyItemUseCase>(
    //   () => BuyItemUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetShopRefreshTimeUseCase>(
    //   () => GetShopRefreshTimeUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<RefreshShopUseCase>(
    //   () => RefreshShopUseCase(repository: injector()),
    // );
  }

  /// 联盟模块用例
  ///
  /// TODO: 注册联盟相关的所有 UseCase
  /// 预计包含：
  /// - CreateAllianceUseCase：创建联盟
  /// - JoinAllianceUseCase：加入联盟
  /// - LeaveAllianceUseCase：退出联盟
  /// - GetAllianceInfoUseCase：获取联盟信息
  /// - GetAllianceMemberListUseCase：获取成员列表
  /// - KickMemberUseCase：踢出成员
  /// - DonateAllianceUseCase：联盟捐献
  static void _registerAllianceUseCases(GetIt injector) {
    // TODO: injector.registerFactory<CreateAllianceUseCase>(
    //   () => CreateAllianceUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<JoinAllianceUseCase>(
    //   () => JoinAllianceUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<LeaveAllianceUseCase>(
    //   () => LeaveAllianceUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetAllianceInfoUseCase>(
    //   () => GetAllianceInfoUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetAllianceMemberListUseCase>(
    //   () => GetAllianceMemberListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<KickMemberUseCase>(
    //   () => KickMemberUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<DonateAllianceUseCase>(
    //   () => DonateAllianceUseCase(repository: injector()),
    // );
  }

  /// 任务模块用例
  ///
  /// TODO: 注册任务相关的所有 UseCase
  /// 预计包含：
  /// - GetDailyQuestListUseCase：获取日常任务列表
  /// - GetMainQuestListUseCase：获取主线任务列表
  /// - ClaimQuestRewardUseCase：领取任务奖励
  /// - GetAchievementListUseCase：获取成就列表
  /// - ClaimAchievementRewardUseCase：领取成就奖励
  static void _registerQuestUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetDailyQuestListUseCase>(
    //   () => GetDailyQuestListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetMainQuestListUseCase>(
    //   () => GetMainQuestListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<ClaimQuestRewardUseCase>(
    //   () => ClaimQuestRewardUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetAchievementListUseCase>(
    //   () => GetAchievementListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<ClaimAchievementRewardUseCase>(
    //   () => ClaimAchievementRewardUseCase(repository: injector()),
    // );
  }

  /// 邮件模块用例
  ///
  /// TODO: 注册邮件相关的所有 UseCase
  /// 预计包含：
  /// - GetMailListUseCase：获取邮件列表
  /// - ReadMailUseCase：阅读邮件
  /// - ClaimMailAttachmentUseCase：领取邮件附件
  /// - DeleteMailUseCase：删除邮件
  /// - SendMailUseCase：发送邮件
  static void _registerMailUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetMailListUseCase>(
    //   () => GetMailListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<ReadMailUseCase>(
    //   () => ReadMailUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<ClaimMailAttachmentUseCase>(
    //   () => ClaimMailAttachmentUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<DeleteMailUseCase>(
    //   () => DeleteMailUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<SendMailUseCase>(
    //   () => SendMailUseCase(repository: injector()),
    // );
  }

  /// 聊天模块用例
  ///
  /// TODO: 注册聊天相关的所有 UseCase
  /// 预计包含：
  /// - GetChatHistoryUseCase：获取聊天记录
  /// - SendMessageUseCase：发送消息
  /// - GetChannelListUseCase：获取频道列表
  static void _registerChatUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetChatHistoryUseCase>(
    //   () => GetChatHistoryUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<SendMessageUseCase>(
    //   () => SendMessageUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetChannelListUseCase>(
    //   () => GetChannelListUseCase(repository: injector()),
    // );
  }

  /// 排行模块用例
  ///
  /// TODO: 注册排行相关的所有 UseCase
  /// 预计包含：
  /// - GetPowerRankingUseCase：获取战力排行
  /// - GetArenaRankingUseCase：获取竞技场排行
  /// - GetGeneralRankingUseCase：获取武将排行
  static void _registerRankingUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetPowerRankingUseCase>(
    //   () => GetPowerRankingUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetArenaRankingUseCase>(
    //   () => GetArenaRankingUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetGeneralRankingUseCase>(
    //   () => GetGeneralRankingUseCase(repository: injector()),
    // );
  }

  /// 活动模块用例
  ///
  /// TODO: 注册活动相关的所有 UseCase
  /// 预计包含：
  /// - GetEventListUseCase：获取活动列表
  /// - GetEventDetailUseCase：获取活动详情
  /// - JoinEventUseCase：参加活动
  /// - ClaimEventRewardUseCase：领取活动奖励
  static void _registerEventUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetEventListUseCase>(
    //   () => GetEventListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetEventDetailUseCase>(
    //   () => GetEventDetailUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<JoinEventUseCase>(
    //   () => JoinEventUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<ClaimEventRewardUseCase>(
    //   () => ClaimEventRewardUseCase(repository: injector()),
    // );
  }

  /// 系统模块用例
  ///
  /// TODO: 注册系统相关的所有 UseCase
  /// 预计包含：
  /// - GetServerTimeUseCase：获取服务器时间
  /// - CheckUpdateUseCase：检查更新
  /// - GetAnnouncementUseCase：获取公告
  /// - GetGameConfigUseCase：获取游戏配置
  /// - ReportBugUseCase：提交 Bug
  static void _registerSystemUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetServerTimeUseCase>(
    //   () => GetServerTimeUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<CheckUpdateUseCase>(
    //   () => CheckUpdateUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetAnnouncementUseCase>(
    //   () => GetAnnouncementUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetGameConfigUseCase>(
    //   () => GetGameConfigUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<ReportBugUseCase>(
    //   () => ReportBugUseCase(repository: injector()),
    // );
  }

  /// 社交模块用例
  ///
  /// TODO: 注册社交相关的所有 UseCase
  /// 预计包含：
  /// - AddFriendUseCase：添加好友
  /// - RemoveFriendUseCase：删除好友
  /// - GetFriendListUseCase：获取好友列表
  /// - SendGiftUseCase：赠送礼物
  static void _registerSocialUseCases(GetIt injector) {
    // TODO: injector.registerFactory<AddFriendUseCase>(
    //   () => AddFriendUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<RemoveFriendUseCase>(
    //   () => RemoveFriendUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetFriendListUseCase>(
    //   () => GetFriendListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<SendGiftUseCase>(
    //   () => SendGiftUseCase(repository: injector()),
    // );
  }

  /// 支付模块用例
  ///
  /// TODO: 注册支付相关的所有 UseCase
  /// 预计包含：
  /// - GetProductListUseCase：获取商品列表
  /// - PurchaseProductUseCase：购买商品
  /// - VerifyPurchaseUseCase：验证购买
  /// - RestorePurchaseUseCase：恢复购买
  /// - GetPurchaseHistoryUseCase：获取购买记录
  static void _registerPaymentUseCases(GetIt injector) {
    // TODO: injector.registerFactory<GetProductListUseCase>(
    //   () => GetProductListUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<PurchaseProductUseCase>(
    //   () => PurchaseProductUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<VerifyPurchaseUseCase>(
    //   () => VerifyPurchaseUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<RestorePurchaseUseCase>(
    //   () => RestorePurchaseUseCase(repository: injector()),
    // );
    // TODO: injector.registerFactory<GetPurchaseHistoryUseCase>(
    //   () => GetPurchaseHistoryUseCase(repository: injector()),
    // );
  }
}
