import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/ai_service.dart';
import '../constants/colors.dart';
import '../widgets/glass_container.dart';

class AlchemyScreen extends StatefulWidget {
  final List<Item> inventory;
  final Function(Item) onItemSynthesized;

  const AlchemyScreen({
    super.key,
    required this.inventory,
    required this.onItemSynthesized,
  });

  @override
  State<AlchemyScreen> createState() => _AlchemyScreenState();
}

class _AlchemyScreenState extends State<AlchemyScreen> with SingleTickerProviderStateMixin {
  Item? _slot1;
  Item? _slot2;
  bool _isSynthesizing = false;
  Item? _resultItem;
  final AIService _aiService = AIService();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _selectItem(int slot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Transparent for Glass effect
      builder: (context) => GlassContainer(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: AppColors.labBg,
        opacity: 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Select Material", style: TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(height: 10),
            Expanded(
              child: widget.inventory.isEmpty 
                  ? const Center(child: Text("Inventory Empty", style: TextStyle(color: Colors.white54)))
                  : ListView.builder(
                    itemCount: widget.inventory.length,
                    itemBuilder: (context, index) {
                      final item = widget.inventory[index];
                      return ListTile(
                        leading: Text(item.iconData, style: const TextStyle(fontSize: 24)),
                        title: Text(item.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70)),
                        onTap: () {
                          setState(() {
                            if (slot == 1) _slot1 = item;
                            else _slot2 = item;
                            _resultItem = null; // Reset result if slots change
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _synthesize() async {
    if (_slot1 == null || _slot2 == null) return;
    
    setState(() {
      _isSynthesizing = true;
      _resultItem = null;
    });

    // Simulate magic delay if API is too fast
    await Future.delayed(const Duration(seconds: 2));

    final newItem = await _aiService.synthesizeItem(_slot1!.name, _slot2!.name);
    
    if (newItem != null) {
      widget.onItemSynthesized(newItem);
    }

    if (mounted) {
      setState(() {
        _isSynthesizing = false;
        _resultItem = newItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Effect
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.2,
                colors: [
                  AppColors.accent.withOpacity(0.1),
                  AppColors.towerBg,
                ],
              ),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Alchemy Lab", style: TextStyle(fontSize: 28, fontFamily: 'serif', color: AppColors.accent)),
              const Text("Fuse items to create powerful artifacts", style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 40),
              
              Stack(
                alignment: Alignment.center,
                children: [
                  // Magic Circle Background
                  if (_isSynthesizing)
                    RotationTransition(
                      turns: _pulseController,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2),
                          gradient: RadialGradient(
                            colors: [AppColors.accent.withOpacity(0.1), Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSlot(1, _slot1),
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) => Transform.scale(
                          scale: _isSynthesizing ? _pulseAnimation.value : 1.0,
                          child: Icon(
                            Icons.science,
                            color: _isSynthesizing ? AppColors.accent : Colors.white24,
                            size: 40,
                          ),
                        ),
                      ),
                      _buildSlot(2, _slot2),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: (_slot1 != null && _slot2 != null && !_isSynthesizing) ? _synthesize : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: _isSynthesizing ? 10 : 2,
                  shadowColor: AppColors.accent.withOpacity(0.5),
                ),
                child: _isSynthesizing 
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)),
                        SizedBox(width: 10),
                        Text("Transmuting..."),
                      ],
                    ) 
                  : const Text("Synthesize", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 40),
              
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _resultItem != null
                  ? GlassContainer(
                      key: ValueKey(_resultItem!.id),
                      padding: const EdgeInsets.all(20),
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.accent,
                      opacity: 0.1,
                      border: Border.all(color: AppColors.accent.withOpacity(0.5)),
                      child: Column(
                        children: [
                          const Text("✨ Synthesis Complete! ✨", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_resultItem!.iconData, style: const TextStyle(fontSize: 56)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_resultItem!.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(_resultItem!.description, style: const TextStyle(color: Colors.white70)),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text("Dmg: ${_resultItem!.damage}", style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlot(int slot, Item? item) {
    return GestureDetector(
      onTap: () => _selectItem(slot),
      child: GlassContainer(
        width: 100,
        height: 100,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        opacity: 0.1,
        border: Border.all(color: Colors.white24),
        child: item == null
          ? const Center(child: Icon(Icons.add_circle_outline, color: Colors.white24, size: 40))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.iconData, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 4),
                Text(item.name, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
      ),
    );
  }
}
