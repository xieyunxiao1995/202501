import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/screens/login/pre_login_screen.dart';
import 'package:zhenyu_flutter/services/im_manager.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'secure_screen.dart';
import 'blacklist_screen.dart';
import 'about_us_screen.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _autoPostEnabled = true;
  bool _pushEnabled = true;

  @override
  void initState() {
    super.initState();
    // Here you would load user settings from an API
  }

  void _handleAutoPostChange(bool value) {
    setState(() {
      _autoPostEnabled = value;
    });
    // Here you would call an API to update the setting
    showMsg(context, '自动发动态已${value ? "开启" : "关闭"}');
  }

  void _handlePushChange(bool value) {
    setState(() {
      _pushEnabled = value;
    });
    showMsg(context, '个性化推送已${value ? "开启" : "关闭"}');
  }

  Future<void> _logout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      // 完全清理 IM SDK (包括取消监听器和反初始化)
      await ImManager.instance.unInit();
      // 再登出 App
      await UserApi.loginOut({});
    } catch (e) {
      // Ignore errors during logout
    } finally {
      // 清理本地状态并跳转
      await userProvider.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PreLoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledText('设置', fontSize: 18),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Column(
          children: [
            _buildNavItem('账号安全', () => _navigateTo(const SecureScreen())),
            _buildSwitchItem('个性化推送', _pushEnabled, _handlePushChange),
            _buildSwitchItem(
              '自动发动态',
              _autoPostEnabled,
              _handleAutoPostChange,
              subtitle: '修改头像时，自动发送动态',
            ),
            _buildNavItem('黑名单', () => _navigateTo(const BlacklistScreen())),
            _buildNavItem('关于我们', () => _navigateTo(const AboutUsScreen())),
            const Spacer(),
            _buildLogoutButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.tabBarBackground,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledText(title, fontSize: 13),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    String title,
    bool value,
    ValueChanged<bool> onChanged, {
    String? subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.tabBarBackground,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledText(title, fontSize: 13),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                StyledText(
                  subtitle,
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.5),
                ),
              ],
            ],
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.secondaryGradientStart,
              inactiveTrackColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _logout,
      child: Container(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          gradient: AppGradients.secondaryGradient,
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: const Text(
          '退出登录',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
