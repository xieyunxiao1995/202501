import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';

class ProfileA extends StatelessWidget {
  const ProfileA({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: StyledText('Face A - Profile Page')),
    );
  }
}
