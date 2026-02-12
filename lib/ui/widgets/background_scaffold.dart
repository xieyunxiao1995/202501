import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final Widget body;
  final String backgroundImage;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final double opacity;

  const BackgroundScaffold({
    super.key,
    required this.body,
    required this.backgroundImage,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.opacity = 0.5, // Default opacity for the black layer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow background to extend behind app bar
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            backgroundImage,
            fit: BoxFit.cover,
          ),
          // Black Overlay
          Container(
            color: Colors.black.withOpacity(opacity),
          ),
          // Content
          SafeArea(
            top: appBar == null, // Only safe area top if no app bar, or handle inside body
            child: body,
          ),
        ],
      ),
    );
  }
}
