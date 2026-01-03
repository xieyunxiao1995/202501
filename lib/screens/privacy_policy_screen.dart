import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.systemBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Privacy Policy", style: TextStyle(fontFamily: 'serif')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Last Updated: December 2025",
              style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            
            _buildSection(
              "1. Introduction",
              "Welcome to Elemental Memory. We respect your privacy and are committed to protecting your personal data.",
            ),
            
            _buildSection(
              "2. Data Collection",
              "We do not collect, store, or transmit any personal identifiable information (PII) to external servers. All game progress, including inventory, stats, and settings, is stored locally on your device.",
            ),
            
            _buildSection(
              "3. Third-Party Services",
              "This app may use third-party services for AI generation (e.g., DeepSeek API). Data sent to these services is strictly limited to game context prompts and does not include user personal data.",
            ),
            
            _buildSection(
              "4. Children's Privacy",
              "Our game is safe for all ages and does not knowingly collect personal information from children under 13.",
            ),
            
            _buildSection(
              "5. Contact Us",
              "If you have any questions about this Privacy Policy, please contact us via the Feedback section in the app.",
            ),
            
            const SizedBox(height: 40),
            Center(
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                opacity: 0.05,
                child: const Text(
                  "Play Safe. Stay Private.",
                  style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
