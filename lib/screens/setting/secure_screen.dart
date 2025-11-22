import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/setting/change_password_screen.dart';
import 'package:zhenyu_flutter/screens/setting/unsubscribe_screen.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class SecureScreen extends StatefulWidget {
  const SecureScreen({super.key});

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  SecurityInfoData? _info;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSecurityInfo();
  }

  Future<void> _loadSecurityInfo() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final resp = await UserApi.getSecurityInfo();
      if (!mounted) return;

      if (resp.code == 0) {
        setState(() {
          _info = resp.data;
        });
      } else {
        showMsg(context, resp.message ?? '获取账号安全信息失败');
      }
    } catch (e) {
      if (mounted) {
        showMsg(context, '获取账号安全信息失败');
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _displayMobile() {
    final mobile = _info?.mobile;
    if (mobile == null || mobile.isEmpty) {
      return '未绑定手机号';
    }
    if (mobile.length < 7) {
      return mobile;
    }
    final prefix = mobile.substring(0, 3);
    final suffix = mobile.substring(mobile.length - 4);
    return '$prefix****$suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledText('账号安全', fontSize: 18),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _loadSecurityInfo,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          children: [
            _buildMenuBox(
              children: [
                _buildMenuRow(
                  title: '手机号码',
                  trailing: Text(
                    _isLoading ? '加载中…' : _displayMobile(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                _buildMenuRow(
                  title: '修改密码',
                  onTap: () => Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      )
                      .then((_) {
                        if (mounted) {
                          _loadSecurityInfo();
                        }
                      }),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildMenuBox(
              children: [
                _buildMenuRow(
                  title: '注销账号',
                  onTap: () => Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => const UnsubscribeScreen(),
                        ),
                      )
                      .then((_) {
                        if (mounted) {
                          _loadSecurityInfo();
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuBox({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tabBarBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[children[i]],
        ],
      ),
    );
  }

  Widget _buildMenuRow({
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          trailing ??
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.5),
                size: 18,
              ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
