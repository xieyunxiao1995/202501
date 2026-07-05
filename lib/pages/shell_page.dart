import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/chat_message.dart';
import '../models/clothing_item.dart';
import '../models/outfit_entry.dart';
import '../services/image_storage_service.dart';
import '../services/local_storage_service.dart';
import 'assistant/assistant_page.dart';
import 'outfits/outfits_page.dart';
import 'settings/settings_page.dart';
import 'wardrobe/wardrobe_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final _storage = LocalStorageService();
  int _currentIndex = 0;
  bool _isLoading = true;
  List<OutfitEntry> _outfits = [];
  List<ClothingItem> _clothingItems = [];
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var outfits = await _storage.loadOutfits();
      var clothingItems = await _storage.loadClothingItems();
      final messages = await _storage.loadChatMessages();



      if (!mounted) return;
      setState(() {
        _outfits = outfits;
        _clothingItems = clothingItems;
        _messages = messages;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveOutfit(OutfitEntry entry) async {
    final index = _outfits.indexWhere((item) => item.id == entry.id);
    setState(() {
      if (index == -1) {
        _outfits = [entry, ..._outfits];
      } else {
        _outfits = [..._outfits]..[index] = entry;
      }
    });
    await _storage.saveOutfits(_outfits);
  }

  Future<void> _deleteOutfit(String id) async {
    setState(() => _outfits = _outfits.where((item) => item.id != id).toList());
    await _storage.saveOutfits(_outfits);
  }

  Future<void> _saveClothingItem(ClothingItem item) async {
    final index = _clothingItems.indexWhere((entry) => entry.id == item.id);
    setState(() {
      if (index == -1) {
        _clothingItems = [item, ..._clothingItems];
      } else {
        _clothingItems = [..._clothingItems]..[index] = item;
      }
    });
    await _storage.saveClothingItems(_clothingItems);
  }

  Future<void> _deleteClothingItem(String id) async {
    setState(() {
      _clothingItems = _clothingItems.where((item) => item.id != id).toList();
      _outfits = _outfits
          .map(
            (entry) => entry.copyWith(
              clothingItemIds: entry.clothingItemIds
                  .where((itemId) => itemId != id)
                  .toList(),
            ),
          )
          .toList();
    });
    await Future.wait([
      _storage.saveClothingItems(_clothingItems),
      _storage.saveOutfits(_outfits),
    ]);
  }

  Future<void> _saveMessages(List<ChatMessage> messages) async {
    _messages = [...messages];
    await _storage.saveChatMessages(_messages);
  }

  Future<void> _clearData() async {
    await Future.wait([
      _storage.clearAll(),
      ImageStorageService().clearAllImages(),
    ]);
    if (!mounted) return;
    setState(() {
      _outfits = [];
      _clothingItems = [];
      _messages = [];
    });
  }

  void _selectPage(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _currentIndex = index);
  }

  List<Widget> get _pages => [
    OutfitsPage(
      outfits: _outfits,
      clothingItems: _clothingItems,
      onSave: _saveOutfit,
      onDelete: _deleteOutfit,
    ),
    WardrobePage(
      items: _clothingItems,
      onSave: _saveClothingItem,
      onDelete: _deleteClothingItem,
    ),
    AssistantPage(
      outfits: _outfits,
      clothingItems: _clothingItems,
      messages: _messages,
      onMessagesChanged: _saveMessages,
    ),
    SettingsPage(
      outfitCount: _outfits.length,
      clothingCount: _clothingItems.length,
      onClearData: _clearData,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _selectPage,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.style_outlined),
                selectedIcon: Icon(Icons.style_rounded),
                label: '穿搭',
              ),
              NavigationDestination(
                icon: Icon(Icons.checkroom_outlined),
                selectedIcon: Icon(Icons.checkroom_rounded),
                label: '衣橱',
              ),
              NavigationDestination(
                icon: Icon(Icons.auto_awesome_outlined),
                selectedIcon: Icon(Icons.auto_awesome_rounded),
                label: 'AI 助手',
              ),
              NavigationDestination(
                icon: Icon(Icons.tune_outlined),
                selectedIcon: Icon(Icons.tune_rounded),
                label: '设置',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
