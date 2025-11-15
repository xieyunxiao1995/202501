import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Help & Guide'),
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
                  'How to Use FlowCanvas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                _buildHelpSection(
                  '⏰ Timer Tab',
                  'Create Focus Sessions',
                  [
                    'Tap the "+" button to create a new timer',
                    'Set your desired duration and intervals',
                    'Add a title to describe your focus session',
                    'Tap "Start" to begin your timer',
                    'Use fullscreen mode for distraction-free focus',
                  ],
                ),
                _buildHelpSection(
                  '📝 Marquee Tab',
                  'Display Dynamic Text',
                  [
                    'Create a new marquee with the "+" button',
                    'Enter your text message',
                    'Customize font size and scroll speed',
                    'Choose your preferred color scheme',
                    'Tap fullscreen to display on your device',
                  ],
                ),
                _buildHelpSection(
                  '🎯 Combo Tab',
                  'Combine Multiple Tools',
                  [
                    'Create a combo to use timer and marquee together',
                    'Select a timer from your saved templates',
                    'Choose a marquee to display during focus',
                    'Save your combo for quick access',
                    'Perfect for presentations or study sessions',
                  ],
                ),
                _buildHelpSection(
                  '👤 Profile Tab',
                  'Manage Your Settings',
                  [
                    'View your usage statistics',
                    'Customize app preferences',
                    'Access saved templates',
                    'Review privacy and terms',
                    'Send feedback to improve the app',
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFF334155)),
                const SizedBox(height: 20),
                const Text(
                  'Tips & Tricks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
                _buildTipItem('💡', 'Use combos for consistent workflows'),
                _buildTipItem('🔄', 'Save frequently used timers as templates'),
                _buildTipItem('🎨', 'Experiment with different marquee styles'),
                _buildTipItem('📱', 'Enable "Keep Screen On" for long sessions'),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFF334155)),
                const SizedBox(height: 20),
                const Text(
                  'Need More Help?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Contact our support team at support@flowcanvas.app\nWe typically respond within 24 hours.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8), height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String icon, String title, List<String> steps) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(left: 34, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key + 1}. ',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF6366F1)),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
            ),
          ),
        ],
      ),
    );
  }
}
