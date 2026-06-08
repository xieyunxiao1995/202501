import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';

/// 登录页
///
/// 提供账号密码登录和第三方登录（微信、QQ）入口。
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      // TODO: 实际登录逻辑
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.go(RoutePaths.home);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 标题
              Text(
                '三国谋定天下',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '运筹帷幄，决胜千里',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 48),

              // 用户名输入
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: '请输入账号',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              // 密码输入
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '请输入密码',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 32),

              // 登录按钮
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('登 录'),
                ),
              ),
              const SizedBox(height: 24),

              // 第三方登录
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ThirdPartyButton(
                    icon: Icons.chat_bubble,
                    label: '微信',
                    onTap: () {
                      // TODO: 微信登录
                    },
                  ),
                  const SizedBox(width: 32),
                  _ThirdPartyButton(
                    icon: Icons.people,
                    label: 'QQ',
                    onTap: () {
                      // TODO: QQ 登录
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThirdPartyButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ThirdPartyButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
