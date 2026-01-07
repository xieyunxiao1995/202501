import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/beast_model.dart';

class BeastDetailPage extends StatefulWidget {
  final Beast beast;
  final Function(Beast) onUpdate;

  const BeastDetailPage({
    super.key,
    required this.beast,
    required this.onUpdate,
  });

  @override
  State<BeastDetailPage> createState() => _BeastDetailPageState();
}

class _BeastDetailPageState extends State<BeastDetailPage> {
  late TextEditingController _nameController;
  bool _isEditing = false;
  late Beast _currentBeast;

  @override
  void initState() {
    super.initState();
    _currentBeast = widget.beast;
    _nameController = TextEditingController(text: _currentBeast.name);
  }

  void _toggleLock() {
    setState(() {
      _currentBeast.isLocked = !_currentBeast.isLocked;
    });
    widget.onUpdate(_currentBeast);
  }

  void _saveName() {
    setState(() {
      _currentBeast.name = _nameController.text;
      _isEditing = false;
    });
    widget.onUpdate(_currentBeast);
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.height < 600;

    // 根据阶级决定主题色
    Color themeColor = AppColors.secondary;
    if (_currentBeast.tier == "千年") themeColor = AppColors.primary;
    if (_currentBeast.tier == "万年") themeColor = AppColors.danger;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white70,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _currentBeast.isLocked ? Icons.lock : Icons.lock_open,
              color: _currentBeast.isLocked
                  ? AppColors.primary
                  : Colors.white38,
              size: 20,
            ),
            onPressed: _toggleLock,
          ),
          const SizedBox(width: 12),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 顶部大图区域
            _buildHeader(themeColor, isSmallScreen),

            // 属性面板
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRadar(themeColor, isSmallScreen),
                  SizedBox(height: isSmallScreen ? 20 : 30),
                  _buildPartsSection(themeColor, isSmallScreen),
                  SizedBox(height: isSmallScreen ? 20 : 30),
                  _buildDescriptionSection(isSmallScreen),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color color, bool isSmallScreen) {
    final double headerHeight = isSmallScreen ? 220 : 280;
    final double iconSize = isSmallScreen ? 90 : 120;
    final double fontSize = isSmallScreen ? 48 : 60;

    return Container(
      constraints: BoxConstraints(minHeight: headerHeight),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.3), AppColors.bg],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'beast_${_currentBeast.id}',
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.2),
                    border: Border.all(color: color, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: isSmallScreen ? 20 : 30,
                        spreadRadius: isSmallScreen ? 3 : 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _currentBeast.name[0],
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: color,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 12 : 20),
              if (_isEditing)
                SizedBox(
                  width: isSmallScreen ? 160 : 200,
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.check,
                          color: AppColors.secondary,
                          size: 20,
                        ),
                        onPressed: _saveName,
                      ),
                    ),
                    onSubmitted: (_) => _saveName(),
                  ),
                )
              else
                GestureDetector(
                  onTap: () => setState(() => _isEditing = true),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentBeast.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.edit, size: 14, color: Colors.white30),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                child: Text(
                  _currentBeast.tier,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: isSmallScreen ? 11 : 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRadar(Color color, bool isSmallScreen) {
    return Column(
      children: [
        Text(
          "属性六维 · HEXAGON",
          style: TextStyle(
            color: AppColors.textSub,
            fontSize: isSmallScreen ? 10 : 12,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: isSmallScreen ? 10 : 20),
        SizedBox(
          height: isSmallScreen ? 160 : 200,
          width: double.infinity,
          child: CustomPaint(
            painter: RadarChartPainter(
              stats: _currentBeast.stats,
              color: color,
              isSmallScreen: isSmallScreen,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 10 : 20),
        // 具体数值
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statBox("生命", _currentBeast.stats.hp, Colors.green, isSmallScreen),
            _statBox(
              "攻击",
              _currentBeast.stats.atk,
              AppColors.danger,
              isSmallScreen,
            ),
            _statBox(
              "防御",
              _currentBeast.stats.def,
              AppColors.info,
              isSmallScreen,
            ),
            _statBox(
              "敏捷",
              _currentBeast.stats.spd,
              AppColors.secondary,
              isSmallScreen,
            ),
          ],
        ),
      ],
    );
  }

  Widget _statBox(String label, int val, Color c, bool isSmallScreen) {
    return Column(
      children: [
        Text(
          val.toString(),
          style: TextStyle(
            color: c,
            fontSize: isSmallScreen ? 15 : 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSub,
            fontSize: isSmallScreen ? 9 : 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPartsSection(Color color, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "肢体构造 · ANATOMY",
          style: TextStyle(
            color: AppColors.textSub,
            fontSize: isSmallScreen ? 10 : 12,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: isSmallScreen ? 10 : 12),
        Wrap(
          spacing: isSmallScreen ? 8 : 12,
          runSpacing: isSmallScreen ? 8 : 12,
          children: _currentBeast.parts.map((p) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 8 : 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.extension,
                    size: isSmallScreen ? 14 : 16,
                    color: color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    p,
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "异兽志 · LORE",
            style: TextStyle(
              color: AppColors.textSub,
              fontSize: isSmallScreen ? 9 : 10,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            _currentBeast.description ?? "暂无记载。",
            style: TextStyle(
              color: Colors.white70,
              height: 1.6,
              fontSize: isSmallScreen ? 13 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Canvas Painting for Radar Chart
class RadarChartPainter extends CustomPainter {
  final BeastStats stats;
  final Color color;
  final bool isSmallScreen;

  RadarChartPainter({
    required this.stats,
    required this.color,
    required this.isSmallScreen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - (isSmallScreen ? 15 : 20);

    final paintLine = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final paintFill = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // 4个维度的最大值归一化 (假设最大值为 1000 HP, 200 Others)
    // 这里简单处理：HP/10, others normal
    final double maxVal = 100.0; // scale factor

    // Normalize stats
    final v1 = (stats.hp / 10).clamp(0, 150) / 150; // HP权重不同
    final v2 = stats.atk.clamp(0, 150) / 150;
    final v3 = stats.def.clamp(0, 150) / 150;
    final v4 = stats.spd.clamp(0, 150) / 150;

    final values = [v1, v2, v3, v4];
    final labels = ["HP", "ATK", "DEF", "SPD"];

    // Draw Webs
    for (int i = 1; i <= 4; i++) {
      double r = radius * (i / 4);
      Path path = Path();
      for (int j = 0; j < 4; j++) {
        double angle = (j * 90) * pi / 180 - pi / 2;
        double x = center.dx + r * cos(angle);
        double y = center.dy + r * sin(angle);
        if (j == 0)
          path.moveTo(x, y);
        else
          path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, paintLine);
    }

    // Draw Lines to corners
    for (int j = 0; j < 4; j++) {
      double angle = (j * 90) * pi / 180 - pi / 2;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), paintLine);

      // Draw Text Labels
      final textSpan = TextSpan(
        text: labels[j],
        style: TextStyle(
          color: AppColors.textSub,
          fontSize: isSmallScreen ? 8 : 10,
        ),
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout();
      double tx = x + (cos(angle) * (isSmallScreen ? 10 : 15)) - tp.width / 2;
      double ty = y + (sin(angle) * (isSmallScreen ? 10 : 15)) - tp.height / 2;
      tp.paint(canvas, Offset(tx, ty));
    }

    // Draw Stats Polygon
    Path statPath = Path();
    for (int j = 0; j < 4; j++) {
      double angle = (j * 90) * pi / 180 - pi / 2;
      double r = radius * (0.2 + values[j] * 0.8); // 基础0.2防止太小
      double x = center.dx + r * cos(angle);
      double y = center.dy + r * sin(angle);
      if (j == 0)
        statPath.moveTo(x, y);
      else
        statPath.lineTo(x, y);
    }
    statPath.close();
    canvas.drawPath(statPath, paintFill);
    canvas.drawPath(statPath, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
