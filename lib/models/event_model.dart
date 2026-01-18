class GameEvent {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<EventOption> options;

  const GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.options,
  });
}

class EventOption {
  final String label;
  final String description; // Result description (shown after selection if needed, or tooltip)
  final EventOutcomeType type;
  final dynamic value; // Can be int (gold/hp), String (item id), or null
  final double probability; // Success chance (0.0 - 1.0)
  final EventOption? failureOption; // Result if probability check fails

  const EventOption({
    required this.label,
    required this.description,
    required this.type,
    this.value,
    this.probability = 1.0,
    this.failureOption,
  });
}

enum EventOutcomeType {
  none,
  gainGold,
  loseGold,
  heal,
  damage,
  gainItem, // Value is item ID or type
  gainBuff, // Value is buff ID
  gainCurse, // Value is curse ID
  spawnMonster, // Value is monster ID or level
  trade, // Lose X to Gain Y
}
