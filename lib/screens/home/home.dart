import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledText.primaryBold('Home Page', fontSize: 18),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const StyledText.primaryBold('Welcome!', fontSize: 24),
            const SizedBox(height: 10),
            const StyledText(
              'This is the home page, styled with custom text widgets.',
              fontSize: 16,
            ),
            StyledButton(onPressed: () {}, child: const Text('hee')),
          ],
        ),
      ),
    );
  }
}
