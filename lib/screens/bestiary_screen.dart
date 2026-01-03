import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';

class BestiaryScreen extends StatelessWidget {
  const BestiaryScreen({super.key});

  final List<Map<String, dynamic>> _monsters = const [
    {
      'name': 'Slime',
      'icon': '👾',
      'description': 'A gooey creature that lives in the lower floors. Not very dangerous alone, but annoying in groups.',
      'weakness': 'Fire',
    },
    {
      'name': 'Goblin',
      'icon': '👺',
      'description': 'A small, malicious humanoid. Loves to steal gold and hit adventurers with clubs.',
      'weakness': 'Physical',
    },
    {
      'name': 'Skeleton',
      'icon': '💀',
      'description': 'The animated bones of a fallen warrior. Resistant to piercing attacks.',
      'weakness': 'Holy/Blunt',
    },
    {
      'name': 'Dragon',
      'icon': '🐉',
      'description': 'A mighty beast of legend. Breaths fire and hoards treasure.',
      'weakness': 'Ice',
    },
    {
      'name': 'Demon',
      'icon': '👿',
      'description': 'A creature from the underworld. High magical resistance.',
      'weakness': 'Holy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.towerBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Bestiary", style: TextStyle(fontFamily: 'serif')),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _monsters.length,
            itemBuilder: (context, index) {
          final monster = _monsters[index];
          return GlassContainer(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
            opacity: 0.4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(monster['icon'], style: const TextStyle(fontSize: 48)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(monster['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accent)),
                      const SizedBox(height: 4),
                      Text(monster['description'], style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text("Weakness: ${monster['weakness']}", style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  ),
);
  }
}