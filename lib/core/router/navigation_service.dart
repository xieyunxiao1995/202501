/// 导航服务
///
/// 封装编程式导航操作，提供统一的跳转接口。
/// 基于 GoRouter 实现，通过 `GlobalKey<NavigatorState>` 支持
/// 在非 Widget 上下文中进行导航操作。
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 导航服务，封装常用路由操作
///
/// 使用方式：
/// ```dart
/// NavigationService.instance.go('/home');
/// NavigationService.instance.push('/generals/1');
/// NavigationService.instance.replace('/login');
/// NavigationService.instance.pop();
/// ```
class NavigationService {
  NavigationService._();

  /// 单例实例
  static final NavigationService instance = NavigationService._();

  /// 全局 NavigatorState 键，用于在非 Widget 上下文中获取导航器
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// GoRouter 实例引用（由 app_router.dart 在创建后设置）
  GoRouter? _router;

  /// 设置 GoRouter 实例
  ///
  /// 必须在 app_router 初始化后调用此方法，否则导航方法将无法工作。
  void setRouter(GoRouter router) {
    _router = router;
  }

  /// 获取当前 BuildContext
  ///
  /// 通过 navigatorKey 获取当前导航器的 context。
  /// 如果 navigatorKey 尚未挂载，则抛出异常。
  BuildContext get context {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) {
      throw StateError('NavigatorKey 尚未挂载，无法获取 BuildContext');
    }
    return ctx;
  }

  /// 导航到指定路径（替换当前路由栈顶）
  ///
  /// [path] 目标路由路径
  /// [extra] 额外参数，可通过 `GoRouterState.extra` 获取
  void go(String path, {Object? extra}) {
    if (_router != null) {
      _router!.go(path, extra: extra);
      return;
    }
    // 降级方案：通过 context 使用 GoRouter
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      GoRouter.of(ctx).go(path, extra: extra);
    }
  }

  /// 推入新路由到栈顶
  ///
  /// [path] 目标路由路径
  /// [extra] 额外参数
  /// 返回值为 pop 时携带的返回值
  Future<T?> push<T extends Object?>(String path, {Object? extra}) async {
    if (_router != null) {
      return _router!.push<T>(path, extra: extra);
    }
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      return GoRouter.of(ctx).push<T>(path, extra: extra);
    }
    return null;
  }

  /// 替换当前路由
  ///
  /// [path] 目标路由路径
  /// [extra] 额外参数
  void replace(String path, {Object? extra}) {
    if (_router != null) {
      _router!.replace(path, extra: extra);
      return;
    }
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      GoRouter.of(ctx).replace(path, extra: extra);
    }
  }

  /// 弹出当前路由
  ///
  /// [result] 返回给上一个页面的结果
  void pop<T extends Object?>([T? result]) {
    if (_router != null) {
      _router!.pop<T>(result);
      return;
    }
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      GoRouter.of(ctx).pop<T>(result);
    }
  }

  /// 判断是否可以弹出
  bool canPop() {
    if (_router != null) {
      return _router!.canPop();
    }
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      return GoRouter.of(ctx).canPop();
    }
    return false;
  }

  // ==================== 传参便利方法 ====================

  /// 导航到武将详情页
  ///
  /// [generalId] 武将ID
  void goToGeneralDetail(String generalId) {
    go('/generals/$generalId');
  }

  /// 导航到武将升级页
  void goToGeneralUpgrade(String generalId) {
    go('/generals/$generalId/upgrade');
  }

  /// 导航到武将觉醒页
  void goToGeneralAwake(String generalId) {
    go('/generals/$generalId/awake');
  }

  /// 导航到武将升星页
  void goToGeneralStarUp(String generalId) {
    go('/generals/$generalId/star-up');
  }

  /// 导航到建筑详情页
  ///
  /// [buildingId] 建筑ID
  void goToBuildingDetail(String buildingId) {
    go('/city/buildings/$buildingId');
  }

  /// 导航到建筑升级页
  void goToBuildingUpgrade(String buildingId) {
    go('/city/buildings/$buildingId/upgrade');
  }

  /// 导航到招募池页
  ///
  /// [poolId] 招募池ID
  void goToRecruitPool(String poolId) {
    go('/recruit/pool/$poolId');
  }

  /// 导航到物品详情页
  ///
  /// [itemId] 物品ID
  void goToItemDetail(String itemId) {
    go('/bag/items/$itemId');
  }

  /// 导航到关卡详情页
  ///
  /// [chapterId] 章节ID
  /// [stageId] 关卡ID
  void goToStageDetail(String chapterId, String stageId) {
    go('/stages/chapters/$chapterId/stages/$stageId');
  }

  /// 导航到经典战役页
  void goToClassicBattle(String battleId) {
    go('/stages/classic-battles/$battleId');
  }

  /// 导航到活动详情页
  void goToActivityDetail(String activityId) {
    go('/activities/$activityId');
  }

  /// 导航到PVP回放页
  void goToPvpReplay(String replayId) {
    go('/pvp/replay/$replayId');
  }

  /// 导航到国战城池节点页
  void goToCityNode(String cityId) {
    go('/kingdom-war/cities/$cityId');
  }

  /// 导航到攻城战页
  void goToAttackCity(String cityId) {
    go('/kingdom-war/attack/$cityId');
  }

  /// 导航到好友详情页
  void goToFriendDetail(String friendId) {
    go('/social/friends/$friendId');
  }

  /// 导航到节日活动页
  void goToFestivalActivity(String activityId) {
    go('/activities/festival/$activityId');
  }

  /// 导航到限时活动页
  void goToLimitedEvent(String eventId) {
    go('/activities/limited/$eventId');
  }
}
