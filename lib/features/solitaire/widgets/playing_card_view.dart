import 'package:flutter/material.dart';

import '../models/card_model.dart';

class PlayingCardView extends StatelessWidget {
  const PlayingCardView({
    super.key,
    required this.card,
    required this.width,
    this.selected = false,
  });

  final PlayingCard card;
  final double width;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final height = width * 1.42;
    if (!card.isFaceUp) {
      return _CardBack(width: width, height: height, selected: selected);
    }
    if (card.isJoker) {
      return _JokerFace(width: width, height: height, selected: selected);
    }
    final color = card.isRed
        ? const Color(0xFFB42D2D)
        : const Color(0xFF15221B);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF4),
        borderRadius: BorderRadius.circular(width * .09),
        border: Border.all(
          color: selected ? const Color(0xFFF7D75C) : const Color(0xFFDDD4BA),
          width: selected ? 2.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .35),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width * .09),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.rank.label,
                  style: TextStyle(
                    color: color,
                    fontSize: width * .27,
                    fontWeight: FontWeight.w900,
                    height: .9,
                  ),
                ),
                Text(
                  card.suit.symbol,
                  style: TextStyle(
                    color: color,
                    fontSize: width * .2,
                    height: .9,
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                card.suit.symbol,
                style: TextStyle(color: color, fontSize: width * .62),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Transform.rotate(
                angle: 3.14159,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.rank.label,
                      style: TextStyle(
                        color: color,
                        fontSize: width * .22,
                        fontWeight: FontWeight.w900,
                        height: .9,
                      ),
                    ),
                    Text(
                      card.suit.symbol,
                      style: TextStyle(
                        color: color,
                        fontSize: width * .17,
                        height: .9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JokerFace extends StatelessWidget {
  const _JokerFace({
    required this.width,
    required this.height,
    required this.selected,
  });

  final double width;
  final double height;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: const Color(0xFFFFFDF4),
      borderRadius: BorderRadius.circular(width * .09),
      border: Border.all(
        color: selected ? const Color(0xFFF7D75C) : const Color(0xFFB98BD8),
        width: selected ? 2.5 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .35),
          blurRadius: 4,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Center(
      child: Text('🃏', style: TextStyle(fontSize: width * .58)),
    ),
  );
}

class _CardBack extends StatelessWidget {
  const _CardBack({
    required this.width,
    required this.height,
    required this.selected,
  });
  final double width;
  final double height;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(width * .09),
      border: Border.all(
        color: selected ? const Color(0xFFF7D75C) : const Color(0xFFDBC77B),
        width: selected ? 2.5 : 1.2,
      ),
      gradient: const LinearGradient(
        colors: [Color(0xFF2F5A92), Color(0xFF102A4C)],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .38),
          blurRadius: 4,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Center(
      child: Container(
        width: width * .67,
        height: height * .78,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDBC77B)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Icon(
            Icons.auto_awesome,
            color: const Color(0xFFF1D471),
            size: width * .34,
          ),
        ),
      ),
    ),
  );
}
