import 'package:flutter/material.dart';
import '../widgets/game_background.dart';

class PreviewView extends StatelessWidget {
  const PreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('preview'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('preview'),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('未来视界'),
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildPreviewCard(
              '全新 UR 英雄：リリス',
              '深淵の魔女が降臨。虚空の力を支配する最強のサポーター。',
              '2026-03-15',
              Colors.purpleAccent,
            ),
            const SizedBox(height: 16),
            _buildPreviewCard(
              '新マップ：浮空の島',
              '雲端を越えた挑戦。伝説級の装備断片がドロップ。',
              '2026-04-01',
              Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(
    String title,
    String desc,
    String date,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.4), Colors.black12],
        ),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.new_releases, color: color),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Divider(height: 30, color: Colors.white10),
          Text(
            '预计开启: $date',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
