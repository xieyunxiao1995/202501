class ReportUserReq {
  /// 举报原因
  final String reason;

  /// 举报场景 CHAT:私聊 HOMEPAGE:个人空间 POST：动态
  final String reportType;

  /// 被举报用户ID
  final int toUid;

  ReportUserReq({
    required this.reason,
    required this.reportType,
    required this.toUid,
  });

  Map<String, dynamic> toJson() {
    return {'reason': reason, 'reportType': reportType, 'toUid': toUid};
  }
}
