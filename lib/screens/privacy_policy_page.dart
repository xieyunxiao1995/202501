import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Last Updated: November 2025',
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 30),
                _buildSection(
                  '1. Information We Collect',
                  'FlowCanvas collects minimal information to provide you with the best experience. This includes:\n\n• App usage data (timers, marquees, combos you create)\n• Device settings and preferences\n• Anonymous analytics to improve our service',
                ),
                _buildSection(
                  '2. How We Use Your Information',
                  'We use the collected information to:\n\n• Provide and maintain our service\n• Improve user experience\n• Develop new features\n• Send important updates about the app',
                ),
                _buildSection(
                  '3. Data Storage',
                  'All your personal data is stored locally on your device. We do not transmit your timers, marquees, or personal content to our servers unless you explicitly choose to sync or backup your data.',
                ),
                _buildSection(
                  '4. Third-Party Services',
                  'We may use third-party services for analytics and crash reporting. These services have their own privacy policies and we encourage you to review them.',
                ),
                _buildSection(
                  '5. Data Security',
                  'We implement appropriate security measures to protect your information. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.',
                ),
                _buildSection(
                  '6. Your Rights',
                  'You have the right to:\n\n• Access your personal data\n• Delete your data at any time\n• Opt-out of analytics\n• Export your content',
                ),
                _buildSection(
                  '7. Children\'s Privacy',
                  'Our service is not directed to children under 13. We do not knowingly collect personal information from children under 13.',
                ),
                _buildSection(
                  '8. Changes to Privacy Policy',
                  'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                ),
                const SizedBox(height: 20),
                const Text(
                  'For privacy concerns or questions, contact us at privacy@flowcanvas.app',
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.6),
          ),
        ],
      ),
    );
  }
}
