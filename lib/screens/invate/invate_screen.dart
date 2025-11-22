import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zhenyu_flutter/api/invite_api.dart';
import 'package:zhenyu_flutter/models/invite_api_model.dart';
import 'package:zhenyu_flutter/screens/invate/invate_fail_screen.dart';
import 'package:zhenyu_flutter/screens/invate/invate_poster_screen.dart';
import 'package:zhenyu_flutter/screens/invate/invate_rule_screen.dart';
import 'package:zhenyu_flutter/screens/invate/partner_qrcode_dialog.dart';
import 'package:zhenyu_flutter/screens/wallet/diamond_detail_screen.dart';
import 'package:zhenyu_flutter/screens/wallet/diamond_withdraw_screen.dart';
import 'package:zhenyu_flutter/theme.dart';

class InvateScreen extends StatefulWidget {
  const InvateScreen({super.key});

  @override
  State<InvateScreen> createState() => _InvateScreenState();
}

class _InvateScreenState extends State<InvateScreen> {
  InvitePageData? _inviteData;
  List<String> _act1Desc = const [];
  List<String> _act2Desc = const [];
  List<InviteIncomeTopItem> _incomeTopList = const [];

  bool _isInviteLoading = true;
  bool _isIncomeTopLoading = true;
  bool _hasInviteError = false;
  bool _hasTopError = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    await Future.wait([_fetchInviteInfo(), _fetchInviteIncomeTop()]);
  }

  /// 获取邀请页面信息
  Future<void> _fetchInviteInfo() async {
    setState(() {
      _isInviteLoading = true;
      _hasInviteError = false;
    });
    try {
      final resp = await InviteApi.getInvitePage();
      if (!mounted) return;
      if (resp.code == 0 && resp.data != null) {
        final data = resp.data!;
        setState(() {
          _inviteData = data;
          _act1Desc = _splitLines(data.act1Desc);
          _act2Desc = _splitLines(data.act2Desc);
          _isInviteLoading = false;
        });
      } else {
        setState(() {
          _inviteData = null;
          _isInviteLoading = false;
          _hasInviteError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _inviteData = null;
        _isInviteLoading = false;
        _hasInviteError = true;
      });
    }
  }

  /// 获取邀请收益榜单数据
  Future<void> _fetchInviteIncomeTop() async {
    setState(() {
      _isIncomeTopLoading = true;
      _hasTopError = false;
    });
    try {
      final resp = await InviteApi.getInviteIncomeTop();
      if (!mounted) return;
      if (resp.code == 0 && resp.data?.list != null) {
        setState(() {
          _incomeTopList = resp.data!.list!;
          _isIncomeTopLoading = false;
        });
      } else {
        setState(() {
          _incomeTopList = const [];
          _isIncomeTopLoading = false;
          _hasTopError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _incomeTopList = const [];
        _isIncomeTopLoading = false;
        _hasTopError = true;
      });
    }
  }

  /// 将文案按行拆分并过滤空字符串
  List<String> _splitLines(String? raw) {
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    return raw
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  /// 复制邀请码到剪贴板
  Future<void> _copyInviteCode() async {
    final code = _inviteData?.inviteCode;
    if (code == null || code.isEmpty) {
      _showToast('暂无可复制的邀请码');
      return;
    }
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    _showToast('邀请码已复制');
  }

  /// 复制邀请链接到剪贴板
  Future<void> _copyInviteUrl() async {
    final url = _inviteData?.inviteUrlH5;
    if (url == null || url.isEmpty) {
      _showToast('暂无可复制的链接');
      return;
    }
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    _showToast('邀请链接已复制');
  }

  /// 显示提示信息
  void _showToast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadAllData,
            child: _buildScrollableBody(context),
          ),
          _buildNavigationBar(context),
          _buildFloatingRulesButton(context),
        ],
      ),
    );
  }

  Widget _buildScrollableBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isInviteLoading)
            const Padding(
              padding: EdgeInsets.only(top: 120),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_hasInviteError)
            _buildErrorPlaceholder(
              onRetry: _fetchInviteInfo,
              message: '加载邀请信息失败',
            )
          else if (_inviteData != null) ...[
            _buildHeaderSection(context),
            const SizedBox(height: 20),
            _buildPartnerSection(),
            const SizedBox(height: 20),
            _buildMyInviteSection(),
            const SizedBox(height: 20),
          ],
          _buildIncomeTopSection(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Container(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      '邀请有奖',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const InvateFailScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '绑定邀请关系失败？',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final data = _inviteData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _InviteHeroBanner(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInviteCodeCard(data),
              const SizedBox(height: 16),
              _buildActionButtons(),
              const SizedBox(height: 16),
              _buildRuleCard(_act1Desc, data?.vipConfigs ?? const []),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInviteCodeCard(InvitePageData? data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: '我的邀请码：',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: data?.inviteCode ?? '--',
                style: const TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _CustomActionButton(
          text: '复制',
          onTap: _copyInviteCode,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          fontSize: 12.5,
          textColor: Colors.black,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _CustomActionButton(
            text: '分享海报',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const InvatePosterScreen(),
                ),
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CustomActionButton(
            text: '分享链接',
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            onTap: _copyInviteUrl,
          ),
        ),
      ],
    );
  }

  Widget _buildRuleCard(List<String> rules, List<InviteVipConfig> vipConfigs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryGradientEnd, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in rules)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: AppColors.invateScreenColor,
                    fontSize: 14,
                  ),
                  children: _buildHighlightSpans(line),
                ),
              ),
            ),
          if (vipConfigs.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildVipTable(vipConfigs),
          ],
        ],
      ),
    );
  }

  List<InlineSpan> _buildHighlightSpans(String line) {
    final List<InlineSpan> spans = [];
    final regex = RegExp(r'\[([^\]]+)\]');
    int start = 0;
    for (final match in regex.allMatches(line)) {
      if (match.start > start) {
        spans.add(TextSpan(text: line.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(1) ?? '',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      );
      start = match.end;
    }
    if (start < line.length) {
      spans.add(TextSpan(text: line.substring(start)));
    }
    if (spans.isEmpty) {
      spans.add(TextSpan(text: line));
    }
    return spans;
  }

  Widget _buildVipTable(List<InviteVipConfig> vipConfigs) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondaryGradientEnd),
      ),
      child: Column(
        children: [
          // 表头：充值时长行
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3E2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // 第一列：标题
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: AppColors.secondaryGradientEnd,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          '充值时长',
                          style: TextStyle(
                            color: AppColors.invateScreenColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 后续列：会员套餐
                for (int i = 0; i < vipConfigs.length; i++)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: i < vipConfigs.length - 1
                            ? const Border(
                                right: BorderSide(
                                  color: AppColors.secondaryGradientEnd,
                                  width: 0.5,
                                ),
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            '${vipConfigs[i].vipDay ?? 0}天会员',
                            style: const TextStyle(
                              color: AppColors.invateScreenColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // 数据行：奖励天数
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.secondaryGradientEnd,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                // 第一列：标题
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: AppColors.secondaryGradientEnd,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          '奖励天数',
                          style: TextStyle(
                            color: AppColors.invateScreenColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 后续列：奖励天数
                for (int i = 0; i < vipConfigs.length; i++)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: i < vipConfigs.length - 1
                            ? const Border(
                                right: BorderSide(
                                  color: AppColors.secondaryGradientEnd,
                                  width: 0.5,
                                ),
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            '${vipConfigs[i].howMany ?? 0}天',
                            style: const TextStyle(
                              color: AppColors.invateScreenColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerSection() {
    final data = _inviteData;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            for (final line in _act2Desc)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.invateScreenColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: _buildHighlightSpans(line),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              height: 135,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/invate/yqbj.png',
                    fit: BoxFit.fill,
                  ),
                  Positioned.fill(
                    top: 17.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPartnerRatioItem(
                          label: '初级合伙人',
                          ratio: data?.shareRatioPrimary,
                        ),
                        _buildPartnerRatioItem(
                          label: '高级合伙人',
                          ratio: data?.shareRatioSenior,
                        ),
                        _buildPartnerRatioItem(
                          label: '城市合伙人',
                          ratio: data?.shareRatioCity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _GradientButton(
              imagePath: 'assets/images/invate/Slice 68_1.png',
              onTap: () => showPartnerQRCodeDialog(
                context,
                _inviteData?.partnerQRCodeUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerRatioItem({required String label, int? ratio}) {
    return Column(
      children: [
        SizedBox(
          width: 94,
          height: 88,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/invate/yqjl.png', fit: BoxFit.cover),
              Positioned(
                top: 10,
                child: Text(
                  '${ratio ?? 0}%',
                  style: const TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 26.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.invateScreenColor,
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMyInviteSection() {
    final data = _inviteData;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17.5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.5),
          border: Border.all(color: const Color(0xFF5E5E5E), width: 5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '我的邀请',
                    style: TextStyle(
                      color: AppColors.invateScreenColor,
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${data?.incomeBalance ?? 0} 钻石',
                    style: const TextStyle(
                      color: AppColors.red,
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  _InviteDetailButton(
                    text: '明细',
                    onTap: () {
                      final data = _inviteData;
                      if (data == null) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DiamondDetailScreen(
                            incomeBalance: (data.incomeBalance ?? 0),
                            inviteDiamondAmount:
                                (data.inviteDiamondAmount ?? 0),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 5),
                  _InviteDetailButton(
                    text: '提现',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DiamondWithdrawScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeTopSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF5E5E5E), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '邀请榜单',
                style: TextStyle(
                  color: AppColors.invateScreenColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildIncomeTopHeader(),
            if (_isIncomeTopLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_hasTopError)
              _buildErrorPlaceholder(
                onRetry: _fetchInviteIncomeTop,
                message: '加载榜单失败',
              )
            else if (_incomeTopList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        '还没有邀请记录',
                        style: TextStyle(color: Color(0xFF949494)),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '快去邀请好友获取奖励吧',
                        style: TextStyle(color: Color(0xFF949494)),
                      ),
                    ],
                  ),
                ),
              )
            else
              _buildIncomeTopList(),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeTopHeader() {
    return Container(
      color: const Color(0xFFFFF3E2),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: const Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                '排名',
                style: TextStyle(
                  color: AppColors.invateScreenColor,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '头像',
                style: TextStyle(
                  color: AppColors.invateScreenColor,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '昵称',
                style: TextStyle(
                  color: AppColors.invateScreenColor,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '已获得奖励',
                style: TextStyle(
                  color: AppColors.invateScreenColor,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeTopList() {
    return Column(
      children: [
        for (int i = 0; i < _incomeTopList.length; i++)
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.secondaryGradientEnd,
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              children: [
                Expanded(child: Center(child: _buildRankWidget(i))),
                Expanded(
                  child: Center(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFF2F2F2),
                      backgroundImage:
                          _incomeTopList[i].avatar != null &&
                              _incomeTopList[i].avatar!.isNotEmpty
                          ? NetworkImage(_incomeTopList[i].avatar!)
                          : null,
                      child:
                          (_incomeTopList[i].avatar == null ||
                              _incomeTopList[i].avatar!.isEmpty)
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _incomeTopList[i].userName ?? '--',
                      style: const TextStyle(
                        color: AppColors.invateScreenColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${_incomeTopList[i].income?.toStringAsFixed(2) ?? '0.00'}元',
                      style: const TextStyle(
                        color: AppColors.invateScreenColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRankWidget(int index) {
    const rankColors = [
      Color(0xFFFFD700),
      Color(0xFFC0C0C0),
      Color(0xFFCD7F32),
    ];
    if (index < 3) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: rankColors[index],
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return Text(
      '${index + 1}',
      style: const TextStyle(
        color: AppColors.invateScreenColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildErrorPlaceholder({
    required VoidCallback onRetry,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingRulesButton(BuildContext context) {
    return Positioned(
      right: 0,
      top: MediaQuery.of(context).size.height * 0.25,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const InvateRuleScreen()),
          );
        },
        child: Container(
          width: 28,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '邀',
                style: TextStyle(
                  color: AppColors.btnText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '请',
                style: TextStyle(
                  color: AppColors.btnText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '规',
                style: TextStyle(
                  color: AppColors.btnText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '则',
                style: TextStyle(
                  color: AppColors.btnText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.imagePath, required this.onTap});

  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(height: 48, child: Image.asset(imagePath)),
    );
  }
}

class _CustomActionButton extends StatelessWidget {
  const _CustomActionButton({
    required this.text,
    required this.onTap,
    this.height,
    this.padding,
    this.fontSize,
    this.textColor,
  });

  final String text;
  final VoidCallback onTap;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.secondaryGradientStart,
              AppColors.secondaryGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(83),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

class _InviteDetailButton extends StatelessWidget {
  const _InviteDetailButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 52,
        height: 26,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/invate/yqbt.png', fit: BoxFit.fill),
            Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InviteHeroBanner extends StatelessWidget {
  const _InviteHeroBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _HeroBackgroundImage(),
          // const Positioned(
          //   top: 120,
          //   left: 70,
          //   child: _GradientSkewText(text: '邀好友，赚现金', fontSize: 34),
          // ),
          // Positioned(
          //   top: 190,
          //   left: 50,
          //   child: _GradientSkewText(text: '多邀多得，上不封顶', fontSize: 32),
          // ),
        ],
      ),
    );
  }
}

class _HeroBackgroundImage extends StatelessWidget {
  const _HeroBackgroundImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/invate/invate2get3.png',
      fit: BoxFit.cover,
    );
  }
}

class _GradientSkewText extends StatelessWidget {
  const _GradientSkewText({required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(1, 0, math.tan(-1 * math.pi / 180)),
      alignment: Alignment.centerLeft,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) {
          return const LinearGradient(
            colors: [Color(0xFFFFF4E2), Color(0xFFFFE492)],
          ).createShader(bounds);
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
