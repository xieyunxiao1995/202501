import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Terms of Service'),
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
                  'Terms of Service',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Last Updated: November 2025',
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 30),
                _buildSection(
                  '1. Acceptance of Terms',
                  'By accessing and using FlowCanvas, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these terms, please do not use our application.',
                ),
                _buildSection(
                  '2. Use License',
                  'Permission is granted to temporarily use FlowCanvas for personal, non-commercial purposes. This license shall automatically terminate if you violate any of these restrictions.',
                ),
                _buildSection(
                  '3. User Responsibilities',
                  'You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account. You agree to use the application in compliance with all applicable laws and regulations.',
                ),
                _buildSection(
                  '4. Content Ownership',
                  'All content you create using FlowCanvas remains your property. We do not claim ownership of your timers, marquees, or any other content you generate.',
                ),
                _buildSection(
                  '5. Service Modifications',
                  'We reserve the right to modify or discontinue the service at any time without notice. We shall not be liable to you or any third party for any modification, suspension, or discontinuance of the service.',
                ),
                _buildSection(
                  '6. Limitation of Liability',
                  'FlowCanvas shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use or inability to use the service.',
                ),
                _buildSection(
                  '7. Changes to Terms',
                  'We reserve the right to update these terms at any time. Continued use of the application after changes constitutes acceptance of the new terms.',
                ),
                const SizedBox(height: 20),
                const Text(
                  'If you have any questions about these Terms, please contact us at legal@flowcanvas.app',
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
