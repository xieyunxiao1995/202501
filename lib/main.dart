import 'package:flutter/material.dart';
import 'screens/game_container.dart';

void main() {
  runApp(const ShanhaiDungenApp());
}

class ShanhaiDungenApp extends StatelessWidget {
  const ShanhaiDungenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shanhai Dungen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF111827), // gray-900
        fontFamily: 'Roboto', // Default flutter font, but good to specify if needed.
        useMaterial3: true,
      ),
      home: const GameContainer(),
    );
  }
}
