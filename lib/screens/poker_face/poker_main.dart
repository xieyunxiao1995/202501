import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/screens/poker_face/poker_home.dart';
import 'package:zhenyu_flutter/screens/poker_face/poker_profile.dart';

class PokerMainFrame extends StatefulWidget {
  const PokerMainFrame({super.key});

  @override
  State<PokerMainFrame> createState() => _PokerMainFrameAState();
}

class _PokerMainFrameAState extends State<PokerMainFrame> {
  int _currentIndex = 0;
  final List<Widget> _pages = [const HomeA(), const ProfileA()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
