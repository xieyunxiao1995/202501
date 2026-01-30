class Log {
  final String id;
  final String text;
  final String type; // 'event', 'gain', 'neutral', 'danger'
  final DateTime timestamp;

  Log({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        id: json['id'],
        text: json['text'],
        type: json['type'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
