import 'part.dart';
import 'card.dart';
import 'skill.dart';
import 'item.dart';

class Player {
  int sanity;
  int ink;
  int maxSanity;
  int maxInk;
  int level;
  int currentExp;
  int maxExp;
  Map<PartType, Part?> parts;
  List<WordCard> deck;
  List<WordCard> hand;
  List<Part> inventory;
  List<Skill> skills;
  List<Item> items;
  List<String> contractedBeasts; // IDs of contracted beasts
  List<String> ownedRoles; // IDs of owned roles
  Map<int, String> formation; // Index 0-8 -> Role ID

  Player({
    this.sanity = 100,
    this.ink = 50,
    this.maxSanity = 100,
    this.maxInk = 100,
    this.level = 1,
    this.currentExp = 0,
    this.maxExp = 100,
    Map<PartType, Part?>? parts,
    List<WordCard>? deck,
    List<WordCard>? hand,
    List<Part>? inventory,
    List<Skill>? skills,
    List<Item>? items,
    List<String>? contractedBeasts,
    List<String>? ownedRoles,
    Map<int, String>? formation,
  })  : parts = parts ?? {},
        deck = deck ?? [],
        hand = hand ?? [],
        inventory = inventory ?? [],
        skills = skills ?? [],
        items = items ?? [],
        contractedBeasts = contractedBeasts ?? [],
        ownedRoles = ownedRoles ?? [],
        formation = formation ?? {};

  Map<String, dynamic> toJson() {
    return {
      'sanity': sanity,
      'ink': ink,
      'maxSanity': maxSanity,
      'maxInk': maxInk,
      'level': level,
      'currentExp': currentExp,
      'maxExp': maxExp,
      'parts': parts.map((k, v) => MapEntry(k.index.toString(), v?.toJson())),
      'deck': deck.map((e) => e.toJson()).toList(),
      'inventory': inventory.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'items': items.map((e) => e.toJson()).toList(),
      'contractedBeasts': contractedBeasts,
      'ownedRoles': ownedRoles,
      'formation': formation.map((k, v) => MapEntry(k.toString(), v)),
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> partsJson = json['parts'] ?? {};
    final Map<PartType, Part?> loadedParts = {};
    partsJson.forEach((key, value) {
      if (value != null) {
        loadedParts[PartType.values[int.parse(key)]] = Part.fromJson(value);
      }
    });
    
    final Map<String, dynamic> formationJson = json['formation'] ?? {};
    final Map<int, String> loadedFormation = {};
    formationJson.forEach((key, value) {
      loadedFormation[int.parse(key)] = value;
    });

    return Player(
      sanity: json['sanity'],
      ink: json['ink'],
      maxSanity: json['maxSanity'],
      maxInk: json['maxInk'],
      level: json['level'] ?? 1,
      currentExp: json['currentExp'] ?? 0,
      maxExp: json['maxExp'] ?? 100,
      parts: loadedParts,
      deck: (json['deck'] as List?)?.map((e) => WordCard.fromJson(e)).toList(),
      inventory: (json['inventory'] as List?)?.map((e) => Part.fromJson(e)).toList(),
      skills: (json['skills'] as List?)?.map((e) => Skill.fromJson(e)).toList(),
      items: (json['items'] as List?)?.map((e) => Item.fromJson(e)).toList(),
      contractedBeasts: (json['contractedBeasts'] as List?)?.map((e) => e.toString()).toList(),
      ownedRoles: (json['ownedRoles'] as List?)?.map((e) => e.toString()).toList(),
      formation: loadedFormation,
    );
  }

  // Aggregated Stats from Parts and Skills
  int get attack {
    int total = 0;
    // Base from Parts
    for (final part in parts.values) {
      if (part != null && part.stats.containsKey('attack')) {
        total += (part.stats['attack'] as int);
      }
    }
    // Add from Skills
    for (final skill in skills) {
      if (skill.statKey == 'attack') {
        total += skill.currentValue;
      }
    }
    return total;
  }

  int get defense {
    int total = 0;
    // Base from Parts
    for (final part in parts.values) {
      if (part != null && part.stats.containsKey('defense')) {
        total += (part.stats['defense'] as int);
      }
    }
    // Add from Skills
    for (final skill in skills) {
      if (skill.statKey == 'defense') {
        total += skill.currentValue;
      }
    }
    return total;
  }

  int get speed {
    int total = 0;
    // Base from Parts
    for (final part in parts.values) {
      if (part != null && part.stats.containsKey('speed')) {
        total += (part.stats['speed'] as int);
      }
    }
    // Add from Skills
    for (final skill in skills) {
      if (skill.statKey == 'speed') {
        total += skill.currentValue;
      }
    }
    return total;
  }

  // Get dynamic max values including skills
  int get calculatedMaxInk {
    int total = maxInk;
    for (final skill in skills) {
      if (skill.statKey == 'maxInk') {
        total += skill.currentValue;
      }
    }
    return total;
  }

  int get calculatedMaxSanity {
    int total = maxSanity;
    for (final skill in skills) {
      if (skill.statKey == 'maxSanity') {
        total += skill.currentValue;
      }
    }
    return total;
  }
}
