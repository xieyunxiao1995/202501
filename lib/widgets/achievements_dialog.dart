import 'package:flutter/material.dart';
import '../data/achievements_data.dart';
import '../utils/achievement_manager.dart';

class AchievementsDialog extends StatelessWidget {
  final VoidCallback onClose;

  const AchievementsDialog({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1F2937),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "功业录",
              style: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SizedBox(
                height: 400,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    final ach = achievements[index];
                    final isUnlocked = AchievementManager.unlockedIds.contains(ach.id);
                    return Card(
                      color: isUnlocked ? Colors.black54 : Colors.black26,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Text(
                          isUnlocked ? ach.icon : "🔒",
                          style: const TextStyle(fontSize: 32),
                        ),
                        title: Text(
                          ach.name,
                          style: TextStyle(
                            color: isUnlocked ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                            decoration: isUnlocked ? null : TextDecoration.lineThrough,
                          ),
                        ),
                        subtitle: Text(
                          ach.desc,
                          style: TextStyle(color: isUnlocked ? Colors.grey[400] : Colors.grey[700]),
                        ),
                        trailing: isUnlocked
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text("关闭"),
            ),
          ],
        ),
      ),
    );
  }
}
