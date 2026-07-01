import 'package:flutter/material.dart';

/// 铸币司页面
///
/// 产出和收集金币。
class MintPage extends StatefulWidget {
  const MintPage({super.key});

  @override
  State<MintPage> createState() => _MintPageState();
}

class _MintPageState extends State<MintPage> {
  int _coins = 125000; // 铜钱
  int _grain = 500000; // 粮食
  double _mintRatio = 0.5; // 铸造比例 0.0~1.0
  static const _maxGrainPerMint = 50000; // 单次最大消耗粮食
  static const _grainToCoinRate = 2; // 1粮食 = 2铜钱

  int get _grainCost => (_maxGrainPerMint * _mintRatio).round();
  int get _coinGain => _grainCost * _grainToCoinRate;

  void _setMin() {
    setState(() => _mintRatio = 0.0);
  }

  void _setMax() {
    setState(() => _mintRatio = 1.0);
  }

  void _mint() {
    if (_grainCost <= 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('请选择铸造数量'), duration: Duration(seconds: 1)));
      return;
    }
    if (_grain < _grainCost) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('粮食不足，无法铸造'), duration: Duration(seconds: 1)));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.monetization_on, color: Color(0xFFD4A84B)),
            SizedBox(width: 8),
            Text('确认铸造', style: TextStyle(color: Color(0xFFE8D5A3))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [const Text('消耗粮食: ', style: TextStyle(color: Color(0x998B7E6A))), Text('🌾 $_grainCost', style: const TextStyle(color: Color(0xFFA11717), fontWeight: FontWeight.bold))]),
            const SizedBox(height: 4),
            Row(children: [const Text('获得铜钱: ', style: TextStyle(color: Color(0x998B7E6A))), Text('🪙 $_coinGain', style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold))]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A84B), foregroundColor: const Color(0xFF1A1111)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _grain -= _grainCost;
                _coins += _coinGain;
              });
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('铸造完成！消耗粮食 $_grainCost，获得铜钱 $_coinGain'),
                  backgroundColor: const Color(0xFF4CAF50),
                  duration: const Duration(seconds: 2),
                ));
            },
            child: const Text('确认铸造'),
          ),
        ],
      ),
    );
  }

  void _collect() {
    // 一键领取产出的铜钱
    final gain = 1200;
    setState(() => _coins += gain);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('收取产出: 铜钱 +$gain'),
        backgroundColor: const Color(0xFFD4A84B),
        duration: const Duration(seconds: 1),
      ));
  }

  String _fmt(int n) {
    if (n >= 10000) return '${(n / 10000).toStringAsFixed(1)}万';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('铸币司'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/Bg/Bg12.png'), fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _MintPanel(
              coins: _coins,
              grain: _grain,
              mintRatio: _mintRatio,
              maxGrainPerMint: _maxGrainPerMint,
              grainCost: _grainCost,
              coinGain: _coinGain,
              canMint: _grainCost > 0 && _grain >= _grainCost,
              formatAmount: _fmt,
              onRatioChanged: (v) => setState(() => _mintRatio = v),
              onSetMin: _setMin,
              onSetMax: _setMax,
              onMint: _mint,
              onCollect: _collect,
            ),
          ),
        ],
      ),
    );
  }
}

/// 铸币面板
class _MintPanel extends StatelessWidget {
  const _MintPanel({
    required this.coins,
    required this.grain,
    required this.mintRatio,
    required this.maxGrainPerMint,
    required this.grainCost,
    required this.coinGain,
    required this.canMint,
    required this.formatAmount,
    required this.onRatioChanged,
    required this.onSetMin,
    required this.onSetMax,
    required this.onMint,
    required this.onCollect,
  });

  final int coins;
  final int grain;
  final double mintRatio;
  final int maxGrainPerMint;
  final int grainCost;
  final int coinGain;
  final bool canMint;
  final String Function(int) formatAmount;
  final ValueChanged<double> onRatioChanged;
  final VoidCallback onSetMin;
  final VoidCallback onSetMax;
  final VoidCallback onMint;
  final VoidCallback onCollect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xCC1A1111), Color(0xF21A1111)]),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: const Border(top: BorderSide(color: Color(0x40D4A84B), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PanelTitle(),
          const SizedBox(height: 12),
          _EfficiencyRow(),
          const SizedBox(height: 10),
          // 收取按钮
          GestureDetector(
            onTap: onCollect,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0x18D4A84B),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0x40D4A84B)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download, size: 16, color: Color(0xFFD4A84B)),
                  SizedBox(width: 6),
                  Text('收取产出', style: TextStyle(color: Color(0xFFD4A84B), fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _CoinAmount(coins: formatAmount(coins), grain: formatAmount(grain)),
          const SizedBox(height: 14),
          _AmountSlider(ratio: mintRatio, maxAmount: maxGrainPerMint, onChanged: onRatioChanged, onSetMin: onSetMin, onSetMax: onSetMax),
          const SizedBox(height: 12),
          _CostAndMint(grainCost: grainCost, coinGain: coinGain, canMint: canMint, onMint: onMint),
        ],
      ),
    );
  }
}

/// 面板标题
class _PanelTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _goldLine(width: 40),
        const SizedBox(width: 12),
        const Text('铸币司', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        _goldLine(width: 40),
      ],
    );
  }

  Widget _goldLine({required double width}) {
    return Container(
      width: width, height: 1.5,
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)])),
    );
  }
}

/// 产出效率行
class _EfficiencyRow extends StatelessWidget {
  const _EfficiencyRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(color: const Color(0x10D4A84B), borderRadius: BorderRadius.circular(6)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('产出效率: ', style: TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
          Icon(Icons.schedule, size: 14, color: Color(0xFFD4A84B)),
          SizedBox(width: 4),
          Text('1200/小时', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// 铜钱数量展示
class _CoinAmount extends StatelessWidget {
  const _CoinAmount({required this.coins, required this.grain});
  final String coins;
  final String grain;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0x10D4A84B), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0x18D4A84B))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: const Color(0x25D4A84B), borderRadius: BorderRadius.circular(20)),
                child: const Center(child: Text('🪙', style: TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('铜钱', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(coins, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: const Color(0x20D4A84B), borderRadius: BorderRadius.circular(20)),
                child: const Center(child: Text('🌾', style: TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('存粮', style: TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
                  Text(grain, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 数量滑块
class _AmountSlider extends StatelessWidget {
  const _AmountSlider({required this.ratio, required this.maxAmount, required this.onChanged, required this.onSetMin, required this.onSetMax});
  final double ratio;
  final int maxAmount;
  final ValueChanged<double> onChanged;
  final VoidCallback onSetMin;
  final VoidCallback onSetMax;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onSetMin,
          child: Container(
            width: 40, height: 30,
            decoration: BoxDecoration(border: Border.all(color: const Color(0x40D4A84B)), borderRadius: BorderRadius.circular(4)),
            child: const Center(child: Text('最小', style: TextStyle(color: Color(0x998B7E6A), fontSize: 10))),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              activeTrackColor: const Color(0xFFD4A84B),
              inactiveTrackColor: const Color(0x33FFFFFF),
              thumbColor: const Color(0xFFD4A84B),
              overlayColor: const Color(0x20D4A84B),
            ),
            child: Slider(value: ratio, onChanged: onChanged),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onSetMax,
          child: Container(
            width: 40, height: 30,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]), borderRadius: BorderRadius.all(Radius.circular(4))),
            child: const Center(child: Text('最大', style: TextStyle(color: Color(0xFF1A1111), fontSize: 10, fontWeight: FontWeight.bold))),
          ),
        ),
      ],
    );
  }
}

/// 消耗 & 铸造按钮
class _CostAndMint extends StatelessWidget {
  const _CostAndMint({required this.grainCost, required this.coinGain, required this.canMint, required this.onMint});
  final int grainCost;
  final int coinGain;
  final bool canMint;
  final VoidCallback onMint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌾', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            const Text('消耗粮食: ', style: TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
            Text('$grainCost', style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            const Icon(Icons.arrow_forward, size: 14, color: Color(0x998B7E6A)),
            const SizedBox(width: 4),
            const Text('获得铜钱: ', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 13)),
            Text('$coinGain', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: onMint,
            style: ElevatedButton.styleFrom(
              backgroundColor: canMint ? const Color(0xFFD4A84B) : const Color(0x30D4A84B),
              foregroundColor: canMint ? const Color(0xFF1A1111) : const Color(0x408B7E6A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              elevation: 0,
            ),
            child: const Text('铸  造'),
          ),
        ),
      ],
    );
  }
}
