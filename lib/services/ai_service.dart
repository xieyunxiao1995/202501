import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class AIService {
  static const String _apiKey = 'sk-8e3c046d1446452199b020a5bd08e2e7';
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';

  Future<Item?> synthesizeItem(String item1, String item2) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "deepseek-chat",
          "messages": [
            {
              "role": "system",
              "content": "You are a game designer for a roguelike game. "
                  "Combine the two input items into a new magical item. "
                  "Return ONLY a JSON object with keys: name (String), description (String), damage (int, 10-50), iconData (String, pick a relevant emoji). "
                  "No markdown, no code blocks, just raw JSON. Language: Chinese."
            },
            {
              "role": "user",
              "content": "Combine '$item1' and '$item2'."
            }
          ],
          "stream": false
        }),
      );

      if (response.statusCode == 200) {
        // Handle utf8 decoding manually if needed, though http.post usually handles it if charset is set.
        // But response.body might be encoded. safely decode.
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        
        // Clean up content if it contains markdown code blocks
        String jsonStr = content.trim();
        if (jsonStr.startsWith('```json')) {
          jsonStr = jsonStr.replaceAll('```json', '').replaceAll('```', '');
        } else if (jsonStr.startsWith('```')) {
          jsonStr = jsonStr.replaceAll('```', '');
        }

        final itemData = jsonDecode(jsonStr);
        
        return Item(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: itemData['name'],
          description: itemData['description'],
          damage: itemData['damage'],
          iconData: itemData['iconData'],
        );
      } else {
        print('API Error: ${response.statusCode} ${response.body}');
        return _fallbackSynthesis(item1, item2);
      }
    } catch (e) {
      print('Exception: $e');
      return _fallbackSynthesis(item1, item2);
    }
  }

  Item _fallbackSynthesis(String item1, String item2) {
    // Basic offline recipes
    int damage = 20;
    String name = "Fused Artifact";
    String desc = "Created from $item1 and $item2";
    String icon = "✨";

    if (item1.contains("Potion") || item2.contains("Potion")) {
      name = "Elixir";
      damage = -80; // Heals more
      icon = "🍷";
    } else if (item1.contains("Sword") || item2.contains("Sword")) {
      name = "Dual Blade";
      damage = 30;
      icon = "⚔️";
    }

    return Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: desc,
      damage: damage,
      iconData: icon,
    );
  }
}
