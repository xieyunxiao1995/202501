import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alchemy_model.dart';
import '../data/alchemy_data.dart';

class AlchemyManager {
  static const String _inventoryKey = 'mythic_alchemy_inventory';
  static const String _activeElixirKey = 'mythic_active_elixir';

  static Map<String, int> _inventory = {}; // materialId -> count
  static String? _activeElixirId;

  // Load inventory and active elixir
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Inventory
    final invString = prefs.getString(_inventoryKey);
    if (invString != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(invString);
        _inventory = decoded.map((key, value) => MapEntry(key, value as int));
      } catch (e) {
        print("Error loading alchemy inventory: $e");
        _inventory = {};
      }
    }

    // Load Active Elixir
    _activeElixirId = prefs.getString(_activeElixirKey);
  }

  static Map<String, int> get inventory => Map.unmodifiable(_inventory);
  static String? get activeElixirId => _activeElixirId;

  // Add material to inventory
  static Future<void> addMaterial(String materialId, int amount) async {
    final current = _inventory[materialId] ?? 0;
    _inventory[materialId] = current + amount;
    await _saveInventory();
  }

  // Check if can craft
  static bool canCraft(Elixir elixir) {
    for (var entry in elixir.recipe.entries) {
      if ((_inventory[entry.key] ?? 0) < entry.value) {
        return false;
      }
    }
    return true;
  }

  // Craft elixir (deduct materials, set active)
  static Future<bool> craftElixir(Elixir elixir) async {
    if (!canCraft(elixir)) return false;

    // Deduct materials
    for (var entry in elixir.recipe.entries) {
      _inventory[entry.key] = (_inventory[entry.key] ?? 0) - entry.value;
    }
    await _saveInventory();

    // Set Active Elixir
    _activeElixirId = elixir.id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeElixirKey, elixir.id);
    
    return true;
  }

  // Consume active elixir (call this when run starts)
  static Future<Elixir?> consumeActiveElixir() async {
    if (_activeElixirId == null) return null;

    final elixir = allElixirs.firstWhere(
      (e) => e.id == _activeElixirId, 
      orElse: () => throw Exception('Elixir not found'),
    );

    // Clear active elixir
    _activeElixirId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeElixirKey);

    return elixir;
  }

  static Future<void> _saveInventory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_inventoryKey, jsonEncode(_inventory));
  }
}
