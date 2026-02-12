import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';
import '../../models/part.dart';
import '../../models/item.dart';

class SummonScreen extends StatefulWidget {
  final GameService gameService;

  const SummonScreen({super.key, required this.gameService});

  @override
  State<SummonScreen> createState() => _SummonScreenState();
}

class _SummonScreenState extends State<SummonScreen> with SingleTickerProviderStateMixin {
  final List<Part> _summonedParts = [];
  bool _isAnimating = false;
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _performSummon(int count) async {
    final player = widget.gameService.player;
    if (player == null) return;

    // Cost: 1 Ink per summon.
    int cost = count * 1; 

    if (player.ink < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('墨韵不足！')),
      );
      return;
    }

    widget.gameService.consumeInk(cost);

    setState(() {
      _isAnimating = true;
      // Do not clear previous results immediately if we want to append, 
      // but usually gacha clears screen. Let's append if user wants "Thousands" feeling?
      // No, usually "Thousands Draw" implies doing it in batches or one go.
      // Let's clear for now to avoid memory issues with thousands of widgets.
      _summonedParts.clear(); 
    });

    _controller.forward(from: 0).then((_) {
      setState(() {
        _isAnimating = false;
        for (int i = 0; i < count; i++) {
          final part = widget.gameService.generateRandomPart();
          _summonedParts.add(part);
          widget.gameService.addPartToInventory(part);
        }
      });
      
      // Show Summary
      _showSummonSummary(count);
    });
  }

  void _showSummonSummary(int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgPaper,
        title: Text('祈愿结果', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('共获得了 $count 个部件', style: const TextStyle(color: AppColors.inkBlack)),
            const SizedBox(height: 16),
            const Text('已自动存入背包', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定', style: TextStyle(color: AppColors.inkRed)),
          ),
        ],
      ),
    );
  }

  void _clearResults() {
    setState(() {
      _summonedParts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.gameService.player;
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.inkBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('千抽祈愿', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: 24)),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '墨韵: ${player?.ink ?? 0}',
                style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner / Animation Area
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.woodDark, width: 4),
                image: const DecorationImage(
                  image: NetworkImage('https://www.transparenttextures.com/patterns/black-scales.png'), // Placeholder pattern
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isAnimating)
                    const CircularProgressIndicator(color: AppColors.inkRed),
                  if (!_isAnimating && _summonedParts.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, size: 80, color: AppColors.inkRed.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          '聚天地之灵气，凝万物之精华',
                          style: GoogleFonts.maShanZheng(fontSize: 20, color: AppColors.inkBlack),
                        ),
                      ],
                    ),
                  if (!_isAnimating && _summonedParts.isNotEmpty)
                    GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _summonedParts.length,
                      itemBuilder: (context, index) {
                        final part = _summonedParts[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.woodLight),
                            color: Colors.white.withOpacity(0.8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.extension, size: 24, color: AppColors.inkBlack),
                              const SizedBox(height: 4),
                              Text(
                                part.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  if (!_isAnimating && _summonedParts.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.inkRed),
                        tooltip: '清空结果',
                        onPressed: _clearResults,
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Controls
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSummonButton(context, '单抽', 1, 1),
                      _buildSummonButton(context, '十连', 10, 10),
                      _buildSummonButton(context, '百连', 100, 100),
                      _buildSummonButton(context, '千抽', 1000, 1000),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '每次祈愿消耗 1 墨韵',
                    style: TextStyle(color: AppColors.inkBlack.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummonButton(BuildContext context, String label, int count, int cost) {
    return InkWell(
      onTap: _isAnimating ? null : () => _performSummon(count),
      child: Container(
        width: 70,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFF3EFE6),
          border: Border.all(color: AppColors.inkBlack, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: GoogleFonts.maShanZheng(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('$cost 墨', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
