import 'package:flutter/material.dart';
import 'diary_entry.dart';

class CardStack {
  final String id;
  final String? title;
  final List<DiaryEntry> cards;
  final int zIndex;
  final Offset position;

  CardStack({
    required this.id,
    this.title,
    required this.cards,
    required this.zIndex,
    required this.position,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'cards': cards.map((c) => c.toJson()).toList(),
        'zIndex': zIndex,
        'position': {'x': position.dx, 'y': position.dy},
      };

  factory CardStack.fromJson(Map<String, dynamic> json) => CardStack(
        id: json['id'],
        title: json['title'],
        cards: (json['cards'] as List).map((c) => DiaryEntry.fromJson(c)).toList(),
        zIndex: json['zIndex'],
        position: Offset(json['position']['x'], json['position']['y']),
      );

  CardStack copyWith({
    String? id,
    String? title,
    List<DiaryEntry>? cards,
    int? zIndex,
    Offset? position,
  }) =>
      CardStack(
        id: id ?? this.id,
        title: title ?? this.title,
        cards: cards ?? this.cards,
        zIndex: zIndex ?? this.zIndex,
        position: position ?? this.position,
      );
}
