import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // HapticFeedback
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/card_data.dart';
import '../models/configs.dart';
import '../models/enums.dart';
import '../models/player_stats.dart';
import '../utils/game_logic.dart';
import '../utils/save_manager.dart';
import '../widgets/effect_layer.dart'; // ShakeWidget
import '../widgets/floating_text_layer.dart';
import 'level_up_screen.dart';
import 'shop_screen.dart';
import 'shrine_screen.dart';
import 'meta_store_screen.dart';
import 'achievements_screen.dart';
import 'alchemy_screen.dart';
import 'compendium_screen.dart';
import '../widgets/stat_bar.dart';
import '../utils/achievement_manager.dart';
import '../utils/alchemy_manager.dart';
import '../models/soul_model.dart';
import '../data/souls_data.dart';
import '../models/event_model.dart';
import '../data/events_data.dart';
import 'game_board.dart';
import 'main_menu.dart';
import 'splash_screen.dart';
import '../widgets/particle_layer.dart';
import '../utils/daily_login_manager.dart';
import 'level_screen.dart';
import 'daily_login_screen.dart';
import 'task_reward_screen.dart';
import 'event_screen.dart';
import 'game_over_screen.dart';
import 'settings_screen.dart';
import 'cultivation_screen.dart';
import '../widgets/background_wrapper.dart';

class GameContainer extends StatefulWidget {
  const GameContainer({super.key});

  @override
  State<GameContainer> createState() => _GameContainerState();
}

class _GameContainerState extends State<GameContainer>
    with TickerProviderStateMixin {
  GameState _gameState = GameState.splash;
  List<CardData> _cards = [];
  late PlayerStats _player;
  final List<FloatingTextData> _floatingTexts = [];
  int _textIdCounter = 0;
  Set<int> _reachableIndices = {};
  List<ShopItem> _shopItems = [];
  List<Perk> _levelUpOptions = [];
  bool _showFloorIntro = false;
  GameEvent? _currentEvent;
  double? _eventX;
  double? _eventY;

  // Meta Progression
  int _totalGold = 0;
  List<String> _unlockedPerks = [];
  bool _hasSave = false;
  
  // GameState extensions
  // Note: We can add new states to enum, but for now let's just use a bool overlay or existing state mechanism
  // Let's add 'taskReward' to GameState in models/enums.dart ideally, but here we can check if we want to modify enum.
  // Assuming we can't easily modify enum across files without reading it first, let's check enums.dart.
  // Actually, I'll just use a separate boolean or existing state if possible. 
  // Wait, I can modify enums.dart easily. Let's do that first.
  
  // Level System
  Map<int, int> _levelStars = {};

  // Effects
  Color? _flashColor;
  late AnimationController _shakeController;
  final GlobalKey<ParticleLayerState> _particleKey = GlobalKey();
  final List<GlobalKey> _cardKeys = List.generate(
    gridSize,
    (index) => GlobalKey(),
  );

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _player = initialPlayerStats.copyWith();
    _loadMetaProgress();
    AchievementManager.load();
    AlchemyManager.load(); // Load alchemy data
    _initDailyLogin();
  }

  Future<void> _initDailyLogin() async {
    await DailyLoginManager.checkLoginStatus();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _loadMetaProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final highScore = prefs.getInt('mythic_highscore') ?? 0;
    final totalGold = prefs.getInt('mythic_total_gold') ?? 0;
    final unlockedPerks = prefs.getStringList('mythic_perks') ?? [];
    final hasSave = await SaveManager.hasSave();

    final levelStarsJson = prefs.getString('mythic_level_stars');
    if (levelStarsJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(levelStarsJson);
      _levelStars = decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    }

    setState(() {
      _player.highScore = highScore;
      _totalGold = totalGold;
      _unlockedPerks = unlockedPerks;
      _hasSave = hasSave;
    });
  }

  Future<void> _continueGame() async {
    final data = await SaveManager.loadGame();
    if (data != null) {
      setState(() {
        _player = PlayerStats.fromJson(data['player']);
        _cards = (data['cards'] as List)
            .map((c) => CardData.fromJson(c))
            .toList();
        _gameState = GameState.values[data['gameState']];
      });
      _calculateReachable();
      _triggerFlash(Colors.green);
    }
  }

  Future<void> _autoSave() async {
    await SaveManager.saveGame(
      player: _player,
      cards: _cards,
      gameState: _gameState,
    );
  }

  Future<void> _saveMetaProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mythic_total_gold', _totalGold);
    await prefs.setStringList('mythic_perks', _unlockedPerks);

    final levelStarsJson = jsonEncode(_levelStars);
    await prefs.setString('mythic_level_stars', levelStarsJson);

    if (_player.score > _player.highScore) {
      await prefs.setInt('mythic_highscore', _player.score);
      setState(() {
        _player.highScore = _player.score;
      });
    }
  }

  void _checkAchievements({
    int kills = 0,
    int gold = 0,
    bool death = false,
  }) async {
    final newUnlocked = await AchievementManager.checkAchievements(
      player: _player,
      newKills: kills,
      newGold: gold,
      isDeath: death,
    );

    if (newUnlocked.isNotEmpty && mounted) {
      final size = MediaQuery.of(context).size;
      for (var ach in newUnlocked) {
        _addFloatingText(
          size.width / 2,
          size.height / 2 - 150,
          "🏆 ${ach.name}",
          "text-purple-300",
        );
        await Future.delayed(Duration(milliseconds: 500));
      }
      _triggerFlash(Colors.purpleAccent);
    }
  }

  // Logic
  int _getDynamicPower(PlayerStats stats) {
    int p = stats.power;
    if (stats.perks.contains('might')) p += 1;
    if (stats.classId == 'warrior') {
      final missing = max(0, stats.maxHp - stats.hp);
      p += (missing / 20).floor();
    }
    if (stats.weak > 0) {
      p = (p * 0.5).floor();
    }
    return p;
  }

  void _calculateReachable() {
    final heroIndex = _cards.indexWhere((c) => c.type == CardType.hero);
    if (heroIndex == -1) return;

    final Set<int> reachable = {};
    final row = heroIndex ~/ gridCols;
    final col = heroIndex % gridCols;

    final neighbors = [
      Point(row - 1, col),
      Point(row + 1, col),
      Point(row, col - 1),
      Point(row, col + 1),
    ];

    for (final n in neighbors) {
      if (n.x >= 0 && n.x < gridCols && n.y >= 0 && n.y < gridCols) {
        final neighborIdx = (n.x * gridCols + n.y).toInt();
        // Can interact with any neighbor? Yes, usually.
        // But usually only revealed ones? No, you tap to reveal/interact.
        reachable.add(neighborIdx);
      }
    }
    setState(() {
      _reachableIndices = reachable;
    });
  }

  void _selectClass(String classId) async {
    final cls = classes.firstWhere(
      (c) => c.id == classId,
      orElse: () => classes[0],
    );

    // Apply Meta Perks
    int bonusHp = _unlockedPerks.contains('start_hp') ? 10 : 0;
    int bonusPower = _unlockedPerks.contains('start_power') ? 1 : 0;
    int startingGold = _unlockedPerks.contains('start_gold') ? 50 : 0;

    // Apply Alchemy Elixir
    final elixir = await AlchemyManager.consumeActiveElixir();
    if (elixir != null) {
      if (elixir.effects.containsKey('start_max_hp')) {
        bonusHp += elixir.effects['start_max_hp'] as int;
      }
      if (elixir.effects.containsKey('start_power')) {
        bonusPower += elixir.effects['start_power'] as int;
      }
      if (elixir.effects.containsKey('start_gold')) {
        startingGold += elixir.effects['start_gold'] as int;
      }
      if (elixir.effects.containsKey('start_shield')) {
        // Shield logic might need to be applied after player creation or modify initial shield
        // Here we just add to the initial player stats later
      }

      // We will apply shield and xp after creating the player object

      if (mounted) {
        final size = MediaQuery.of(context).size;
        _addFloatingText(
          size.width / 2,
          size.height / 2,
          "药剂生效: ${elixir.name}!",
          "text-purple-400",
        );
      }
    }

    int bonusShield = 0;
    int bonusXp = 0;

    if (elixir != null) {
      if (elixir.effects.containsKey('start_shield')) {
        bonusShield += elixir.effects['start_shield'] as int;
      }
      if (elixir.effects.containsKey('start_xp')) {
        bonusXp += elixir.effects['start_xp'] as int;
      }
    }

    setState(() {
      _player = initialPlayerStats.copyWith(
        hp: cls.hp + bonusHp,
        maxHp: cls.hp + bonusHp,
        power: cls.power + bonusPower,
        shield: cls.shield + bonusShield,
        gold: startingGold,
        xp: bonusXp,
        classId: cls.id,
        highScore: _player.highScore,
      );
      _gameState = GameState.levelSelect;
    });
  }

  void _selectLevel(int levelId) {
    setState(() {
      _gameState = GameState.playing;
    });

    _loadFloor(1);
  }

  void _buyMetaPerk(String perkId, int cost) {
    if (_totalGold >= cost && !_unlockedPerks.contains(perkId)) {
      setState(() {
        _totalGold -= cost;
        _unlockedPerks.add(perkId);
      });
      _saveMetaProgress();
      _triggerFlash(Colors.yellow);
      final size = MediaQuery.of(context).size;
      _addFloatingText(
        size.width / 2,
        size.height / 2,
        "购买成功!",
        "text-yellow-400",
      );
    } else {
      _triggerShake();
    }
  }

  void _loadFloor(int floorNum) {
    final newCards = generateLevel(floorNum);

    // Set Center as Hero
    if (newCards.length > 4) {
      newCards[4] = CardData(
        id: 'hero',
        type: CardType.hero,
        value: 0,
        isFlipped: true,
        isRevealed: true,
        name: '你',
        icon: '🤠',
        rarity: Rarity.common,
      );
    }

    int shield = _player.shield;
    if (_player.relics.contains('stone')) shield += 15;
    if (_player.perks.contains('fortress')) shield += 15;

    setState(() {
      _cards = newCards;
      _player.floor = floorNum;
      _player.shield = shield;
      _gameState = GameState.playing;
      _showFloorIntro = true;
    });
    _calculateReachable();
    _autoSave();

    Future.delayed(Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _showFloorIntro = false);
    });
  }

  void _addFloatingText(double x, double y, String text, String colorName) {
    final id = _textIdCounter++;
    setState(() {
      _floatingTexts.add(
        FloatingTextData(id: id, x: x, y: y, text: text, color: colorName),
      );
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _floatingTexts.removeWhere((ft) => ft.id == id);
        });
      }
    });
  }

  void _triggerShake() {
    _shakeController.forward(from: 0.0);
  }

  void _triggerFlash(Color color) {
    setState(() => _flashColor = color);
    Future.delayed(
      Duration(milliseconds: 150),
      () => setState(() => _flashColor = null),
    );
  }

  void _checkDeath() {
    if (_player.hp <= 0) {
      // Accumulate gold
      _totalGold += _player.gold;
      _saveMetaProgress();
      _checkAchievements(death: true); // Check death achievements
      setState(() {
        _gameState = GameState.gameOver;
      });
      _autoSave();
    }
  }

  void _incrementCombo(int amount, double x, double y) {
    setState(() {
      _player.combo += amount;
      if (_player.combo > 0 && _player.combo % 5 == 0) {
        Future.delayed(Duration(milliseconds: 200), () {
          _addFloatingText(x, y - 50, "连击奖励! 精血上限 +1", "text-yellow-200");
          setState(() {
            _player.maxHp += 1;
            _player.hp += 1;
          });
        });
      }
    });
  }

  void _resetCombo() {
    if (_player.combo > 1) {
      final size = MediaQuery.of(context).size;
      _addFloatingText(
        size.width / 2,
        size.height / 2 - 50,
        "连击中断",
        "text-gray-400",
      );
    }
    setState(() => _player.combo = 0);
  }

  void _gainXp(int amount) {
    int newXp = _player.xp + amount;
    int newLevel = _player.level;
    int newMaxXp = _player.maxXp;
    bool didLevelUp = false;

    if (newXp >= newMaxXp) {
      newXp -= newMaxXp;
      newLevel += 1;
      newMaxXp = (newMaxXp * 1.3).floor();
      didLevelUp = true;
    }

    setState(() {
      _player.xp = newXp;
      _player.level = newLevel;
      _player.maxXp = newMaxXp;
    });

    if (didLevelUp) {
      Future.delayed(Duration(milliseconds: 500), _triggerLevelUp);
    }
  }

  void _triggerLevelUp() {
    final shuffled = List<Perk>.from(perks)..shuffle();
    final size = MediaQuery.of(context).size;
    _particleKey.currentState?.addLevelUp(size.width / 2, size.height / 2);

    setState(() {
      _levelUpOptions = shuffled.take(3).toList();
      _gameState = GameState.levelUp;
    });
    _triggerFlash(Colors.white);
  }

  void _selectPerk(Perk perk) {
    setState(() {
      _player.perks.add(perk.id);
      if (perk.id == 'thick_skin') {
        _player.maxHp += 15;
        _player.hp += 15;
      } else if (perk.id == 'divine') {
        _player.hp = _player.maxHp;
        _player.poison = 0;
        _player.weak = 0;
      }
      _gameState = GameState.playing;
    });
    final size = MediaQuery.of(context).size;
    _addFloatingText(
      size.width / 2,
      size.height / 2,
      "等级提升!",
      "text-yellow-200",
    );
  }

  // Card Interaction
  int? _activeCardIndex;
  CardData? _nextSpawnCard;

  void _moveHeroTo(int targetIndex) {
    HapticFeedback.lightImpact();
    final heroIndex = _cards.indexWhere((c) => c.type == CardType.hero);
    if (heroIndex != -1) {
      setState(() {
        _cards[targetIndex] = _cards[heroIndex];
        if (_nextSpawnCard != null) {
          _cards[heroIndex] = _nextSpawnCard!;
          _nextSpawnCard = null;
        } else {
          _cards[heroIndex] = generateSingleCard(_player.floor);
        }
      });
      _handleSummonerSpawn();
      _calculateReachable();
      _autoSave();
    }
  }

  Future<void> _onCardTap(CardData card, GlobalKey key) async {
    if (_gameState != GameState.playing || card.type == CardType.hero) return;

    final index = _cards.indexOf(card);
    if (!_reachableIndices.contains(index)) {
      _triggerShake();
      return;
    }

    _activeCardIndex = index;

    // Get Position
    final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final x = position.dx + box.size.width / 2;
    final y = position.dy;

    if (card.type == CardType.chest && _player.keys <= 0) {
      _addFloatingText(x, y, "已锁定! 需要钥匙", "text-gray-400");
      _triggerShake();
      HapticFeedback.heavyImpact();
      return;
    }

    // Flip if not flipped (should happen automatically via reachability but safety check)
    if (!card.isFlipped) {
      setState(() {
        _cards[index].isFlipped = true;
        int chargeGain = 10;
        if (_player.relics.contains('luck')) chargeGain += 5;
        if (_player.classId == 'mage') chargeGain += 3;
        _player.skillCharge = min(100, _player.skillCharge + chargeGain);
      });
      _autoSave();
    }

    // Status Effects (Burn)
    if (_player.burn > 0) {
      setState(() {
        _player.hp -= 1;
        _player.burn = max(0, _player.burn - 1);
      });
      _addFloatingText(x, y - 80, "灼烧！ -1", "text-orange-500");
      if (_player.hp <= 0) {
        _checkDeath();
        return;
      }
    }

    // Status Effects (Poison)
    if (_player.poison > 0) {
      int pDmg = _player.poison;
      setState(() {
        _player.hp -= pDmg;
        _player.poison = max(0, _player.poison - 1);
      });
      _addFloatingText(x, y - 90, "中毒！ -$pDmg", "text-green-500");
      if (_player.hp <= 0) {
        _checkDeath();
        return;
      }
    }

    // Process
    bool canMove = await _processCardEffect(card, index, x, y);

    if (canMove) {
      _moveHeroTo(index);
    } else {
      _autoSave(); // Save state even if didn't move (e.g. combat damage)
    }
  }

  void _handleSummonerSpawn() {
    for (int i = 0; i < _cards.length; i++) {
      final c = _cards[i];
      if (c.type == CardType.monster &&
          c.enemyType == EnemyType.summoner &&
          c.isFlipped) {
        if (Random().nextDouble() < 0.25) {
          // 25% chance
          // Find candidates to replace (Potions, Weapons, Shields, Treasures - things that are not Monsters/Keys/Exits)
          final candidates = <int>[];
          for (int j = 0; j < _cards.length; j++) {
            final t = _cards[j].type;
            if (t != CardType.hero &&
                t != CardType.monster &&
                t != CardType.key &&
                t != CardType.portal &&
                t != CardType.exit &&
                t != CardType.chest) {
              candidates.add(j);
            }
          }

          if (candidates.isNotEmpty) {
            final targetIdx = candidates[Random().nextInt(candidates.length)];
            setState(() {
              _cards[targetIdx] = generateSingleCard(_player.floor).copyWith(
                type: CardType.monster,
                enemyType: EnemyType.standard,
                value: (_player.floor * 2) + 3,
                name: "魔化软泥",
                icon: "🦠",
                rarity: Rarity.common,
                isFlipped: true, // Spawn revealed
              );
            });
            final size = MediaQuery.of(context).size;
            _addFloatingText(
              size.width / 2,
              size.height / 2 - 100,
              "被召唤！",
              "text-purple-300",
            );
          }
        }
      }
    }
  }

  Future<bool> _processCardEffect(
    CardData card,
    int index,
    double x,
    double y,
  ) async {
    // Add small delay for visual feedback of tap before action
    await Future.delayed(Duration(milliseconds: 150));

    switch (card.type) {
      case CardType.monster:
        return _handleCombat(card, index, x, y);
      case CardType.trap:
        return _handleTrap(card, x, y);
      case CardType.key:
        setState(() => _player.keys += 1);
        _addFloatingText(x, y, "发现钥匙", "text-yellow-100");
        _incrementCombo(1, x, y);
        return true;
      case CardType.chest:
        return _handleChest(card, x, y);
      case CardType.shrine:
        return _handleShrine(x, y);
      case CardType.event:
        return _handleEvent(card, x, y);
      case CardType.weapon:
        HapticFeedback.lightImpact();
        setState(() {
          _player.power += card.value;
          if (card.element != GameElement.none) {
            _player.currentElement = card.element;
          }
        });
        _addFloatingText(x, y, "+${card.value} 战力", "text-yellow-400");
        if (card.element != GameElement.none) {
          String eName = "";
          switch (card.element) {
            case GameElement.metal:
              eName = "金";
              break;
            case GameElement.wood:
              eName = "木";
              break;
            case GameElement.water:
              eName = "水";
              break;
            case GameElement.fire:
              eName = "火";
              break;
            case GameElement.earth:
              eName = "土";
              break;
            default:
              eName = "";
          }
          _addFloatingText(x, y - 20, "附魔: $eName", "text-cyan-300");
        }
        _incrementCombo(1, x, y);
        return true;
      case CardType.shield:
        HapticFeedback.lightImpact();
        setState(() => _player.shield += card.value);
        _addFloatingText(x, y, "+${card.value} 护身", "text-blue-400");
        _incrementCombo(1, x, y);
        return true;
      case CardType.material:
        HapticFeedback.lightImpact();
        await AlchemyManager.addMaterial(card.description ?? '', 1);
        setState(() {
          card.isFlipped = true;
        });
        _addFloatingText(x, y, "+1 ${card.name}", "text-green-400");
        _addFloatingText(x, y + 20, "已收集!", "text-white");
        return true;
      case CardType.potion:
        HapticFeedback.lightImpact();
        _particleKey.currentState?.addHeal(x, y);
        setState(() {
          final heal = min(card.value, _player.maxHp - _player.hp);
          _player.hp += heal;
        });
        _addFloatingText(x, y, "+${card.value} 精血", "text-green-400");
        _incrementCombo(1, x, y);
        return true;
      case CardType.treasure:
        HapticFeedback.lightImpact();
        int bonusGold = _player.relics.contains('midas')
            ? (card.value * 1.5).floor()
            : card.value;
        if (_player.perks.contains('greed')) {
          bonusGold = (bonusGold * 1.2).floor();
        }

        // Soul Effect: Gold Bonus
        if (_player.equippedSoulId != null) {
          final soul = allSouls.firstWhere(
            (s) => s.id == _player.equippedSoulId,
            orElse: () => allSouls[0],
          );
          if (soul.effectType == SoulEffectType.goldBonus) {
            bonusGold = (bonusGold * (1 + soul.effectValue)).floor();
          }
        }

        setState(() {
          _player.gold += bonusGold;
          _player.score += bonusGold;
        });
        _addFloatingText(x, y, "+$bonusGold 灵石", "text-yellow-300");
        _triggerFlash(Colors.yellow);
        _incrementCombo(1, x, y);
        _checkAchievements(gold: bonusGold); // Check Gold
        return true;
      case CardType.soul:
        HapticFeedback.mediumImpact();
        setState(() {
          _player.equippedSoulId =
              card.description; // We store soulId in description
        });
        final soulName = card.name;
        _addFloatingText(x, y, "已装备: $soulName", "text-purple-400");
        _addFloatingText(x, y + 25, "灵魂觉醒!", "text-white");
        _incrementCombo(1, x, y);
        return true;
      case CardType.portal:
        HapticFeedback.mediumImpact();
        final nextFloor = _player.floor + 1;
        _addFloatingText(x, y, "大荒突破", "text-blue-200");
        _checkAchievements(); // Check Floor
        Future.delayed(Duration(milliseconds: 600), () {
          if (nextFloor % 3 == 1 && nextFloor > 1) {
            _generateShop();
          } else {
            _loadFloor(nextFloor);
          }
        });
        return false; // Don't move hero, level will reset
      default:
        return true;
    }
  }

  bool _handleCombat(CardData monster, int index, double x, double y) {
    int effectivePower = _getDynamicPower(_player);
    int monsterPower = monster.value;

    // Resolve Soul
    Soul? soul;
    if (_player.equippedSoulId != null) {
      soul = allSouls.firstWhere(
        (s) => s.id == _player.equippedSoulId,
        orElse: () => allSouls[0],
      );
    }

    // Element Counter Logic
    if (_player.currentElement != GameElement.none &&
        monster.element != GameElement.none) {
      if (isElementCounter(_player.currentElement, monster.element)) {
        effectivePower = (effectivePower * 1.5).floor();
        _addFloatingText(x, y - 80, "属性克制!", "text-cyan-300");
      } else if (isElementCounter(monster.element, _player.currentElement)) {
        monsterPower = (monsterPower * 1.3).floor(); // Enemy gets stronger
        _addFloatingText(x, y - 80, "属性被克!", "text-red-300");
      }
    }

    // Ranged First Strike
    if (monster.enemyType == EnemyType.ranged) {
      int firstStrikeDmg = (monsterPower * 0.3).ceil();
      int s = _player.shield;
      if (s > 0) {
        int absorbed = min(s, firstStrikeDmg);
        s -= absorbed;
        firstStrikeDmg -= absorbed;
      }

      if (firstStrikeDmg > 0) {
        HapticFeedback.heavyImpact();
        setState(() {
          _player.hp -= firstStrikeDmg;
          _player.shield = s;
        });
        _addFloatingText(x, y - 60, "远程攻击! -$firstStrikeDmg", "text-red-400");
        _triggerFlash(Colors.redAccent);
        _checkDeath();
        if (_gameState == GameState.gameOver) return false;
      }
    }

    if (_player.perks.contains('executioner') && monsterPower < 15) {
      effectivePower = 9999;
    }
    if (_player.perks.contains('sharpness') && Random().nextDouble() < 0.5) {
      effectivePower = (effectivePower * 1.5).floor();
      _addFloatingText(x, y - 40, "暴击!", "text-red-600");
    }
    // Soul Crit
    if (soul?.effectType == SoulEffectType.crit &&
        Random().nextDouble() < soul!.effectValue) {
      effectivePower = (effectivePower * 1.5).floor();
      _addFloatingText(x, y - 40, "灵魂暴击!", "text-purple-600");
    }

    // Tank Logic
    if (monster.enemyType == EnemyType.tank && monster.currentHp > 0) {
      setState(() {
        monster.currentHp = 0; // Break Shield
        // monster.value = (monster.value * 0.7).floor(); // Optional: weaken after break?
      });
      _addFloatingText(x, y, "护盾破碎!", "text-gray-300");
      _triggerShake();
      HapticFeedback.heavyImpact();
      return false; // Cannot move yet
    }

    if (effectivePower >= monsterPower) {
      // WIN
      HapticFeedback.mediumImpact();
      _particleKey.currentState?.addSlash(x, y); // Visual Slash Effect
      int goldReward = (monsterPower / 2).floor() + 5;
      if (monster.isBoss) goldReward *= 5;
      if (_player.relics.contains('midas')) {
        goldReward = (goldReward * 1.5).floor();
      }
      if (_player.perks.contains('greed')) {
        goldReward = (goldReward * 1.2).floor();
      }

      final xpGain = monster.isBoss ? 20 : 5;
      _gainXp(xpGain);

      setState(() {
        int newHp = _player.hp;
        if (_player.relics.contains('vampire')) {
          newHp = min(_player.maxHp, newHp + 3);
        }
        if (_player.classId == 'paladin') {
          newHp = min(_player.maxHp, newHp + 2);
        }
        if (_player.perks.contains('leech')) {
          newHp = min(_player.maxHp, newHp + 1);
        }

        // Soul Life Steal
        if (soul?.effectType == SoulEffectType.lifeSteal) {
          newHp = min(
            _player.maxHp,
            newHp + (monsterPower * soul!.effectValue).floor(),
          );
        }
        // Soul Regen
        if (soul?.effectType == SoulEffectType.regen) {
          newHp = min(_player.maxHp, newHp + soul!.effectValue.floor());
        }

        _player.gold += goldReward;
        _player.score += (goldReward * 2);
        _player.hp = newHp;
        _player.weak = max(0, _player.weak - 1);
      });

      // Soul Drop Chance
      if (Random().nextDouble() < 0.05) {
        // 5% chance
        final randomSoul = allSouls[Random().nextInt(allSouls.length)];
        _nextSpawnCard = CardData(
          id: 'soul_${DateTime.now().millisecondsSinceEpoch}',
          type: CardType.soul,
          value: 0,
          isFlipped: true,
          name: randomSoul.name,
          icon: randomSoul.icon,
          rarity: randomSoul.rarity,
          description: randomSoul.id, // Store ID in description
        );
        _addFloatingText(x, y - 100, "灵魂掉落!", "text-purple-300");
      }

      if (monster.affix == Affix.cursed) {
        setState(() => _player.weak += 3);
        _addFloatingText(x, y - 60, "诅咒! 虚弱", "text-purple-500");
      }
      if (monster.affix == Affix.burning) {
        setState(() => _player.burn += 5);
        _addFloatingText(x, y - 60, "灼烧!", "text-orange-500");
      }

      _addFloatingText(x, y - 20, "+$goldReward 灵石", "text-yellow-300");
      _addFloatingText(x, y - 10, "+$xpGain 灵力", "text-cyan-300");
      _particleKey.currentState?.addSparkles(x, y);
      _incrementCombo(1, x, y);
      return true; // Move allowed
    } else {
      // LOSE
      double dodgeChance = _player.classId == 'rogue' ? 0.2 : 0;

      // Soul Dodge
      if (soul?.effectType == SoulEffectType.dodge) {
        dodgeChance += soul!.effectValue;
      }

      if (Random().nextDouble() < dodgeChance) {
        _addFloatingText(x, y, "闪避!", "text-blue-400");
        _incrementCombo(1, x, y);
        return false; // Stay
      } else {
        final diff = monsterPower - effectivePower;
        int damage = diff;
        int newShield = _player.shield;
        if (newShield > 0) {
          final absorbed = min(newShield, damage);
          newShield -= absorbed;
          damage -= absorbed;
        }

        // Soul Reflect/Thorns
        if (soul?.effectType == SoulEffectType.thorns ||
            soul?.effectType == SoulEffectType.reflect) {
          int reflected = (damage * soul!.effectValue).floor();
          if (reflected > 0) {
            setState(() {
              final newValue = max(0, monster.value - reflected);
              _cards[index] = monster.copyWith(
                value: newValue,
              ); // Monster takes damage
            });
            _addFloatingText(x, y - 40, "反射 -$reflected", "text-purple-500");
          }
        }

        setState(() {
          _player.hp -= damage;
          _player.shield = newShield;
        });

        _triggerFlash(Colors.red);
        HapticFeedback.heavyImpact();
        _particleKey.currentState?.addExplosion(x, y, Colors.orange);
        _addFloatingText(x, y, "-$damage 精血", "text-red-500");
        _resetCombo();

        if (monster.affix == Affix.toxic) {
          setState(() => _player.poison += 3);
          _addFloatingText(x, y - 40, "中毒！", "text-green-500");
        }
        if (monster.affix == Affix.burning) {
          setState(() => _player.burn += 3);
          _addFloatingText(x, y - 40, "灼烧！", "text-orange-500");
        }

        _checkDeath();
        return false; // Stay and fight again
      }
    }
  }

  bool _handleTrap(CardData trap, double x, double y) {
    int damage = trap.value;
    int newShield = _player.shield;

    if (newShield > 0) {
      final absorbed = min(newShield, damage);
      newShield -= absorbed;
      damage -= absorbed;
    }

    if (damage > 0) {
      _triggerFlash(Colors.red);
      HapticFeedback.heavyImpact();
      _particleKey.currentState?.addExplosion(x, y, Colors.red);
      _addFloatingText(x, y, "-$damage 精血", "text-red-500");
      _resetCombo();
      setState(() {
        _player.hp -= damage;
        _player.shield = newShield;
      });
      _checkDeath();
    } else {
      HapticFeedback.lightImpact();
      _addFloatingText(x, y, "格挡", "text-blue-300");
      setState(() => _player.shield = newShield);
    }
    return true; // Trap triggered and removed/disarmed, so move allowed
  }

  bool _handleChest(CardData card, double x, double y) {
    HapticFeedback.mediumImpact();
    _particleKey.currentState?.addSparkles(x, y);
    setState(() => _player.keys -= 1);
    _addFloatingText(x, y - 20, "使用钥匙", "text-gray-400");

    final rand = Random().nextDouble();
    if (rand < 0.25 || _player.perks.contains('scavenger')) {
      final availableRelics = relics
          .where((r) => !_player.relics.contains(r.id))
          .toList();
      if (availableRelics.isNotEmpty) {
        final r = availableRelics[Random().nextInt(availableRelics.length)];
        setState(() => _player.relics.add(r.id));
        _addFloatingText(x, y, "发现 ${r.name}!", "text-purple-300");
      } else {
        final gold = card.value * 2;
        setState(() {
          _player.gold += gold;
          _player.score += gold;
        });
        _addFloatingText(x, y, "+$gold 灵石", "text-yellow-300");
      }
    } else {
      setState(() {
        _player.gold += card.value;
        _player.score += card.value;
      });
      _addFloatingText(x, y, "+${card.value} 灵石", "text-yellow-300");
    }
    _triggerFlash(Colors.yellow);
    _incrementCombo(1, x, y);
    return true;
  }

  Future<bool> _handleEvent(CardData card, double x, double y) async {
    final eventId = card.description;
    final event = allEvents.firstWhere(
      (e) => e.id == eventId,
      orElse: () => allEvents[0],
    );

    setState(() {
      _currentEvent = event;
      _eventX = x;
      _eventY = y;
      _gameState = GameState.event;
    });

    return false; // Wait for event screen
  }

  void _onEventOptionSelected(EventOption selectedOption) {
    if (_currentEvent == null || _eventX == null || _eventY == null) {
      setState(() => _gameState = GameState.playing);
      return;
    }

    final x = _eventX!;
    final y = _eventY!;

    // Probability Check
    final rand = Random().nextDouble();
    final bool success = rand < selectedOption.probability;
    final outcome = success
        ? selectedOption
        : (selectedOption.failureOption ?? selectedOption);

    String feedback = "";
    String style = "text-white";

    switch (outcome.type) {
      case EventOutcomeType.none:
        feedback = "什么也没发生";
        style = "text-gray-400";
        break;
      case EventOutcomeType.gainGold:
        int amount = outcome.value is int ? outcome.value : 0;
        setState(() => _player.gold += amount);
        feedback = "+$amount 灵石";
        style = "text-yellow-300";
        HapticFeedback.mediumImpact();
        break;
      case EventOutcomeType.loseGold:
        int amount = outcome.value is int ? outcome.value : 0;
        setState(() => _player.gold = max(0, _player.gold - amount));
        feedback = "-$amount 灵石";
        style = "text-red-400";
        HapticFeedback.heavyImpact();
        break;
      case EventOutcomeType.heal:
        int amount = outcome.value is int ? outcome.value : 0;
        setState(() => _player.hp = min(_player.maxHp, _player.hp + amount));
        _particleKey.currentState?.addHeal(x, y);
        feedback = "+$amount 精血";
        style = "text-green-400";
        HapticFeedback.mediumImpact();
        break;
      case EventOutcomeType.damage:
        int amount = outcome.value is int ? outcome.value : 0;
        int damage = amount;
        int newShield = _player.shield;
        if (newShield > 0) {
          final absorbed = min(newShield, damage);
          newShield -= absorbed;
          damage -= absorbed;
        }
        setState(() {
          _player.hp -= damage;
          _player.shield = newShield;
        });
        feedback = "-$damage 精血";
        style = "text-red-500";
        _triggerFlash(Colors.red);
        HapticFeedback.heavyImpact();
        if (_player.hp <= 0) {
          _checkDeath();
        }
        break;
      case EventOutcomeType.gainBuff:
        if (outcome.value == 'blessing_fox') {
          setState(() => _player.power += 1);
          feedback = "灵狐祝福 (战力 +1)";
        } else {
          setState(() => _player.power += 1);
          feedback = "战力提升！";
        }
        style = "text-blue-300";
        HapticFeedback.mediumImpact();
        break;
      case EventOutcomeType.gainItem:
      case EventOutcomeType.gainCurse:
      case EventOutcomeType.spawnMonster:
      case EventOutcomeType.trade:
        feedback = "效果已生效";
        HapticFeedback.mediumImpact();
        break;
    }

    if (feedback.isNotEmpty) {
      _addFloatingText(x, y, feedback, style);
    }

    setState(() {
      _gameState = GameState.playing;
    });

    if (_activeCardIndex != null) {
      _moveHeroTo(_activeCardIndex!);
    }
  }

  bool _handleShrine(double x, double y) {
    setState(() => _gameState = GameState.shrine);
    return false; // Wait for dialog
  }

  void _handleShrineOption(String option) {
    if (_activeCardIndex == null) {
      setState(() => _gameState = GameState.playing);
      return;
    }

    final size = MediaQuery.of(context).size;
    final x = size.width / 2;
    final y = size.height / 2;

    bool effectApplied = false;

    if (option == 'pray') {
      if (_player.gold >= 50) {
        setState(() => _player.gold -= 50);
        final rand = Random().nextDouble();
        if (rand < 0.7) {
          // Success
          final buff = Random().nextBool() ? 'atk' : 'maxhp';
          if (buff == 'atk') {
            HapticFeedback.mediumImpact();
            setState(() => _player.power += 2);
            _addFloatingText(x, y, "仙缘：攻击 +2", "text-blue-300");
          } else {
            HapticFeedback.mediumImpact();
            setState(() {
              _player.maxHp += 10;
              _player.hp += 10;
            });
            _addFloatingText(x, y, "仙缘：最大精血 +10", "text-blue-300");
          }
        } else {
          HapticFeedback.lightImpact();
          _addFloatingText(x, y, "祈祷未得到天道回应", "text-gray-400");
        }
        effectApplied =
            true; // Consume shrine even if unanswered to prevent save-scumming
      }
    } else if (option == 'sacrifice') {
      final cost = (_player.maxHp * 0.25).ceil();
      if (_player.hp > cost) {
        HapticFeedback.heavyImpact();
        setState(() => _player.hp -= cost);
        // Reward
        final rand = Random().nextDouble();
        if (rand < 0.4) {
          // Relic
          final availableRelics = relics
              .where((r) => !_player.relics.contains(r.id))
              .toList();
          if (availableRelics.isNotEmpty) {
            final r = availableRelics[Random().nextInt(availableRelics.length)];
            HapticFeedback.mediumImpact();
            setState(() => _player.relics.add(r.id));
            _addFloatingText(x, y, "获得 ${r.name}", "text-purple-300");
          } else {
            HapticFeedback.mediumImpact();
            setState(() => _player.gold += 200);
            _addFloatingText(x, y, "+200 灵石", "text-yellow-300");
          }
        } else if (rand < 0.7) {
          // Perk (Current run only? No, perks are permanent in this code context? No, player perks are for run)
          // Actually _player.perks are current run perks.
          // Let's give a random perk.
          final availablePerks = perks
              .where((p) => !_player.perks.contains(p.id))
              .toList();
          if (availablePerks.isNotEmpty) {
            final p = availablePerks[Random().nextInt(availablePerks.length)];
            HapticFeedback.mediumImpact();
            setState(() => _player.perks.add(p.id));
            _addFloatingText(x, y, "天赋：${p.name}", "text-cyan-300");
          } else {
            setState(() => _player.gold += 200);
            _addFloatingText(x, y, "+200 灵石", "text-yellow-300");
          }
        } else {
          // Gold
          setState(() => _player.gold += 300);
          _addFloatingText(x, y, "+300 灵石", "text-yellow-300");
        }
        effectApplied = true;
      }
    } else if (option == 'leave') {
      setState(() => _gameState = GameState.playing);
      return; // Do nothing
    }

    setState(() => _gameState = GameState.playing);

    if (effectApplied) {
      _moveHeroTo(_activeCardIndex!);
    }
  }

  void _useSkill() {
    if (_player.skillCharge < 100) {
      _triggerShake();
      return;
    }

    _particleKey.currentState?.addExplosion(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
      Colors.purpleAccent,
    );
    HapticFeedback.heavyImpact();
    _triggerFlash(Colors.purpleAccent);

    setState(() => _player.skillCharge = 0);
    _triggerFlash(Colors.purpleAccent);
    final size = MediaQuery.of(context).size;
    _addFloatingText(
      size.width / 2,
      size.height / 2,
      "神通已激活！",
      "text-purple-400",
    );

    switch (_player.classId) {
      case 'warrior':
        setState(() => _player.shield += 25);
        _addFloatingText(
          size.width / 2,
          size.height / 2 + 30,
          "+25 护身",
          "text-blue-400",
        );
        break;
      case 'paladin':
        setState(() => _player.hp = min(_player.maxHp, _player.hp + 30));
        _addFloatingText(
          size.width / 2,
          size.height / 2 + 30,
          "+30 精血",
          "text-green-400",
        );
        break;
      case 'rogue':
        final unrevealedIndices = _cards
            .asMap()
            .entries
            .where((e) => !e.value.isFlipped && !e.value.isRevealed)
            .map((e) => e.key)
            .toList();
        unrevealedIndices.shuffle();
        final toReveal = unrevealedIndices.take(3).toSet();
        setState(() {
          for (int i = 0; i < _cards.length; i++) {
            if (toReveal.contains(i)) _cards[i].isRevealed = true;
          }
        });
        _addFloatingText(
          size.width / 2,
          size.height / 2 + 30,
          "已探测区域",
          "text-yellow-200",
        );
        break;
      case 'mage':
        int hitCount = 0;
        for (int i = 0; i < _cards.length; i++) {
          if (_cards[i].type == CardType.monster && _cards[i].value > 0) {
            final renderBox =
                _cardKeys[i].currentContext?.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              final pos = renderBox.localToGlobal(Offset.zero);
              final cx = pos.dx + renderBox.size.width / 2;
              final cy = pos.dy + renderBox.size.height / 2;
              _particleKey.currentState?.addExplosion(cx, cy, Colors.purple);
              _addFloatingText(cx, cy, "-15 战力", "text-purple-400");
            }
            setState(() {
              _cards[i] = _cards[i].copyWith(
                value: max(0, _cards[i].value - 15),
              );
            });
            hitCount++;
          }
        }
        _addFloatingText(
          size.width / 2,
          size.height / 2 + 30,
          "五雷轰顶! ($hitCount 次命中)",
          "text-purple-400",
        );
        break;
    }
    _autoSave();
  }

  void _claimDailyReward(int gold, Map<String, int> items) {
    setState(() {
      _totalGold += gold;
    });

    // Add items to AlchemyManager
    items.forEach((key, count) {
      AlchemyManager.addMaterial(
        key,
        count,
      ); // Assuming addMaterial takes ID/Name.
      // Wait, AlchemyManager.addMaterial uses material name/description matching logic?
      // Let's check AlchemyManager.addMaterial signature.
      // In _processCardEffect: AlchemyManager.addMaterial(card.description ?? '', 1);
      // It seems it takes a String.
    });

    _saveMetaProgress();

    final size = MediaQuery.of(context).size;
    _addFloatingText(
      size.width / 2,
      size.height / 2,
      "签到奖励领取成功!",
      "text-yellow-400",
    );
    _triggerFlash(Colors.yellow);
  }

  // Shop
  void _generateShop() {
    final items = <ShopItem>[];
    final floorFactor = _player.floor;
    final random = Random();

    items.add(
      ShopItem(
        id: 'potion_${DateTime.now().millisecondsSinceEpoch}',
        name: '大回元丹',
        type: 'heal',
        value: 50,
        cost: 40 + (floorFactor * 5),
        icon: '🍷',
        desc: '回复 50 精血',
      ),
    );

    items.add(
      ShopItem(
        id: 'key_${DateTime.now().millisecondsSinceEpoch}',
        name: '旧钥匙',
        type: 'key',
        value: 1,
        cost: 30 + (floorFactor * 2),
        icon: '🗝️',
        desc: '开启一个宝箱',
      ),
    );

    if (random.nextBool()) {
      items.add(
        ShopItem(
          id: 'atk_${DateTime.now().millisecondsSinceEpoch}',
          name: '淬火石',
          type: 'stat',
          value: 2,
          cost: 80 + (floorFactor * 10),
          icon: '🗡️',
          desc: '+2 攻击力',
        ),
      );
    } else {
      items.add(
        ShopItem(
          id: 'shield_${DateTime.now().millisecondsSinceEpoch}',
          name: '玄铁甲',
          type: 'stat',
          value: 25,
          cost: 50 + (floorFactor * 5),
          icon: '🛡️',
          desc: '+25 护身',
        ),
      );
    }

    final availableRelics = relics
        .where(
          (r) =>
              !_player.relics.contains(r.id) &&
              r.id != 'sharp' &&
              r.id != 'vitality',
        )
        .toList();
    if (availableRelics.isNotEmpty) {
      final r = availableRelics[random.nextInt(availableRelics.length)];
      items.add(
        ShopItem(
          id: r.id,
          name: r.name,
          type: 'relic',
          value: 0,
          cost: r.cost,
          icon: r.icon,
          desc: r.desc,
        ),
      );
    } else {
      items.add(
        ShopItem(
          id: 'maxhp_${DateTime.now().millisecondsSinceEpoch}',
          name: '气血本源',
          type: 'stat',
          value: 10,
          cost: 100,
          icon: '💗',
          desc: '+10 最大精血',
        ),
      );
    }

    setState(() {
      _shopItems = items;
      _gameState = GameState.shop;
    });
  }

  void _buyItem(ShopItem item) {
    if (item.isSold) return;
    if (_player.gold < item.cost) {
      final size = MediaQuery.of(context).size;
      _addFloatingText(
        size.width / 2,
        size.height / 2,
        "灵石不足!",
        "text-red-500",
      );
      _triggerShake();
      return;
    }

    setState(() {
      _player.gold -= item.cost;
      if (item.type == 'heal') {
        _player.hp = min(_player.maxHp, _player.hp + item.value);
        final size = MediaQuery.of(context).size;
        _particleKey.currentState?.addHeal(size.width / 2, size.height / 2);
      } else if (item.type == 'stat') {
        if (item.name == '淬火石') {
          _player.power += item.value;
        } else if (item.name == '玄铁甲') {
          _player.shield += item.value;
        } else if (item.name == '气血本源') {
          _player.maxHp += item.value;
        }
      } else if (item.type == 'relic') {
        _player.relics.add(item.id);
      } else if (item.type == 'key') {
        _player.keys += 1;
      }
      item.isSold = true;
    });

    _triggerFlash(Colors.yellow);
    final size = MediaQuery.of(context).size;
    _addFloatingText(
      size.width / 2,
      size.height / 2,
      "购买成功!",
      "text-yellow-400",
    );
    _autoSave();
  }

  String _getBackgroundImage() {
    if (_gameState == GameState.splash) return 'assets/bg/Bg1.jpeg';
    if (_gameState == GameState.menu) return 'assets/bg/Bg2.jpeg';
    
    // Map floor to background image (Bg3 - Bg31)
    // We reserve Bg1 and Bg2 for Splash/Menu if we want, or just cycle all.
    // Let's cycle all 31.
    int index = ((_player.floor - 1) % 31) + 1;
    return 'assets/bg/Bg$index.jpeg';
  }

  @override
  Widget build(BuildContext context) {
    // Determine dynamic background color or overlay based on Flash
    // We can use a Stack for the entire screen

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        backgroundImage: _getBackgroundImage(),
        child: ShakeWidget(
          controller: _shakeController,
          child: Stack(
            children: [
              // Main Content
              _buildContent(),

              // Effects Layer
            if (_flashColor != null)
              IgnorePointer(
                child: Container(color: _flashColor!.withValues(alpha: 0.3)),
              ),

            // Particle Layer
            IgnorePointer(child: ParticleLayer(key: _particleKey)),

            // Floating Text Layer
            FloatingTextLayer(floatingTexts: _floatingTexts),

            // Dialogs
            if (_gameState == GameState.shop)
              ShopScreen(
                items: _shopItems,
                playerGold: _player.gold,
                onBuy: _buyItem,
                onClose: () => _loadFloor(_player.floor + 1),
              ),

            if (_gameState == GameState.shrine)
              ShrineScreen(
                playerGold: _player.gold,
                playerHp: _player.hp,
                playerMaxHp: _player.maxHp,
                onOptionSelected: _handleShrineOption,
              ),

            if (_gameState == GameState.achievements)
              AchievementsScreen(
                onClose: () => setState(() => _gameState = GameState.menu),
              ),

            if (_gameState == GameState.alchemy)
              AlchemyScreen(
                onClose: () => setState(() => _gameState = GameState.menu),
              ),

            if (_gameState == GameState.compendium)
              CompendiumScreen(
                onClose: () => setState(() => _gameState = GameState.menu),
                currentRelics: _player.relics,
              ),

            if (_gameState == GameState.metaStore)
              MetaStoreScreen(
                totalGold: _totalGold,
                unlockedPerks: _unlockedPerks,
                onBuy: _buyMetaPerk,
                onClose: () => setState(() => _gameState = GameState.menu),
              ),

            if (_gameState == GameState.settings)
              SettingsScreen(
                onClose: () => setState(() => _gameState = GameState.menu),
              ),

            if (_gameState == GameState.dailyLogin)
              DailyLoginScreen(
                onClose: () => setState(() => _gameState = GameState.menu),
                onClaim: _claimDailyReward,
              ),

            if (_gameState == GameState.taskReward)
              TaskRewardScreen(
                onClose: () => setState(() => _gameState = GameState.menu),
                onClaim: (rewards) {
                  // Reuse daily reward claim logic or similar
                  _claimDailyReward(0, rewards); 
                },
              ),

            if (_gameState == GameState.event && _currentEvent != null)
              EventScreen(
                event: _currentEvent!,
                onOptionSelected: _onEventOptionSelected,
              ),

            if (_gameState == GameState.cultivation)
              CultivationScreen(
                player: _player,
                onBack: () => setState(() => _gameState = _cards.isEmpty ? GameState.menu : GameState.playing),
              ),

            if (_gameState == GameState.levelUp)
              LevelUpScreen(options: _levelUpOptions, onSelect: _selectPerk),

            if (_gameState == GameState.gameOver)
              GameOverScreen(
                floor: _player.floor,
                score: _player.score,
                onRestart: () {
                  setState(() {
                    _gameState = GameState.menu;
                    _player = initialPlayerStats.copyWith(
                      highScore: _player.highScore,
                    );
                  });
                },
              ),

            if (_showFloorIntro)
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  color: Colors.black,
                  child: Text(
                    "大荒第 ${_player.floor} 层",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildContent() {
    if (_gameState == GameState.splash) {
      return SplashScreen(
        onFinish: () => setState(() => _gameState = GameState.menu),
      );
    }

    if (_gameState == GameState.menu || _gameState == GameState.classSelect) {
      return MainMenu(
        highScore: _player.highScore,
        totalGold: _totalGold,
        onClassSelect: _selectClass,
        onOpenStore: () => setState(() => _gameState = GameState.metaStore),
        onOpenAchievements: () =>
            setState(() => _gameState = GameState.achievements),
        onOpenCompendium: () =>
            setState(() => _gameState = GameState.compendium),
        onOpenAlchemy: () => setState(() => _gameState = GameState.alchemy),
        onOpenDailyLogin: () =>
            setState(() => _gameState = GameState.dailyLogin),
        onOpenSettings: () => setState(() => _gameState = GameState.settings),
        onOpenLevelSelect: () =>
            setState(() => _gameState = GameState.levelSelect),
        onOpenCultivation: () =>
            setState(() => _gameState = GameState.cultivation),
        onOpenTaskReward: () =>
            setState(() => _gameState = GameState.taskReward),
        hasSave: _hasSave,
        onContinue: _continueGame,
      );
    }

    if (_gameState == GameState.levelSelect) {
      return LevelScreen(
        highScore: _player.highScore,
        levelStars: _levelStars,
        onLevelSelect: _selectLevel,
        onClose: () => setState(() => _gameState = GameState.menu),
      );
    }

    if (_gameState != GameState.playing) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        StatBar(
          player: _player.copyWith(power: _getDynamicPower(_player)),
          onOpenSettings: () => setState(() => _gameState = GameState.settings),
          onOpenCompendium: () =>
              setState(() => _gameState = GameState.compendium),
          onOpenCultivation: () =>
              setState(() => _gameState = GameState.cultivation),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: GameBoard(
                        cards: _cards,
                        reachableIndices: _reachableIndices,
                        onCardTap: _onCardTap,
                        cardKeys: _cardKeys,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom Bar (Skill Button)
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _player.skillCharge >= 100 ? _useSkill : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _player.skillCharge >= 100
                      ? Colors.purple[700]
                      : Colors.grey[800],
                  disabledBackgroundColor: Colors.grey[800],
                ),
                child: Text(
                  _player.skillCharge >= 100
                      ? "神通就绪! (点击释放)"
                      : "神通充能中... ${_player.skillCharge}%",
                  style: TextStyle(
                    color: Colors.white,
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
