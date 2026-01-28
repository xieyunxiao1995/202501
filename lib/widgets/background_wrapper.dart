import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundWrapper extends StatefulWidget {
  final Widget child;
  final String backgroundImage;
  final double overlayOpacity;
  final bool enableRotation;

  const BackgroundWrapper({
    super.key,
    required this.child,
    this.backgroundImage = 'assets/bg/Bg1.jpeg',
    this.overlayOpacity = 0.7,
    this.enableRotation = true,
  });

  @override
  State<BackgroundWrapper> createState() => _BackgroundWrapperState();
}

class _BackgroundWrapperState extends State<BackgroundWrapper> {
  late String _currentImage;
  Timer? _timer;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.backgroundImage;

    if (widget.enableRotation) {
      // Random start index to provide variety
      _currentIndex = Random().nextInt(31) + 1;
      _updateImage();

      _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex % 31) + 1;
            _updateImage();
          });
        }
      });
    }
  }

  void _updateImage() {
    _currentImage = 'assets/bg/Bg$_currentIndex.jpeg';
  }

  @override
  void didUpdateWidget(BackgroundWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.backgroundImage != oldWidget.backgroundImage) {
      _currentImage = widget.backgroundImage;
      // If we want to restart the rotation sequence or just update current:
      // Since rotation changes _currentIndex, and _currentImage is derived from it in timer,
      // but here we are setting it directly.
      // If rotation is enabled, the next timer tick will overwrite this with Bg{_currentIndex}.
      // If we want to respect the parent's change, we might want to update _currentIndex too if the new image fits the pattern.
      
      // Attempt to parse index from "assets/bg/Bg{X}.jpeg"
      final match = RegExp(r'Bg(\d+)\.jpeg').firstMatch(widget.backgroundImage);
      if (match != null) {
        _currentIndex = int.parse(match.group(1)!);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: Image.asset(
              _currentImage,
              key: ValueKey(_currentImage),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFF111827));
              },
            ),
          ),
        ),
        // Overlay Mask
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: widget.overlayOpacity),
          ),
        ),
        // Content
        Positioned.fill(child: widget.child),
      ],
    );
  }
}
