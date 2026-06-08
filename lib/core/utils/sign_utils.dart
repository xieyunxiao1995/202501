import 'encrypt_utils.dart';

/// 签名工具类
///
/// 用于请求参数的排序、拼接和签名生成，确保请求参数不被篡改。
/// 签名流程：
/// 1. 将所有非空参数按 key 的字典序排列
/// 2. 按 key=value 格式用 & 拼接
/// 3. 在拼接字符串末尾追加密钥
/// 4. 对最终字符串进行 HMAC-SHA256 签名
class SignUtils {
  SignUtils._();

  /// 生成请求签名
  ///
  /// [params] 请求参数字典
  /// [secret] 签名密钥
  /// 返回签名后的十六进制字符串
  static String sign(Map<String, dynamic> params, String secret) {
    final sortedParams = sortParams(params);
    final joinedString = joinParams(sortedParams);
    final signStr = '$joinedString&key=$secret';
    return EncryptUtils.hmacSha256(signStr, secret);
  }

  /// 验证签名是否正确
  ///
  /// [params] 请求参数字典（包含 sign 字段）
  /// [secret] 签名密钥
  /// [signField] 签名字段名，默认 "sign"
  static bool verify(Map<String, dynamic> params, String secret, {String signField = 'sign'}) {
    final signValue = params[signField]?.toString();
    if (signValue == null || signValue.isEmpty) return false;

    final paramsWithoutSign = Map<String, dynamic>.from(params)..remove(signField);
    final expectedSign = sign(paramsWithoutSign, secret);
    return expectedSign == signValue;
  }

  /// 按字典序排列参数
  ///
  /// 过滤掉值为 null 或空字符串的参数，按 key 字典序排列
  static Map<String, String> sortParams(Map<String, dynamic> params) {
    final filtered = <String, String>{};
    params.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        filtered[key] = value.toString();
      }
    });
    final sortedKeys = filtered.keys.toList()..sort();
    return {for (final key in sortedKeys) key: filtered[key]!};
  }

  /// 将参数拼接为字符串
  ///
  /// 格式：key1=value1&key2=value2&key3=value3
  static String joinParams(Map<String, String> sortedParams) {
    return sortedParams.entries.map((e) => '${e.key}=${e.value}').join('&');
  }

  /// 生成带时间戳的签名（防重放攻击）
  ///
  /// 自动添加 timestamp 参数后签名
  static String signWithTimestamp(Map<String, dynamic> params, String secret) {
    final paramsWithTimestamp = Map<String, dynamic>.from(params);
    paramsWithTimestamp['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
    return sign(paramsWithTimestamp, secret);
  }
}
