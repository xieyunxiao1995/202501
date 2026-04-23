import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/data.dart';
import '../theme/theme.dart';
import 'settings/about_us_page.dart';
import 'settings/feedback_page.dart';
import 'settings/help_page.dart';
import 'settings/privacy_policy_page.dart';
import 'settings/user_agreement_page.dart';
import 'settings/background_music_page.dart';
import '../utils/responsive_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final currentUser = AppState.instance.currentUser;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildSettingsList(context),
                      _buildVersionInfo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = ResponsiveHelper.getScaleFactor(context);
        final padding = ResponsiveHelper.responsivePadding(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16 * scale),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundLight,
                Color(0xFFF3E8FF),
                Color(0xFFE8F4FD),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scale,
                    vertical: 8 * scale,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientTealStart,
                        AppColors.gradientTealEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientTealStart.withOpacity(0.3),
                        blurRadius: 10 * scale,
                        offset: Offset(0, 3 * scale),
                      ),
                    ],
                  ),
                  child: Text(
                    '设置',
                    style: TextStyle(
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, UserProfile user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF3E8FF), Color(0xFFE8F4FD)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: const Color(0xFFC4B5E0)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientPurpleStart,
                        AppColors.gradientPurpleEnd,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientPurpleStart.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        user.avatar != null && user.avatar!.startsWith('http')
                        ? NetworkImage(user.avatar!)
                        : null,
                    child:
                        user.avatar == null || !user.avatar!.startsWith('http')
                        ? const Icon(
                            Icons.person,
                            size: 36,
                            color: Color(0xFF6B5B95),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B5B95),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (user.bio != null) ...[
              const SizedBox(height: 16),
              Text(
                user.bio!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B5B95),
                  height: 1.5,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('记录', user.entriesCount.toString()),
                _buildStatColumn('粉丝', user.followersCount.toString()),
                _buildStatColumn('关注', user.followingCount.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8D5F5), Color(0xFFD5E8F5)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC4B5E0), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B5B95),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '设置与更多',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF3E8FF), Color(0xFFE8F4FD)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: const Color(0xFFC4B5E0)),
            ),
            child: Column(
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.music_note_rounded,
                  title: '背景音乐',
                  subtitle: '播放音乐，即使切换到其他应用',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BackgroundMusicPage(),
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: '帮助与支持',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpPage()),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.feedback_outlined,
                  title: '反馈与建议',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackPage()),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: '关于我们',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsPage()),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.description_outlined,
                  title: '用户协议',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserAgreementPage(),
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: '隐私政策',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.gradientPurpleStart,
              AppColors.gradientPurpleEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradientPurpleStart.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B5B95),
                fontWeight: FontWeight.w400,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: const Color(0xFF6B5B95),
        size: 24,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: const Color(0xFFC4B5E0)),
    );
  }

  Widget _buildVersionInfo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 40),
        child: Text(
          'MoodStyle v2.0.4',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B5B95),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
