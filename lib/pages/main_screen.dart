import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_colors.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';
import '../models/beast_model.dart';
import '../models/achievement_model.dart';
import '../models/item_model.dart';
import '../models/daily_task_model.dart';
import '../models/tribe_model.dart';
import 'explore_page.dart';
import 'beast_list_page.dart';
import 'forge_page.dart';
import 'battle_page.dart';
import 'tribe_page.dart';
import 'evolution_page.dart';
import 'achievement_page.dart';
import 'inventory_page.dart';
import 'daily_task_page.dart';
import 'leaderboard_page.dart';
import 'settings_page.dart';
import 'collection_page.dart';
import 'beginner_gift_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  // 全局状态
  int _spirit = 12450; // 灵气
  int _flesh = 840; // 血食
  List<Beast> _beasts = [];

  // 新增系统状态
  Inventory _inventory = Inventory();
  AchievementStats _achievementStats = AchievementStats();
  DailyTaskManager _dailyTaskManager = DailyTaskManager();
  TribeData _tribeData = TribeData.initial();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _spirit = prefs.getInt('spirit') ?? 12450;
      _flesh = prefs.getInt('flesh') ?? 840;

      final String? beastsJson = prefs.getString('beasts');
      if (beastsJson != null) {
        final List<dynamic> decoded = jsonDecode(beastsJson);
        _beasts = decoded.map((item) => Beast.fromJson(item)).toList();
      } else {
        // 初始异兽
        _beasts = initialBeasts.map((item) => Beast.fromJson(item)).toList();
      }

      // 加载背包数据
      final String? inventoryJson = prefs.getString('inventory');
      if (inventoryJson != null) {
        _inventory = Inventory.fromJson(jsonDecode(inventoryJson));
      }

      // 加载成就数据
      final String? achievementJson = prefs.getString('achievementStats');
      if (achievementJson != null) {
        _achievementStats = AchievementStats.fromJson(
          jsonDecode(achievementJson),
        );
      } else {
        _achievementStats = AchievementStats(
          beastsCollected: _beasts.length,
          totemLevel: prefs.getInt('totemLevel') ?? 1,
        );
      }

      // 加载每日任务数据
      final String? dailyTaskJson = prefs.getString('dailyTaskManager');
      if (dailyTaskJson != null) {
        _dailyTaskManager = DailyTaskManager.fromJson(
          jsonDecode(dailyTaskJson),
        );
      }

      // 加载部落数据
      final String? tribeJson = prefs.getString('tribeData');
      if (tribeJson != null) {
        _tribeData = TribeData.fromJson(jsonDecode(tribeJson));
      } else {
        // 兼容旧版本的 totemLevel
        _tribeData = TribeData.initial();
        _tribeData.level = prefs.getInt('totemLevel') ?? 1;
      }

      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('spirit', _spirit);
    await prefs.setInt('flesh', _flesh);
    await prefs.setInt('totemLevel', _tribeData.level);
    await prefs.setString(
      'beasts',
      jsonEncode(_beasts.map((b) => b.toJson()).toList()),
    );

    // 保存背包数据
    await prefs.setString('inventory', jsonEncode(_inventory.toJson()));

    // 保存成就数据
    await prefs.setString(
      'achievementStats',
      jsonEncode(_achievementStats.toJson()),
    );

    // 保存每日任务数据
    await prefs.setString(
      'dailyTaskManager',
      jsonEncode(_dailyTaskManager.toJson()),
    );

    // 保存部落数据
    await prefs.setString('tribeData', jsonEncode(_tribeData.toJson()));
  }

  void _updateResource(int spiritChange, int fleshChange) {
    setState(() {
      _spirit += spiritChange;
      _flesh += fleshChange;
    });
    _saveData();
  }

  void _addBeast(Beast beast) {
    setState(() {
      _beasts.add(beast);
    });
    _saveData();
  }

  void _removeBeast(String id) {
    setState(() {
      _beasts.removeWhere((b) => b.id == id);
    });
    _saveData();
  }

  void _updateBeast(Beast beast) {
    setState(() {
      final index = _beasts.indexWhere((b) => b.id == beast.id);
      if (index != -1) {
        _beasts[index] = beast;
      }
    });
    _saveData();
  }

  void _upgradeTotem() {
    final cost = _tribeData.upgradeCost;
    if (_spirit >= cost) {
      setState(() {
        _spirit -= cost;
        _tribeData.upgradeLevel();
      });
      _saveData();
      _showSnack("部落图腾升级成功！当前等级: ${_tribeData.level}");
    } else {
      _showSnack("灵气不足，无法升级图腾！");
    }
  }

  void _upgradeBlessing(String id) {
    final blessing = _tribeData.blessings.firstWhere((b) => b.id == id);
    if (_spirit >= blessing.cost) {
      setState(() {
        _spirit -= blessing.cost;
        blessing.upgrade();
      });
      _saveData();
      _showSnack("${blessing.name} 提升至 Lv.${blessing.level}");
    } else {
      _showSnack("灵气不足，无法提升赐福！");
    }
  }

  void _buyEgg() {
    if (_spirit >= 1000) {
      setState(() {
        _spirit -= 1000;
        final newBeast = Beast.generateRandom(tier: "百年");
        _beasts.add(newBeast);
      });
      _saveData();
      _showSnack("孵化成功！获得了一只 [${_beasts.last.name}]");
    } else {
      _showSnack("灵气不足！");
    }
  }

  void _healBeasts() {
    if (_spirit >= 50) {
      setState(() {
        _spirit -= 50;
        for (var b in _beasts) {
          b.stats.hp += 100; // 简单回血
        }
      });
      _saveData();
      _showSnack("全军状态已恢复！");
    } else {
      _showSnack("灵气不足！");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMainMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // 改为透明以配合圆角
      isScrollControlled: true, // 允许自适应高度
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          20 + MediaQuery.of(context).padding.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部指示条
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildMenuTile(
                icon: Icons.trending_up,
                color: AppColors.primary,
                title: '进化',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EvolutionPage(
                        beasts: _beasts,
                        spirit: _spirit,
                        flesh: _flesh,
                        onEvolve: (beast) {
                          _updateBeast(beast);
                          _showSnack('进化成功！');
                        },
                        onResourceChange: (spirit, flesh) {
                          _updateResource(spirit - _spirit, flesh - _flesh);
                        },
                      ),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                icon: Icons.auto_stories,
                color: Colors.deepOrangeAccent,
                title: '图鉴',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CollectionPage(),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                icon: Icons.emoji_events,
                color: Colors.amber,
                title: '成就',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AchievementPage(
                        stats: _achievementStats,
                        onClaimReward: (reward) {
                          setState(() {
                            _spirit += reward;
                          });
                          _saveData();
                        },
                        onClaimAchievement: (id) {
                          setState(() {
                            _achievementStats.claimedAchievements.add(id);
                          });
                          _saveData();
                        },
                      ),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                icon: Icons.backpack,
                color: Colors.green,
                title: '背包',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InventoryPage(
                        inventory: _inventory,
                        beasts: _beasts,
                        onUpdateInventory: (inventory) {
                          setState(() {
                            _inventory = inventory;
                          });
                          _saveData();
                        },
                      ),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                icon: Icons.card_giftcard,
                color: Colors.redAccent,
                title: '福利',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BeginnerGiftPage(),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                icon: Icons.task,
                color: Colors.blue,
                title: '任务',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyTaskPage(
                        taskManager: _dailyTaskManager,
                        onClaimReward: (reward) {
                          setState(() {
                            _spirit += reward;
                          });
                          _saveData();
                        },
                      ),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                icon: Icons.leaderboard,
                color: Colors.purple,
                title: '排行榜',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardPage(),
                    ),
                  );
                },
              ),
              _buildMenuTile(
                icon: Icons.settings,
                color: AppColors.textSub,
                title: '设置',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSub,
            size: 20,
          ),
          onTap: onTap,
        ),
        Divider(color: Colors.white.withOpacity(0.05), height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final pages = [
      ExplorePage(
        onResourceGain: _updateResource,
        onBeastFound: _addBeast,
        tribeData: _tribeData,
      ),
      BeastListPage(
        beasts: _beasts,
        onUpdateBeast: _updateBeast, // 传递更新函数
      ),
      ForgePage(
        spirit: _spirit,
        beasts: _beasts,
        tribeData: _tribeData,
        onUpdateBeast: _updateBeast,
        onRemoveBeast: _removeBeast,
        onUpdateResource: _updateResource,
      ),
      BattlePage(
        beasts: _beasts,
        tribeData: _tribeData,
        onReward: _updateResource,
      ),
      TribePage(
        spirit: _spirit,
        tribeData: _tribeData,
        onUpgrade: _upgradeTotem,
        onUpgradeBlessing: _upgradeBlessing,
        onBuyEgg: _buyEgg,
        onHeal: _healBeasts,
      ),
    ];

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildResourceHeader(),
              Expanded(
                child: IndexedStack(index: _currentIndex, children: pages),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.95),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.map_outlined, '山海', 0),
              _buildNavItem(Icons.catching_pokemon, '异兽', 1),
              _buildForgeNavItem(),
              _buildNavItem(Icons.flash_on, '征伐', 3),
              _buildNavItem(Icons.auto_awesome, '部落', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildResChip(
                    Icons.bolt,
                    _spirit.toString(),
                    AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  _buildResChip(
                    Icons.water_drop,
                    _flesh.toString(),
                    AppColors.danger,
                  ),
                  const SizedBox(width: 8),
                  _buildResChip(
                    Icons.backpack,
                    '${_inventory.itemCount}',
                    AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "图腾 Lv.${_tribeData.level}",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                onPressed: _showMainMenu,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResChip(IconData icon, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            val,
            style: TextStyle(
              color: color.withOpacity(0.9),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.secondary : AppColors.textSub,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.secondary : AppColors.textSub,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgeNavItem() {
    final isSelected = _currentIndex == 2;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Transform.translate(
        offset: const Offset(0, -15),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.danger, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : AppColors.card,
            border: Border.all(color: AppColors.bg, width: 4),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.danger.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.local_fire_department,
            color: isSelected ? Colors.white : AppColors.textSub,
            size: 28,
          ),
        ),
      ),
    );
  }
}
