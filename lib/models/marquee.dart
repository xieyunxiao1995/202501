import 'package:flutter/material.dart';

class MarqueeConfig {
  final String id;
  final String text;
  final Color color;
  final double speed;

  MarqueeConfig({
    required this.id,
    required this.text,
    required this.color,
    required this.speed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'color': color.toARGB32(),
      'speed': speed,
    };
  }

  factory MarqueeConfig.fromJson(Map<String, dynamic> json) {
    return MarqueeConfig(
      id: json['id'],
      text: json['text'],
      color: Color(json['color']),
      speed: json['speed'],
    );
  }
}
