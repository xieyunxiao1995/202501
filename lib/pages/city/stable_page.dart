import 'package:flutter/material.dart';

/// 马匹数据
class _Horse {
  _Horse({
    required this.name,
    required this.icon,
    required this.level,
    required this.bonusLabel,
    required this.bonusPerLevel,
    required this.trainCost,
  });

  final String name;
  final String icon;
  int level;
  final String bonusLabel;
  final int bonusPerLevel;
  final int trainCost;

  int get bonusValue => level * bonusPerLevel;
  String get bonus => '$bonusLabel +${bonusValue}%';
}

/// 马厩页面
///
/// 培养战马，提升坐骑属性。
class StablePage extends StatefulWidget {
  const StablePage({super.key});

  @override
  State<StablePage> createState() => _StablePageState();
}

class _StablePageState extends State<StablePage> {
  int _food = 200000;

  late final List<_Horse> _horses;

  static const _allHorses = [
    {'name': '赤兔马', 'icon': '🐴', 'bonus': '速度', 'desc': '千里马之王，日行千里'},
    {'name': '的卢马', 'icon': '🐎', 'bonus': '闪避', 'desc': '跃马檀溪，救主神驹'},
    {'name': '爪黄飞电', 'icon': '🦄', 'bonus': '攻击', 'desc': '曹操爱马，迅捷如电'},
    {'name': '绝影', 'icon': '🏇', 'bonus': '暴击', 'desc': '大宛名马，无影无踪'},
    {'name': '乌云踏雪', 'icon': '🐃', 'bonus': '防御', 'desc': '张飞坐骑，通体乌黑'},
    {'name': '照夜玉狮子', 'icon': '🦓', 'bonus': '闪避', 'desc': '赵云坐骑，通体雪白'},
  ];

  @override
  void initState() {
    super.initState();
    _horses = [
      _Horse(name: '赤兔马', icon: '🐴', level: 20, bonusLabel: '速度', bonusPerLevel: 1, trainCost: 5000),
      _Horse(name: '的卢马', icon: '🐎', level: 15, bonusLabel: '闪避', bonusPerLevel: 1, trainCost: 4000),
      _Horse(name: '爪黄飞电', icon: '🦄', level: 12, bonusLabel: '攻击', bonusPerLevel: 1, trainCost: 3500),
      _Horse(name: '绝影', icon: '🏇', level: 10, bonusLabel: '暴击', bonusPerLevel: 1, trainCost: 3000),
    ];
  }

  void _train(int index) {
    final horse = _horses[index];
    if (_food < horse.trainCost) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('粮草不足，无法培养'), duration: Duration(seconds: 1)));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Text(horse.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text('培养 ${horse.name}', style: const TextStyle(color: Color(0xFFE8D5A3))),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('消耗粮草 ${horse.trainCost} 提升 ${horse.name} 等级', style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
            const SizedBox(height: 8),
            Text('Lv.${horse.level} → Lv.${horse.level + 1}', style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${horse.bonusLabel}: +${horse.bonusValue}% → +${horse.bonusValue + horse.bonusPerLevel}%', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A84B), foregroundColor: const Color(0xFF1A1111)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _food -= horse.trainCost;
                horse.level++;
              });
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('${horse.name} 升至 Lv.${horse.level}！'), backgroundColor: const Color(0xFF4CAF50), duration: const Duration(seconds: 1)));
            },
            child: const Text('确认培养'),
          ),
        ],
      ),
    );
  }

  void _showRules() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [Icon(Icons.info_outline, color: Color(0xFFD4A84B), size: 22), SizedBox(width: 8), Text('马厩规则', style: TextStyle(color: Color(0xFFE8D5A3)))]),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RuleItem(icon: '🐴', text: '每种战马提供不同的属性加成'),
            SizedBox(height: 8),
            _RuleItem(icon: '📈', text: '消耗粮草可培养战马，每级提升 1% 属性加成'),
            SizedBox(height: 8),
            _RuleItem(icon: '🏪', text: '马匹商店可购买稀有战马'),
            SizedBox(height: 8),
            _RuleItem(icon: '📖', text: '图鉴中可查看所有战马信息'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('知道了', style: TextStyle(color: Color(0xFFD4A84B))))],
      ),
    );
  }

  void _showAlbum() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [Icon(Icons.book, color: Color(0xFFD4A84B), size: 22), SizedBox(width: 8), Text('马匹图鉴', style: TextStyle(color: Color(0xFFE8D5A3)))]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _allHorses.map((h) {
            final owned = _horses.any((oh) => oh.name == h['name']);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: owned ? const Color(0x104CAF50) : const Color(0x08FFFFFF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: owned ? const Color(0x204CAF50) : const Color(0x10FFFFFF)),
                ),
                child: Row(children: [
                  Text(h['icon'] as String, style: TextStyle(fontSize: 24, color: owned ? null : Colors.grey.withAlpha(80))),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(h['name'] as String, style: TextStyle(color: owned ? const Color(0xFFE8D5A3) : const Color(0x558B7E6A), fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(h['desc'] as String, style: TextStyle(color: owned ? const Color(0x998B7E6A) : const Color(0x308B7E6A), fontSize: 11)),
                  ])),
                  Text(owned ? '已拥有' : '未获得', style: TextStyle(color: owned ? const Color(0xFF4CAF50) : const Color(0x408B7E6A), fontSize: 11)),
                ]),
              ),
            );
          }).toList(),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('关闭', style: TextStyle(color: Color(0xFFD4A84B))))],
      ),
    );
  }

  void _showShop() {
    final available = _allHorses.where((h) => !_horses.any((oh) => oh.name == h['name'])).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [Icon(Icons.store, color: Color(0xFFD4A84B), size: 22), SizedBox(width: 8), Text('马匹商店', style: TextStyle(color: Color(0xFFE8D5A3)))]),
        content: available.isEmpty
            ? const Text('你已经拥有所有马匹！', style: TextStyle(color: Color(0x668B7E6A)))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: available.map((h) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _horses.add(_Horse(name: h['name'] as String, icon: h['icon'] as String, level: 1, bonusLabel: h['bonus'] as String, bonusPerLevel: 1, trainCost: 2000));
                        });
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text('获得战马: ${h['name']}！'), backgroundColor: const Color(0xFFD4A84B), duration: const Duration(seconds: 1)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0x10D4A84B), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0x20D4A84B))),
                        child: Row(children: [
                          Text(h['icon'] as String, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          Expanded(child: Text(h['name'] as String, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14, fontWeight: FontWeight.bold))),
                          const Text('💎 200', style: TextStyle(color: Color(0xFFD4A84B), fontSize: 13, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                  );
                }).toList(),
              ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('关闭', style: TextStyle(color: Color(0xFFD4A84B))))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('马厩'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('🌾', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text('${_food ~/ 10000}万', style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 13, fontWeight: FontWeight.bold)),
            ]),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/city/majiu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部面板
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StablePanel(
              horses: _horses,
              onTrain: _train,
              onRules: _showRules,
              onAlbum: _showAlbum,
              onShop: _showShop,
            ),
          ),
        ],
      ),
    );
  }
}

/// 马厩面板
class _StablePanel extends StatelessWidget {
  const _StablePanel({
    required this.horses,
    required this.onTrain,
    required this.onRules,
    required this.onAlbum,
    required this.onShop,
  });

  final List<_Horse> horses;
  final ValueChanged<int> onTrain;
  final VoidCallback onRules;
  final VoidCallback onAlbum;
  final VoidCallback onShop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC1A1111), Color(0xF21A1111)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: const Border(
          top: BorderSide(color: Color(0x40D4A84B), width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PanelHeader(onRules: onRules),
          const SizedBox(height: 14),
          ...horses.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _HorseItem(
                    name: e.value.name,
                    icon: e.value.icon,
                    level: e.value.level,
                    bonus: e.value.bonus,
                    onTap: () => onTrain(e.key),
                  ),
                ),
              ),
          const SizedBox(height: 14),
          _BottomActions(onAlbum: onAlbum, onShop: onShop),
        ],
      ),
    );
  }
}

/// 面板标题
class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.onRules});
  final VoidCallback onRules;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _goldLine(width: 30),
            const SizedBox(width: 10),
            const Text(
              '马厩',
              style: TextStyle(
                color: Color(0xFFE8D5A3),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            _goldLine(width: 30),
          ],
        ),
        GestureDetector(
          onTap: onRules,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x60D4A84B)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '规则说明',
              style: TextStyle(color: Color(0xCCD4A84B), fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _goldLine({required double width}) {
    return Container(
      width: width,
      height: 1.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)],
        ),
      ),
    );
  }
}

/// 单个马匹条目
class _HorseItem extends StatelessWidget {
  const _HorseItem({
    required this.name,
    required this.icon,
    required this.level,
    required this.bonus,
    required this.onTap,
  });
  final String name;
  final String icon;
  final int level;
  final String bonus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x10D4A84B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x18D4A84B)),
        ),
        child: Row(
          children: [
            // 马匹头像
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0x20D4A84B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 10),
            // 名称 / 等级 / 加成
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xFFE8D5A3),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x30D4A84B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0x40D4A84B)),
                        ),
                        child: Text(
                          'Lv.$level',
                          style: const TextStyle(
                            color: Color(0xFFD4A84B),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bonus,
                    style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // 培养按钮
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: const Text(
                  '培养',
                  style: TextStyle(
                    color: Color(0xFF1A1111),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部双按钮
class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.onAlbum, required this.onShop});
  final VoidCallback onAlbum;
  final VoidCallback onShop;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onAlbum,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x40D4A84B)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '马匹图鉴',
                  style: TextStyle(
                    color: Color(0xCCD4A84B),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onShop,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '马匹商店',
                  style: TextStyle(
                    color: Color(0xFF1A1111),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }
}
