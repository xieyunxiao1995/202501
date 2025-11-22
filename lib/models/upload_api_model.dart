// 定义预签名响应的数据模型
class UploadPolicy {
  final String cosHost;
  final String cosKey;
  final String policy;
  final String qsignAlgorithm;
  final String qak;
  final String qkeyTime;
  final String qsignature;

  UploadPolicy({
    required this.cosHost,
    required this.cosKey,
    required this.policy,
    required this.qsignAlgorithm,
    required this.qak,
    required this.qkeyTime,
    required this.qsignature,
  });

  factory UploadPolicy.fromJson(Map<String, dynamic> json) {
    return UploadPolicy(
      cosHost: json['cosHost'] ?? '',
      cosKey: json['cosKey'] ?? '',
      policy: json['policy'] ?? '',
      qsignAlgorithm: json['qsignAlgorithm'] ?? '',
      qak: json['qak'] ?? '',
      qkeyTime: json['qkeyTime'] ?? '',
      qsignature: json['qsignature'] ?? '',
    );
  }
}
