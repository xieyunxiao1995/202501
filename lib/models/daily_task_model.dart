class DailyTask {
  final String id;
  final String name;
  final String description;
  final int target;
  final int reward;
  final TaskType type;

  DailyTask({
    required this.id,
    required this.name,
    required this.description,
    required this.target,
    required this.reward,
    required this.type,
  });
}

enum TaskType {
  explore,      // 探索次数
  collectBeast, // 收集异兽
  evolveBeast,  // 进化异兽
  battleWin,    // 战斗胜利
  forgeBeast,   // 熔炼异兽
  gatherSpirit, // 收集灵气
}

class TaskProgress {
  final String taskId;
  int current;
  bool isClaimed;

  TaskProgress({
    required this.taskId,
    this.current = 0,
    this.isClaimed = false,
  });

  bool get isCompleted => current >= (DailyTaskDatabase.getTask(taskId)?.target ?? 0);

  Map<String, dynamic> toJson() => {
    'taskId': taskId,
    'current': current,
    'isClaimed': isClaimed,
  };

  factory TaskProgress.fromJson(Map<String, dynamic> json) {
    return TaskProgress(
      taskId: json['taskId'],
      current: json['current'] ?? 0,
      isClaimed: json['isClaimed'] ?? false,
    );
  }

  TaskProgress copyWith({int? current, bool? isClaimed}) {
    return TaskProgress(
      taskId: taskId,
      current: current ?? this.current,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }
}

class DailyTaskDatabase {
  static final Map<String, DailyTask> _tasks = {
    'explore_3': DailyTask(
      id: 'explore_3',
      name: '神游山海',
      description: '使用神游功能3次',
      target: 3,
      reward: 100,
      type: TaskType.explore,
    ),
    'explore_10': DailyTask(
      id: 'explore_10',
      name: '神游大师',
      description: '使用神游功能10次',
      target: 10,
      reward: 300,
      type: TaskType.explore,
    ),
    'collect_beast_2': DailyTask(
      id: 'collect_beast_2',
      name: '收集异兽',
      description: '收集2只新异兽',
      target: 2,
      reward: 200,
      type: TaskType.collectBeast,
    ),
    'evolve_beast_1': DailyTask(
      id: 'evolve_beast_1',
      name: '进化异兽',
      description: '进化1只异兽',
      target: 1,
      reward: 300,
      type: TaskType.evolveBeast,
    ),
    'battle_win_3': DailyTask(
      id: 'battle_win_3',
      name: '战斗洗礼',
      description: '赢得3场战斗',
      target: 3,
      reward: 250,
      type: TaskType.battleWin,
    ),
    'forge_beast_2': DailyTask(
      id: 'forge_beast_2',
      name: '熔炼之术',
      description: '熔炼异兽2次',
      target: 2,
      reward: 200,
      type: TaskType.forgeBeast,
    ),
    'gather_spirit_2000': DailyTask(
      id: 'gather_spirit_2000',
      name: '灵气汇聚',
      description: '累计收集2000灵气',
      target: 2000,
      reward: 200,
      type: TaskType.gatherSpirit,
    ),
  };

  static DailyTask? getTask(String id) {
    return _tasks[id];
  }

  static List<DailyTask> getAllTasks() {
    return _tasks.values.toList();
  }

  static List<DailyTask> getDailyTasks() {
    // 每天随机选择5个任务
    final allTasks = getAllTasks();
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;

    // 使用日期作为随机种子生成任务
    final dailyTaskIds = <String>[];
    final taskList = allTasks.toList();
    final randomIndices = <int>[];

    for (int i = 0; i < 5 && i < taskList.length; i++) {
      final index = (seed + i * 7) % taskList.length;
      if (!randomIndices.contains(index)) {
        randomIndices.add(index);
        dailyTaskIds.add(taskList[index].id);
      }
    }

    return dailyTaskIds.map((id) => _tasks[id]!).toList();
  }
}

class DailyTaskManager {
  Map<String, TaskProgress> progressMap;
  String lastResetDate;
  int completedCount;
  int totalRewardsClaimed;
  
  // 签到相关字段
  int signInDays;
  String lastSignInDate;
  List<bool> claimedRewards;

  DailyTaskManager({
    Map<String, TaskProgress>? progressMap,
    String? lastResetDate,
    this.completedCount = 0,
    this.totalRewardsClaimed = 0,
    this.signInDays = 0,
    String? lastSignInDate,
    List<bool>? claimedRewards,
  })  : progressMap = progressMap ?? {},
        lastResetDate = lastResetDate ?? _getTodayString(),
        lastSignInDate = lastSignInDate ?? '',
        claimedRewards = claimedRewards ?? List.generate(7, (_) => false);

  static String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool canSignIn() {
    return lastSignInDate != _getTodayString();
  }

  void signIn() {
    if (canSignIn()) {
      lastSignInDate = _getTodayString();
      if (signInDays < 7) {
        signInDays++;
      } else {
        // 满7天后重置
        signInDays = 1;
        claimedRewards = List.generate(7, (_) => false);
      }
    }
  }

  bool claimSignInReward(int dayIndex) {
    if (dayIndex < signInDays && !claimedRewards[dayIndex]) {
      claimedRewards[dayIndex] = true;
      return true;
    }
    return false;
  }

  bool needsReset() {
    return lastResetDate != _getTodayString();
  }

  void resetIfNeeded() {
    if (needsReset()) {
      progressMap.clear();
      lastResetDate = _getTodayString();
      completedCount = 0;
      totalRewardsClaimed = 0;
    }
  }

  List<DailyTask> getDailyTasks() {
    resetIfNeeded();
    return DailyTaskDatabase.getDailyTasks();
  }

  TaskProgress getProgress(String taskId) {
    resetIfNeeded();
    if (!progressMap.containsKey(taskId)) {
      progressMap[taskId] = TaskProgress(taskId: taskId);
    }
    return progressMap[taskId]!;
  }

  void updateProgress(TaskType type, {int amount = 1}) {
    resetIfNeeded();
    final tasks = getDailyTasks();

    for (final task in tasks) {
      if (task.type == type) {
        final progress = getProgress(task.id);
        if (!progress.isCompleted) {
          progressMap[task.id] = progress.copyWith(
            current: progress.current + amount,
          );
        }
      }
    }
  }

  bool claimTask(String taskId) {
    final progress = getProgress(taskId);
    if (!progress.isCompleted || progress.isClaimed) {
      return false;
    }

    progressMap[taskId] = progress.copyWith(isClaimed: true);
    final task = DailyTaskDatabase.getTask(taskId);
    if (task != null) {
      totalRewardsClaimed += task.reward;
      completedCount++;
    }
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'progressMap': progressMap.map((key, value) => MapEntry(key, value.toJson())),
      'lastResetDate': lastResetDate,
      'completedCount': completedCount,
      'totalRewardsClaimed': totalRewardsClaimed,
      'signInDays': signInDays,
      'lastSignInDate': lastSignInDate,
      'claimedRewards': claimedRewards,
    };
  }

  factory DailyTaskManager.fromJson(Map<String, dynamic> json) {
    final progressMapJson = json['progressMap'] as Map<String, dynamic>?;
    final progressMap = progressMapJson?.map(
      (key, value) => MapEntry(key, TaskProgress.fromJson(value as Map<String, dynamic>)),
    );

    return DailyTaskManager(
      progressMap: progressMap,
      lastResetDate: json['lastResetDate'],
      completedCount: json['completedCount'] ?? 0,
      totalRewardsClaimed: json['totalRewardsClaimed'] ?? 0,
      signInDays: json['signInDays'] ?? 0,
      lastSignInDate: json['lastSignInDate'] ?? '',
      claimedRewards: (json['claimedRewards'] as List<dynamic>?)?.cast<bool>(),
    );
  }

  DailyTaskManager copyWith() {
    return DailyTaskManager(
      progressMap: progressMap.map((key, value) => MapEntry(key, value.copyWith())),
      lastResetDate: lastResetDate,
      completedCount: completedCount,
      totalRewardsClaimed: totalRewardsClaimed,
      signInDays: signInDays,
      lastSignInDate: lastSignInDate,
      claimedRewards: List.from(claimedRewards),
    );
  }
}
