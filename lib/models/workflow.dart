class Workflow {
  final String id;
  final String name;
  final List<WorkflowStage> stages;
  final int cycles;

  Workflow({
    required this.id,
    required this.name,
    required this.stages,
    required this.cycles,
  });

  int get totalDuration {
    return stages.fold(0, (sum, stage) => sum + stage.duration) * cycles;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stages': stages.map((s) => s.toJson()).toList(),
      'cycles': cycles,
    };
  }

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      id: json['id'],
      name: json['name'],
      stages: (json['stages'] as List)
          .map((s) => WorkflowStage.fromJson(s))
          .toList(),
      cycles: json['cycles'],
    );
  }
}

class WorkflowStage {
  final String name;
  final int duration;

  WorkflowStage({
    required this.name,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
    };
  }

  factory WorkflowStage.fromJson(Map<String, dynamic> json) {
    return WorkflowStage(
      name: json['name'],
      duration: json['duration'],
    );
  }
}
