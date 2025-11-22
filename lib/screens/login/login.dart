import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/login/invitation_screen.dart';
import 'package:zhenyu_flutter/screens/main_frame.dart';
import 'package:zhenyu_flutter/screens/register/user_register_screen.dart';
import 'package:zhenyu_flutter/shared/custom_text_field.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  // true: 验证码登录, false: 密码登录
  bool _isCodeLogin = true;
  bool _passwordVisible = false;

  bool _isSending = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isSending = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isSending = false;
          _countdown = 60;
        });
      }
    });
  }

  Future<void> _sendSms() async {
    if (_isSending) return;
    if (_phoneController.text.length != 11) {
      showMsg(context, '请输入有效的手机号');
      return;
    }
    try {
      final data = GetSmsData(
        phone: _phoneController.text,
        scene: SmsScene.login,
      );
      await UserApi.getSms(data);
      showMsg(context, '验证码已发送');
      _startCountdown();
    } catch (e) {
      showMsg(context, '发送失败，请稍后重试');
    }
  }

  Future<void> _login() async {
    if (_phoneController.text.isEmpty) {
      showMsg(context, '请输入手机号');
      return;
    }

    LoginData data;
    if (_isCodeLogin) {
      if (_codeController.text.isEmpty) {
        showMsg(context, '请输入验证码');
        return;
      }
      data = LoginData(
        loginType: LoginType.verCode,
        mobile: _phoneController.text,
        code: _codeController.text,
      );
    } else {
      if (_passwordController.text.isEmpty) {
        showMsg(context, '请输入密码');
        return;
      }
      data = LoginData(
        loginType: LoginType.pwd,
        mobile: _phoneController.text,
        password: _passwordController.text,
      );
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await userProvider.login(data);

    if (!mounted) return;

    switch (result.type) {
      case LoginResultType.success:
        showMsg(context, '登录成功！');
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainFrame()),
              (Route<dynamic> route) => false,
            );
          }
        });
        break;
      // 需要填写信息
      case LoginResultType.needsProfileCompletion:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserDataScreen(
              extraParam: result.data!.extraParam!,
              mobile: _phoneController.text,
              smsCode: _codeController.text,
            ),
          ),
        );
        break;
      // 需要邀请码
      case LoginResultType.needsInvitationCode:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InvitationScreen(
              reviewParam: result.data!.reviewParam,
              reviewStatus: result.data!.reviewStatus,
            ),
          ),
        );
        break;
      case LoginResultType.failed:
        showMsg(context, result.message ?? '登录失败');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledText.primaryBold('登录', fontSize: 36.sp)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),
              StyledText.primaryBold(
                _isCodeLogin ? '短信验证码登录/注册' : '密码登录',
                fontSize: 38.sp,
              ),
              SizedBox(height: 10.h),
              StyledText.secondary('未注册的手机号验证后自动登录', fontSize: 29.sp),
              SizedBox(height: 40.h),
              CustomTextField(
                prefixText: '+86',
                hintText: '请输入手机号',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
              ),
              SizedBox(height: 40.h),
              // 验证码输入框
              Visibility(
                visible: _isCodeLogin,
                child: CustomTextField(
                  prefixText: '验证码',
                  hintText: '请输入验证码',
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  suffix: GestureDetector(
                    onTap: _sendSms,
                    child: Container(
                      padding: EdgeInsets.only(right: 20.w),
                      child: StyledText(
                        _isSending ? '$_countdown s' : '获取验证码',
                        fontSize: 25.sp,
                        style: const TextStyle(
                          color: AppColors.secondaryGradientStart,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 密码输入框
              Visibility(
                visible: !_isCodeLogin,
                child: CustomTextField(
                  prefixText: '密码',
                  hintText: '请输入密码',
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // 切换登录方式
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCodeLogin = !_isCodeLogin;
                      });
                    },
                    child: StyledText(
                      _isCodeLogin ? '密码登录' : '验证码登录',
                      fontSize: 26.sp,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60.h),
              StyledButton(
                onPressed: _login,
                width: 650.w,
                height: 90.h,
                borderRadius: BorderRadius.circular(80.r),
                gradient: AppGradients.secondaryGradient,
                child: StyledText.inButton('登录', fontSize: 32.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
