import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math; // 用于旋转计算
import '../../models/map_config.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';
import 'map_intro_screen.dart';

class MapSelectionScreen extends StatefulWidget {
  final GameService gameService;

  const MapSelectionScreen({super.key, required this.gameService});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    // 将地图数据分配到三列
    final List<MapConfig> col1 = [];
    final List<MapConfig> col2 = [];
    final List<MapConfig> col3 = [];

    for (int i = 0; i < GameMaps.all.length; i++) {
      if (i % 3 == 0) {
        col1.add(GameMaps.all[i]);
      } else if (i % 3 == 1) {
        col2.add(GameMaps.all[i]);
      } else {
        col3.add(GameMaps.all[i]);
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '选择征途',
          style: GoogleFonts.maShanZheng(
            color: AppColors.inkBlack,
            fontSize: isSmallScreen ? 26 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.inkBlack),
      ),
      body: Stack(
        children: [
          // 1. 背景图片
          Positioned.fill(
            child: Image.asset(
              'assets/bg/A_circular_fantasy_floating_island.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. 装饰性遮罩
          Positioned.fill(
            child: Container(color: const Color(0xFFF3EFE6).withOpacity(0.2)),
          ),

          // 3. 三列错位分布的关卡列表
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(10, 100, 10, 100), // 上下留白
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // 顶部对齐，通过Padding实现错位
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 第一列：无额外偏移
                Expanded(
                  child: _buildColumn(context, col1, 0, -0.02, isSmallScreen),
                ),
                // 第二列：顶部下沉 60，形成错落
                Expanded(
                  child: _buildColumn(context, col2, 60, 0.01, isSmallScreen),
                ),
                // 第三列：顶部下沉 30 (介于两者之间或更深，这里选30形成波浪感，或者120形成阶梯)
                // 这里选择 120 形成明显的阶梯错落
                Expanded(
                  child: _buildColumn(context, col3, 120, -0.01, isSmallScreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(
    BuildContext context,
    List<MapConfig> maps,
    double topOffset,
    double rotationAngle,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: topOffset),
      child: Column(
        children: maps
            .map(
              (map) => _buildVerticalMapTag(
                context,
                map,
                rotationAngle,
                isSmallScreen,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildVerticalMapTag(
    BuildContext context,
    MapConfig map,
    double rotationAngle,
    bool isSmallScreen,
  ) {
    // 标签的主体宽度 - 稍微调窄以适应三列
    final double tagWidth = isSmallScreen ? 60 : 75;
    // 调整了高度：从小屏幕260/大屏幕320 减小到 210/260
    final double tagHeight = isSmallScreen ? 210 : 260;
    // 字体大小适配
    final double fontSize = isSmallScreen ? 24 : 30;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MapIntroScreen(gameService: widget.gameService, mapConfig: map),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10), // 每个标签垂直间距
        child: Transform.rotate(
          angle: rotationAngle,
          child: Column(
            children: [
              // 挂绳视觉效果
              Container(
                width: 2,
                height: 30, // 绳子长度
                color: AppColors.inkBlack.withOpacity(0.6),
              ),

              // 标签卡片
              Container(
                width: tagWidth,
                height: tagHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EFE6).withOpacity(0.92),
                  border: Border.all(color: map.themeColor, width: 1.5),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(4),
                    topRight: const Radius.circular(4),
                    bottomLeft: const Radius.circular(16),
                    bottomRight: const Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 挂孔
                    const SizedBox(height: 8),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: AppColors.inkBlack.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 竖排文字名称
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: map.name.split('').map((char) {
                              return Text(
                                char,
                                style: GoogleFonts.maShanZheng(
                                  fontSize: fontSize,
                                  color: AppColors.inkBlack,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),

                    // 难度星级
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(map.difficulty, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Icon(
                              Icons.star,
                              color: AppColors.inkRed,
                              size: 12,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
