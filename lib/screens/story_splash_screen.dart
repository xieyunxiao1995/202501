import 'package:flutter/material.dart';
import 'dart:async';
import '../state/game_state.dart';
import 'main_game_screen.dart';

/// 複数ページのゲーム紹介スクリーン
class StorySplashScreen extends StatefulWidget {
  const StorySplashScreen({super.key});

  @override
  State<StorySplashScreen> createState() => _StorySplashScreenState();
}

class _StorySplashScreenState extends State<StorySplashScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

  // ストーリーページデータ
  final List<StoryPageData> _storyPages = [
    StoryPageData(
      icon: Icons.auto_awesome,
      title: '一界旅',
      subtitle: 'JOURNEY OF ONE REALM',
      description: '遥かなる異世界に、神秘的な旅館が存在する\nここは旅人の帰処、そして冒険の起点',
      storyText: '目を開けると、あなたは古びた旅館の中にいる\n窓の外は見知らぬ星空、耳には奇妙な生物の鳴き声\nそして優しい声が耳元に囁く：\n「一界旅へようこそ」',
      color: const Color(0xff8c6751),
    ),
    StoryPageData(
      icon: Icons.groups,
      title: '英雄との邂逅',
      subtitle: 'HEROES GATHERING',
      description: '数十人の異なる陣営の英雄があなたとの契約を待つ\n火・水・風・光・闇、五大陣営が相互に克制',
      storyText: '赤髪の狐耳少女が油紙傘を差し、あなたに温かい微笑みを向ける\n「私はフレア、あなたの最強の盾となります」\n巨鯨を描く魔法少女ロティア\nそして風系刺客の蒼刃…\n彼らすべてがあなたの召喚を待っている',
      color: const Color(0xffd49d6a),
    ),
    StoryPageData(
      icon: Icons.local_fire_department,
      title: '戦略バトル',
      subtitle: 'STRATEGIC COMBAT',
      description: '5v5 ターン制オートバトル、スキル組み合わせは千変万化\n天賦・ルーン・装備、最強の編成を打造',
      storyText: '戦闘の号角が既に鳴り響いた\n陽炎の斬撃が空を切り、神筆の巨鯨が狂澜を巻く\n疾風の剣影が敵陣を穿梭\nあなたの知恵を駆使し、戦術を立案\n真の異界の領主となれ',
      color: const Color(0xffc75c5c),
    ),
    StoryPageData(
      icon: Icons.castle,
      title: '旅館経営',
      subtitle: 'INN MANAGEMENT',
      description: '温泉・暖炉・商店…あなた専用の異界旅館を打造\nメイドと交流し、各方の旅人をもてなす',
      storyText: 'この古びた旅館には悠久の歴史がある\n議事の暖炉はギルドの栄光を証し\n温泉は冒険の疲れを癒やす\n商店には貴重な宝物が並ぶ\nここが、あなたの家',
      color: const Color(0xff5c8cc7),
    ),
    StoryPageData(
      icon: Icons.trending_up,
      title: '深遠育成',
      subtitle: 'DEEP PROGRESSION',
      description: 'レベルアップ・星上げ・天賦・ルーン…多次元の成長システム\n遣返システム、無損リセット、自由に編成を試行',
      storyText: '一人の普通の旅人から、戦力百万の強者へ\n毎回の昇華が質的飛躍\n一つの赤い星がすべて栄誉を代表\nたとえ選択を間違えても、遣返システムがすべての資源を返還\nあなたの成長の道に、寄り道なし',
      color: const Color(0xff9d67c7),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();

    // ゲームデータを事前ロード
    _preloadGameData();
  }

  Future<void> _preloadGameData() async {
    // 事前にデータを読み込むが、ユーザー操作または最終ページで自動遷移するまで待機
    await GameState.load();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _storyPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _startGame();
    }
  }

  void _startGame() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final loadedState = await GameState.load();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MainGameScreen(initialState: loadedState),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1a1a2e),
              Color(0xff16213e),
              Color(0xff0f0f23),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 背景装飾の星
            ..._buildBackgroundStars(),

            // メインコンテンツエリア
            SafeArea(
              child: Column(
                children: [
                  // 上部スキップボタン
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isLoading ? null : _startGame,
                          child: Text(
                            'スキップ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ストーリーページビュー
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: _storyPages.length,
                        itemBuilder: (context, index) {
                          return _buildStoryPage(_storyPages[index]);
                        },
                      ),
                    ),
                  ),

                  // ページインジケーター
                  _buildPageIndicator(),

                  // 下部ボタン
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 前へボタン
                        IconButton(
                          onPressed: _isLoading
                              ? null
                              : (_currentPage > 0
                                  ? () {
                                      _pageController.previousPage(
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  : null),
                          icon: Icon(
                            Icons.chevron_left,
                            size: 32,
                            color: _currentPage > 0
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                        ),

                        // スタートボタンまたは次ページインジケーター
                        if (_currentPage == _storyPages.length - 1)
                          ElevatedButton(
                            onPressed: _isLoading ? null : _startGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffd49d6a),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    '旅を開始',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4,
                                    ),
                                  ),
                          )
                        else
                          IconButton(
                            onPressed: _isLoading ? null : _nextPage,
                            icon: const Icon(
                              Icons.chevron_right,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryPage(StoryPageData page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // メインアイコン
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          page.color.withValues(alpha: 0.8),
                          page.color,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: page.color.withValues(alpha: 0.5),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      page.icon,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // タイトル
                  Text(
                    page.title,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 8,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // サブタイトル
                  Text(
                    page.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: page.color,
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 简介
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: page.color.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      page.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.8,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ストーリーテキストボックス
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: page.storyText.split('\n').map((line) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            line,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 2,
                              letterSpacing: 1,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const Spacer(flex: 1),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _storyPages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? const Color(0xffd49d6a)
                  : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundStars() {
    return List.generate(
      20,
      (index) => Positioned(
        left: (index * 17.5) % 100,
        top: (index * 23.7) % 100,
        child: TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 1500 + (index * 200)),
          tween: Tween(begin: 0.3, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value * 0.5,
              child: child,
            );
          },
          onEnd: () {
            // 循環アニメーションロジックを追加可能
          },
          child: Icon(
            Icons.star,
            size: 8 + (index % 3) * 4,
            color: const Color(0xffd49d6a),
          ),
        ),
      ),
    );
  }
}

/// ストーリーページデータモデル
class StoryPageData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String storyText;
  final Color color;

  StoryPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.storyText,
    required this.color,
  });
}
