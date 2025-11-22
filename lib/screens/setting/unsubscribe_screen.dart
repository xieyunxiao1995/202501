import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/shared/styled_dialog.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class UnsubscribeScreen extends StatefulWidget {
  const UnsubscribeScreen({super.key});

  @override
  State<UnsubscribeScreen> createState() => _UnsubscribeScreenState();
}

class _UnsubscribeScreenState extends State<UnsubscribeScreen> {
  CancelInfoData? _cancelInfo;
  bool _isLoading = false;
  bool _actionInProgress = false;

  String get _appDisplayName {
    if (kIsWeb) {
      return '真遇';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return '美侣';
      default:
        return '美侣';
    }
  }

  bool get _hasApplied => (_cancelInfo?.cancelStatus ?? 0) != 0;

  @override
  void initState() {
    super.initState();
    _loadCancelInfo();
  }

  Future<void> _loadCancelInfo() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final resp = await UserApi.getCancelInfo();
      if (!mounted) return;
      if (resp.code == 0) {
        setState(() {
          _cancelInfo = resp.data;
        });
      } else {
        showMsg(context, resp.message ?? '获取注销信息失败');
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '获取注销信息失败');
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmApply() async {
    final confirmed = await StyledDialog.show<bool>(
      context: context,
      contentText: '账号一旦注销，所有数据及余额都将无法恢复。申请注销后，您有7天的反悔时间，确认要注销账号吗？',
      confirmText: '确定',
      cancelText: '取消',
    );

    if (confirmed == true) {
      await _applyCancel();
    }
  }

  Future<void> _applyCancel() async {
    if (_actionInProgress) return;

    setState(() {
      _actionInProgress = true;
    });

    try {
      final resp = await UserApi.applyAccountCancel();
      if (!mounted) return;
      if (resp.code == 0) {
        showMsg(context, '已申请注销');
        await _loadCancelInfo();
      } else {
        showMsg(context, resp.message ?? '申请注销失败');
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '申请注销失败');
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _actionInProgress = false;
      });
    }
  }

  Future<void> _revokeCancel() async {
    if (_actionInProgress) return;

    setState(() {
      _actionInProgress = true;
    });

    try {
      final resp = await UserApi.revokeAccountCancel();
      if (!mounted) return;
      if (resp.code == 0) {
        showMsg(context, '已取消注销');
        await _loadCancelInfo();
      } else {
        showMsg(context, resp.message ?? '取消失败');
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '取消失败');
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _actionInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledText('注销账号', fontSize: 18),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _buildContent(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final name = _appDisplayName;
    final List<_Paragraph> paragraphs = [
      _Paragraph(text: '在注销$name账户前，请您充分阅读、理解并同意以下内容：'),
      _Paragraph(text: '1、您所申请注销的账户是您依照$name用户协议约定进行注册并由$name提供给您的账号；'),
      _Paragraph(text: '2、您注销成功后将视为您放弃该账号下的如下资产或权益，该等资产或权益将被清空或删除，且无法恢复：'),
      _Paragraph(text: 'A.您的个人身份信息、账户信息、认证信息、粉丝数量等；', isSub: true),
      _Paragraph(text: 'B.您发布的任何信息(动态、视频、音频、图片、文字等)数据内容；', isSub: true),
      _Paragraph(
        text: 'C.您账号内虚拟礼物、收益、余额、交易信息将会全部删除，请您在申请注销前务必妥善处理账号中的资产问题。',
        isSub: true,
      ),
      _Paragraph(
        text:
            '3、您确认您申请注销账户的行为不违反任何法律法规、不侵犯任何第三方的合法权益，否则因此产生的个人纠纷及赔偿由您自行承担，并赔偿因此给$name造成的全部损失；',
      ),
      _Paragraph(
        text: '4、在账户注销前及注销期间，如被第三方投诉、被国家机关调查或处于申诉，$name有权自行终止您账户注销的申请，且无需经您同意；',
      ),
      _Paragraph(text: '5、您注销$name账号并不视为您注销前的所有账号行为和相关责任得到豁免或减轻。'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final paragraph in paragraphs) ...[
          Padding(
            padding: EdgeInsets.only(
              bottom: 12,
              left: paragraph.isSub ? 16 : 0,
            ),
            child: Text(
              paragraph.text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final isProcessing = _actionInProgress || _isLoading;
    final button = _hasApplied
        ? _buildRevokeButton(isProcessing)
        : _buildApplyButton(isProcessing);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: button,
      ),
    );
  }

  Widget _buildApplyButton(bool disabled) {
    return GestureDetector(
      onTap: disabled ? null : _confirmApply,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          gradient: disabled
              ? const LinearGradient(
                  colors: [Color(0x80F1B873), Color(0x80F2DBA8)],
                )
              : const LinearGradient(
                  colors: [
                    AppColors.secondaryGradientStart,
                    AppColors.secondaryGradientEnd,
                  ],
                ),
        ),
        alignment: Alignment.center,
        child: Text(
          disabled ? '处理中…' : '申请注销',
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRevokeButton(bool disabled) {
    return GestureDetector(
      onTap: disabled ? null : _revokeCancel,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color: disabled ? const Color(0x803A393E) : const Color(0xFF3A393E),
          border: Border.all(color: const Color(0xFF3A393E), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          disabled ? '处理中…' : '取消注销',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _Paragraph {
  final String text;
  final bool isSub;

  _Paragraph({required this.text, this.isSub = false});
}
