import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 加密工具类
///
/// 使用 crypto 包实现 MD5 哈希、SHA256 哈希、HMAC-SHA256 签名。
class EncryptUtils {
  EncryptUtils._();

  // ==================== MD5 ====================

  /// 计算字符串的 MD5 哈希值
  ///
  /// [value] 原始字符串
  /// [encoding] 编码方式，默认 UTF-8
  /// 返回32位小写十六进制字符串
  static String md5Hash(String value, {Encoding encoding = utf8}) {
    return md5.convert(encoding.encode(value)).toString();
  }

  /// 计算字节数组的 MD5 哈希值
  static String md5HashBytes(List<int> bytes) {
    return md5.convert(bytes).toString();
  }

  // ==================== SHA256 ====================

  /// 计算字符串的 SHA256 哈希值
  ///
  /// [value] 原始字符串
  /// [encoding] 编码方式，默认 UTF-8
  /// 返回64位小写十六进制字符串
  static String sha256Hash(String value, {Encoding encoding = utf8}) {
    return sha256.convert(encoding.encode(value)).toString();
  }

  /// 计算字节数组的 SHA256 哈希值
  static String sha256HashBytes(List<int> bytes) {
    return sha256.convert(bytes).toString();
  }

  // ==================== HMAC-SHA256 ====================

  /// 计算 HMAC-SHA256 签名
  ///
  /// [value] 待签名数据
  /// [secret] 密钥
  /// [encoding] 编码方式，默认 UTF-8
  /// 返回小写十六进制字符串
  static String hmacSha256(String value, String secret, {Encoding encoding = utf8}) {
    final key = Hmac(sha256, encoding.encode(secret));
    final digest = key.convert(encoding.encode(value));
    return digest.toString();
  }

  /// 计算 HMAC-SHA256 签名（返回 Base64 编码）
  static String hmacSha256Base64(String value, String secret, {Encoding encoding = utf8}) {
    final key = Hmac(sha256, encoding.encode(secret));
    final digest = key.convert(encoding.encode(value));
    return base64Encode(digest.bytes);
  }

  // ==================== SHA1 ====================

  /// 计算字符串的 SHA1 哈希值
  static String sha1Hash(String value, {Encoding encoding = utf8}) {
    return sha1.convert(encoding.encode(value)).toString();
  }

  // ==================== 辅助 ====================

  /// 将字节数组转换为十六进制字符串
  static String bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// 将十六进制字符串转换为字节数组
  static List<int> hexToBytes(String hex) {
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }
}
