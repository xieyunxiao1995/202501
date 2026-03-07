import 'package:flutter/material.dart';
import '../state/game_state.dart';
import '../widgets/game_background.dart';
import 'login_bonus_view.dart';
import 'preview_view.dart';
import 'tasks_view.dart';
import 'inventory_view.dart';
import 'monster_park_view.dart';
import 'hot_spring_view.dart';
import 'store_view.dart';
import '../LvTingIAP/EndMutableParameterStack.dart';

/// 旅館メイン画面 - コアインタラクションハブ
class HubView extends StatelessWidget {
  final GameState gameState;

  const HubView({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    // iOS 上部セーフエリア対応（ノッチ）
    final double topPadding = MediaQuery.of(context).padding.top;
    final Size size = MediaQuery.of(context).size;

    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('hub'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('hub'),
      child: Container(
        child: Stack(
          children: [
            // 1. 環境雰囲気背景層
            _buildAtmosphere(size),

            // 2. 左上：七日ログインエントリー
            _buildLoginBonusEntry(context, topPadding),

            // 3. 右側：機能メニューリスト
            _buildRightFunctionalMenu(context, topPadding),

            // 4. 中央：シーンインタラクションノード
            _buildCenterInteractionNodes(context, size),
          ],
        ),
      ),
    );
  }

  /// 背景雰囲気を構築
  Widget _buildAtmosphere(Size size) {
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: -40,
          child: Container(
            width: size.width * 1.5,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xff4a2e1b).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.5,
          left: -40,
          child: Container(
            width: size.width * 1.2,
            height: 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff412818), Color(0xff2b180d)],
              ),
              borderRadius: BorderRadius.circular(50),
              border: const Border(
                top: BorderSide(color: Color(0xff5d3b24), width: 4),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: size.width,
            height: size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff180e08), Color(0xff0a0502)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 七日ログインエントリー - 修正：markNeedsBuild で画面を更新
  Widget _buildLoginBonusEntry(BuildContext context, double topPadding) {
    return Positioned(
      top: topPadding + 70,
      left: 20,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LoginBonusView(gameState: gameState, onSave: () {}),
            ),
          ).then((_) {
            (context as Element).markNeedsBuild();
          });
        },
        child: Column(
          children: [
            _buildCircularIconButton(
              icon: Icons.event_available_rounded,
              color: const Color(0xff8c6751),
            ),
            const SizedBox(height: 8),
            _buildTagLabel('七日ログイン', isGold: true),
          ],
        ),
      ),
    );
  }

  /// 右側メニューリスト
  Widget _buildRightFunctionalMenu(BuildContext context, double topPadding) {
    return Positioned(
      top: topPadding + 76,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildMenuTile(
            icon: Icons.credit_card_rounded,
            label: '課金',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuantizationCustomSkewXImplement(
                  gameState: gameState,
                  onSave: () => (context as Element).markNeedsBuild(),
                ),
              ),
            ).then((_) => (context as Element).markNeedsBuild()),
          ),
          _buildMenuTile(
            icon: Icons.auto_graph_rounded,
            label: 'お知らせ',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PreviewView()),
            ),
          ),
          _buildMenuTile(
            icon: Icons.assignment_turned_in_rounded,
            label: 'クエスト',
            hasRedDot: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TasksView(
                  gameState: gameState,
                  onSave: () => (context as Element).markNeedsBuild(),
                ),
              ),
            ).then((_) => (context as Element).markNeedsBuild()),
          ),
          _buildMenuTile(
            icon: Icons.inventory_2_rounded,
            label: 'バックパック',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InventoryView(gameState: gameState),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 中央インタラクションノード - 遷移を追加
  Widget _buildCenterInteractionNodes(BuildContext context, Size size) {
    return Stack(
      children: [
        // 魔物遊園
        Positioned(
          top: size.height * 0.28,
          left: size.width / 2 - 40,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MonsterParkView(
                    gameState: gameState,
                    onSave: () => (context as Element).markNeedsBuild(),
                  ),
                ),
              );
            },
            child: _buildInteractionNode(
              icon: Icons.castle_rounded,
              label: '魔物遊園',
              glowColor: Colors.purpleAccent,
            ),
          ),
        ),
        // 温泉
        Positioned(
          top: size.height * 0.45,
          right: size.width * 0.15,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HotSpringView(
                    gameState: gameState,
                    onSave: () => (context as Element).markNeedsBuild(),
                  ),
                ),
              );
            },
            child: _buildInteractionNode(
              icon: Icons.hot_tub_rounded,
              label: '温泉',
              glowColor: Colors.blueAccent,
            ),
          ),
        ),
        // 商店 (Store)
        Positioned(
          bottom: size.height * 0.22,
          left: size.width * 0.2,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoreView(
                    gameState: gameState,
                    onSave: () => (context as Element).markNeedsBuild(),
                  ),
                ),
              );
            },
            child: _buildInteractionNode(
              icon: Icons.storefront_rounded,
              label: '商店',
              glowColor: Colors.orangeAccent,
            ),
          ),
        ),
      ],
    );
  }

  // --- UI コンポーネント ---

  Widget _buildCircularIconButton({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffc0997e), width: 2),
        gradient: const LinearGradient(
          colors: [Color(0xfffdf8f4), Color(0xffe8d2c1)],
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Icon(icon, color: color, size: 30),
    );
  }

  Widget _buildTagLabel(String text, {bool isGold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isGold ? Colors.amber.withValues(alpha: 0.5) : Colors.white10,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isGold ? Colors.amber : Colors.white70,
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool hasRedDot = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff5a3a29), Color(0xff402619)],
          ),
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(24),
          ),
          border: Border.all(color: const Color(0xff8a6a4b), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(-2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xffe2c7a8)),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xfff4ebd8),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            if (hasRedDot)
              Container(
                margin: const EdgeInsets.only(left: 6),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionNode({
    required IconData icon,
    required String label,
    required Color glowColor,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.4),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            Icon(icon, size: 44, color: Colors.white.withValues(alpha: 0.9)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xffefe2ce), Color(0xffd3bb9c)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xff8e6c49), width: 1.5),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xff5c3a21),
            ),
          ),
        ),
      ],
    );
  }
}
