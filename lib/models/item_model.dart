import 'dart:math';

enum ItemType {
  consumable, // 消耗品
  material,   // 材料
  special,    // 特殊物品
}

enum ItemEffect {
  healHp,        // 恢复生命
  boostAttack,   // 提升攻击
  boostDefense,  // 提升防御
  boostSpeed,    // 提升速度
  evolveMaterial,// 进化材料
  rareParts,     // 稀有部位
}

class Item {
  final String id;
  final String name;
  final String description;
  final String icon;
  final ItemType type;
  final ItemEffect? effect;
  final int value;
  final int rarity; // 1-5, 5为最稀有

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    this.effect,
    required this.value,
    required this.rarity,
  });
}

class ItemStack {
  final Item item;
  int quantity;

  ItemStack({
    required this.item,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
    'itemId': item.id,
    'quantity': quantity,
  };

  factory ItemStack.fromJson(Map<String, dynamic> json, Item item) {
    return ItemStack(
      item: item,
      quantity: json['quantity'] ?? 1,
    );
  }
}

class ItemDatabase {
  static final Map<String, Item> items = {
    // 消耗品
    'heal_potion': Item(
      id: 'heal_potion',
      name: '回灵丹',
      description: '恢复异兽100点生命值',
      icon: '💊',
      type: ItemType.consumable,
      effect: ItemEffect.healHp,
      value: 100,
      rarity: 1,
    ),
    'great_heal_potion': Item(
      id: 'great_heal_potion',
      name: '大回灵丹',
      description: '恢复异兽300点生命值',
      icon: '💎',
      type: ItemType.consumable,
      effect: ItemEffect.healHp,
      value: 300,
      rarity: 3,
    ),
    'attack_boost': Item(
      id: 'attack_boost',
      name: '强攻丹',
      description: '永久提升异兽5点攻击力',
      icon: '⚔️',
      type: ItemType.consumable,
      effect: ItemEffect.boostAttack,
      value: 5,
      rarity: 2,
    ),
    'defense_boost': Item(
      id: 'defense_boost',
      name: '铁壁丹',
      description: '永久提升异兽5点防御力',
      icon: '🛡️',
      type: ItemType.consumable,
      effect: ItemEffect.boostDefense,
      value: 5,
      rarity: 2,
    ),
    'speed_boost': Item(
      id: 'speed_boost',
      name: '疾风丹',
      description: '永久提升异兽5点速度',
      icon: '💨',
      type: ItemType.consumable,
      effect: ItemEffect.boostSpeed,
      value: 5,
      rarity: 2,
    ),

    // 材料
    'dragon_scale': Item(
      id: 'dragon_scale',
      name: '龙鳞',
      description: '龙的鳞片，可用于进化千年异兽',
      icon: '🐉',
      type: ItemType.material,
      effect: ItemEffect.evolveMaterial,
      value: 1,
      rarity: 4,
    ),
    'phoenix_feather': Item(
      id: 'phoenix_feather',
      name: '凤羽',
      description: '凤凰的羽毛，可用于进化千年异兽',
      icon: '🪶',
      type: ItemType.material,
      effect: ItemEffect.evolveMaterial,
      value: 1,
      rarity: 4,
    ),
    'spirit_essence': Item(
      id: 'spirit_essence',
      name: '精元',
      description: '凝聚的灵气精华',
      icon: '✨',
      type: ItemType.material,
      effect: ItemEffect.rareParts,
      value: 1,
      rarity: 3,
    ),

    // 特殊物品
    'beast_egg_common': Item(
      id: 'beast_egg_common',
      name: '凡品异兽蛋',
      description: '有几率孵化出百年异兽',
      icon: '🥚',
      type: ItemType.special,
      value: 1,
      rarity: 1,
    ),
    'beast_egg_rare': Item(
      id: 'beast_egg_rare',
      name: '稀有异兽蛋',
      description: '有几率孵化出千年异兽',
      icon: '🥚',
      type: ItemType.special,
      value: 1,
      rarity: 3,
    ),
    'beast_egg_epic': Item(
      id: 'beast_egg_epic',
      name: '传说异兽蛋',
      description: '有几率孵化出万年异兽',
      icon: '🥚',
      type: ItemType.special,
      value: 1,
      rarity: 5,
    ),
  };

  static Item? getById(String id) {
    return items[id];
  }

  static List<Item> getAll() {
    return items.values.toList();
  }

  static List<Item> getByType(ItemType type) {
    return items.values.where((item) => item.type == type).toList();
  }

  static List<Item> getByRarity(int rarity) {
    return items.values.where((item) => item.rarity == rarity).toList();
  }
}

class Inventory {
  final Map<String, ItemStack> items;

  Inventory({Map<String, ItemStack>? items}) : items = items ?? {};

  int get itemCount => items.values.fold(0, (sum, stack) => sum + stack.quantity);

  bool hasItem(String itemId, {int quantity = 1}) {
    final stack = items[itemId];
    return stack != null && stack.quantity >= quantity;
  }

  bool removeItem(String itemId, {int quantity = 1}) {
    final stack = items[itemId];
    if (stack == null || stack.quantity < quantity) {
      return false;
    }

    if (stack.quantity == quantity) {
      items.remove(itemId);
    } else {
      stack.quantity -= quantity;
    }
    return true;
  }

  bool addItem(String itemId, {int quantity = 1}) {
    final item = ItemDatabase.getById(itemId);
    if (item == null) return false;

    final existing = items[itemId];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      items[itemId] = ItemStack(item: item, quantity: quantity);
    }
    return true;
  }

  List<ItemStack> getAllItems() {
    return items.values.toList()
      ..sort((a, b) => b.item.rarity.compareTo(a.item.rarity));
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  factory Inventory.fromJson(Map<String, dynamic> json) {
    final itemsMap = <String, ItemStack>{};
    final itemsJson = json['items'] as Map<String, dynamic>? ?? {};

    itemsJson.forEach((itemId, stackJson) {
      final item = ItemDatabase.getById(itemId);
      if (item != null) {
        itemsMap[itemId] = ItemStack.fromJson(
          stackJson as Map<String, dynamic>,
          item,
        );
      }
    });

    return Inventory(items: itemsMap);
  }

  Inventory copyWith() {
    return Inventory(
      items: Map.from(items),
    );
  }
}

class RewardGenerator {
  static final Random _random = Random();

  static String generateRandomItem({int maxRarity = 3}) {
    final allItems = ItemDatabase.getAll();
    final availableItems = allItems
        .where((item) => item.rarity <= maxRarity)
        .toList();

    if (availableItems.isEmpty) return 'heal_potion';

    // 根据稀有度加权随机
    final weights = availableItems.map((item) {
      return (6 - item.rarity) * (6 - item.rarity); // 稀有度越高，权重越低
    }).toList();

    final totalWeight = weights.reduce((a, b) => a + b);
    var randomValue = _random.nextInt(totalWeight);
    int selectedIndex = 0;

    for (int i = 0; i < weights.length; i++) {
      randomValue -= weights[i];
      if (randomValue <= 0) {
        selectedIndex = i;
        break;
      }
    }

    return availableItems[selectedIndex].id;
  }
}
