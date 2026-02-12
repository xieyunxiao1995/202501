import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';
import '../../models/card.dart';
import '../../models/item.dart';
import '../widgets/background_scaffold.dart';
import 'battle_result_screen.dart';

class BattleScreen extends StatefulWidget {
  final GameService gameService;
  final String? enemyName;
  final int? initialHp;

  const BattleScreen({
    super.key, 
    required this.gameService,
    this.enemyName,
    this.initialHp,
  });

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> with TickerProviderStateMixin {
  int enemyHp = 100;
  int maxEnemyHp = 100;
  String enemyChar = '饕'; // 默认: Taotie

  // 状态堆叠: key=状态名, value=层数
  Map<String, int> enemyStatuses = {};
  int playerShield = 0;
  
  // 敌人意图系统
  String nextMoveType = 'attack'; // attack, buff, debuff
  int nextMoveValue = 5;
  int turnCount = 0;

  List<WordCard> hand = [];
  List<WordCard> drawPile = [];
  List<WordCard> discardPile = [];
  String _battleLog = '战斗开始...';
  
  // Animations
  late AnimationController _enemyAnimController;
  late AnimationController _playerAnimController;
  late Animation<Offset> _enemyOffsetAnim;
  late Animation<Offset> _playerOffsetAnim;
  
  List<FloatingText> _floatingTexts = [];

  @override
  void initState() {
    super.initState();
    
    // Init Animations
    _enemyAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _playerAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    
    _enemyOffsetAnim = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _enemyAnimController, curve: Curves.easeInOut)
    );
    _playerOffsetAnim = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _playerAnimController, curve: Curves.easeInOut)
    );

    if (widget.enemyName != null) {
      enemyChar = widget.enemyName!;
    }
    if (widget.initialHp != null) {
      enemyHp = widget.initialHp!;
      maxEnemyHp = widget.initialHp!;
    }
    _initDeck();
    _startPlayerTurn();
  }

  @override
  void dispose() {
    _enemyAnimController.dispose();
    _playerAnimController.dispose();
    super.dispose();
  }

  void _addFloatingText(String text, BattleTarget target, Color color) {
    final id = DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(1000).toString();
    setState(() {
      _floatingTexts.add(FloatingText(
        id: id,
        text: text,
        target: target,
        color: color,
      ));
    });
    
    // Auto remove after animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _floatingTexts.removeWhere((ft) => ft.id == id); 
        });
      }
    });
  }

  Future<void> _animateAttack(bool isPlayerAttacking) async {
    final controller = isPlayerAttacking ? _playerAnimController : _enemyAnimController;
    // Attack: Move forward and back
    // Player moves Up (negative Y), Enemy moves Down (positive Y)
    final moveDir = isPlayerAttacking ? const Offset(0, -0.5) : const Offset(0, 0.5);
    
    Animation<Offset> anim = Tween<Offset>(begin: Offset.zero, end: moveDir).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutBack) // Bouncy attack
    );
    
    if (isPlayerAttacking) {
      _playerOffsetAnim = anim;
    } else {
      _enemyOffsetAnim = anim;
    }
    
    await controller.forward();
    await controller.reverse();
  }

  Future<void> _animateHit(bool isPlayerHit) async {
    final controller = isPlayerHit ? _playerAnimController : _enemyAnimController;
    // Hit: Shake
    final shakeAnim = TweenSequence<Offset>([
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(0.1, 0)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(0.1, 0), end: const Offset(-0.1, 0)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: const Offset(-0.1, 0), end: const Offset(0.05, 0)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: const Offset(0.05, 0), end: Offset.zero), weight: 1),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

    if (isPlayerHit) {
      _playerOffsetAnim = shakeAnim;
    } else {
      _enemyOffsetAnim = shakeAnim;
    }

    await controller.forward(from: 0);
  }

  bool _hasContract(String beastId) {
    return widget.gameService.player?.contractedBeasts.contains(beastId) ?? false;
  }

  void _initDeck() {
    drawPile = List.from(widget.gameService.player?.deck ?? []);
    drawPile.shuffle();
  }

  void _startPlayerTurn() {
    setState(() {
      turnCount++;
      playerShield = 0; // 回合开始，护盾重置

      // 契约神兽效果：混沌 (beast_003) - 战斗开始获得 20 护盾
      if (turnCount == 1 && _hasContract('beast_003')) {
        playerShield += 20;
        _addFloatingText('+20 混沌盾', BattleTarget.player, AppColors.elementMetal);
        _battleLog = '>> 混沌契约生效：获得20护盾';
      }

      // 契约神兽效果：九尾狐 (beast_001) - 每回合恢复 5 理智
      if (_hasContract('beast_001')) {
        widget.gameService.restoreSanity(5);
        _addFloatingText('+5 九尾愈', BattleTarget.player, Colors.pinkAccent);
      }

      _drawCards(4);
      _generateEnemyIntent(); // 确保意图已生成
      if (turnCount == 1 && _hasContract('beast_003')) {
         // Append to log if needed, or just let it be
      } else {
         _battleLog = '你的回合 (第$turnCount回合)';
      }
    });
  }

  void _drawCards(int count) {
    for (int i = 0; i < count; i++) {
      if (drawPile.isEmpty) {
        if (discardPile.isEmpty) break; // 真的没牌了
        // 洗牌
        drawPile.addAll(discardPile);
        discardPile.clear();
        drawPile.shuffle();
        _battleLog = '弃牌堆已重洗';
      }
      if (drawPile.isNotEmpty) {
        hand.add(drawPile.removeLast());
      }
    }
  }

  void _endTurn() {
    setState(() {
      // 弃掉手牌
      discardPile.addAll(hand);
      hand.clear();
      _enemyTurn();
    });
  }

  void _generateEnemyIntent() {
    final rand = Random();
    int r = rand.nextInt(100);
    if (r < 60) {
      nextMoveType = 'attack';
      nextMoveValue = 8 + rand.nextInt(5);
    } else if (r < 80) {
      nextMoveType = 'buff'; // e.g. 强化或治疗
      nextMoveValue = 0;
    } else {
      nextMoveType = 'debuff'; // e.g. 干扰
      nextMoveValue = 0;
    }
  }

  String get _intentDescription {
    if (nextMoveType == 'attack') return '攻击 $nextMoveValue';
    if (nextMoveType == 'buff') return '强化自身';
    if (nextMoveType == 'debuff') return '干扰';
    return '未知';
  }

  IconData get _intentIcon {
    if (nextMoveType == 'attack') return Icons.flash_on;
    if (nextMoveType == 'buff') return Icons.arrow_upward;
    if (nextMoveType == 'debuff') return Icons.smoke_free;
    return Icons.help_outline;
  }
  
  void _handleVictory() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        const inkReward = 20;
        const xpReward = 50;
        widget.gameService.gainInk(inkReward); // Use gainInk to allow overflow
        final leveledUp = widget.gameService.gainExp(xpReward);

        // Drop Logic
        final random = Random();
        Item? droppedItem;
        // 30% chance to drop item
        if (random.nextDouble() < 0.3) {
          if (random.nextBool()) {
            droppedItem = Item(
              id: 'item_tea',
              name: '灵茶',
              description: '清心凝神，恢复30点理智',
              type: ItemType.consumable,
              effectType: ItemEffectType.healSanity,
              effectValue: 30,
            );
          } else {
            droppedItem = Item(
              id: 'item_pill',
              name: '凝神丹',
              description: '强效定心，恢复60点理智',
              type: ItemType.consumable,
              effectType: ItemEffectType.healSanity,
              effectValue: 60,
            );
          }
          widget.gameService.addItemToBag(droppedItem);
        }
        
        String msg = '胜利！获得20墨韵，50修为。';
        if (droppedItem != null) {
          msg += ' 获得: ${droppedItem.name}';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BattleResultScreen(
              isVictory: true,
              gameService: widget.gameService,
              inkReward: inkReward,
              xpReward: xpReward,
              leveledUp: leveledUp,
              droppedItem: droppedItem,
            )
          )
        );
      }
    });
  }

  void _playCard(WordCard card) async {
    // 1. Player Attack Animation
    if (card.effects.any((e) => e.type == EffectType.damage) || 
        (card.effects.isEmpty && (card.element == ElementType.fire || card.element == ElementType.water))) {
        await _animateAttack(true);
    }

    setState(() {
      hand.remove(card);
      discardPile.add(card); // 移入弃牌堆
      
      int damage = 0;
      int shield = 0;
      int heal = 0;
      int draw = 0;
      
      // 处理卡牌效果
      for (var effect in card.effects) {
        switch (effect.type) {
          case EffectType.damage:
            int dmg = effect.value;
            // 契约神兽效果：穷奇 (beast_004) - 攻击力提升 15%
            if (_hasContract('beast_004')) {
               dmg = (dmg * 1.15).ceil();
            }
            // 易伤检查
            if ((enemyStatuses['易伤'] ?? 0) > 0) {
              dmg = (dmg * 1.5).toInt();
            }
            damage += dmg;
            break;
          case EffectType.shield:
            shield += effect.value;
            break;
          case EffectType.heal:
            heal += effect.value;
            break;
          case EffectType.burn:
            enemyStatuses['灼烧'] = (enemyStatuses['灼烧'] ?? 0) + effect.value;
            break;
          case EffectType.poison:
            enemyStatuses['中毒'] = (enemyStatuses['中毒'] ?? 0) + effect.value;
            break;
          case EffectType.weak:
             enemyStatuses['虚弱'] = (enemyStatuses['虚弱'] ?? 0) + effect.value;
            break;
          case EffectType.vulnerable:
             enemyStatuses['易伤'] = (enemyStatuses['易伤'] ?? 0) + effect.value;
            break;
          case EffectType.draw:
            draw += effect.value;
            break;
        }
      }
      
      // 兼容旧卡牌数据
      if (card.effects.isEmpty) {
         if (card.element == ElementType.fire) {
           damage = 30;
           enemyStatuses['灼烧'] = (enemyStatuses['灼烧'] ?? 0) + 1;
         } else if (card.element == ElementType.water) {
           enemyStatuses['潮湿'] = (enemyStatuses['潮湿'] ?? 0) + 1;
           damage = 20;
         } else if (card.element == ElementType.wood) {
           heal = 10;
         }
      }

      // 应用数值
      if (damage > 0) {
        enemyHp = (enemyHp - damage).clamp(0, maxEnemyHp);
        _animateHit(false); // Enemy Hit Animation
        _addFloatingText('-$damage', BattleTarget.enemy, AppColors.inkRed);
        
        // 契约神兽效果：饕餮 (beast_002) - 吸血 10%
        if (_hasContract('beast_002')) {
           int lifesteal = (damage * 0.1).ceil();
           if (lifesteal > 0) {
             widget.gameService.restoreSanity(lifesteal);
             _addFloatingText('+$lifesteal 饕餮噬', BattleTarget.player, Colors.deepPurple);
           }
        }
      }
      if (shield > 0) {
        playerShield += shield;
        _addFloatingText('+$shield 盾', BattleTarget.player, AppColors.elementMetal);
      }
      if (heal > 0) {
        widget.gameService.restoreSanity(heal);
        _addFloatingText('+$heal', BattleTarget.player, AppColors.elementWood);
      }
      if (draw > 0) {
        _drawCards(draw);
      }
      
      _battleLog = '你打出了 [${card.character}]';
      if (damage > 0) _battleLog += '，造成 $damage 伤害';
      if (shield > 0) _battleLog += '，获得 $shield 护盾';
      if (heal > 0) _battleLog += '，恢复 $heal 理智';
    });
    
    if (enemyHp <= 0) {
      _handleVictory();
      // 不再自动结束回合
      return;
    }
  }

  Future<void> _enemyTurn() async {
    if (!mounted) return;
    
    // 1. Thinking Delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // 2. DoT Damage
    if (mounted) {
      setState(() {
        int dotDamage = 0;
        if ((enemyStatuses['灼烧'] ?? 0) > 0) {
          dotDamage += 5 * enemyStatuses['灼烧']!;
          enemyStatuses['灼烧'] = enemyStatuses['灼烧']! - 1; // 衰减
          if (enemyStatuses['灼烧']! <= 0) enemyStatuses.remove('灼烧');
        }
        if ((enemyStatuses['中毒'] ?? 0) > 0) {
          dotDamage += 3 * enemyStatuses['中毒']!;
          enemyStatuses['中毒'] = enemyStatuses['中毒']! - 1;
           if (enemyStatuses['中毒']! <= 0) enemyStatuses.remove('中毒');
        }
        
        if (dotDamage > 0) {
          enemyHp = (enemyHp - dotDamage).clamp(0, maxEnemyHp);
          _animateHit(false);
          _addFloatingText('-$dotDamage', BattleTarget.enemy, Colors.purple);
          _battleLog = '敌人受到 $dotDamage 点状态伤害。';
        }
      });
    }

    if (enemyHp <= 0) {
       _handleVictory();
       return;
    }
    
    // 3. Enemy Action
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    if (nextMoveType == 'attack') {
      await _animateAttack(false); // Enemy Attack Animation
      
      if (!mounted) return;
      setState(() {
        int incomingDmg = nextMoveValue;
        
        // 护盾抵挡
        if (playerShield > 0) {
          if (playerShield >= incomingDmg) {
            playerShield -= incomingDmg;
            incomingDmg = 0;
             _addFloatingText('格挡', BattleTarget.player, Colors.grey);
          } else {
            incomingDmg -= playerShield;
            playerShield = 0;
          }
        }
        
        if (incomingDmg > 0) {
          widget.gameService.damageSanity(incomingDmg);
          _animateHit(true); // Player Hit Animation
          _addFloatingText('-$incomingDmg', BattleTarget.player, AppColors.inkRed);
          _battleLog = '敌人攻击，造成 $incomingDmg 伤害';
        } else {
          _battleLog = '敌人攻击被护盾完全格挡';
        }
      });
    } else if (nextMoveType == 'buff') {
      // Buff Animation (Scale Up)
      await _enemyAnimController.forward(); 
      await _enemyAnimController.reverse();
      
      if (!mounted) return;
      setState(() {
        int heal = 10;
        enemyHp = (enemyHp + heal).clamp(0, maxEnemyHp);
        _addFloatingText('+$heal', BattleTarget.enemy, Colors.green);
        _battleLog = '敌人恢复了 $heal 点生命';
      });
    } else if (nextMoveType == 'debuff') {
       if (!mounted) return;
       setState(() {
         _addFloatingText('干扰', BattleTarget.player, Colors.grey);
         _battleLog = '敌人施放了干扰烟雾';
       });
    }

    // 4. End Turn Delay
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
       _startPlayerTurn();
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.gameService.player;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 380;
    final isTablet = size.width > 600;
    final handAreaHeight = isSmallScreen ? 180.0 : (isTablet ? 320.0 : 280.0);
    
    return BackgroundScaffold(
      backgroundImage: AppAssets.bgRedLeafValley,
      body: Stack(
        children: [
          Column(
            children: [
              // === 敌方区域 (Top) ===
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  // 移除深色背景，使用透明或纸张色
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                       // 顶部: 意图显示
                       Positioned(
                         top: isSmallScreen ? 40 : (isTablet ? 80 : 60),
                         child: Container(
                           padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16, vertical: isTablet ? 10 : 6),
                           decoration: BoxDecoration(
                             color: AppColors.bgPaper,
                             borderRadius: BorderRadius.circular(4),
                             border: Border.all(color: AppColors.inkBlack.withValues(alpha: 0.3)),
                             boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                           ),
                           child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Icon(_intentIcon, color: AppColors.inkRed, size: isSmallScreen ? 16 : (isTablet ? 24 : 18)),
                               SizedBox(width: isTablet ? 12 : 8),
                               Text(
                                 _intentDescription,
                                 style: GoogleFonts.notoSerifSc(
                                   color: AppColors.inkBlack, 
                                   fontSize: isSmallScreen ? 12 : (isTablet ? 18 : 14), 
                                   fontWeight: FontWeight.bold
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
    
                       // 右上角: 竖排 "敌方"
                       Positioned(
                         top: isTablet ? 60 : 50,
                         right: isTablet ? 40 : 24,
                         child: Column(
                           children: [
                             Text('敌', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack.withValues(alpha: 0.3), fontSize: isSmallScreen ? 20 : (isTablet ? 32 : 24))),
                             Text('方', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack.withValues(alpha: 0.3), fontSize: isSmallScreen ? 20 : (isTablet ? 32 : 24))),
                           ],
                         ),
                       ),
                       
                       // 中央: 敌人形象与血条
                       SlideTransition(
                         position: _enemyOffsetAnim,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             SizedBox(height: isTablet ? 60 : 40),
                             // 敌人文字 (呼吸动画)
                             Text(
                               enemyChar,
                               style: GoogleFonts.maShanZheng(
                                 fontSize: isSmallScreen ? 80 : (isTablet ? 160 : 120), 
                                 color: AppColors.inkBlack, 
                                 shadows: [
                                   Shadow(color: AppColors.inkRed.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 5))
                                 ],
                               ),
                             ).animate(onPlay: (c) => c.repeat(reverse: true))
                              .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 3000.ms),
                             
                             SizedBox(height: isTablet ? 30 : 20),
      
                             // 血条 (水墨风格)
                             SizedBox(
                               width: isSmallScreen ? 160 : (isTablet ? 300 : 200),
                               child: Column(
                                 children: [
                                   Stack(
                                     children: [
                                       Container(height: isTablet ? 10 : 6, color: AppColors.inkBlack.withValues(alpha: 0.1)),
                                       FractionallySizedBox(
                                         widthFactor: enemyHp / maxEnemyHp,
                                         child: Container(
                                           height: isTablet ? 10 : 6,
                                           color: AppColors.inkRed,
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: isTablet ? 8 : 4),
                                   Text('$enemyHp / $maxEnemyHp', style: GoogleFonts.notoSerifSc(color: AppColors.inkBlack.withValues(alpha: 0.6), fontSize: isTablet ? 16 : 12)),
                                 ],
                               ),
                             ),
                             
                             // 状态列表
                            if (enemyStatuses.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: isTablet ? 24.0 : 16.0),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: isTablet ? 12 : 8,
                                  children: enemyStatuses.entries.map((entry) => Container(
                                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8, vertical: isTablet ? 6 : 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.inkRed),
                                      borderRadius: BorderRadius.circular(4),
                                      color: AppColors.bgPaper,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(_getStatusIcon(entry.key), size: isTablet ? 20 : 14, color: AppColors.inkRed),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${entry.key} ${entry.value}', 
                                          style: GoogleFonts.notoSerifSc(color: AppColors.inkRed, fontSize: isTablet ? 16 : 12, fontWeight: FontWeight.bold)
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                                ),
                              ),
                          ],
                        ),
                       ),
                    ],
                  ),
                ),
              ),
   
              // === 玩家区域 (Middle) ===
              Expanded(
                flex: 3,
                child: SizedBox( // Changed from Container with color to SizedBox
                  width: double.infinity,
                  // color: AppColors.bgPaper, // Removed to show background gradient
                  child: Stack(
                    children: [
                      // 左上角: 竖排 "绘师"
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Column(
                          children: [
                             Text('绘', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack.withValues(alpha: 0.3), fontSize: isSmallScreen ? 20 : (isTablet ? 32 : 24))),
                             Text('师', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack.withValues(alpha: 0.3), fontSize: isSmallScreen ? 20 : (isTablet ? 32 : 24))),
                          ],
                        ),
                      ),
    
                      // 玩家护盾显示
                      if (playerShield > 0)
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.elementMetal),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.shield, color: AppColors.elementMetal, size: isTablet ? 20 : 14),
                                const SizedBox(width: 4),
                                Text('护盾 $playerShield', style: GoogleFonts.notoSerifSc(color: AppColors.elementMetal, fontSize: isSmallScreen ? 10 : (isTablet ? 16 : 12), fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      
                      // 中央区域: 玩家形象与资源
                      Center(
                        child: SlideTransition(
                          position: _playerOffsetAnim,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               // 玩家形象
                               Text(
                                 '我', 
                                 style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 48 : (isTablet ? 80 : 56), color: AppColors.woodDark),
                               ),
                               
                               SizedBox(width: isTablet ? 48 : 32),
                               
                               // 资源条
                               Column(
                                 mainAxisSize: MainAxisSize.min,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   // 精神 (Sanity)
                                   Row(
                                     children: [
                                       Text('神', style: GoogleFonts.maShanZheng(color: AppColors.woodLight, fontSize: isSmallScreen ? 14 : (isTablet ? 24 : 16))),
                                       const SizedBox(width: 8),
                                       SizedBox(
                                         width: isSmallScreen ? 100 : (isTablet ? 180 : 120),
                                         height: isTablet ? 10 : 6,
                                         child: Stack(
                                           children: [
                                             Container(color: AppColors.inkBlack.withValues(alpha: 0.1)),
                                             FractionallySizedBox(
                                               widthFactor: (player?.sanity ?? 1) / (player?.maxSanity ?? 1),
                                               child: Container(color: AppColors.woodDark),
                                             ),
                                           ],
                                         ),
                                       ),
                                       const SizedBox(width: 8),
                                       Text('${player?.sanity}', style: GoogleFonts.notoSerifSc(color: AppColors.woodLight, fontSize: isSmallScreen ? 10 : (isTablet ? 16 : 12))),
                                     ],
                                   ),
                                   SizedBox(height: isTablet ? 16 : 12),
                                   // 墨魂 (Ink)
                                   Row(
                                     children: [
                                       Text('墨', style: GoogleFonts.maShanZheng(color: AppColors.woodLight, fontSize: isSmallScreen ? 14 : (isTablet ? 24 : 16))),
                                       const SizedBox(width: 8),
                                       SizedBox(
                                         width: isSmallScreen ? 100 : (isTablet ? 180 : 120),
                                         height: isTablet ? 10 : 6,
                                         child: Stack(
                                           children: [
                                             Container(color: AppColors.inkBlack.withValues(alpha: 0.1)),
                                             FractionallySizedBox(
                                               widthFactor: ((player?.ink ?? 0) / 100).clamp(0.0, 1.0),
                                               child: Container(color: AppColors.inkBlack),
                                             ),
                                           ],
                                         ),
                                       ),
                                        const SizedBox(width: 8),
                                       Text('${player?.ink}', style: GoogleFonts.notoSerifSc(color: AppColors.woodLight, fontSize: isSmallScreen ? 10 : (isTablet ? 16 : 12))),
                                     ],
                                   ),
                                 ],
                               ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // === 手牌区域 (Bottom) ===
              Container(
                height: handAreaHeight, 
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2D1B18), Color(0xFF1A0F0D)],
                  ),
                  border: const Border(top: BorderSide(color: AppColors.woodLight, width: 4)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, -2))]
                ),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  children: [
                    // 战斗日志
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 8),
                      alignment: Alignment.center,
                      child: Text(
                        _battleLog,
                        style: GoogleFonts.notoSerifSc(color: const Color(0xFFFFF8E1), fontSize: isSmallScreen ? 12 : (isTablet ? 18 : 14), fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    // 卡牌列表区域
                    Expanded(
                      child: Row(
                        children: [
                          // 牌堆 (左)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.style, color: Colors.white24, size: isTablet ? 24 : 20),
                              const SizedBox(height: 4),
                              Text('${drawPile.length}', style: GoogleFonts.notoSerifSc(color: Colors.white24, fontSize: isTablet ? 14 : 12)),
                              Text('牌堆', style: GoogleFonts.notoSerifSc(color: Colors.white12, fontSize: isTablet ? 12 : 10)),
                            ],
                          ),
                          SizedBox(width: isTablet ? 24 : 16),
                          
                          // 手牌 (横向滚动)
                          Expanded(
                            child: hand.isEmpty 
                              ? Center(child: Text('手牌空空如也', style: GoogleFonts.notoSerifSc(color: Colors.white24, fontSize: isTablet ? 16 : 14)))
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: hand.length,
                                  separatorBuilder: (_, __) => SizedBox(width: isTablet ? 16 : 12),
                                  itemBuilder: (context, index) {
                                    return _buildBambooCard(hand[index], isSmallScreen, isTablet);
                                  },
                                ),
                          ),
                          
                          SizedBox(width: isTablet ? 24 : 16),
                          // 弃牌堆 (右)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline, color: Colors.white24, size: isTablet ? 24 : 20),
                              const SizedBox(height: 4),
                              Text('${discardPile.length}', style: GoogleFonts.notoSerifSc(color: Colors.white24, fontSize: isTablet ? 14 : 12)),
                              Text('弃牌', style: GoogleFonts.notoSerifSc(color: Colors.white12, fontSize: isTablet ? 12 : 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    // 底部按钮区域
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 遁走按钮
                        TextButton.icon(
                          onPressed: () {
                             widget.gameService.damageSanity(10);
                             Navigator.pushReplacement(
                               context,
                               MaterialPageRoute(
                                 builder: (_) => BattleResultScreen(
                                   isVictory: false,
                                   gameService: widget.gameService,
                                   sanityCost: 10,
                                 )
                               )
                             );
                          },
                          icon: Icon(Icons.exit_to_app, color: Colors.white24, size: isTablet ? 20 : 16),
                          label: Text('遁走', style: GoogleFonts.notoSerifSc(color: Colors.white24, fontSize: isTablet ? 14 : 12)),
                        ),
                        
                        // 结束回合按钮
                        ElevatedButton.icon(
                          onPressed: _endTurn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.inkRed,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24, vertical: isTablet ? 16 : 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            elevation: 4,
                          ),
                          icon: Icon(Icons.hourglass_bottom, size: isTablet ? 24 : 18),
                          label: Text('结束回合', style: GoogleFonts.notoSerifSc(fontSize: isTablet ? 20 : 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          
          // Floating Texts Overlay
          IgnorePointer(
            child: Stack(
              children: _floatingTexts.map((ft) {
                final align = ft.target == BattleTarget.enemy 
                    ? const Alignment(0, -0.5) // Upper middle
                    : const Alignment(0, 0.2); // Lower middle
                    
                return Align(
                  alignment: align,
                  child: Text(
                    ft.text,
                     style: GoogleFonts.notoSerifSc(
                      color: ft.color, 
                      fontSize: isTablet ? 48 : 32, 
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(color: Colors.white, blurRadius: 2),
                        Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 4, offset: const Offset(2, 2))
                      ]
                    ),
                  ).animate(key: ValueKey(ft.id))
                   .moveY(begin: 0, end: isTablet ? -80 : -50, duration: 1000.ms, curve: Curves.easeOut)
                   .fadeOut(delay: 500.ms, duration: 500.ms),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 竹简卡牌样式
  Widget _buildBambooCard(WordCard card, bool isSmallScreen, bool isTablet) {
    return GestureDetector(
      onTap: () => _playCard(card),
      child: Container(
        width: isSmallScreen ? 56 : (isTablet ? 80 : 64), // 窄长条
        margin: EdgeInsets.only(bottom: isSmallScreen ? 6 : (isTablet ? 12 : 8)),
        // Padding moved to Positioned to ensure content area is constrained
        decoration: BoxDecoration(
          color: const Color(0xFFD7C484), // 竹简黄
          border: const Border(
            right: BorderSide(color: Color(0xFFBBA560), width: 1), // 立体感
            left: BorderSide(color: Colors.white24, width: 0.5),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(3, 3)),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 上下穿绳孔
            Positioned(top: 4, child: _buildBindingDot()),
            Positioned(bottom: 4, child: _buildBindingDot()),
            
            // 内容区域 (Constrained vertically)
            Positioned(
              top: isSmallScreen ? 12 : (isTablet ? 20 : 16), 
              bottom: isSmallScreen ? 24 : (isTablet ? 40 : 32), // Leave space for effect text
              left: 2,
              right: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 核心汉字
                  Text(
                    card.character,
                    style: GoogleFonts.maShanZheng(
                      fontSize: isSmallScreen ? 24 : (isTablet ? 36 : 28), // Slightly smaller to prevent overflow
                      color: const Color(0xFF3E2723),
                      shadows: [
                        Shadow(
                          color: _getElementColor(card.element).withValues(alpha: 0.4),
                          blurRadius: 10,
                        )
                      ]
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 4 : (isTablet ? 12 : 8)),
                  
                  // 竖排名称 (Use Expanded + FittedBox to handle long names)
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: card.name.split('').map((char) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            char, 
                            style: GoogleFonts.notoSerifSc(
                              fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14), 
                              fontWeight: FontWeight.w900, 
                              color: Colors.black87,
                              shadows: [
                                const Shadow(color: Colors.white30, offset: Offset(0, 1), blurRadius: 0)
                              ]
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 效果提示
            if (card.effects.isNotEmpty)
              Positioned(
                bottom: isSmallScreen ? 8 : (isTablet ? 16 : 12),
                child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                   decoration: BoxDecoration(
                     color: Colors.black.withValues(alpha: 0.6),
                     borderRadius: BorderRadius.circular(4)
                   ),
                   child: Text(
                     '${card.effects.first.value}', // Only number is fine
                     style: GoogleFonts.notoSerifSc(color: Colors.white, fontSize: isSmallScreen ? 8 : 10, fontWeight: FontWeight.bold),
                   ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildBindingDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFF3E2723).withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getElementColor(ElementType type) {
    switch (type) {
      case ElementType.fire: return AppColors.elementFire;
      case ElementType.water: return AppColors.elementWater;
      case ElementType.wood: return AppColors.elementWood;
      case ElementType.metal: return AppColors.elementMetal;
      case ElementType.earth: return AppColors.elementEarth;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case '灼烧': return Icons.local_fire_department;
      case '中毒': return Icons.coronavirus; // Or bubble_chart
      case '虚弱': return Icons.broken_image;
      case '易伤': return Icons.heart_broken;
      case '潮湿': return Icons.water_drop;
      default: return Icons.circle;
    }
  }
}

enum BattleTarget { player, enemy }

class FloatingText {
  final String id;
  final String text;
  final BattleTarget target;
  final Color color;

  FloatingText({
    required this.id,
    required this.text,
    required this.target,
    required this.color,
  });
}
