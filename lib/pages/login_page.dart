import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../models/data.dart';
import 'main_screen.dart';
import 'eula_page.dart';
import '../utils/responsive_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _isAgreed = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('请阅读并同意用户协议'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: '查看协议',
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EulaPage()),
              );
            },
          ),
        ),
      );
      return;
    }

    // Mark as logged in
    AppState.instance.setLoggedIn(true);

    // Navigate to Main Screen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.getScaleFactor(context);
    final padding = ResponsiveHelper.responsivePadding(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 2),
                        Container(
                          width: 100 * scale,
                          height: 100 * scale,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 15 * scale,
                                spreadRadius: 2 * scale,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.checkroom,
                            size: 50 * scale,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 32 * scale),
                        Text(
                          'MoodStyle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36 * scale,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        SizedBox(height: 12 * scale),
                        Text(
                          '欢迎使用 MoodStyle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16 * scale,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8 * scale),
                        Text(
                          '记录穿搭，分享心情',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14 * scale,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.grey.shade400,
                              ),
                              child: Checkbox(
                                value: _isAgreed,
                                onChanged: (value) {
                                  setState(() {
                                    _isAgreed = value ?? false;
                                  });
                                },
                                activeColor: AppColors.primary,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EulaPage(),
                                    ),
                                  ).then((_) {
                                    if (AppState.instance.eulaAgreed) {
                                      setState(() {
                                        _isAgreed = true;
                                      });
                                    }
                                  });
                                },
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14 * scale,
                                      color: Colors.grey.shade700,
                                    ),
                                    children: [
                                      TextSpan(text: '我已阅读并同意'),
                                      TextSpan(
                                        text: '《用户协议》',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24 * scale),
                        GestureDetector(
                          onTap: _handleLogin,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16 * scale),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 10 * scale,
                                  offset: Offset(0, 4 * scale),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login, color: Colors.white, size: 20 * scale),
                                  SizedBox(width: 8 * scale),
                                  Text(
                                    '进入应用',
                                    style: TextStyle(
                                      fontSize: 18 * scale,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16 * scale),
                        Text(
                          '无需注册账号。进入应用即表示你同意用户协议。',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12 * scale,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
