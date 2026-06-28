import 'package:flutter/material.dart';

import '../pages/launch/launch_flow_page.dart';
import 'app_theme.dart';

class CpClothApp extends StatelessWidget {
  const CpClothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPDD小屋',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LaunchFlowPage(),
    );
  }
}
