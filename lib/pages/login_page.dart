import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/route_guard.dart';
import '../core/router/route_paths.dart';

/// 登录页
///
/// 包含账号密码登录、第三方登录以及服务器选择入口。
/// 与闪屏页共享暗红渐变背景风格，保持视觉一致性。
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _accountController = TextEditingController();
  final _accountFocusNode = FocusNode();
  bool _agreedToTerms = false;
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _accountController.dispose();
    _accountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_agreedToTerms) {
      _showSnackBar('请先阅读并同意用户协议和隐私政策');
      return;
    }
    if (_accountController.text.trim().isEmpty) {
      _showSnackBar('请输入任意账号');
      return;
    }

    setState(() => _isLoggingIn = true);

    // TODO: 接入 AuthApi / LoginUseCase 进行真实登录
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoggingIn = false);

    // 登录成功后更新守卫状态并跳转到主页
    if (mounted) {
      RouteGuard.isLoggedIn.value = true;
      RouteGuard.hasCompletedTutorial.value = true;
      context.go(RoutePaths.home);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF120D0D),
                Color(0xFF241616),
                Color(0xFF090909),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ---- 游戏标题 ----
                    const _GameTitle(),
                    const SizedBox(height: 40),

                    // ---- 登录表单 ----
                    _LoginForm(
                      accountController: _accountController,
                      accountFocusNode: _accountFocusNode,
                      onToggleObscure: () {},
                    ),
                    const SizedBox(height: 12),

                    // ---- 记住密码 & 协议 ----
                    _LoginOptions(
                      agreedToTerms: _agreedToTerms,
                      onToggleAgreement: (v) =>
                          setState(() => _agreedToTerms = v!),
                    ),
                    const SizedBox(height: 24),

                    // ---- 登录按钮 ----
                    _LoginButton(
                      isLoading: _isLoggingIn,
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== 游戏标题 ====================

/// 游戏标题 "三国谋定天下"
class _GameTitle extends StatelessWidget {
  const _GameTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '三国天下',
          style: TextStyle(
            fontSize: 32,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE2D9CD),
            fontFamily: 'STKaiti, Kaiti SC, KaiTi, serif',
            shadows: [
              Shadow(
                color: Color(0xCC7A0D0D),
                blurRadius: 12,
                offset: Offset(0, 0),
              ),
              Shadow(
                color: Color(0xE6000000),
                blurRadius: 2,
                offset: Offset(2, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 48,
          height: 1.5,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Color(0x99A11717), Colors.transparent],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '运筹帷幄 · 逐鹿中原',
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 4,
            color: Color(0x998B7E6A),
          ),
        ),
      ],
    );
  }
}

// ==================== 登录表单 ====================

/// 账号密码输入表单
class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.accountController,
    required this.accountFocusNode,
    required this.onToggleObscure,
  });

  final TextEditingController accountController;
  final FocusNode accountFocusNode;
  final VoidCallback onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _InputField(
          controller: accountController,
          focusNode: accountFocusNode,
          hintText: '请输入任意账号',
          prefixIcon: Icons.person_outline,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}

/// 单个输入框
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        color: Color(0xFFE2D9CD),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0x558B7E6A),
          fontSize: 15,
        ),
        prefixIcon: Icon(prefixIcon, size: 20, color: const Color(0x998B7E6A)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0x18FFFFFF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0x306A0F0F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0x99A11717), width: 1.2),
        ),
      ),
    );
  }
}

// ==================== 记住密码 & 协议 ====================

/// 记住密码和用户协议勾选行
class _LoginOptions extends StatelessWidget {
  const _LoginOptions({
    required this.agreedToTerms,
    required this.onToggleAgreement,
  });

  final bool agreedToTerms;
  final ValueChanged<bool?> onToggleAgreement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 32,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: agreedToTerms,
                  onChanged: onToggleAgreement,
                  activeColor: const Color(0xFFA11717),
                  side: const BorderSide(color: Color(0x55A11717)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => onToggleAgreement(!agreedToTerms),
                child: const Text(
                  '同意《用户协议》和《隐私政策》',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0x998B7E6A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== 登录按钮 ====================

/// 登录按钮
class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFFA11717), Color(0xFF6A0F0F)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40A11717),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: isLoading ? null : onPressed,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFE2D9CD)),
                      ),
                    )
                  : const Text(
                      '登  录',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE2D9CD),
                        letterSpacing: 6,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}