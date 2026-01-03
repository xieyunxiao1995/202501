import 'package:flutter/material.dart';
import '../models/item.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.towerBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(item.name, style: const TextStyle(fontFamily: 'serif')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Hero(
              tag: 'item_${item.id}',
              child: GlassContainer(
                width: 300,
                // Remove fixed height to allow expansion
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.iconData, style: const TextStyle(fontSize: 120)),
                    const SizedBox(height: 24),
                    Text(item.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.accent)),
                    const SizedBox(height: 16),
                    Text(
                      "Damage/Heal: ${item.damage}", 
                      style: TextStyle(
                        fontSize: 20, 
                        color: item.damage < 0 ? Colors.greenAccent : Colors.redAccent
                      )
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 24),
                    Text(
                      item.description, 
                      style: const TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}