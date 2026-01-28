import '../models/card_data.dart';
import '../models/enums.dart';

class AssetHelper {
  /// Returns the asset path for a given card, or null if no image is available.
  static String? getCardImage(CardData card) {
    // Role Assets: Role1.png - Role20.png
    // Item Assets: item1.png - item39.png

    switch (card.type) {
      case CardType.hero:
        // Default hero image
        return 'assets/role/Role1.png';
      
      case CardType.monster:
        // Consistent mapping based on Name to ensure same monster always looks same
        // We use Role2 to Role20 for monsters (19 images)
        int index = (card.name.hashCode.abs() % 19) + 2; 
        return 'assets/role/Role$index.png';
      
      case CardType.weapon:
      case CardType.shield:
      case CardType.potion:
      case CardType.treasure:
      case CardType.key:
      case CardType.chest:
      case CardType.material:
      case CardType.soul:
        // Item assets for items
        // We use item1 to item39 (39 images)
        int index = (card.name.hashCode.abs() % 39) + 1;
        return 'assets/item/item$index.png';
        
      default:
        return null;
    }
  }
}
