import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../settings/user_agreement_page.dart';
import '../settings/privacy_policy_page.dart';

class WelcomePage extends StatefulWidget {
  final VoidCallback onAccepted;
  const WelcomePage({super.key, required this.onAccepted});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _agreed = false;
  bool _showError = false;

  void _enterApp() {
    if (!_agreed) {
      setState(() => _showError = true);
      return;
    }
    widget.onAccepted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      body: SafeArea(
        child: Column(
          children: [
            // 可滚动信息区
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 28),
                    _InfoCard(
                      icon: Icons.smart_toy_outlined,
                      iconColor: AppColors.deepLavender,
                      title: 'AI 技术说明',
                      children: [
                        _InfoRow(
                          label: '推荐引擎',
                          value: '内置本地智能搭配算法，基于规则与偏好匹配',
                        ),
                        _InfoRow(
                          label: '运行方式',
                          value: '全部计算在你的设备上完成，不依赖云端服务器',
                        ),
                        _InfoRow(
                          label: '第三方 AI',
                          value: '当前版本未接入任何第三方 AI 服务（如 OpenAI 等）',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InfoCard(
                      icon: Icons.admin_panel_settings_outlined,
                      iconColor: const Color(0xFFE8873A),
                      title: '我们申请的权限',
                      children: [
                        _InfoRow(
                          label: '相机',
                          value: '拍摄衣物和每日穿搭照片（仅你主动触发时调用）',
                        ),
                        _InfoRow(
                          label: '相册 / 存储',
                          value: '从相册选取衣物图片、保存穿搭记录照片',
                        ),
                        _InfoRow(
                          label: '说明',
                          value: '不会在后台静默使用任何权限，你可随时在系统设置中关闭',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InfoCard(
                      icon: Icons.folder_shared_outlined,
                      iconColor: const Color(0xFF4CAF82),
                      title: '你的数据去向',
                      children: [
                        _InfoRow(
                          label: '本地处理',
                          value: '衣物照片、穿搭记录、风格偏好均存储在设备本地',
                        ),
                        _InfoRow(
                          label: '不上传',
                          value: '不会将你的照片或个人数据上传至任何服务器',
                        ),
                        _InfoRow(
                          label: 'AI 输入',
                          value: '搭配算法仅读取你选择的单品标签与偏好设置，不读取照片像素',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // 固定底部：EULA + 按钮
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildEulaSection(),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _enterApp,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.deepLavender,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        '同意并进入应用',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '版本 1.0.0',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.lavender, AppColors.deepLavender],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.lavender.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.checkroom_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '可伴 AI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '开始使用前，请了解以下信息',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEulaSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _showError
              ? Colors.red.shade200
              : AppColors.lavender.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                _agreed = !_agreed;
                if (_agreed) _showError = false;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: _agreed,
                    onChanged: (value) {
                      setState(() {
                        _agreed = value ?? false;
                        if (_agreed) _showError = false;
                      });
                    },
                    activeColor: AppColors.deepLavender,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: '我已阅读并同意'),
                          WidgetSpan(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UserAgreementPage(),
                                ),
                              ),
                              child: const Text(
                                '《用户协议》',
                                style: TextStyle(
                                  color: AppColors.deepLavender,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: '和'),
                          WidgetSpan(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PrivacyPolicyPage(),
                                ),
                              ),
                              child: const Text(
                                '《隐私协议》',
                                style: TextStyle(
                                  color: AppColors.deepLavender,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showError)
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 8),
              child: Text(
                '请先阅读并同意协议后继续使用',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red.shade400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 信息卡片：带标题和多行说明
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<Widget> children;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 17, color: iconColor),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

/// 单行 label + value 说明
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.lavender.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.deepLavender,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
