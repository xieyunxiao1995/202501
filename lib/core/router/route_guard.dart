/// 路由守卫
///
/// 负责在路由跳转时执行拦截逻辑，包括：
/// - 登录状态检测：未登录用户重定向到登录页
/// - 维护公告检测：服务器维护时重定向到公告页
/// - 新手引导检测：未完成引导时重定向到引导页
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'route_paths.dart';

/// 路由守卫，处理全局路由重定向逻辑
///
/// 使用 [GoRouter.redirect] 机制，在每次路由跳转前执行守卫检查。
/// 守卫按优先级顺序执行，先到先得：维护检测 > 登录检测 > 引导检测。
class RouteGuard {
  RouteGuard._();

  /// 是否已登录（由外部 Auth 状态管理设置）
  static ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  /// 是否处于维护状态（由服务器推送或接口检测设置）
  static ValueNotifier<bool> isUnderMaintenance = ValueNotifier<bool>(false);

  /// 是否已完成新手引导（由外部引导状态管理设置）
  static ValueNotifier<bool> hasCompletedTutorial = ValueNotifier<bool>(false);

  /// 不需要登录即可访问的路径白名单
  static const List<String> _publicPaths = [
    RoutePaths.splash,
    RoutePaths.login,
    RoutePaths.update,
    RoutePaths.openingCG,
    RoutePaths.tutorial,
  ];

  /// GoRouter redirect 回调
  ///
  /// 返回 `null` 表示放行，返回路径字符串表示重定向到该路径。
  /// 此方法会被 GoRouter 在每次路由变化时调用。
  static String? guard(BuildContext context, GoRouterState state) {
    final currentPath = state.matchedLocation;

    // 1. 维护公告检测（最高优先级）
    if (isUnderMaintenance.value) {
      // 维护状态下仅允许闪屏页和更新页
      if (currentPath == RoutePaths.splash ||
          currentPath == RoutePaths.update) {
        return null;
      }
      return RoutePaths.update;
    }

    // 2. 新手引导检测
    if (!hasCompletedTutorial.value) {
      // 引导未完成时仅允许闪屏、登录、引导相关页面
      if (currentPath == RoutePaths.splash ||
          currentPath == RoutePaths.login ||
          currentPath == RoutePaths.openingCG ||
          currentPath == RoutePaths.tutorial ||
          currentPath == RoutePaths.update) {
        return null;
      }
      // 未完成引导，重定向到开场CG
      return RoutePaths.openingCG;
    }

    // 3. 登录状态检测
    if (!isLoggedIn.value) {
      // 白名单路径不需要登录
      if (_publicPaths.contains(currentPath)) {
        return null;
      }
      // 未登录且不在白名单中，重定向到登录页
      return RoutePaths.login;
    }

    // 4. 已登录用户访问登录页/闪屏页时，重定向到主页
    if (currentPath == RoutePaths.login || currentPath == RoutePaths.splash) {
      return RoutePaths.home;
    }

    // 所有检查通过，放行
    return null;
  }

  /// 重置所有守卫状态（通常在登出时调用）
  static void reset() {
    isLoggedIn.value = false;
    isUnderMaintenance.value = false;
    hasCompletedTutorial.value = false;
  }
}
