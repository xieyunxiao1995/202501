import 'package:flutter/material.dart';
import '../models/beast_model.dart';
import '../models/evolution_model.dart';
import '../core/app_colors.dart';

class EvolutionPage extends StatefulWidget {
  final List<Beast> beasts;
  final int spirit;
  final int flesh;
  final Function(Beast) onEvolve;
  final Function(int, int) onResourceChange;

  const EvolutionPage({
    super.key,
    required this.beasts,
    required this.spirit,
    required this.flesh,
    required this.onEvolve,
    required this.onResourceChange,
  });

  @override
  State<EvolutionPage> createState() => _EvolutionPageState();
}

class _EvolutionPageState extends State<EvolutionPage>
    with SingleTickerProviderStateMixin {
  Beast? selectedBeast;
  EvolutionPath? selectedPath;
  bool isEvolving = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startEvolution() {
    if (selectedBeast == null) return;

    final nextTier = _getNextTier(selectedBeast!.tier);
    final availablePath =
        EvolutionPath.paths['${selectedBeast!.tier}_to_$nextTier'];

    if (availablePath == null) return;

    final requirement = availablePath.stages.first;
    if (!requirement.canEvolve(selectedBeast!, widget.spirit, widget.flesh)) {
      _showSnackBar('资源或条件不足', Colors.red);
      return;
    }

    setState(() {
      isEvolving = true;
    });
    _animationController.forward();

    widget.onResourceChange(
      widget.spirit - requirement.spiritCost,
      widget.flesh - requirement.fleshCost,
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      final evolvedBeast = Beast(
        id: selectedBeast!.id,
        name: selectedBeast!.name,
        tier: availablePath.toTier,
        parts: List.from(selectedBeast!.parts),
        stats: selectedBeast!.stats.copyWith(
          hp: (selectedBeast!.stats.hp * 1.5).toInt(),
          atk: (selectedBeast!.stats.atk * 1.5).toInt(),
          def: (selectedBeast!.stats.def * 1.5).toInt(),
          spd: (selectedBeast!.stats.spd * 1.5).toInt(),
        ),
        description: '经过进化，${selectedBeast!.name}的力量得到了质的飞跃！',
        isLocked: selectedBeast!.isLocked,
      );

      widget.onEvolve(evolvedBeast);
      _animationController.reset();
      setState(() {
        isEvolving = false;
        selectedBeast = null;
        selectedPath = null;
      });
      _showSnackBar('进化成功！', Colors.green);
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          '灵兽境界突破',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildResourceHeader(),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(width: 160, child: _buildBeastList()),
                    Expanded(child: _buildEvolutionPanel()),
                  ],
                ),
              ),
            ],
          ),
          if (isEvolving) _buildEvolutionAnimation(),
        ],
      ),
    );
  }

  Widget _buildResourceHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildResourceItem(
            '灵气',
            widget.spirit,
            Icons.blur_circular,
            Colors.cyan,
          ),
          const SizedBox(width: 24),
          _buildResourceItem(
            '血食',
            widget.flesh,
            Icons.restaurant,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(
    String label,
    int value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 8),
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeastList() {
    final evolvableBeasts = widget.beasts
        .where((beast) => beast.tier == '百年' || beast.tier == '千年')
        .toList();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(right: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '灵兽选择',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '选择符合条件的异兽进行进化',
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: evolvableBeasts.length,
              itemBuilder: (context, index) {
                final beast = evolvableBeasts[index];
                final isSelected = selectedBeast?.id == beast.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBeast = beast;
                      selectedPath = null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              beast.name,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getTierColor(
                                  beast.tier,
                                ).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                beast.tier,
                                style: TextStyle(
                                  color: _getTierColor(beast.tier),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.flash_on,
                              size: 12,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '战力: ${beast.stats.totalScore}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvolutionPanel() {
    if (selectedBeast == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            const Text(
              '请从左侧选择需要进化的异兽',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      );
    }

    final nextTier = _getNextTier(selectedBeast!.tier);
    final availablePath =
        EvolutionPath.paths['${selectedBeast!.tier}_to_$nextTier'];

    if (availablePath == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              '${selectedBeast!.name} 已达至尊境界',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '当前阶位已无可再进之路',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      );
    }

    final requirement = availablePath.stages.first;
    final canEvolve = requirement.canEvolve(
      selectedBeast!,
      widget.spirit,
      widget.flesh,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildEvolutionVisual(selectedBeast!, nextTier),
                  const SizedBox(height: 32),
                  _buildStatComparison(selectedBeast!, nextTier),
                  const SizedBox(height: 32),
                  _buildRequirements(requirement),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildEvolveButton(canEvolve),
        ],
      ),
    );
  }

  Widget _buildEvolutionVisual(Beast beast, String nextTier) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBeastAvatar(beast, beast.tier),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Icon(
                  Icons.keyboard_double_arrow_right,
                  color: AppColors.primary,
                  size: 24,
                ),
                Text(
                  '境界突破',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildBeastAvatar(beast, nextTier, isPreview: true),
        ],
      ),
    );
  }

  Widget _buildBeastAvatar(Beast beast, String tier, {bool isPreview = false}) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _getTierColor(tier), width: 2),
            boxShadow: [
              BoxShadow(
                color: _getTierColor(tier).withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.pets,
              size: 40,
              color: isPreview
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isPreview ? '未知灵化' : beast.name,
          style: TextStyle(
            color: isPreview ? Colors.white70 : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getTierColor(tier).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tier,
            style: TextStyle(
              color: _getTierColor(tier),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatComparison(Beast beast, String nextTier) {
    final oldStats = beast.stats;
    // 模拟进化后的属性提升 (1.5倍)
    final newStats = {
      '生命': [oldStats.hp, (oldStats.hp * 1.5).toInt()],
      '攻击': [oldStats.atk, (oldStats.atk * 1.5).toInt()],
      '防御': [oldStats.def, (oldStats.def * 1.5).toInt()],
      '速度': [oldStats.spd, (oldStats.spd * 1.5).toInt()],
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.query_stats, color: Colors.amber, size: 18),
              SizedBox(width: 8),
              Text(
                '属性成长预测',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...newStats.entries.map(
            (e) => _buildStatCompareRow(e.key, e.value[0], e.value[1]),
          ),
          const Divider(color: Colors.white10, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '预期评分提升',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                '+${((oldStats.totalScore * 1.5) - oldStats.totalScore).toInt()}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCompareRow(String label, int oldVal, int newVal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.6, // 简化显示
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            oldVal.toString(),
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.trending_up, color: Colors.green, size: 14),
          ),
          Text(
            newVal.toString(),
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirements(EvolutionRequirement req) {
    final hasSpirit = widget.spirit >= req.spiritCost;
    final hasFlesh = widget.flesh >= req.fleshCost;
    final hasParts = req.requiredParts.every(
      (part) => selectedBeast!.parts.contains(part),
    );
    final hasStats = selectedBeast!.stats.totalScore >= req.minStatsTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '突破所需资粮',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildReqCard(
          '天精地气',
          '${widget.spirit}/${req.spiritCost}',
          hasSpirit,
          Icons.blur_circular,
          Colors.cyan,
        ),
        _buildReqCard(
          '血肉精华',
          '${widget.flesh}/${req.fleshCost}',
          hasFlesh,
          Icons.restaurant,
          Colors.orange,
        ),
        if (req.requiredParts.isNotEmpty)
          _buildReqCard(
            '造化残片',
            '${selectedBeast!.parts.length}/${req.requiredParts.length}',
            hasParts,
            Icons.extension,
            Colors.purple,
          ),
        _buildReqCard(
          '神识境界',
          '${selectedBeast!.stats.totalScore}/${req.minStatsTotal}',
          hasStats,
          Icons.auto_awesome,
          Colors.amber,
        ),
      ],
    );
  }

  Widget _buildReqCard(
    String label,
    String value,
    bool met,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: met ? color.withValues(alpha: 0.2) : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: met ? color : Colors.white38,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            met ? Icons.check_circle : Icons.error_outline,
            color: met ? Colors.green : Colors.red.withValues(alpha: 0.5),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildEvolveButton(bool canEvolve) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        boxShadow: canEvolve
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: canEvolve && !isEvolving ? _startEvolution : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.05),
          disabledForegroundColor: Colors.white24,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 0,
        ),
        child: Text(
          isEvolving ? '正在感悟天地...' : '破境升阶',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildEvolutionAnimation() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          color: Colors.black.withValues(
            alpha: 0.9 * _animationController.value,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // 旋转的光环
                    Transform.rotate(
                      angle: _animationController.value * 2 * 3.14159,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    // 脉冲的中心
                    Container(
                      width: 120 * _scaleAnimation.value,
                      height: 120 * _scaleAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.auto_awesome,
                      size: 64,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, AppColors.primary, Colors.white],
                    stops: [
                      (_animationController.value - 0.2).clamp(0.0, 1.0),
                      _animationController.value,
                      (_animationController.value + 0.2).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    '蜕变中...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getNextTier(String currentTier) {
    switch (currentTier) {
      case '百年':
        return '千年';
      case '千年':
        return '万年';
      default:
        return '';
    }
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case '万年':
        return Colors.purple;
      case '千年':
        return Colors.blue;
      case '百年':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
