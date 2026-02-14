import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../models/part.dart';
import '../models/card.dart';
import '../utils/constants.dart';
import 'storage_service.dart';
import 'package:uuid/uuid.dart';

import '../models/skill.dart';
import '../models/item.dart';
import '../models/role.dart';

class GameService extends ChangeNotifier {
  Player? _player;
  final StorageService _storage = StorageService();
  bool _isLoading = true;

  Player? get player => _player;
  bool get isLoading => _isLoading;

  GameService() {
    _init();
  }

  Future<void> _init() async {
    _player = await _storage.loadPlayer();
    
    // Migration: Initialize skills for existing players if missing
    if (_player != null) {
      bool changed = false;
      if (_player!.skills.isEmpty) {
        _player!.skills = _getInitialSkills();
        changed = true;
      }
      
      // Migration: Give default roles if none
      if (_player!.ownedRoles.isEmpty) {
        _player!.ownedRoles = ['monkey_king', 'nezha', 'nuwa'];
        // Auto deploy first 3
        if (_player!.formation.isEmpty) {
             _player!.formation = {
               3: 'monkey_king',
               4: 'nezha',
               5: 'nuwa',
             };
        }
        changed = true;
      }
      
      if (changed) {
        await saveGame();
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  List<Skill> _getInitialSkills() {
    return [
      Skill(
        id: 'skill_attack',
        name: '朱雀之火',
        description: '以南明离火淬炼肉身，提升攻击力。',
        baseValue: 5,
        growthValue: 3,
        baseCost: 50,
        statKey: 'attack',
      ),
      Skill(
        id: 'skill_defense',
        name: '玄武之盾',
        description: '感悟玄武不动如山之意，提升防御力。',
        baseValue: 5,
        growthValue: 2,
        baseCost: 50,
        statKey: 'defense',
      ),
      Skill(
        id: 'skill_speed',
        name: '白虎之速',
        description: '白虎主杀伐，动若雷霆，提升速度。',
        baseValue: 2,
        growthValue: 1,
        baseCost: 50,
        statKey: 'speed',
      ),
      Skill(
        id: 'skill_ink',
        name: '青龙之息',
        description: '青龙主生机，绵延不绝，提升灵墨上限。',
        baseValue: 10,
        growthValue: 10,
        baseCost: 50,
        statKey: 'maxInk',
      ),
    ];
  }

  Future<void> createNewGame() async {
    _isLoading = true;
    notifyListeners();

    // specific initial parts
    final initialHead = Part(
      id: const Uuid().v4(),
      name: '凡人头颅',
      type: PartType.head,
      description: '一颗普通的头颅，毫无特异之处。',
      stats: {'vision': 10},
      origin: '人族',
    );
    
    // Initial deck
    final initialDeck = [
      const WordCard(
        id: '1',
        character: '火',
        element: ElementType.fire,
        name: '烈火',
        description: '造成30点伤害，并施加灼烧。',
        manaCost: 5,
        effects: [
          CardEffect(type: EffectType.damage, value: 30),
          CardEffect(type: EffectType.burn, value: 1),
        ],
      ),
      const WordCard(
        id: '2',
        character: '水',
        element: ElementType.water,
        name: '流水',
        description: '造成20点伤害，施加潮湿。',
        manaCost: 5,
        effects: [
          CardEffect(type: EffectType.damage, value: 20),
        ],
      ),
      const WordCard(
        id: '3',
        character: '木',
        element: ElementType.wood,
        name: '青木',
        description: '恢复10点理智。',
        manaCost: 5,
        effects: [
          CardEffect(type: EffectType.heal, value: 10),
        ],
      ),
      const WordCard(
        id: '4',
        character: '盾',
        element: ElementType.none,
        name: '石甲',
        description: '获得20点护盾。',
        manaCost: 5,
        effects: [
          CardEffect(type: EffectType.shield, value: 20),
        ],
      ),
      const WordCard(
        id: '5',
        character: '毒',
        element: ElementType.none,
        name: '断肠',
        description: '造成10点伤害，施加3层中毒。',
        manaCost: 5,
        effects: [
          CardEffect(type: EffectType.damage, value: 10),
          CardEffect(type: EffectType.poison, value: 3),
        ],
      ),
      const WordCard(
        id: '6',
        character: '破',
        element: ElementType.none,
        name: '贯云',
        description: '造成15点伤害，施加2层易伤。',
        manaCost: 5,
        effects: [
          CardEffect(type: EffectType.damage, value: 15),
          CardEffect(type: EffectType.vulnerable, value: 2),
        ],
      ),
    ];

    // Initial Skills
    final initialSkills = _getInitialSkills();

    _player = Player(
      parts: {PartType.head: initialHead},
      deck: initialDeck,
      hand: [],
      inventory: [],
      skills: initialSkills,
      sanity: 100,
      ink: 50,
    );
    
    await _storage.savePlayer(_player!);
    _isLoading = false;
    notifyListeners();
  }

  Part generateRandomPart() {
    final types = PartType.values;
    final type = types[DateTime.now().microsecond % types.length];
    
    final adjectives = ['破碎的', '古老的', '被诅咒的', '神圣的', '生锈的'];
    final nouns = ['骨', '鳞', '羽', '皮', '晶'];
    
    final name = '${adjectives[DateTime.now().microsecond % adjectives.length]} ${nouns[DateTime.now().millisecond % nouns.length]}';
    
    return Part(
      id: const Uuid().v4(),
      name: name,
      type: type,
      description: '虚空中发现的神秘肢体。',
      stats: {
        'attack': (DateTime.now().microsecond % 10) + 1,
        'defense': (DateTime.now().millisecond % 10) + 1,
      },
      origin: '未知',
    );
  }

  void addPartToInventory(Part part) {
    updatePlayer((p) {
      p.inventory.add(part);
    });
  }

  Future<void> saveGame() async {
    if (_player != null) {
      await _storage.savePlayer(_player!);
    }
  }

  void updatePlayer(void Function(Player) updateFn) {
    if (_player != null) {
      updateFn(_player!);
      saveGame();
      notifyListeners();
    }
  }
  
  // Game Actions
  void consumeInk(int amount) {
    updatePlayer((p) {
      // Don't clamp to maxInk when consuming, otherwise if we have overflowed ink (from loot),
      // spending it would reset us down to maxInk.
      p.ink = (p.ink - amount).clamp(0, 999999999); 
    });
  }
  
  // Used for regeneration/potions - respects maxInk cap
  void restoreInk(int amount) {
    updatePlayer((p) {
      // Only restore up to maxInk. If already above maxInk (due to loot), don't reduce it, but don't add more.
      if (p.ink < p.maxInk) {
        p.ink = (p.ink + amount).clamp(0, p.maxInk);
      }
    });
  }

  // Used for loot/rewards - ignores maxInk cap (allows overflow)
  void gainInk(int amount) {
    updatePlayer((p) {
      p.ink += amount;
    });
  }

  void damageSanity(int amount) {
    updatePlayer((p) {
      p.sanity = (p.sanity - amount).clamp(0, p.maxSanity);
    });
  }
  
  void restoreSanity(int amount) {
    updatePlayer((p) {
      p.sanity = (p.sanity + amount).clamp(0, p.maxSanity);
    });
  }

  void equipPart(Part newPart) {
    updatePlayer((p) {
      // 1. Remove newPart from inventory
      p.inventory.removeWhere((part) => part.id == newPart.id);

      // 2. Check if slot is occupied
      final existingPart = p.parts[newPart.type];
      if (existingPart != null) {
        // 3. Move existing part to inventory
        p.inventory.add(existingPart);
      }

      // 4. Equip new part
      p.parts[newPart.type] = newPart;
    });
  }

  void unequipPart(PartType type) {
    updatePlayer((p) {
      final existingPart = p.parts[type];
      if (existingPart != null) {
        // 1. Move to inventory
        p.inventory.add(existingPart);
        // 2. Clear slot
        p.parts[type] = null;
      }
    });
  }

  // Skill System
  bool upgradeSkill(Skill skill) {
    bool success = false;
    updatePlayer((p) {
      // Find the skill in player's skills list to ensure we are modifying the correct instance
      final playerSkill = p.skills.firstWhere((s) => s.id == skill.id, orElse: () => skill);
      
      if (playerSkill.isMaxLevel) return;
      
      final cost = playerSkill.upgradeCost;
      if (p.ink >= cost) {
        p.ink -= cost;
        playerSkill.level++;
        
        // If skill increases maxInk/maxSanity, we should update the base values or current values?
        // Actually, Player.calculatedMaxInk handles the max value.
        // But if max increases, current ink stays same, which is fine.
        
        // However, if we upgrade Max Ink, we might want to fill the new capacity? 
        // No, usually max increases, current stays.
        
        success = true;
      }
    });
    return success;
  }

  // Item System
  void addItemToBag(Item newItem) {
    updatePlayer((p) {
      // Check if item exists (by ID)
      final existingIndex = p.items.indexWhere((i) => i.id == newItem.id);
      if (existingIndex != -1) {
        p.items[existingIndex].count += newItem.count;
      } else {
        p.items.add(newItem);
      }
    });
  }

  bool useItem(Item item) {
    bool used = false;
    updatePlayer((p) {
      final index = p.items.indexWhere((i) => i.id == item.id);
      if (index == -1) return;

      final actualItem = p.items[index];
      if (actualItem.count <= 0) return;

      // Apply effects
      switch (actualItem.effectType) {
        case ItemEffectType.healSanity:
           if (p.sanity < p.calculatedMaxSanity) {
             p.sanity = (p.sanity + actualItem.effectValue).clamp(0, p.calculatedMaxSanity);
             used = true;
           }
           break;
        case ItemEffectType.restoreInk:
           if (p.ink < p.calculatedMaxInk) {
             p.ink = (p.ink + actualItem.effectValue).clamp(0, p.calculatedMaxInk);
             used = true;
           }
           break;
        default:
           break;
      }

      if (used) {
        actualItem.count--;
        if (actualItem.count <= 0) {
          p.items.removeAt(index);
        }
      }
    });
    return used;
  }

  // Growth System
  bool gainExp(int amount) {
    bool leveledUp = false;
    updatePlayer((p) {
      p.currentExp += amount;
      while (p.currentExp >= p.maxExp) {
        p.currentExp -= p.maxExp;
        p.level++;
        p.maxExp = (p.level * 100 * 1.5).toInt(); // Simple scaling
        
        // Level Up Rewards
        p.maxSanity += 10;
        p.maxInk += 10;
        p.sanity = p.maxSanity; // Full restore on level up? Or just +10? Let's do full restore for "growth" feel.
        p.ink = p.maxInk;
        
        leveledUp = true;
      }
    });
    return leveledUp;
  }
}
