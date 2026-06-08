/// 路由观察者
///
/// 负责监听路由变化，用于：
/// - 页面访问埋点统计
/// - 页面停留时长记录
/// - 路由异常监控
///
/// 当前为骨架实现，具体埋点逻辑待接入统计SDK后补充。
library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// 路由观察者，监听路由变化事件
///
/// 继承 [NavigatorObserver]，配合 GoRouter 的 observers 参数使用。
/// 在路由变化时触发回调，可配合 Firebase Analytics 等统计SDK实现页面埋点。
class AppRouteObserver extends NavigatorObserver {
  AppRouteObserver._();

  /// 单例实例
  static final AppRouteObserver instance = AppRouteObserver._();

  /// 页面进入时间记录，用于计算停留时长
  final Map<String, DateTime> _pageEnterTime = {};

  /// 路由变化时的回调
  ///
  /// [route] 新路由信息
  /// [previousRoute] 前一个路由信息（可能为null）
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _onRouteChanged(route.settings.name ?? '/');
  }

  /// 路由替换时的回调
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _onRouteChanged(newRoute.settings.name ?? '/');
    }
  }

  /// 路由弹出时的回调
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _onRouteExited(route.settings.name ?? '/');
    if (previousRoute != null) {
      _onRouteChanged(previousRoute.settings.name ?? '/');
    }
  }

  /// 路由进入处理
  ///
  /// 记录页面进入时间，并触发页面访问埋点。
  void _onRouteChanged(String routeName) {
    _pageEnterTime[routeName] = DateTime.now();

    // TODO: 接入 Firebase Analytics 页面追踪
    // FirebaseAnalytics.instance.logEvent(
    //   name: 'page_view',
    //   parameters: {'page_name': routeName},
    // );

    debugPrint('[RouteObserver] 进入页面: $routeName');
  }

  /// 路由退出处理
  ///
  /// 计算页面停留时长，并触发页面离开埋点。
  void _onRouteExited(String routeName) {
    final enterTime = _pageEnterTime.remove(routeName);
    if (enterTime != null) {
      final duration = DateTime.now().difference(enterTime);

      // TODO: 接入页面停留时长统计
      // FirebaseAnalytics.instance.logEvent(
      //   name: 'page_exit',
      //   parameters: {
      //     'page_name': routeName,
      //     'duration_seconds': duration.inSeconds,
      //   },
      // );

      debugPrint(
        '[RouteObserver] 离开页面: $routeName, 停留时长: ${duration.inSeconds}秒',
      );
    }
  }

  /// GoRouter 路由变化回调
  ///
  /// 配合 GoRouter 的 observers 参数使用。
  void onRouteChange(GoRouterState state) {
    final path = state.matchedLocation;
    _onRouteChanged(path);
  }

  /// 清除所有页面时间记录（通常在登出时调用）
  void clearAll() {
    _pageEnterTime.clear();
  }
}
