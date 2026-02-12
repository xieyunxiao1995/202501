import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import 'settings/about_us_screen.dart';
import 'settings/legal_screen.dart';
import 'settings/help_screen.dart';
import 'settings/feedback_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 380;
    
    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('设置', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: isSmallScreen ? 26 : 32)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.inkBlack),
      ),
      body: ListView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        children: [
          _buildSettingsItem(
            context,
            '关于我们',
            Icons.info_outline,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen())),
            isSmallScreen,
          ),
          _buildSettingsItem(
            context,
            '用户协议',
            Icons.gavel_outlined,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(title: '用户协议', type: LegalType.terms))),
            isSmallScreen,
          ),
          _buildSettingsItem(
            context,
            '隐私协议',
            Icons.privacy_tip_outlined,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalScreen(title: '隐私协议', type: LegalType.privacy))),
            isSmallScreen,
          ),
          _buildSettingsItem(
            context,
            '使用帮助',
            Icons.help_outline,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())),
            isSmallScreen,
          ),
          _buildSettingsItem(
            context,
            '反馈与建议',
            Icons.feedback_outlined,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen())),
            isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, IconData icon, VoidCallback onTap, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFE6),
        border: Border.all(color: AppColors.woodDark, width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.inkBlack, size: isSmallScreen ? 20 : 24),
        title: Text(
          title,
          style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 18 : 20, color: AppColors.inkBlack),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: isSmallScreen ? 14 : 16, color: AppColors.woodLight),
        onTap: onTap,
        dense: isSmallScreen,
      ),
    );
  }
}
