import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';

class HomeA extends StatelessWidget {
  const HomeA({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: StyledText('Face A - Home Page')),
    );
  }
}
