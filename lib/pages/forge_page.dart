import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/constants.dart';
import '../models/beast_model.dart';
import '../models/tribe_model.dart';

class ForgePage extends StatefulWidget {
  final int spirit;
  final List<Beast> beasts;
  final TribeData tribeData;
  final Function(Beast) onUpdateBeast;
  final Function(String) onRemoveBeast;
  final Function(int, int) onUpdateResource;

  const ForgePage({
    super.key,
    required this.spirit,
    required this.beasts,
    required this.tribeData,
    required this.onUpdateBeast,
    required this.onRemoveBeast,
    required this.onUpdateResource,
  });

  @override
  State<ForgePage> createState() => _ForgePageState();
}

class _ForgePageState extends State<ForgePage>
    with SingleTickerProviderStateMixin {
  bool _isRefining = false;
  Beast? _host;
  Beast? _fodder;
  late AnimationController _animController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleRefine() {
    if (_host == null || _fodder == null) return;
    if (widget.spirit < 500) {
      _showError("灵气不足！");
      return;
    }

    setState(() => _isRefining = true);
    widget.onUpdateResource(-500, 0);
    _animController.repeat();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _animController.stop();
      _processDevour();
      setState(() => _isRefining = false);
    });
  }

  Map<String, double> _calculateProbabilities() {
    if (_host == null || _fodder == null) {
      return {'mutation': 5.0, 'success': 30.0, 'fail': 60.0, 'death': 5.0};
    }

    double successRate = 0.30;
    if (_host!.tier == "百年" && _fodder!.tier == "千年") successRate = 0.20;
    if (_host!.tier == "百年" && _fodder!.tier == "万年") successRate = 0.10;
    if (_host!.tier == "千年" && _fodder!.tier == "万年") successRate = 0.15;
    if (_host!.tier == _fodder!.tier) successRate = 0.35;

    // 图腾赐福加成
    successRate += widget.tribeData.swallowSuccessBonus;
    double mutationRate = 0.05 + widget.tribeData.mutationBonus;
    double deathRate = (0.05 - widget.tribeData.deathReduction).clamp(
      0.01,
      0.05,
    );

    return {
      'mutation': (mutationRate * 100).clamp(0, 100),
      'success': (successRate * 100).clamp(0, 100),
      'fail': (100 - mutationRate * 100 - successRate * 100 - deathRate * 100)
          .clamp(0, 100),
      'death': (deathRate * 100).clamp(0, 100),
    };
  }

  void _processDevour() {
    if (_host == null || _fodder == null) return;

    final random = Random();
    final roll = random.nextDouble();
    String resultTitle = "";
    String resultDesc = "";
    Color resultColor = Colors.white;
    bool isMutation = false;

    final fodderId = _fodder!.id;
    final hostCopy = Beast(
      id: _host!.id,
      name: _host!.name,
      tier: _host!.tier,
      parts: List.from(_host!.parts),
      stats: _host!.stats.copyWith(),
    );

    double successRate = 0.4;
    if (_host!.tier == "百年" && _fodder!.tier == "千年") successRate = 0.2;
    if (_host!.tier == "百年" && _fodder!.tier == "万年") successRate = 0.05;

    // 图腾赐福加成
    successRate += widget.tribeData.swallowSuccessBonus;
    double mutationRate = 0.05 + widget.tribeData.mutationBonus;
    double deathRate = (0.05 - widget.tribeData.deathReduction).clamp(
      0.01,
      0.05,
    );

    if (roll < mutationRate) {
      resultTitle = "完美融合！";
      isMutation = true;
      final newPart = _fodder!.parts.isNotEmpty
          ? _fodder!.parts[random.nextInt(_fodder!.parts.length)]
          : beastParts[random.nextInt(beastParts.length)];

      if (!hostCopy.parts.contains(newPart)) {
        hostCopy.parts.add(newPart);
      }

      final adjective = beastAdjectives[random.nextInt(beastAdjectives.length)];
      if (!hostCopy.name.contains("·")) {
        hostCopy.name = "$adjective·${hostCopy.name}";
      }

      hostCopy.stats.hp += (50 + random.nextInt(50));
      hostCopy.stats.atk += (20 + random.nextInt(20));
      hostCopy.stats.def += (10 + random.nextInt(10));
      hostCopy.stats.spd += (10 + random.nextInt(10));

      resultDesc = "主体发生了异变！获得了祭品的部位 [$newPart]，全属性大幅提升！";
      resultColor = AppColors.primary;
    } else if (roll < mutationRate + successRate) {
      resultTitle = "融合成功";
      final hpGain = (_fodder!.stats.hp * 0.2).toInt();
      final atkGain = (_fodder!.stats.atk * 0.2).toInt();
      hostCopy.stats.hp += hpGain;
      hostCopy.stats.atk += atkGain;
      resultDesc = "主体成功吸收了祭品的精华。\nHP +$hpGain / ATK +$atkGain";
      resultColor = AppColors.secondary;
    } else if (roll < 1.0 - deathRate) {
      resultTitle = "炼化失败";
      final dmg = (hostCopy.stats.hp * 0.1).toInt();
      hostCopy.stats.hp = max(1, hostCopy.stats.hp - dmg);
      resultDesc = "祭品排斥反应强烈，主体受到反噬，气血受损 $dmg 点。";
      resultColor = AppColors.info;
    } else {
      resultTitle = "爆体而亡！";
      resultDesc = "无法承受庞大的灵力冲击，主体与祭品化为灰烬...";
      resultColor = AppColors.danger;
      widget.onRemoveBeast(hostCopy.id);
      widget.onRemoveBeast(fodderId);
      _host = null;
      _fodder = null;
      _showResultDialog(resultTitle, resultDesc, resultColor, dead: true);
      return;
    }

    widget.onUpdateBeast(hostCopy);
    widget.onRemoveBeast(fodderId);
    _host = hostCopy;
    _fodder = null;
    _showResultDialog(
      resultTitle,
      resultDesc,
      resultColor,
      mutation: isMutation,
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.danger),
    );
  }

  void _showResultDialog(
    String title,
    String desc,
    Color color, {
    bool dead = false,
    bool mutation = false,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.height < 600;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: color.withOpacity(0.2), width: 2),
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dead ? '炼化失败' : (mutation ? '异变成功' : '炼化成功'),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isSmallScreen ? 14 : 16,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                Container(
                  width: isSmallScreen ? 60 : 80,
                  height: isSmallScreen ? 60 : 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.5), color],
                    ),
                  ),
                  child: Icon(
                    dead
                        ? Icons.dangerous
                        : (mutation ? Icons.auto_awesome : Icons.check),
                    color: Colors.white,
                    size: isSmallScreen ? 30 : 40,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 32),
                InkWell(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    width: double.infinity,
                    height: isSmallScreen ? 44 : 52,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 10 : 12,
                      ),
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Center(
                      child: Text(
                        '收下',
                        style: TextStyle(
                          color: color,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  void _pickBeast(bool isHost, bool isSmallScreen) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              isHost ? "选择主体" : "选择祭品",
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.beasts.length,
              itemBuilder: (c, i) {
                final b = widget.beasts[i];
                if (isHost && b.id == _fodder?.id)
                  return const SizedBox.shrink();
                if (!isHost && b.id == _host?.id)
                  return const SizedBox.shrink();

                return ListTile(
                  leading: _buildBeastIcon(b, isSmallScreen),
                  title: Text(
                    b.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  subtitle: Text(
                    b.tier,
                    style: TextStyle(
                      color: AppColors.textSub,
                      fontSize: isSmallScreen ? 11 : 12,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (isHost) {
                        _host = b;
                      } else {
                        _fodder = b;
                      }
                    });
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeastIcon(Beast beast, bool isSmallScreen) {
    Color tierColor = AppColors.secondary;
    if (beast.tier == "千年") tierColor = AppColors.primary;
    if (beast.tier == "万年") tierColor = AppColors.danger;

    final size = isSmallScreen ? 32.0 : 40.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tierColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tierColor, width: 1),
      ),
      child: Center(
        child: Text(
          beast.name.substring(0, 1),
          style: TextStyle(
            color: tierColor,
            fontSize: isSmallScreen ? 16 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.height < 600;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          children: [
            _buildHeader(isSmallScreen),
            SizedBox(height: isSmallScreen ? 20 : 40),
            _buildForgeArea(isSmallScreen),
            SizedBox(height: isSmallScreen ? 20 : 40),
            _buildInfoPanel(isSmallScreen),
            SizedBox(height: isSmallScreen ? 20 : 40),
            _buildRefineButton(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Row(
      children: [
        Icon(
          Icons.local_fire_department,
          color: AppColors.danger,
          size: isSmallScreen ? 20 : 24,
        ),
        const SizedBox(width: 8),
        Text(
          "天地熔炉",
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (!isSmallScreen)
          const Text(
            "CHIMERA FORGE",
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSub,
              letterSpacing: 2,
            ),
          ),
      ],
    );
  }

  Widget _buildForgeArea(bool isSmallScreen) {
    final forgeSize = isSmallScreen ? 220.0 : 280.0;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Circle
        Container(
          width: forgeSize,
          height: forgeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.danger.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        // Rotating Ring
        if (_isRefining)
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animController.value * 2 * 3.14159,
                child: Container(
                  width: isSmallScreen ? 80 : 100,
                  height: isSmallScreen ? 80 : 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(
                    Icons.sync,
                    color: AppColors.primary,
                    size: isSmallScreen ? 32 : 40,
                  ),
                ),
              );
            },
          ),

        if (!_isRefining)
          Icon(
            Icons.arrow_forward,
            color: AppColors.textSub,
            size: isSmallScreen ? 20 : 24,
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSlot(
              title: "主体",
              beast: _host,
              isHost: true,
              isSmallScreen: isSmallScreen,
            ),
            SizedBox(width: isSmallScreen ? 40 : 80),
            _buildSlot(
              title: "祭品",
              beast: _fodder,
              isHost: false,
              isSmallScreen: isSmallScreen,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlot({
    required String title,
    Beast? beast,
    required bool isHost,
    required bool isSmallScreen,
  }) {
    Color tierColor = AppColors.textSub;
    if (beast != null) {
      if (beast.tier == "千年") tierColor = AppColors.primary;
      if (beast.tier == "万年") tierColor = AppColors.danger;
      if (beast.tier == "百年") tierColor = AppColors.secondary;
    }

    final cardWidth = isSmallScreen ? 70.0 : 90.0;
    final cardHeight = isSmallScreen ? 100.0 : 130.0;

    return GestureDetector(
      onTap: () => _isRefining ? null : _pickBeast(isHost, isSmallScreen),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: tierColor.withOpacity(0.5)),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 9 : 10,
                color: tierColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tierColor.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: tierColor.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: beast == null
                ? Icon(
                    Icons.add,
                    size: isSmallScreen ? 24 : 32,
                    color: AppColors.textSub,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: isSmallScreen ? 36 : 50,
                        height: isSmallScreen ? 36 : 50,
                        decoration: BoxDecoration(
                          color: tierColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            beast.name.substring(0, 1),
                            style: TextStyle(
                              color: tierColor,
                              fontSize: isSmallScreen ? 20 : 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 8),
                      Text(
                        beast.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        beast.tier,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 9 : 10,
                          color: tierColor,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            isHost ? "保留意识" : "将会消失",
            style: TextStyle(
              fontSize: isSmallScreen ? 9 : 10,
              color: isHost ? AppColors.textSub : AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel(bool isSmallScreen) {
    final probs = _calculateProbabilities();

    if (_host == null || _fodder == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: AppColors.card.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Text(
          "请选择要炼化的异兽。祭品将被消耗，主体有概率获得属性提升或异变。",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSub,
            fontSize: isSmallScreen ? 11 : 12,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "融合成功率",
                style: TextStyle(
                  color: AppColors.textSub,
                  fontSize: isSmallScreen ? 11 : 12,
                ),
              ),
              Text(
                "${probs['success']!.toStringAsFixed(0)}%",
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: isSmallScreen ? 11 : 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: probs['death']!.toInt(),
                  child: Container(height: 6, color: AppColors.danger),
                ),
                Expanded(
                  flex: probs['fail']!.toInt(),
                  child: Container(height: 6, color: AppColors.info),
                ),
                Expanded(
                  flex: probs['success']!.toInt(),
                  child: Container(height: 6, color: AppColors.secondary),
                ),
                Expanded(
                  flex: probs['mutation']!.toInt(),
                  child: Container(height: 6, color: AppColors.primary),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProbLabel(
                "反噬",
                probs['fail']!,
                AppColors.info,
                isSmallScreen,
              ),
              _buildProbLabel(
                "变异",
                probs['success']!,
                AppColors.secondary,
                isSmallScreen,
              ),
              _buildProbLabel(
                "完美",
                probs['mutation']!,
                AppColors.primary,
                isSmallScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProbLabel(
    String label,
    double? value,
    Color color,
    bool isSmallScreen,
  ) {
    return Text(
      "$label(${value?.toStringAsFixed(0)}%)",
      style: TextStyle(
        color: color,
        fontSize: isSmallScreen ? 9 : 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRefineButton(bool isSmallScreen) {
    bool canRefine = !_isRefining && _host != null && _fodder != null;
    return Container(
      width: double.infinity,
      height: isSmallScreen ? 48 : 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: canRefine
            ? const LinearGradient(
                colors: [AppColors.danger, AppColors.primary],
              )
            : null,
        color: canRefine ? null : Colors.white10,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: canRefine ? _handleRefine : null,
        child: _isRefining
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "开始炼妖",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  Text(
                    "消耗: 500 灵气",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 9 : 10,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
