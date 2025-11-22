import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  SecurityInfoData? _info;
  bool _loadingInfo = false;
  bool _sendingCode = false;
  bool _submitting = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadSecurityInfo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _loadSecurityInfo() async {
    if (_loadingInfo) return;
    setState(() {
      _loadingInfo = true;
    });

    try {
      final resp = await UserApi.getSecurityInfo();
      if (!mounted) return;
      if (resp.code == 0) {
        setState(() {
          _info = resp.data;
        });
      } else {
        showMsg(context, resp.message ?? '获取账号信息失败');
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '获取账号信息失败');
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _loadingInfo = false;
      });
    }
  }

  Future<void> _sendSmsCode() async {
    if (_sendingCode) return;

    final mobile = _info?.mobile;
    if (mobile == null || mobile.isEmpty) {
      showMsg(context, '未获取到手机号');
      return;
    }

    setState(() {
      _sendingCode = true;
    });

    try {
      final response = await UserApi.getSms(
        GetSmsData(phone: mobile, scene: SmsScene.resetPassword),
      );
      if (!mounted) return;

      final data = response.data;
      if (data is Map && data['code'] == 0) {
        showMsg(context, '验证码已发送');
        _startCountdown();
      } else {
        setState(() {
          _sendingCode = false;
        });
        showMsg(context, data is Map ? data['message'] ?? '发送失败' : '发送失败');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _sendingCode = false;
      });
      showMsg(context, '发送失败');
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _countdown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown <= 1) {
        timer.cancel();
        setState(() {
          _sendingCode = false;
        });
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  Future<void> _submit() async {
    if (_submitting) return;

    final code = _codeController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmController.text;

    if (code.isEmpty) {
      showMsg(context, '请输入验证码');
      return;
    }
    if (password.isEmpty || confirmPassword.isEmpty) {
      showMsg(context, '请输入密码');
      return;
    }
    if (password != confirmPassword) {
      showMsg(context, '两次密码不一致');
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      final resp = await UserApi.resetPassword(
        ResetPasswordRequest(password: password, code: code),
      );
      if (!mounted) return;

      if (resp.code == 0) {
        FocusScope.of(context).unfocus();
        showMsg(context, '修改成功');
        Navigator.of(context).pop();
      } else {
        showMsg(context, resp.message ?? '修改失败');
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '修改失败');
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _submitting = false;
      });
    }
  }

  String _maskedMobile() {
    final mobile = _info?.mobile;
    if (mobile == null || mobile.isEmpty) {
      return '未绑定手机号';
    }
    if (mobile.length < 7) {
      return mobile;
    }
    return '${mobile.substring(0, 3)}****${mobile.substring(mobile.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledText('修改密码', fontSize: 18),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            _buildFormBox(),
            const SizedBox(height: 48),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tabBarBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          _buildItem(
            label: '手机号码',
            child: Text(
              _loadingInfo ? '加载中…' : _maskedMobile(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 12),
          _buildItem(
            label: '输入验证码',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: '请输入验证码',
                      hintStyle: TextStyle(
                        color: Color(0x80FFFFFF),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _sendingCode
                    ? Text(
                        '已获取(${_countdown})',
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 12,
                        ),
                      )
                    : GestureDetector(
                        onTap: _sendSmsCode,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          '获取验证码',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            foreground: Paint()
                              ..shader =
                                  const LinearGradient(
                                    colors: [
                                      AppColors.secondaryGradientStart,
                                      AppColors.secondaryGradientEnd,
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 100, 12),
                                  ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildItem(
            label: '输入新密码',
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: '请输入新密码',
                hintStyle: TextStyle(color: Color(0x80FFFFFF), fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildItem(
            label: '确认新密码',
            child: TextField(
              controller: _confirmController,
              obscureText: true,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: '请确认新密码',
                hintStyle: TextStyle(color: Color(0x80FFFFFF), fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 86,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: Align(alignment: Alignment.centerLeft, child: child),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _submitting ? null : _submit,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          gradient: _submitting
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
          _submitting ? '提交中…' : '确认修改',
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
