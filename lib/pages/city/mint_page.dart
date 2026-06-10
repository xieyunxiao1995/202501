import 'package:flutter/material.dart';

/// 铸币司页面
///
/// 产出和收集金币。
class MintPage extends StatelessWidget {
  const MintPage({super.key});

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
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/city/zhubishi.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部面板
          Positioned(left: 0, right: 0, bottom: 0, child: _MintPanel()),
        ],
      ),
    );
  }
}

/// 铸币面板
class _MintPanel extends StatelessWidget {
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
          // ---- 标题 ----
          _PanelTitle(),
          const SizedBox(height: 12),

          // ---- 产出效率 ----
          const _EfficiencyRow(),
          const SizedBox(height: 14),

          // ---- 铜钱数量 ----
          _CoinAmount(),
          const SizedBox(height: 14),

          // ---- 数量滑块 ----
          _AmountSlider(),
          const SizedBox(height: 12),

          // ---- 消耗 & 铸造 ----
          _CostAndMint(),
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
        const Text(
          '铸币司',
          style: TextStyle(
            color: Color(0xFFE8D5A3),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        _goldLine(width: 40),
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

/// 产出效率行
class _EfficiencyRow extends StatelessWidget {
  const _EfficiencyRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '产出效率: ',
            style: TextStyle(color: Color(0x998B7E6A), fontSize: 13),
          ),
          Icon(Icons.schedule, size: 14, color: Color(0xFFD4A84B)),
          SizedBox(width: 4),
          Text(
            '1200/小时',
            style: TextStyle(
              color: Color(0xFFE8D5A3),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// 铜钱数量展示
class _CoinAmount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 铜钱图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x25D4A84B),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text('🪙', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '铜钱',
                style: TextStyle(
                  color: Color(0xFFE8D5A3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Text(
                    '12.5万',
                    style: TextStyle(
                      color: Color(0xFFE8D5A3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' / 12500',
                    style: TextStyle(color: Color(0x668B7E6A), fontSize: 14),
                  ),
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 最小按钮
        GestureDetector(
          onTap: () {
            // TODO: 设为最小值
          },
          child: Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x40D4A84B)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                '最小',
                style: TextStyle(color: Color(0x998B7E6A), fontSize: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 滑块
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
            child: const Slider(value: 0.5, onChanged: null),
          ),
        ),
        const SizedBox(width: 8),
        // 最大按钮
        GestureDetector(
          onTap: () {
            // TODO: 设为最大值
          },
          child: Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                '最大',
                style: TextStyle(
                  color: Color(0xFF1A1111),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 消耗 & 铸造按钮
class _CostAndMint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 消耗
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌾', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            const Text(
              '消耗粮食: ',
              style: TextStyle(color: Color(0x998B7E6A), fontSize: 13),
            ),
            const Text(
              '2.5万',
              style: TextStyle(
                color: Color(0xFFE8D5A3),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 铸造按钮
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: () {
              // TODO: 铸造逻辑
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A84B),
              foregroundColor: const Color(0xFF1A1111),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('铸  造'),
          ),
        ),
      ],
    );
  }
}
