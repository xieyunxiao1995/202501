import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';

/// 草稿存储工具类
///
/// 基于 Hive 实现阵容草稿、聊天草稿等临时数据的读写。
/// 草稿数据使用 JSON 序列化，支持复杂数据结构。
class DraftStorage {
  DraftStorage();

  /// 阵容草稿 Box 名称
  static const String _formationBox = 'formation_drafts';

  /// 聊天草稿 Box 名称
  static const String _chatBox = 'chat_drafts';

  /// 通用草稿 Box 名称
  static const String _generalBox = 'general_drafts';

  /// Box 缓存
  final Map<String, Box<String>> _boxes = {};

  // ==================== 初始化 ====================

  /// 初始化草稿存储，打开所有 Box
  Future<void> init() async {
    await _getBox(_formationBox);
    await _getBox(_chatBox);
    await _getBox(_generalBox);
  }

  /// 获取或打开 Box
  Future<Box<String>> _getBox(String boxName) async {
    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      return _boxes[boxName]!;
    }
    final box = await Hive.openBox<String>(boxName);
    _boxes[boxName] = box;
    return box;
  }

  // ==================== 阵容草稿 ====================

  /// 保存阵容草稿
  ///
  /// [draftId] 草稿 ID（如 "formation_1"）
  /// [data] 草稿数据（会序列化为 JSON）
  Future<void> saveFormationDraft(String draftId, Map<String, dynamic> data) async {
    final box = await _getBox(_formationBox);
    await box.put(draftId, jsonEncode(data));
  }

  /// 读取阵容草稿
  ///
  /// [draftId] 草稿 ID
  /// 返回草稿数据，不存在返回 null
  Future<Map<String, dynamic>?> getFormationDraft(String draftId) async {
    final box = await _getBox(_formationBox);
    final jsonStr = box.get(draftId);
    if (jsonStr == null) return null;
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }

  /// 删除阵容草稿
  Future<void> deleteFormationDraft(String draftId) async {
    final box = await _getBox(_formationBox);
    await box.delete(draftId);
  }

  /// 获取所有阵容草稿
  Future<Map<String, Map<String, dynamic>>> getAllFormationDrafts() async {
    final box = await _getBox(_formationBox);
    final result = <String, Map<String, dynamic>>{};
    for (final key in box.keys) {
      final jsonStr = box.get(key);
      if (jsonStr != null) {
        result[key.toString()] = jsonDecode(jsonStr) as Map<String, dynamic>;
      }
    }
    return result;
  }

  /// 清空所有阵容草稿
  Future<void> clearFormationDrafts() async {
    final box = await _getBox(_formationBox);
    await box.clear();
  }

  // ==================== 聊天草稿 ====================

  /// 保存聊天草稿
  ///
  /// [channelId] 频道 ID
  /// [content] 草稿内容
  Future<void> saveChatDraft(String channelId, String content) async {
    final box = await _getBox(_chatBox);
    if (content.isEmpty) {
      await box.delete(channelId);
    } else {
      await box.put(channelId, content);
    }
  }

  /// 读取聊天草稿
  ///
  /// [channelId] 频道 ID
  /// 返回草稿内容，不存在返回空字符串
  Future<String> getChatDraft(String channelId) async {
    final box = await _getBox(_chatBox);
    return box.get(channelId, defaultValue: '') ?? '';
  }

  /// 删除聊天草稿
  Future<void> deleteChatDraft(String channelId) async {
    final box = await _getBox(_chatBox);
    await box.delete(channelId);
  }

  /// 获取所有聊天草稿
  Future<Map<String, String>> getAllChatDrafts() async {
    final box = await _getBox(_chatBox);
    final result = <String, String>{};
    for (final key in box.keys) {
      final value = box.get(key);
      if (value != null) {
        result[key.toString()] = value;
      }
    }
    return result;
  }

  /// 清空所有聊天草稿
  Future<void> clearChatDrafts() async {
    final box = await _getBox(_chatBox);
    await box.clear();
  }

  // ==================== 通用草稿 ====================

  /// 保存通用草稿
  ///
  /// [draftKey] 草稿键名
  /// [data] 草稿数据
  Future<void> saveDraft(String draftKey, Map<String, dynamic> data) async {
    final box = await _getBox(_generalBox);
    await box.put(draftKey, jsonEncode(data));
  }

  /// 读取通用草稿
  ///
  /// [draftKey] 草稿键名
  Future<Map<String, dynamic>?> getDraft(String draftKey) async {
    final box = await _getBox(_generalBox);
    final jsonStr = box.get(draftKey);
    if (jsonStr == null) return null;
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }

  /// 删除通用草稿
  Future<void> deleteDraft(String draftKey) async {
    final box = await _getBox(_generalBox);
    await box.delete(draftKey);
  }

  /// 保存字符串草稿
  Future<void> saveStringDraft(String draftKey, String value) async {
    final box = await _getBox(_generalBox);
    await box.put(draftKey, value);
  }

  /// 读取字符串草稿
  Future<String?> getStringDraft(String draftKey) async {
    final box = await _getBox(_generalBox);
    return box.get(draftKey);
  }

  // ==================== 清理 ====================

  /// 清空所有草稿数据
  Future<void> clearAll() async {
    await clearFormationDrafts();
    await clearChatDrafts();
    final generalBox = await _getBox(_generalBox);
    await generalBox.clear();
  }

  /// 关闭所有 Box
  Future<void> close() async {
    for (final box in _boxes.values.toList()) {
      if (box.isOpen) {
        await box.close();
      }
    }
    _boxes.clear();
  }
}
