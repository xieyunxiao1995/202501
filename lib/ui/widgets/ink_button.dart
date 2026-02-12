import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class InkButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double? fontSize;
  final EdgeInsets? padding;

  const InkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize,
    this.padding,
  });

  @override
  State<InkButton> createState() => _InkButtonState();
}

class _InkButtonState extends State<InkButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 380;
    final double effectiveFontSize = widget.fontSize ?? (isSmallScreen ? 20 : 24);
    final EdgeInsets effectivePadding = widget.padding ?? 
        (isSmallScreen ? const EdgeInsets.symmetric(horizontal: 24, vertical: 12) 
                       : const EdgeInsets.symmetric(horizontal: 40, vertical: 16));

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: Transform.rotate(
            angle: -0.035, // -2 degrees
            child: Container(
              padding: effectivePadding,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.inkRed,
                  width: 3,
                  style: BorderStyle.solid,
                ),
                color: AppColors.inkRed.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.inkRed.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.inkRed,
                  fontWeight: FontWeight.bold,
                  fontSize: effectiveFontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
