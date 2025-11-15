import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('About Us'),
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
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'FlowCanvas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Our Mission',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const Text(
                  'FlowCanvas is designed to help you achieve deep focus and creative expression. We combine powerful productivity tools with elegant design to create an environment where your best work happens naturally.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.6),
                ),
                const SizedBox(height: 20),
                const Text(
                  'What We Offer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _buildFeatureItem('⏰', 'Focus Timer', 'Customizable timers to help you stay on track'),
                _buildFeatureItem('📝', 'Marquee Display', 'Express yourself with dynamic text displays'),
                _buildFeatureItem('🎯', 'Scene Combos', 'Combine tools for your perfect workflow'),
                const SizedBox(height: 20),
                const Text(
                  'Contact Us',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Email: support@flowcanvas.app\nWebsite: www.flowcanvas.app',
                  style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
