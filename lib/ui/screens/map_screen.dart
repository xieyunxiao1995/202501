import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../services/ai_service.dart';
import '../../utils/constants.dart';
import '../../models/map_config.dart';
import '../widgets/background_scaffold.dart';
import 'battle_screen.dart';

class MapScreen extends StatefulWidget {
  final GameService gameService;
  final MapConfig? mapConfig;

  const MapScreen({super.key, required this.gameService, this.mapConfig});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late int rows;
  late int cols;
  late List<String> grid;
  late int playerPos;
  final Random _rng = Random();
  final AIService _aiService = AIService();
  
  // 使用 List 存储日志以便更好地控制样式
  late final List<String> _logs;
  final ScrollController _logScrollController = ScrollController();
  
  int _turnCount = 0;
  int _tideLevel = 0; // How many rings are inked

  @override
  void initState() {
    super.initState();
    // Use config or defaults
    rows = widget.mapConfig?.height ?? 7;
    cols = widget.mapConfig?.width ?? 5;
    _logs = ['>> 进入 [${widget.mapConfig?.name ?? '南山'}]...', '>> 墨迹正在蔓延...'];
    _generateMap();
  }

  void _addLog(String text) {
    setState(() {
      _logs.insert(0, text);
    });
    // 滚动到顶部 (因为是 reverse List)
    if (_logScrollController.hasClients) {
      _logScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _generateMap() {
    final possibleEvents = widget.mapConfig?.possibleEvents ?? ['林', '尸', '水', '泉', '兽'];
    
    // 1. Fill with empty or random events
    grid = List.generate(rows * cols, (index) {
      if (_rng.nextDouble() < 0.5) { // Increased event chance from 0.4 to 0.5
         return possibleEvents[_rng.nextInt(possibleEvents.length)];
      }
      return '·'; // Empty path
    });

    // 2. Set player start (Center)
    playerPos = (rows * cols) ~/ 2; 
    grid[playerPos] = '始';

    // 3. Ensure Exit (Door) exists and is far from player
    int exitPos;
    do {
      exitPos = _rng.nextInt(rows * cols);
    } while (exitPos == playerPos || _manhattanDistance(playerPos, exitPos) < 3);
    grid[exitPos] = '门';

    // 4. Ensure at least 3 enemies
    int enemyCount = grid.where((c) => ['尸', '兽', '妖'].contains(c)).length;
    while (enemyCount < 3) {
      int pos = _rng.nextInt(rows * cols);
      if (grid[pos] == '·') {
        grid[pos] = '兽';
        enemyCount++;
      }
    }
  }

  int _manhattanDistance(int p1, int p2) {
    int r1 = p1 ~/ cols;
    int c1 = p1 % cols;
    int r2 = p2 ~/ cols;
    int c2 = p2 % cols;
    return (r1 - r2).abs() + (c1 - c2).abs();
  }

  void _enterNextLevel() {
    setState(() {
      _turnCount = 0;
      _tideLevel = 0;
      _logs.clear();
      _addLog('>> 进入下一层深渊...');
      _generateMap();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已进入下一层')));
  }

  void _checkInkTide() {
    _turnCount++;
    // Tide rises every 5 turns
    int newLevel = _turnCount ~/ 5; 
    
    if (newLevel > _tideLevel) {
      setState(() {
        _tideLevel = newLevel;
        _addLog('>> 墨潮汹涌！边缘被吞噬...');
      });
    }
    
    if (_isInked(playerPos)) {
       widget.gameService.damageSanity(5);
       _addLog('>> 墨毒侵蚀灵魂！(-5 理智)');
    }
  }

  bool _isInked(int index) {
    int r = index ~/ cols;
    int c = index % cols;
    return r < _tideLevel || r >= rows - _tideLevel || c < _tideLevel || c >= cols - _tideLevel;
  }

  void _movePlayer(int index) {
    // Check adjacency
    int currentRow = playerPos ~/ cols;
    int currentCol = playerPos % cols;
    int targetRow = index ~/ cols;
    int targetCol = index % cols;

    if ((currentRow - targetRow).abs() + (currentCol - targetCol).abs() == 1) {
      setState(() {
        grid[playerPos] = '·'; 
        playerPos = index;
        final char = grid[index];
        grid[index] = '我';
        _handleTileEvent(char);
      });
      
      widget.gameService.damageSanity(1);
      _checkInkTide();
    }
  }

  void _handleTileEvent(String char) {
    String contextPrompt = "玩家踏入了一个由汉字 '$char' 代表的地块。请描述他们所见/所感。";
    
    _aiService.generateFlavorText(contextPrompt).then((text) {
      if (mounted) {
        _addLog('>> $text');
      }
    });

    if (['尸', '兽', '妖'].contains(char)) {
      _showEncounterDialog(isBoss: false);
    } else if (char == '龙') {
      _showEncounterDialog(isBoss: true);
    } else if (char == '泉') {
      widget.gameService.restoreSanity(10);
      _addLog('>> 灵泉濯笔，神志清明 (理智 +10)');
    } else if (char == '林') {
      widget.gameService.gainInk(5);
      _addLog('>> 墨林采风，获得墨韵 (墨韵 +5)');
    } else if (char == '水') {
      widget.gameService.gainInk(3);
      _addLog('>> 汲取黑水，获得少许墨韵 (墨韵 +3)');
    } else if (char == '雷') {
      // Thunder event: Risk/Reward
      if (_rng.nextBool()) {
        widget.gameService.damageSanity(5);
        _addLog('>> 天雷滚滚，震慑心神 (理智 -5)');
      } else {
        widget.gameService.gainInk(10);
        _addLog('>> 雷光乍现，笔锋带电 (墨韵 +10)');
      }
    } else if (char == '云') {
       // Cloud: Random teleport or just safe spot
       widget.gameService.restoreSanity(2);
       _addLog('>> 云深不知处，片刻宁静 (理智 +2)');
    } else if (char == '峰') {
       // Peak: Reveal map (simplified as logic boost)
       widget.gameService.restoreSanity(5);
       _addLog('>> 登高望远，胸怀开阔 (理智 +5)');
       // TODO: Reveal surrounding tiles
    } else if (char == '门') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.bgPaper,
          title: Text('通往深层', style: GoogleFonts.maShanZheng(fontSize: 24, color: AppColors.inkBlack)),
          content: Text('你发现了通往下一层的入口。一旦深入，便无法回头。\n\n目前的墨潮等级将会重置。', style: GoogleFonts.notoSerifSc(color: AppColors.inkBlack)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('暂留', style: GoogleFonts.maShanZheng(color: Colors.grey, fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _enterNextLevel();
              },
              child: Text('深入', style: GoogleFonts.maShanZheng(color: AppColors.inkRed, fontSize: 24)),
            ),
          ],
        ),
      );
    }
  }
  
  void _pulseMap() {
    widget.gameService.damageSanity(2);
    _addLog('>> 感知四周... 墨潮等级: $_tideLevel');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('消耗精神感知四周...')));
  }
  
  void _showEncounterDialog({bool isBoss = false}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Encounter',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        final isSmallScreen = MediaQuery.of(context).size.width < 380;
        
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: anim1,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: isSmallScreen ? 280 : 300,
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                decoration: BoxDecoration(
                  color: AppColors.bgPaper,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: isBoss ? AppColors.inkRed : AppColors.inkBlack, width: isBoss ? 3 : 2),
                  boxShadow: [
                    BoxShadow(color: (isBoss ? Colors.red : AppColors.inkRed).withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isBoss ? '凶兽降临' : '遭遇',
                      style: GoogleFonts.maShanZheng(
                        fontSize: isSmallScreen ? 28 : 36,
                        color: isBoss ? Colors.red : AppColors.inkRed,
                        shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.inkBlack, width: 0.5),
                          bottom: BorderSide(color: AppColors.inkBlack, width: 0.5),
                        ),
                      ),
                      child: Text(
                        isBoss ? '一只上古凶兽【烛龙】从黑雾中显现！' : '前方黑雾弥漫，一只扭曲的墨兽挡住了去路！',
                        style: GoogleFonts.notoSerifSc(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: AppColors.inkBlack,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            int damage = isBoss ? 20 : 5;
                            _addLog('>> 仓皇逃窜... (理智 -$damage)');
                            widget.gameService.damageSanity(damage);
                          },
                          child: Text(
                            '逃跑',
                            style: GoogleFonts.maShanZheng(color: Colors.grey, fontSize: isSmallScreen ? 16 : 20),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isBoss ? Colors.red.shade900 : AppColors.inkRed,
                            foregroundColor: AppColors.bgPaper,
                            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 24, vertical: isSmallScreen ? 6 : 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                          ),
                          onPressed: () async {
                            Navigator.pop(context); // Close dialog
                            await Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (_) => BattleScreen(
                                  gameService: widget.gameService,
                                  enemyName: isBoss ? '龙' : '兽',
                                  initialHp: isBoss ? 300 : 100,
                                )
                              )
                            );
                            setState(() {}); // Refresh state
                          },
                          child: Text(
                            '战斗',
                            style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 20 : 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    
    return BackgroundScaffold(
      backgroundImage: AppAssets.bgDesertOasisTemple,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0,
        title: Text('南山经', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: isSmallScreen ? 20 : 24)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.inkBlack),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text('理智: ${widget.gameService.player?.sanity ?? 0}', style: GoogleFonts.notoSerifSc(color: AppColors.inkBlack, fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 12 : 14)),
          ))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFD6CBB5), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Background Watermark
                Positioned(
                  left: 20,
                  top: 40,
                  child: IgnorePointer(
                    child: Text(
                      '南山',
                      style: GoogleFonts.maShanZheng(
                        fontSize: isSmallScreen ? 80 : 120,
                        color: Colors.black.withValues(alpha: 0.05),
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                
                // Map Grid
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width < 340 ? MediaQuery.of(context).size.width - 20 : (isSmallScreen ? 280 : 320),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EBD8),
                      border: Border.all(color: const Color(0xFFD6CBB5)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rows * cols,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: isSmallScreen ? 6 : 8,
                        mainAxisSpacing: isSmallScreen ? 6 : 8,
                      ),
                      itemBuilder: (context, index) {
                        final char = index == playerPos ? '我' : grid[index];
                        final isPlayer = index == playerPos;
                        final isInked = _isInked(index);
                        
                        return GestureDetector(
                          onTap: () => _movePlayer(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: isPlayer 
                                  ? AppColors.inkRed 
                                  : isInked 
                                      ? const Color(0xFF2A2A2A) // Inked/Dark Stele
                                      : const Color(0xFF444444), // Normal Stele
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                              border: Border.all(
                                color: isPlayer 
                                    ? AppColors.gold 
                                    : isInked 
                                        ? Colors.black 
                                        : const Color(0xFF333333),
                                width: isPlayer ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5), 
                                  blurRadius: 4, 
                                  offset: const Offset(2, 2)
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              isInked ? '墨' : char,
                              style: GoogleFonts.maShanZheng(
                                fontSize: isSmallScreen ? 18 : 22,
                                fontWeight: FontWeight.bold,
                                color: isPlayer 
                                    ? Colors.white 
                                    : isInked 
                                        ? Colors.white10 
                                        : const Color(0xFF888888),
                                shadows: isPlayer ? [const Shadow(color: Colors.black, blurRadius: 2)] : [],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Log & Control Area
          Container(
            height: isSmallScreen ? 150 : 180,
            decoration: const BoxDecoration(
              color: Color(0xFF111111),
              border: Border(top: BorderSide(color: AppColors.inkRed, width: 4)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Logs
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    controller: _logScrollController,
                    reverse: true,
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          _logs[index],
                          style: GoogleFonts.notoSerifSc(
                            color: Colors.grey, 
                            fontSize: isSmallScreen ? 11 : 13, 
                            height: 1.4,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const VerticalDivider(color: Color(0xFF333333), width: 32),
                
                // Controls
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Red Stamp Button (Pulse)
                    GestureDetector(
                      onTap: _pulseMap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.inkRed.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.inkRed, width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        transform: Matrix4.rotationZ(-0.05), // -2 degrees roughly
                        child: Text(
                          '感知',
                          style: GoogleFonts.maShanZheng(
                            color: AppColors.inkRed,
                            fontSize: isSmallScreen ? 16 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '墨潮: Lv.$_tideLevel',
                      style: GoogleFonts.notoSerifSc(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
