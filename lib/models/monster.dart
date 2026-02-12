import 'part.dart';
import '../utils/constants.dart';

class Monster {
  final String id;
  final String name;
  final String description;
  int hp;
  final int maxHp;
  final int attack;
  final AppColors elementColor; // Simplified element
  final List<Part> drops;

  Monster({
    required this.id,
    required this.name,
    required this.description,
    required this.hp,
    required this.maxHp,
    required this.attack,
    required this.elementColor,
    this.drops = const [],
  });
}
