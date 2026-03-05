import 'package:flutter/material.dart';
import 'dart:ui';
import '../state/game_state.dart';
import '../widgets/game_background.dart';

class LoginBonusView extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onSave;

  const LoginBonusView({
    super.key,
    required this.gameState,
    required this.onSave,
  });

  @override
  State<LoginBonusView> createState() => _LoginBonusViewState();
}

class _LoginBonusViewState extends State<LoginBonusView> {
  // 報酬設定：色と説明を含む
  final List<Map<String, dynamic>> _rewards = [
    {
      'day': 1,
      'type': 'ゴールド',
      'amount': 2000,
      'icon': Icons.monetization_on,
      'color': Colors.amber,
    },
    {
      'day': 2,
      'type': '経験値',
      'amount': 5000,
      'icon': Icons.auto_awesome,
      'color': Colors.blueAccent,
    },
    {
      'day': 3,
      'type': '普通券',
      'amount': 2,
      'icon': Icons.confirmation_number,
      'color': Colors.purpleAccent,
    },
    {
      'day': 4,
      'type': 'ゴールド',
      'amount': 10000,
      'icon': Icons.monetization_on,
      'color': Colors.amber,
    },
    {
      'day': 5,
      'type': '経験値',
      'amount': 20000,
      'icon': Icons.auto_awesome,
      'color': Colors.blueAccent,
    },
    {
      'day': 6,
      'type': '高級券',
      'amount': 1,
      'icon': Icons.stars,
      'color': Colors.orangeAccent,
    },
    {
      'day': 7,
      'type': 'UR 断片',
      'amount': 20,
      'icon': Icons.diamond,
      'color': Colors.redAccent,
    },
  ];

  // 現在の進行状況をシミュレート (実際は gameState または LocalStorage に記録)
  int _currentDay = 1;
  bool _claimedToday = false;

  void _claimReward(int index) {
    int day = index + 1;
    if (day == _currentDay && !_claimedToday) {
      setState(() {
        _claimedToday = true;
        final reward = _rewards[index];
        // 報酬付与ロジック
        if (reward['type'] == 'ゴールド') widget.gameState.addGold(reward['amount']);
        if (reward['type'] == '経験値') widget.gameState.addExp(reward['amount']);
      });
      widget.onSave();
      _showRewardAnim(index);
    } else if (day < _currentDay || (day == _currentDay && _claimedToday)) {
      _showToast("報酬はすでに受け取っています");
    } else {
      _showToast("明日の補給をお待ちください");
    }
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
        width: 200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _showRewardAnim(int index) {
    final reward = _rewards[index];
    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (c, val, child) => Transform.scale(
              scale: val,
              child: AlertDialog(
                backgroundColor: const Color(0xff1e1b4b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.amber, width: 2),
                ),
                title: const Text(
                  'おめでとう',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.amber),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(reward['icon'], size: 80, color: reward['color']),
                    const SizedBox(height: 16),
                    Text(
                      '${reward['type']} x${reward['amount']}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'ギフトを受け取る',
                        style: TextStyle(color: Colors.amber, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('login_bonus'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('login_bonus'),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // ぼかしレイヤー
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black12),
                ),
              ),
            ),
            Center(child: _buildDialogContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogContent() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xff1a1c23),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildRewardsGrid(),
          const SizedBox(height: 30),
          _buildActionBtn(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(Icons.card_giftcard_rounded, color: Colors.amber, size: 48),
        const SizedBox(height: 12),
        const Text(
          '七日ログインボーナス',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '連続ログインで伝説報酬をアンロック',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildRewardsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: 7,
      itemBuilder: (context, i) {
        bool isPast = i + 1 < _currentDay;
        bool isToday = i + 1 == _currentDay;
        bool isClaimed = isPast || (isToday && _claimedToday);
        final reward = _rewards[i];

        return GestureDetector(
          onTap: () => _claimReward(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isToday
                  ? Colors.amber.withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isToday
                    ? Colors.amber
                    : (isClaimed ? Colors.white10 : Colors.white24),
                width: isToday ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Day ${i + 1}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.amber : Colors.white54,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  reward['icon'],
                  color: isClaimed ? Colors.grey : reward['color'],
                  size: 30,
                ),
                const SizedBox(height: 6),
                Text(
                  reward['amount'].toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isClaimed ? Colors.grey : Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (isClaimed)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionBtn() {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: const Text(
        '確定',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
