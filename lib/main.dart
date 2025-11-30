import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/card_stack.dart';
import 'models/diary_entry.dart';
import 'constants/app_colors.dart';
import 'constants/sample_data.dart';
import 'services/storage_service.dart';
import 'widgets/bottom_nav.dart';
import 'pages/home_page.dart';
import 'pages/companion_page.dart';
import 'pages/square_page.dart';
import 'pages/settings_page.dart';
import 'pages/editor_page.dart';
import 'pages/splash_page.dart';
import 'pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化日期格式化
  await initializeDateFormatting('zh_CN', null);
  Intl.defaultLocale = 'zh_CN';
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MindFlowApp());
}

class MindFlowApp extends StatelessWidget {
  const MindFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '心屿 MindFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: AppColors.tableBackground,
        useMaterial3: true,
      ),
      home: const AppInitializer(),
      routes: {
        '/main': (context) => const MainPage(),
        '/welcome': (context) => const WelcomePage(),
      },
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // 显示闪屏至少2秒
    await Future.delayed(const Duration(seconds: 2));
    
    // 检查用户是否已同意EULA
    final hasAccepted = await StorageService.hasAcceptedEula();
    
    if (mounted) {
      if (hasAccepted) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        Navigator.of(context).pushReplacementNamed('/welcome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<CardStack> _stacks = [];
  AppPage _activePage = AppPage.home;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final savedStacks = await StorageService.loadStacks();
    setState(() {
      _stacks = savedStacks ?? SampleData.getInitialStacks();
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    await StorageService.saveStacks(_stacks);
  }

  void _handleStackUpdate(List<CardStack> newStacks) {
    setState(() {
      _stacks = newStacks;
    });
    _saveData();
  }

  void _handleSaveEntry(String content, bool isPrivate, String? image, Mood mood) {
    final newEntry = DiaryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      content: content,
      image: image,
      mood: mood,
      location: '我的书桌',
    );

    final newStack = CardStack(
      id: 'stack-${newEntry.id}',
      cards: [newEntry],
      zIndex: _stacks.length,
      position: Offset(0, 0),
    );

    setState(() {
      _stacks = [..._stacks, newStack];
      _activePage = AppPage.home;
    });
    _saveData();
  }

  void _openEditor() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: EditorPage(onSave: _handleSaveEntry),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.ink,
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // 页面内容
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildActivePage(),
          ),

          // 底部导航
          BottomNav(
            activePage: _activePage,
            onNavigate: (page) {
              setState(() {
                _activePage = page;
              });
            },
            onOpenEditor: _openEditor,
          ),
        ],
      ),
    );
  }

  Widget _buildActivePage() {
    switch (_activePage) {
      case AppPage.home:
        return HomePage(
          key: const ValueKey('home'),
          stacks: _stacks,
          onStackUpdate: _handleStackUpdate,
        );
      case AppPage.companion:
        return const CompanionPage(key: ValueKey('companion'));
      case AppPage.square:
        return const SquarePage(key: ValueKey('square'));
      case AppPage.settings:
        return const SettingsPage(key: ValueKey('settings'));
    }
  }
}
