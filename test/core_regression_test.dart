import 'package:cpcloth/models/chat_message.dart';
import 'package:cpcloth/models/clothing_item.dart';
import 'package:cpcloth/models/outfit_entry.dart';
import 'package:cpcloth/services/deepseek_service.dart';
import 'package:cpcloth/services/local_storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  final clothing = ClothingItem(
    id: 'top-1',
    imagePath: '/shirt.jpg',
    name: '雾蓝衬衫',
    category: '上衣',
    color: '蓝色',
    season: '春秋',
    isPurchased: true,
    careNotes: '冷水洗',
    createdAt: DateTime(2026, 6, 20),
  );
  final outfit = OutfitEntry(
    id: 'outfit-1',
    imagePath: '/look.jpg',
    title: '清爽通勤',
    date: DateTime(2026, 6, 21),
    occasion: '通勤',
    mood: '轻松',
    notes: '',
    clothingItemIds: const ['top-1'],
  );
  final message = ChatMessage(
    id: 'message-1',
    role: ChatRole.assistant,
    content: '优先搭配已有衣物。',
    createdAt: DateTime(2026, 6, 21),
  );

  test('handwritten models survive JSON round trips', () {
    expect(ClothingItem.fromJson(clothing.toJson()), clothing);
    expect(OutfitEntry.fromJson(outfit.toJson()), outfit);
    expect(ChatMessage.fromJson(message.toJson()), message);
  });

  test('local storage restores and clears all collections', () async {
    final storage = LocalStorageService();
    await storage.saveClothingItems([clothing]);
    await storage.saveOutfits([outfit]);
    await storage.saveChatMessages([message]);

    expect(await storage.loadClothingItems(), [clothing]);
    expect(await storage.loadOutfits(), [outfit]);
    expect(await storage.loadChatMessages(), [message]);

    await storage.clearAll();
    expect(await storage.loadClothingItems(), isEmpty);
    expect(await storage.loadOutfits(), isEmpty);
    expect(await storage.loadChatMessages(), isEmpty);
  });

  test(
    'DeepSeek prompt includes wardrobe, outfit, shopping and care rules',
    () {
      final prompt = DeepSeekService.buildSystemPrompt(
        clothingItems: [clothing],
        outfits: [outfit],
      );

      expect(prompt, contains('雾蓝衬衫'));
      expect(prompt, contains('清爽通勤'));
      expect(prompt, contains('不购买'));
      expect(prompt, contains('洗标'));
    },
  );

  test('all onboarding illustrations are bundled', () async {
    for (final name in ['journal', 'wardrobe', 'assistant', 'identity']) {
      final bytes = await rootBundle.load('assets/images/onboarding/$name.png');
      expect(bytes.lengthInBytes, greaterThan(1000));
    }
  });
}
