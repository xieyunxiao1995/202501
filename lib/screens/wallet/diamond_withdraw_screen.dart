import 'package:flutter/material.dart';

import 'package:zhenyu_flutter/api/diamond_api.dart';
import 'package:zhenyu_flutter/models/diamond_api_model.dart';
import 'package:zhenyu_flutter/screens/authentication/auth_center_screen.dart';
import 'package:zhenyu_flutter/theme.dart';

class DiamondWithdrawScreen extends StatefulWidget {
  const DiamondWithdrawScreen({super.key});

  @override
  State<DiamondWithdrawScreen> createState() => _DiamondWithdrawScreenState();
}

class _DiamondWithdrawScreenState extends State<DiamondWithdrawScreen> {
  DiamondWithdrawConfigData? _config;
  bool _isLoading = true;
  bool _isSubmitting = false;

  final TextEditingController _diamondController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _zfbController = TextEditingController();
  final TextEditingController _zfbMobileController = TextEditingController();

  String _realName = '';

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _diamondController.dispose();
    _moneyController.dispose();
    _zfbController.dispose();
    _zfbMobileController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final resp = await DiamondApi.getWithdrawConfig();
      if (!mounted) return;
      if (resp.code == 0) {
        final data = resp.data;
        setState(() {
          _config = data;
          _realName = data?.realName ?? '';
          _zfbController.text = data?.zfbAccount ?? '';
          _zfbMobileController.text = data?.zfbMobile ?? '';
          if (data != null &&
              data.availableDiamond != null &&
              data.shellRate != null &&
              data.shellRate! > 0) {
            final initialMoney = data.availableDiamond! / data.shellRate!;
            _moneyController.text = _formatAmount(initialMoney);
          } else {
            _moneyController.clear();
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showMessage(resp.message ?? '加载失败');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showMessage('加载失败: $e');
    }
  }

  void _onDiamondChanged(String value) {
    final shellRate = _config?.shellRate;
    if (shellRate == null || shellRate == 0) {
      _moneyController.clear();
      return;
    }
    final diamond = int.tryParse(value);
    if (diamond == null) {
      _moneyController.clear();
      return;
    }
    final money = diamond / shellRate;
    final formatted = _formatAmount(money);
    if (_moneyController.text != formatted) {
      _moneyController.text = formatted;
    }
  }

  String _formatAmount(num value) {
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final diamondText = _diamondController.text.trim();
    final zfbAccount = _zfbController.text.trim();
    final zfbMobile = _zfbMobileController.text.trim();

    if (diamondText.isEmpty || zfbAccount.isEmpty || zfbMobile.isEmpty) {
      _showMessage('请完善资料');
      return;
    }

    final diamond = int.tryParse(diamondText);
    if (diamond == null || diamond <= 0) {
      _showMessage('请输入有效的提现钻石数量');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final res = await DiamondApi.withdrawApply(
        DiamondWithdrawApplyReq(
          diamond: diamond,
          zfbAccount: zfbAccount,
          zfbMobile: zfbMobile,
        ),
      );
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });

      final code = res['code'] as int? ?? -1;
      final message = res['message'] as String? ?? '';

      if (code == 0) {
        _diamondController.clear();
        _moneyController.clear();
        _showMessage(message.isEmpty ? '提交成功' : message);
        _loadConfig();
      } else {
        _showMessage(message.isEmpty ? '提交失败' : message);
        if (code == 2007 || code == 2006 || code == 2008) {
          _showAuthDialog(code);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      _showMessage('提交失败: $e');
    }
  }

  Future<void> _cancelWithdraw(int id) async {
    try {
      final res = await DiamondApi.withdrawCancel(
        DiamondWithdrawCancelReq(id: id),
      );
      final code = res['code'] as int? ?? -1;
      final message = res['message'] as String? ?? '撤销失败';
      if (code == 0) {
        _showMessage('撤销成功');
        _loadConfig();
      } else {
        _showMessage(message);
      }
    } catch (e) {
      _showMessage('撤销失败: $e');
    }
  }

  void _showAuthDialog(int code) {
    final needRealName = code == 2007;
    final title = needRealName ? '提现需实名认证，当前帐号未实名' : '实名审核中，请耐心等待';

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.textFieldBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            if (needRealName)
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.secondaryGradientStart,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AuthCenterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        '去实名',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.secondaryGradientStart,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    '确认',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('钻石提现')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildTopCard(),
                      const SizedBox(height: 24),
                      _buildForm(),
                      if ((_config?.reviewList?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 24),
                        _buildReviewList(),
                      ],
                      const SizedBox(height: 24),
                      _buildFooter(),
                      const SizedBox(height: 160),
                    ],
                  ),
                ),
                _buildSubmitButton(),
              ],
            ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      width: double.infinity,
      height: 125,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/wallet/diamond_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '可提现钻石：',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Image.asset(
                'assets/images/wallet/diamond.png',
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8),
              Text(
                '${_config?.availableDiamond ?? 0}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.containerBlackColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildFormRow(
            label: '提现钻石',
            child: TextField(
              controller: _diamondController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: '请输入钻石数量',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: _onDiamondChanged,
            ),
          ),
          _buildFormRow(
            label: '提现金额',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _moneyController,
                    enabled: false,
                    style: const TextStyle(color: Colors.white54),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const Text('元', style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          _buildFormRow(
            label: '提现支付宝',
            child: TextField(
              controller: _zfbController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: '请输入支付宝账号',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          _buildFormRow(
            label: '手机号码',
            child: TextField(
              controller: _zfbMobileController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: '请输入手机号码',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          _buildFormRow(
            label: '提现姓名',
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _realName.isEmpty ? '未实名' : _realName,
                style: const TextStyle(color: Colors.white54),
              ),
            ),
            isReadOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow({
    required String label,
    required Widget child,
    bool isReadOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isReadOnly
                    ? Colors.white.withOpacity(0.05)
                    : const Color.fromRGBO(255, 255, 255, 0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    final reviewList = _config?.reviewList;
    if (reviewList == null || reviewList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.containerBlackColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '申请中',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...reviewList.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '提现${_formatAmount(item.money ?? 0)}元',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.createTime ?? '',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (item.id != null) {
                        _cancelWithdraw(item.id!);
                      }
                    },
                    child: const Text(
                      '撤销',
                      style: TextStyle(color: AppColors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final instructions = [
      '1.提现支付宝账号必须与平台实名一致；',
      '2.单次提现最少为1000钻石（10元）；',
      '3.单次提现钻石数必须为10的整数；',
      '4.每笔提现平台将收取6%的服务费；',
      '5.每笔提现申请预计在72小时内进行打款；',
      '6.若用户存在违法违规行为，平台将拒绝提现；',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '提现须知：',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 12),
          ...instructions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 32,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: AppGradients.paleGoldGradient,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  '确定提现',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
