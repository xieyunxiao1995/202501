class EmotionTag {
  final String name;
  final String displayName;
  final String color;

  EmotionTag({
    required this.name,
    required this.displayName,
    required this.color,
  });

  static List<EmotionTag> getAllTags() {
    return [
      EmotionTag(name: 'peaceful', displayName: '平静', color: '#B5EAD7'),
      EmotionTag(name: 'joy', displayName: '开心', color: '#FFD166'),
      EmotionTag(name: 'anxiety', displayName: '焦虑', color: '#A8D8EA'),
      EmotionTag(name: 'hope', displayName: '希望', color: '#C3A6E0'),
      EmotionTag(name: 'love', displayName: '爱', color: '#FFB3C7'),
      EmotionTag(name: 'energy', displayName: '活力', color: '#C3A6E0'),
      EmotionTag(name: 'tired', displayName: '疲惫', color: '#A8B0B8'),
      EmotionTag(name: 'grateful', displayName: '感恩', color: '#B5EAD7'),
      EmotionTag(name: 'confused', displayName: '迷茫', color: '#D4C5B9'),
      EmotionTag(name: 'accomplished', displayName: '成就', color: '#B5EAD7'),
    ];
  }

  static EmotionTag? getTagByName(String name) {
    try {
      return getAllTags().firstWhere((tag) => tag.name == name);
    } catch (e) {
      return null;
    }
  }
}
