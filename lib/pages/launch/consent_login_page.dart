import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../widgets/ambient_background.dart';
import 'eula_page.dart';

class ConsentLoginPage extends StatefulWidget {
  const ConsentLoginPage({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  State<ConsentLoginPage> createState() => _ConsentLoginPageState();
}

class _ConsentLoginPageState extends State<ConsentLoginPage> {
  bool _accepted = false;

  void _openEula() {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (_) => const EulaPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 36,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.ink,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text(
                                'CP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 11),
                          const Text(
                            'CPDD小屋',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(34),
                          border: Border.all(color: AppColors.divider),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x133978F6),
                              blurRadius: 30,
                              offset: Offset(0, 16),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/onboarding/identity.png',
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.55),
                          semanticLabel: '蓝色长裙、衣架与晨光的水彩插画',
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        '欢迎回来',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '不需要账号或密码。确认许可协议后，即可进入你的私人衣橱。',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _accepted
                                ? AppColors.primary.withValues(alpha: 0.35)
                                : AppColors.divider,
                          ),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _accepted,
                              onChanged: (value) =>
                                  setState(() => _accepted = value ?? false),
                            ),
                            const Text(
                              '我已阅读并同意',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Flexible(
                              child: TextButton(
                                onPressed: _openEula,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 12,
                                  ),
                                  minimumSize: const Size(44, 44),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('《最终用户许可协议》'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: _accepted ? widget.onLogin : null,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('登录并进入'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '本次同意仅用于当前启动；下次打开应用时会再次确认。',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
