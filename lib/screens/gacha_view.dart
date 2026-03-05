import 'package:flutter/material.dart' hide Hero;
import 'dart:math' as math;
import '../models/models.dart';
import '../constants.dart';
import '../state/game_state.dart';
import '../widgets/game_background.dart';
import 'main_game_screen.dart';

/// 抽卡結果項目
class GachaResult {
  final Hero hero;
  final bool isNew;

  GachaResult({required this.hero, this.isNew = false});
}

/// 抽卡回调
typedef OnGachaCallback = void Function(List<GachaResult> results);

/// 旅館/抽卡画面
class GachaView extends StatefulWidget {
  final GameState gameState;
  final OnGachaCallback onGacha;
  final VoidCallback onSave;
  final Function(GameView) onNavigate;

  const GachaView({
    super.key,
    required this.gameState,
    required this.onGacha,
    required this.onSave,
    required this.onNavigate,
  });

  @override
  State<GachaView> createState() => _GachaViewState();
}

class _GachaViewState extends State<GachaView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool _isSummoning = false; // 召喚中かどうか
  bool _showFlash = false; // 白光点滅効果の制御

  List<GachaResult>? _summonResults; // 総合結果
  List<GachaResult> _revealedResults = []; // 順番に表示するアニメーション結果リスト

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 4), // 法陣がゆっくり回転
      vsync: this,
    )..repeat(); // 魔法陣を継続的に回転させる
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 抽卡を実行 (ゴールド消費 + アニメーション演出)
  void _performGacha(int times) async {
    if (_isSummoning) return;

    final cost = times * 200; // 单抽200金币，十连2000金币
    if (widget.gameState.gold < cost) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xff2a170e),
            title: const Text('ゴールド不足', style: TextStyle(color: Colors.white)),
            content: const Text(
              'ゴールドが不足しています。探険に行ってゴールドを稼ぎましょう。',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('確定', style: TextStyle(color: Colors.amber)),
              ),
            ],
          ),
        );
      }
      return;
    }

    // 1. ゴールドを差し引き、召喚前揺状態に入る
    widget.gameState.spendGold(cost);
    setState(() {
      _isSummoning = true;
      _summonResults = null;
      _revealedResults = [];
    });

    // 溜めアニメーション時間
    await Future.delayed(const Duration(milliseconds: 600));

    // 2. 閃光弾効果を発動
    setState(() {
      _showFlash = true;
    });

    // 閃光弾が最高亮度の瞬間にデータを生成
    await Future.delayed(const Duration(milliseconds: 150));

    final results = <GachaResult>[];
    final existingHeroUids = widget.gameState.inventory
        .map((h) => h.uid)
        .toSet();

    for (int i = 0; i < times; i++) {
      final hero = _pullSingleHero();
      results.add(
        GachaResult(hero: hero, isNew: !existingHeroUids.contains(hero.uid)),
      );
    }

    // インベントリに追加して保存
    widget.gameState.addHeroes(results.map((r) => r.hero).toList());
    await widget.gameState.save();
    widget.onSave();

    // 3. 閃光をオフにして結果背景パネルを表示
    setState(() {
      _showFlash = false;
      _summonResults = results;
    });

    // 4. カードを順に提示 (Staggered Reveal)
    for (int i = 0; i < results.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted || _summonResults == null) break; // ユーザーが途中で閉じた場合
      setState(() {
        _revealedResults.add(results[i]);
      });
    }

    setState(() {
      _isSummoning = false;
    });
    widget.onGacha(results);
  }

  /// 1 回抽卡の核心ロジック
  Hero _pullSingleHero() {
    final rand = DateTime.now().millisecondsSinceEpoch.toDouble() % 1;
    RarityType pulledRarity = RarityType.R;

    double cumulative = 0;
    for (final rarity in [
      RarityType.UR,
      RarityType.SSR,
      RarityType.SR,
      RarityType.R,
    ]) {
      cumulative += RARITIES[rarity]!.probability;
      if (rand <= cumulative) {
        pulledRarity = rarity;
        break;
      }
    }

    final pool = HERO_TEMPLATES.where((h) => h.rarity == pulledRarity).toList();
    final template = pool[DateTime.now().millisecond % pool.length];

    // 英雄テンプレートの固定画像を使用
    return template.createInstance(
      uid:
          DateTime.now().millisecondsSinceEpoch.toRadixString(36) +
          (DateTime.now().millisecond % 9999).toString(),
      level: 1,
      stars: (pulledRarity == RarityType.UR || pulledRarity == RarityType.SSR)
          ? 5
          : 3,
      image: template.image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('gacha'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('gacha'),
      child: Container(
        child: Stack(
        children: [
          // メインシーン：魔法陣とボタン
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    '旅館召喚陣',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfffbbf24),
                      shadows: [
                        Shadow(color: Color(0xfffbbf24), blurRadius: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '極品 UR 入手確率 UP!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  _buildSummonArray(),
                  const Spacer(),
                  _buildGachaButtons(),
                  const SizedBox(height: 80), // 底部ナビゲーションバーに被らない
                ],
              ),
            ),
          ),

          // フラッシュエフェクトレイヤー
          IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              opacity: _showFlash ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(color: Colors.white),
            ),
          ),

          // 結果表示レイヤー
          if (_summonResults != null) _buildGachaResults(),
        ],
      ),
    ),
    );
  }

  /// 中心魔法陣を描画
  Widget _buildSummonArray() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isSummoning
              ? 1.1 + math.sin(_animationController.value * math.pi * 8) * 0.05
              : 1.0,
          child: Container(
            width: 256,
            height: 256,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isSummoning ? Colors.white : const Color(0xff6366f1),
                width: _isSummoning ? 8 : 4,
              ),
              color: const Color(0xff312e81).withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                  color: _isSummoning
                      ? Colors.white.withOpacity(0.8)
                      : const Color(0xff6366f1).withOpacity(0.5),
                  blurRadius: _isSummoning ? 100 : 50,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle:
                      _animationController.value *
                      2 *
                      math.pi *
                      (_isSummoning ? 3 : 1),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xff818cf8).withOpacity(0.5),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.star_border,
                      size: 180,
                      color: Color(0xff818cf8),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isSummoning
                        ? Colors.amber
                        : const Color(0xff4c1d95).withOpacity(0.8),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: _isSummoning
                        ? Colors.white
                        : const Color(0xfffbbf24),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 抽卡ボタンを描画
  Widget _buildGachaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGachaButton(
          label: '1 回召喚',
          subLabel: '200 ゴールド',
          color: Colors.blue,
          onTap: () => _performGacha(1),
        ),
        const SizedBox(width: 16),
        _buildGachaButton(
          label: '10 連召喚',
          subLabel: '2000 ゴールド',
          color: Colors.amber.shade700,
          onTap: () => _performGacha(10),
        ),
      ],
    );
  }

  Widget _buildGachaButton({
    required String label,
    required String subLabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isSummoning ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isSummoning
                ? [Colors.grey.shade700, Colors.grey.shade800]
                : [color.withOpacity(0.8), color],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isSummoning ? Colors.grey : color.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: _isSummoning
              ? []
              : [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isSummoning ? Colors.white54 : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: TextStyle(
                fontSize: 12,
                color: _isSummoning
                    ? Colors.white38
                    : Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 召喚結果を表示
  Widget _buildGachaResults() {
    // 動的に上部と下部のナビゲーションバーの高さを避ける
    final topPad = MediaQuery.of(context).padding.top + 70;
    final botPad = MediaQuery.of(context).padding.bottom + 70;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.95),
        padding: EdgeInsets.only(top: topPad, bottom: botPad),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              '召喚結果',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: _revealedResults.length, // 順次表示するリストを使用
                itemBuilder: (context, index) {
                  final result = _revealedResults[index];
                  final rColor = _getRarityColor(result.hero.rarity);

                  // 登場したカードに彈性スケールアニメーションを追加
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: rColor, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [rColor.withOpacity(0.5), Colors.black],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: rColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // 英雄画像（テンプレートから取得）
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      result.hero.image.isNotEmpty
                                          ? result.hero.image
                                          : _getImageFromTemplate(result.hero.templateId),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (result.isNew)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        '新',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: rColor,
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            alignment: Alignment.center,
                            child: Text(
                              result.hero.rarity.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              result.hero.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // 操作ボタン行 (淡入アニメーション)
            AnimatedOpacity(
              opacity: _isSummoning ? 0.0 : 1.0, // 抽卡全部終了後にボタンを表示
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: _isSummoning
                    ? null
                    : () => setState(() => _summonResults = null),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xfff59e0b), Color(0xffd97706)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    '確定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(RarityType rarity) {
    switch (rarity) {
      case RarityType.UR:
        return const Color(0xffef4444);
      case RarityType.SSR:
        return const Color(0xfff97316);
      case RarityType.SR:
        return const Color(0xffa855f7);
      case RarityType.R:
        return const Color(0xff3b82f6);
    }
  }

  String _getImageFromTemplate(String templateId) {
    final template = HERO_TEMPLATES.firstWhere(
      (t) => t.id == templateId,
      orElse: () => HERO_TEMPLATES.first,
    );
    return template.image.isEmpty ? HERO_TEMPLATES.first.image : template.image;
  }
}
