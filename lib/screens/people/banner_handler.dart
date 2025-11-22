import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/models/index_api_model.dart';
import 'package:zhenyu_flutter/screens/vip/vip_screen.dart';
import 'package:zhenyu_flutter/screens/invate/get_vip_screen.dart';
import 'package:zhenyu_flutter/screens/wechatAccount/wechat_screen.dart';

/// Banner 点击处理工具类
class BannerHandler {
  /// 处理 banner 点击跳转
  static void handleBannerTap(BuildContext context, BannerInfo banner) {
    debugPrint(
      '点击了 banner: title=${banner.title}, redirectUrl=${banner.redirectUrl}',
    );

    // 根据 title 跳转到不同页面
    Widget? targetScreen;

    if (banner.title?.contains('开通vip') == true ||
        banner.title?.contains('开通VIP') == true) {
      targetScreen = const VipScreen();
    } else if (banner.title?.contains('赠送vip') == true ||
        banner.title?.contains('赠送VIP') == true ||
        banner.title?.contains('邀请有礼') == true) {
      targetScreen = const GetVipScreen();
    } else if (banner.title?.contains('微信公众号') == true ||
        banner.title?.contains('公众号') == true) {
      targetScreen = const WechatScreen();
    }

    if (targetScreen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen!),
      );
    }
  }
}
