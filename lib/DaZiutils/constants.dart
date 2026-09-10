class AppConstants {
  // Damage Types
  static const List<String> damageTypes = [
    'crack',
    'chip',
    'shatter',
    'multiple',
  ];

  static String getDamageTypeLabel(String type) {
    switch (type) {
      case 'crack':
        return '裂纹';
      case 'chip':
        return '缺口';
      case 'shatter':
        return '破碎';
      case 'multiple':
        return '多块碎片';
      default:
        return type;
    }
  }

  // Materials
  static const List<String> materials = [
    'porcelain',
    'stoneware',
    'earthenware',
    'raku',
  ];

  static String getMaterialLabel(String material) {
    switch (material) {
      case 'porcelain':
        return '瓷器';
      case 'stoneware':
        return '炻器';
      case 'earthenware':
        return '陶器';
      case 'raku':
        return '乐烧';
      default:
        return material;
    }
  }

  // Aesthetics
  static const List<String> aesthetics = [
    'classic-gold',
    'modern-silver',
    'rustic-bronze',
    'contemporary-mix',
  ];

  static String getAestheticLabel(String aesthetic) {
    switch (aesthetic) {
      case 'classic-gold':
        return '经典金缮';
      case 'modern-silver':
        return '现代银缮';
      case 'rustic-bronze':
        return '古朴铜缮';
      case 'contemporary-mix':
        return '当代混搭';
      default:
        return aesthetic;
    }
  }

  // AI Preset Prompts
  static const List<String> aiPresetPrompts = [
    '如何准备生漆？',
    '应该使用什么等级的金粉？',
    '固化需要多长时间？',
    '请解释侘寂哲学',
  ];
}
