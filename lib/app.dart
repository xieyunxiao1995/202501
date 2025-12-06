import 'package:flutter/material.dart';
import 'screens/discovery_screen.dart';
import 'screens/expert_camping_screen.dart';
import 'screens/camp_log_screen.dart';
import 'screens/community_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/custom_bottom_nav.dart';

/// Main application widget with bottom navigation
class CelvaApp extends StatefulWidget {
  const CelvaApp({super.key});

  @override
  State<CelvaApp> createState() => _CelvaAppState();
}

class _CelvaAppState extends State<CelvaApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DiscoveryScreen(),
    ExpertCampingScreen(),
    CampLogScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
