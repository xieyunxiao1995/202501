import 'package:flutter/material.dart';
import 'dart:ui';
import 'Moodscreens/home_screen.dart';
import 'Moodscreens/explore_screen.dart';
import 'Moodscreens/ai_screen.dart';
import 'Moodscreens/settings_screen.dart';
import 'Moodscreens/journal_editor_screen.dart';
import 'Moodscreens/journal_detail_screen.dart';
import 'Moodservices/storage_service.dart';

class MoodoraApp extends StatefulWidget {
  final StorageService storageService;
  const MoodoraApp({super.key, required this.storageService});

  @override
  State<MoodoraApp> createState() => _MoodoraAppState();
}

class _MoodoraAppState extends State<MoodoraApp> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(storageService: widget.storageService),
      ExploreScreen(storageService: widget.storageService),
      AIScreen(storageService: widget.storageService),
      SettingsScreen(storageService: widget.storageService),
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void navigateToEditor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEditorScreen(
          storageService: widget.storageService,
        ),
      ),
    );
    
    if (result != null) {
      // Refresh both home and explore screens
      setState(() {
        _screens[0] = HomeScreen(storageService: widget.storageService);
        _screens[1] = ExploreScreen(storageService: widget.storageService);
      });
    }
  }

  void navigateToDetail(String journalId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalDetailScreen(
          journalId: journalId,
          storageService: widget.storageService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      floatingActionButton: _currentIndex == 0
          ? Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A7CF5).withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: navigateToEditor,
                  borderRadius: BorderRadius.circular(34),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 28),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, Icons.home_outlined, 0),
                  _buildNavItem(Icons.explore, Icons.explore_outlined, 1),
                  _buildNavItem(Icons.smart_toy, Icons.smart_toy_outlined, 2),
                  _buildNavItem(Icons.person, Icons.person_outline, 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData inactiveIcon, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF8A7CF5).withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isActive ? activeIcon : inactiveIcon,
          color: isActive ? const Color(0xFF8A7CF5) : const Color(0xFF808080),
          size: 24,
        ),
      ),
    );
  }
}
