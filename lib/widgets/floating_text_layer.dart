import 'package:flutter/material.dart';
import '../models/configs.dart';

class FloatingTextLayer extends StatelessWidget {
  final List<FloatingTextData> floatingTexts;

  const FloatingTextLayer({super.key, required this.floatingTexts});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: floatingTexts.map((ft) => _FloatingTextItem(key: ValueKey(ft.id), data: ft)).toList(),
      ),
    );
  }
}

class _FloatingTextItem extends StatefulWidget {
  final FloatingTextData data;

  const _FloatingTextItem({super.key, required this.data});

  @override
  _FloatingTextItemState createState() => _FloatingTextItemState();
}

class _FloatingTextItemState extends State<_FloatingTextItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.6, 1.0, curve: Curves.easeOut)),
    );
    _offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -60)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Parse color string roughly or default
    Color color = Colors.white;
    if (widget.data.color.contains('red')) {
      color = Colors.red;
    } else if (widget.data.color.contains('green')) {
      color = Colors.green;
    } else if (widget.data.color.contains('blue')) {
      color = Colors.blue;
    } else if (widget.data.color.contains('yellow')) {
      color = Colors.yellow;
    } else if (widget.data.color.contains('purple')) {
      color = Colors.purpleAccent;
    } else if (widget.data.color.contains('cyan')) {
      color = Colors.cyanAccent;
    } else if (widget.data.color.contains('gray')) {
      color = Colors.grey;
    }

    return Positioned(
      left: widget.data.x - 50, // Center roughly
      top: widget.data.y,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _offset.value,
            child: Opacity(
              opacity: _opacity.value,
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  widget.data.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1, 1))],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
