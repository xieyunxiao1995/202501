import 'package:flutter/material.dart';

enum CreativeModeType {
  treasureHunt,
  timeTrial,
  jokerRescue,
  shadowSolitaire,
  chainDeck,
  oneDrawSprint,
}

enum TimeTrialLimit { thirtySeconds, oneMinute, unlimited }

extension TimeTrialLimitDetails on TimeTrialLimit {
  String get label => switch (this) {
    TimeTrialLimit.thirtySeconds => '30 Seconds',
    TimeTrialLimit.oneMinute => '60 Seconds',
    TimeTrialLimit.unlimited => 'Unlimited',
  };

  int? get seconds => switch (this) {
    TimeTrialLimit.thirtySeconds => 30,
    TimeTrialLimit.oneMinute => 60,
    TimeTrialLimit.unlimited => null,
  };
}

enum CreativeSection { featured, speed, classicTwist, puzzle, memory }

extension CreativeSectionLabel on CreativeSection {
  String get label => switch (this) {
    CreativeSection.featured => 'Featured',
    CreativeSection.speed => 'Speed Challenge',
    CreativeSection.classicTwist => 'Special Rules',
    CreativeSection.puzzle => 'Puzzle',
    CreativeSection.memory => 'Memory',
  };
}

class CreativeModeDefinition {
  const CreativeModeDefinition({
    required this.type,
    required this.title,
    required this.description,
    required this.goal,
    required this.rules,
    required this.difficulty,
    required this.icon,
    required this.accentColor,
    required this.section,
    required this.isPlayable,
    this.isVisible = true,
  });

  final CreativeModeType type;
  final String title;
  final String description;
  final String goal;
  final List<String> rules;
  final int difficulty;
  final IconData icon;
  final Color accentColor;
  final CreativeSection section;
  final bool isPlayable;
  final bool isVisible;

  String get difficultyLabel => '${'★' * difficulty}${'☆' * (5 - difficulty)}';

  String get actionLabel => isPlayable ? 'Play' : 'Unavailable';
}

abstract final class CreativeModeCatalog {
  static const all = <CreativeModeDefinition>[
    CreativeModeDefinition(
      type: CreativeModeType.treasureHunt,
      title: 'Treasure Hunt',
      description: 'Find hidden treasures while solving Solitaire.',
      goal: 'Reveal all five hidden treasure cards before clearing the deck.',
      rules: [
        'Normal Solitaire movement rules apply.',
        'Five cards are hidden in the starting stock.',
        'Each treasure is counted when its card is revealed.',
      ],
      difficulty: 3,
      icon: Icons.inventory_2_rounded,
      accentColor: Color(0xFFB88010),
      section: CreativeSection.featured,
      isPlayable: true,
    ),
    CreativeModeDefinition(
      type: CreativeModeType.timeTrial,
      title: 'Time Trial',
      description: 'Beat your best time with a faster Solitaire clear.',
      goal: 'Finish the deal before the clock runs out—or beat your best time.',
      rules: [
        'Normal Solitaire movement rules apply.',
        'Choose a 30-second, 60-second, or Unlimited challenge.',
        'Your best time is saved for the next run.',
      ],
      difficulty: 4,
      icon: Icons.timer_rounded,
      accentColor: Color(0xFF1973B5),
      section: CreativeSection.speed,
      isPlayable: true,
    ),
    CreativeModeDefinition(
      type: CreativeModeType.oneDrawSprint,
      title: 'One Draw Sprint',
      description: 'Plan one card at a time through one stock pass.',
      goal: 'Win without recycling the stock.',
      rules: [
        'Draw one card at a time.',
        'The stock can be passed only once.',
        'After the stock is empty, recycling is not available.',
      ],
      difficulty: 4,
      icon: Icons.redo_rounded,
      accentColor: Color(0xFFC26910),
      section: CreativeSection.classicTwist,
      isPlayable: true,
    ),
    CreativeModeDefinition(
      type: CreativeModeType.jokerRescue,
      title: 'Joker Rescue',
      description: 'Unlock the Joker by keeping a five-move streak.',
      goal: 'Rescue the Joker after five successful board actions.',
      rules: [
        'Normal Solitaire movement rules apply.',
        'The Joker starts locked beside the board.',
        'Make five successful actions to rescue the Joker.',
      ],
      difficulty: 4,
      icon: Icons.mood_rounded,
      accentColor: Color(0xFF7D45AB),
      section: CreativeSection.puzzle,
      isPlayable: true,
    ),
    CreativeModeDefinition(
      type: CreativeModeType.shadowSolitaire,
      title: 'Shadow Cards',
      description: 'Remember the opening cards before the table fades.',
      goal: 'Remember the starting cards, then clear the deal.',
      rules: [
        'Five starting cards are revealed for five seconds.',
        'The memory panel disappears before normal play begins.',
        'Normal Solitaire movement rules apply after the countdown.',
      ],
      difficulty: 3,
      icon: Icons.style_rounded,
      accentColor: Color(0xFF323D7D),
      section: CreativeSection.memory,
      isPlayable: true,
    ),
  ];

  static const _removedChainDeck = CreativeModeDefinition(
    type: CreativeModeType.chainDeck,
    title: 'Chain Deck',
    description: 'This mode is not part of the current Creative set.',
    goal: 'Unavailable.',
    rules: ['This mode has been removed from the current version.'],
    difficulty: 3,
    icon: Icons.lock_rounded,
    accentColor: Color(0xFF147779),
    section: CreativeSection.puzzle,
    isPlayable: false,
    isVisible: false,
  );

  static List<CreativeModeDefinition> get visible =>
      all.where((mode) => mode.isVisible).toList(growable: false);

  static CreativeModeDefinition forType(CreativeModeType type) {
    for (final mode in all) {
      if (mode.type == type) return mode;
    }
    if (type == CreativeModeType.chainDeck) return _removedChainDeck;
    throw ArgumentError.value(type, 'type', 'Creative mode is unavailable');
  }
}
