import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';
import '../models/player_stats.dart';
import 'bestiary_screen.dart';
import 'statistics_screen.dart';
import 'about_screen.dart';
import 'feedback_screen.dart';
import 'privacy_policy_screen.dart';

class SystemScreen extends StatelessWidget {
  final PlayerStats stats;
  final VoidCallback onReset;

  const SystemScreen({super.key, required this.stats, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text("System", style: TextStyle(fontSize: 28, fontFamily: 'serif', color: AppColors.accent)),
          const SizedBox(height: 20),
          
          _buildItem(context, "Statistics", "View your progress", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => StatisticsScreen(stats: stats)));
          }),
          _buildItem(context, "Bestiary", "Enemy Encyclopedia", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const BestiaryScreen()));
          }),
          _buildItem(context, "Reset Game", "Delete all save data", onTap: () async {
            // Confirm Dialog
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Reset Game?"),
                content: const Text("This cannot be undone."),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Reset", style: TextStyle(color: Colors.red))),
                ],
              ),
            );
            
            if (confirm == true) {
              onReset();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Game Data Reset!")));
            }
          }),
          _buildItem(context, "About", "Version 1.0.0", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const AboutScreen()));
          }),
          _buildItem(context, "How to Play", "Rules of the Tower", onTap: () {
             showDialog(context: context, builder: (c) => const AlertDialog(
               backgroundColor: AppColors.systemBg,
               title: Text("How to Play", style: TextStyle(color: Colors.white)),
               content: Text("1. Flip cards to match pairs.\n2. Matches damage the enemy.\n3. Mismatches let the enemy attack.\n4. Defeat enemies to climb floors and get loot.\n5. Synthesize loot in the Lab to get stronger runes.\n6. Equip runes in Grimoire.", style: TextStyle(color: Colors.white70)),
             ));
          }),
          _buildItem(context, "Feedback", "Contact Developer", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const FeedbackScreen()));
          }),
          _buildItem(context, "Privacy Policy", "Data usage", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const PrivacyPolicyScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, String subtitle, {VoidCallback? onTap}) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(8),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: onTap,
      ),
    );
  }
}
