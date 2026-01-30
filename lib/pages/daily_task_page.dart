import 'dart:async';
import 'package:flutter/material.dart';
import '../models/daily_task_model.dart';
import '../core/app_colors.dart';

class DailyTaskPage extends StatefulWidget {
  final DailyTaskManager taskManager;
  final Function(int) onClaimReward;

  const DailyTaskPage({
    super.key,
    required this.taskManager,
    required this.onClaimReward,
  });

  @override
  State<DailyTaskPage> createState() => _DailyTaskPageState();
}

class _DailyTaskPageState extends State<DailyTaskPage> {
  Timer? _timer;
  late DateTime _now;

  final List<Map<String, dynamic>> _rewards = [
    {'name': '灵石', 'amount': 1000, 'icon': 'assets/item/item1.jpeg'},
    {'name': '清心铃', 'amount': 10, 'icon': 'assets/item/item2.jpeg'},
    {'name': '碧玉佩', 'amount': 500, 'icon': 'assets/item/item3.jpeg'},
    {'name': '魂晶', 'amount': 200, 'icon': 'assets/item/item4.jpeg'},
    {'name': '混元珠', 'amount': 2880, 'icon': 'assets/item/item5.jpeg'},
    {'name': '仙豆', 'amount': 50, 'icon': 'assets/item/item6.jpeg'},
    {
      'name': '常羲',
      'amount': 1,
      'icon': 'assets/role/Role14.png',
      'isRole': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getTimeUntilNextDay() {
    final tomorrow = DateTime(_now.year, _now.month, _now.day + 1);
    final difference = tomorrow.difference(_now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}时${minutes.toString().padLeft(2, '0')}分${seconds.toString().padLeft(2, '0')}秒';
  }

  void _handleSignIn() {
    if (widget.taskManager.canSignIn()) {
      setState(() {
        widget.taskManager.signIn();
      });
      // 自动领取当天的奖励
      _handleClaimReward(widget.taskManager.signInDays - 1);
    }
  }

  void _handleClaimReward(int index) {
    if (widget.taskManager.claimSignInReward(index)) {
      setState(() {});

      final reward = _rewards[index];
      if (reward['name'] == '灵石' || reward['name'] == '灵气') {
        widget.onClaimReward(reward['amount']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '成功领取第 ${index + 1} 天奖励：${reward['name']} x${reward['amount']}',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2A2D3E), Color(0xFF161925)],
              ),
            ),
          ),

          // 角色展示区 (左侧)
          Positioned(
            left: -50,
            bottom: 0,
            top: 120, // 从 50 移动到 120，避开返回键
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/role/Role14.png',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),

          // 装饰性元素 - 底部光效
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // 主内容区
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Row(
                    children: [
                      // 左侧留白给角色
                      const Expanded(flex: 4, child: SizedBox()),
                      // 右侧奖励列表
                      Expanded(flex: 6, child: _buildRewardList()),
                    ],
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),

          // 顶部文字
          Positioned(
            top: 100, // 从 60 移动到 100
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '签到',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 10),
                        ],
                      ),
                    ),
                    Text(
                      '${widget.taskManager.signInDays}天',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                const Text(
                  '送SSR+辅助异灵',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 5)],
                  ),
                ),
              ],
            ),
          ),

          // 角色标签
          Positioned(
            top: 200, // 从 160 移动到 200
            left: 20,
            child: _buildRoleLabel(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black26,
              padding: const EdgeInsets.all(8),
            ),
          ),
          IconButton(
            onPressed: () {
              // 显示规则说明
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF2A2D3E),
                  title: const Text(
                    '签到规则',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    '1. 每日可签到一次，领取当日奖励。\n'
                    '2. 累计签到满7天可获得SSR+异灵【常羲】。\n'
                    '3. 签到满7天后将重置签到进度。',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        '知道了',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.help_outline,
              color: Colors.white70,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'SSR+',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.water_drop, color: Colors.blue, size: 20),
            const SizedBox(width: 4),
            const Text(
              '常羲',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '辅助',
                style: TextStyle(color: Colors.amber, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(
            5,
            (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardList() {
    return ListView.builder(
      padding: const EdgeInsets.only(right: 16, top: 20, bottom: 20),
      itemCount: _rewards.length,
      itemBuilder: (context, index) {
        final isToday = index == widget.taskManager.signInDays;
        final isLocked = index > widget.taskManager.signInDays;

        // 增加越界保护
        final isClaimed = index < widget.taskManager.claimedRewards.length
            ? widget.taskManager.claimedRewards[index]
            : false;

        final isPast = index < widget.taskManager.signInDays;

        return _buildRewardItem(index, isToday, isLocked, isClaimed, isPast);
      },
    );
  }

  Widget _buildRewardItem(
    int index,
    bool isToday,
    bool isLocked,
    bool isClaimed,
    bool isPast,
  ) {
    final reward = _rewards[index];

    return GestureDetector(
      onTap: isToday && widget.taskManager.canSignIn()
          ? _handleSignIn
          : (isPast && !isClaimed ? () => _handleClaimReward(index) : null),
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isToday
                ? [
                    const Color(0xFFF9D423).withOpacity(0.3),
                    const Color(0xFFFF4E50).withOpacity(0.3),
                  ]
                : isLocked
                ? [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.1),
                  ]
                : [
                    const Color(0xFF43E97B).withOpacity(0.2),
                    const Color(0xFF38F9D7).withOpacity(0.2),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isToday
                ? Colors.amber.withOpacity(0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: isToday ? 2 : 1,
          ),
          boxShadow: isToday
              ? [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '第 ${index + 1} 天',
                        style: TextStyle(
                          color: isToday ? Colors.amber : Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isToday)
                        Text(
                          _getTimeUntilNextDay(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          reward['icon'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'x${reward['amount']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isClaimed)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                ),
              ),
            if (isLocked)
              Positioned(
                right: 8,
                top: 8,
                child: Icon(
                  Icons.lock,
                  color: Colors.white.withOpacity(0.3),
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final canSignIn = widget.taskManager.canSignIn();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ElevatedButton(
          onPressed: canSignIn ? _handleSignIn : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            disabledBackgroundColor: Colors.grey.withOpacity(0.3),
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 10,
            shadowColor: Colors.amber.withOpacity(0.5),
          ),
          child: Text(
            canSignIn ? '立即签到' : '明日再来',
            style: TextStyle(
              color: canSignIn ? Colors.black : Colors.white54,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
