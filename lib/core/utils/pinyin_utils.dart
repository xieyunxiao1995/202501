import 'package:pinyin/pinyin.dart';

/// 拼音工具类
///
/// 使用 pinyin 包将中文转拼音首字母，用于武将搜索索引。
class PinyinUtils {
  PinyinUtils._();

  /// 获取中文的拼音首字母
  ///
  /// 示例：
  /// - getFirstLetter("曹操") → "C"
  /// - getFirstLetter("刘备") → "L"
  /// - getFirstLetter("诸葛亮") → "Z"
  /// - getFirstLetter("ABC") → "A"
  static String getFirstLetter(String text) {
    if (text.isEmpty) return '#';

    final firstChar = text[0];

    // 非中文字符直接返回大写
    if (!RegExp(r'[一-龥]').hasMatch(firstChar)) {
      return firstChar.toUpperCase();
    }

    final pinyinStr = PinyinHelper.getFirstWordPinyin(firstChar);
    if (pinyinStr.isEmpty) return '#';

    return pinyinStr[0].toUpperCase();
  }

  /// 获取完整拼音
  ///
  /// 示例：
  /// - getFullPinyin("曹操") → "Caocao"
  /// - getFullPinyin("刘备") → "Liubei"
  static String getFullPinyin(String text) {
    if (text.isEmpty) return '';

    return PinyinHelper.getPinyin(text, separator: '');
  }

  /// 获取拼音首字母序列
  ///
  /// 示例：
  /// - getFirstLetters("曹操") → "CC"
  /// - getFirstLetters("诸葛亮") → "ZGL"
  static String getFirstLetters(String text) {
    if (text.isEmpty) return '';

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (RegExp(r'[一-龥]').hasMatch(char)) {
        final pinyinStr = PinyinHelper.getFirstWordPinyin(char);
        if (pinyinStr.isNotEmpty) {
          buffer.write(pinyinStr[0].toUpperCase());
        }
      } else {
        buffer.write(char.toUpperCase());
      }
    }
    return buffer.toString();
  }

  /// 生成搜索索引关键词
  ///
  /// 同时包含中文原文、完整拼音、首字母序列，方便模糊搜索
  /// 示例：
  /// - getSearchKeywords("曹操") → ["曹操", "Caocao", "CC"]
  static List<String> getSearchKeywords(String text) {
    if (text.isEmpty) return [];

    return [
      text,
      getFullPinyin(text),
      getFirstLetters(text),
    ];
  }

  /// 生成拼音排序用的键
  ///
  /// 用于列表按拼音排序
  static String getSortKey(String text) {
    if (text.isEmpty) return '';
    return getFullPinyin(text).toUpperCase();
  }

  /// 判断文字是否匹配搜索词
  ///
  /// 支持中文、拼音、首字母匹配
  static bool matchesSearch(String text, String query) {
    if (text.isEmpty || query.isEmpty) return false;

    final lowerQuery = query.toLowerCase();
    final keywords = getSearchKeywords(text);

    return keywords.any((keyword) => keyword.toLowerCase().contains(lowerQuery));
  }
}
