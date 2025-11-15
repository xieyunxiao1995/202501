class Combo {
  final String id;
  final String name;
  final String description;
  final String workflowId;
  final String marqueeId;

  Combo({
    required this.id,
    required this.name,
    required this.description,
    required this.workflowId,
    required this.marqueeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'workflowId': workflowId,
      'marqueeId': marqueeId,
    };
  }

  factory Combo.fromJson(Map<String, dynamic> json) {
    return Combo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      workflowId: json['workflowId'],
      marqueeId: json['marqueeId'],
    );
  }
}
