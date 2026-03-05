import 'package:flutter/material.dart' hide Hero;
import 'dart:ui';
import '../state/game_state.dart';
import '../widgets/game_background.dart';
import '../models/models.dart' show Hero;
import 'hub_view.dart';
import 'gacha_view.dart';
import 'heroes_view.dart';
import 'hero_detail_view.dart';
import 'combat_map_view.dart';

enum GameView { hub, town, heroes, combat }

class MainGameScreen extends StatefulWidget {
  // 閃屏ページからロード済みの状態を渡すことを許可
  final GameState? initialState;

  const MainGameScreen({super.key, this.initialState});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  GameState? _gameState;
  GameView _currentView = GameView.hub;
  Hero? _selectedHero;
  bool _showHeroDetail = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialState != null) {
      _gameState = widget.initialState;
    } else {
      _initGameState();
    }
  }

  Future<void> _initGameState() async {
    _gameState = await GameState.load();
    if (mounted) setState(() {});
  }

  void _switchView(GameView view) {
    setState(() {
      _currentView = view;
      _showHeroDetail = false;
      _selectedHero = null;
    });
  }

  void _onHeroSelected(Hero hero) {
    setState(() {
      _selectedHero = hero;
      _showHeroDetail = true;
    });
  }

  void _onHeroDetailBack() {
    setState(() {
      _showHeroDetail = false;
      _selectedHero = null;
    });
  }

  void _onSave() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_gameState == null) {
      return const Scaffold(
        backgroundColor: Color(0xff0f172a),
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    if (_showHeroDetail && _selectedHero != null) {
      return HeroDetailView(
        hero: _selectedHero!,
        gameState: _gameState!,
        onSave: _onSave,
        onBack: _onHeroDetailBack,
      );
    }

    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('hub'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('hub'),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Stack(
        children: [
          IndexedStack(
            index: _currentView.index,
            children: [
              HubView(gameState: _gameState!),
              GachaView(
                gameState: _gameState!,
                onGacha: (res) {},
                onSave: _onSave,
                onNavigate: _switchView,
              ),
              HeroesView(
                gameState: _gameState!,
                onHeroSelected: _onHeroSelected,
              ),
              CombatMapView(gameState: _gameState!, onSave: _onSave),
            ],
          ),
          _buildTopBar(),
          if (!_showHeroDetail) _buildBottomNav(),
        ],
      ),
    ),
    );
  }

  /// 顶部资源栏 & 优化的玩家头像
  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左侧玩家信息
                Row(
                  children: [
                    // 美化后的纯UI头像
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.amber.shade300,
                            Colors.orange.shade700,
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.8),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          Positioned(
                            bottom: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'V${_gameState!.vipLevel}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lv.${_gameState!.playerLevel} 冒険者',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                size: 12,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                formatNumber(_gameState!.totalCombatPower),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // 右側リソース欄 (ゴールド)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.shade700.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.shade200,
                              Colors.amber.shade700,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'ゴールド',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formatNumber(_gameState!.gold),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff2a170e).withValues(alpha: 0.85),
              border: Border(
                top: BorderSide(
                  color: Colors.amber.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      icon: Icons.home_rounded,
                      label: '旅館',
                      view: GameView.hub,
                    ),
                    _buildNavItem(
                      icon: Icons.store_rounded,
                      label: '召喚',
                      view: GameView.town,
                    ),
                    _buildNavItem(
                      icon: Icons.groups_rounded,
                      label: '英雄',
                      view: GameView.heroes,
                    ),
                    _buildNavItem(
                      icon: Icons.explore_rounded,
                      label: '探険',
                      view: GameView.combat,
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

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required GameView view,
  }) {
    final isSelected = _currentView == view;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _switchView(view),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.amber.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.amber.shade400 : Colors.white54,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.amber.shade400 : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
