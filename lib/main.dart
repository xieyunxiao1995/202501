import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'services/local_storage_service.dart';
import 'screens/splash_screen.dart';

/// Main entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await LocalStorageService().init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

/// Root app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppInitializer(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/main': (context) => const CelvaApp(),
      },
    );
  }
}

/// 应用初始化器 - 检查是否已同意协议
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _checkEULAStatus();
  }

  Future<void> _checkEULAStatus() async {
    // 检查用户是否已同意EULA
    final hasAgreedEULA = await LocalStorageService().hasAgreedEULA();

    // 添加短暂延迟以显示加载状态
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      if (hasAgreedEULA) {
        // 已同意，直接进入主界面
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        // 未同意，显示启动界面
        Navigator.of(context).pushReplacementNamed('/splash');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 显示加载界面
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.outdoor_grill_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // 加载指示器
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
