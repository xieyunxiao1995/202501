import 'package:flutter/material.dart';
import '../Moodmodels/app_settings.dart';
import '../Moodservices/storage_service.dart';
import '../MoodIAP/LimitUniformActionObserver.dart';
import 'about_us_screen.dart';
import 'user_agreement_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_screen.dart';
import 'feedback_screen.dart';
import 'eula_screen.dart';

class SettingsScreen extends StatefulWidget {
  final StorageService storageService;
  const SettingsScreen({super.key, required this.storageService});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppSettings _settings = AppSettings(
    aiAnalysisEnabled: true,
    anonymousInPublic: false,
    diaryRemindersEnabled: true,
    aiInteractionRemindersEnabled: false,
    themeMode: 'auto',
  );
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await widget.storageService.getSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _updateSettings(AppSettings newSettings) async {
    await widget.storageService.saveSettings(newSettings);
    setState(() {
      _settings = newSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Center(
          child: CircularProgressIndicator(color: const Color(0xFF8A7CF5)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            floating: true,
            pinned: false,
            elevation: 0,
            backgroundColor: const Color(0xFF000000),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF000000),
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                    ).createShader(bounds),
                    child: const Text(
                      '设置',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('隐私', [
                    _buildSwitchItem(
                      icon: Icons.visibility_off_outlined,
                      title: '广场匿名',
                      subtitle: '在情绪广场隐藏你的身份',
                      value: _settings.anonymousInPublic,
                      onChanged: (value) {
                        _updateSettings(
                          _settings.copyWith(anonymousInPublic: value),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('数据管理', [
                    _buildMenuItem(
                      icon: Icons.refresh,
                      title: '重置默认日记',
                      subtitle: '重新加载默认的示例日记数据',
                      onTap: () => _showResetDialog(),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('商城', [
                    _buildMenuItem(
                      icon: Icons.shopping_cart_outlined,
                      title: '金币商城',
                      subtitle: '购买金币和特惠套餐',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SetComprehensiveFormatFilter(),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection('关于', [
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: '关于我们',
                      subtitle: '了解 Moodora',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutUsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: '使用帮助',
                      subtitle: '查看使用指南',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.feedback_outlined,
                      title: '反馈和建议',
                      subtitle: '告诉我们您的想法',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.description_outlined,
                      title: '用户协议',
                      subtitle: '阅读服务条款',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserAgreementScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: '隐私政策',
                      subtitle: '了解隐私保护',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.gavel_outlined,
                      title: '最终用户许可协议',
                      subtitle: 'Apple EULA',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EulaScreen(),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('重置默认日记', style: TextStyle(color: Colors.white)),
        content: const Text(
          '这将会删除所有现有的日记数据，并重新加载默认的示例日记。此操作不可撤销，确定要继续吗？',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Color(0xFF8A7CF5))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _resetDefaultData();
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
  }

  Future<void> _resetDefaultData() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF8A7CF5)),
        ),
      );

      await widget.storageService.forceReinitializeSampleData();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('默认日记已重新加载'),
            backgroundColor: Color(0xFF8A7CF5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('重置失败，请稍后重试'),
            backgroundColor: Color(0xFFFF6B6B),
          ),
        );
      }
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey[500],
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children.map(
          (child) =>
              Padding(padding: const EdgeInsets.only(bottom: 10), child: child),
        ),
      ],
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF8A7CF5).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF8A7CF5), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF8A7CF5),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF8A7CF5).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF8A7CF5), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
