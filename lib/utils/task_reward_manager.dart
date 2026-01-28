import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum TaskStatus {
  locked,   // Cannot start yet
  ongoing,  // In progress
  completed,// Ready to claim
  claimed   // Already claimed
}

class EventTask {
  final String id;
  final String title;
  final String description;
  final String iconPath; // Main icon for the card (e.g. chest)
  final Map<String, int> rewards; // item_id -> count
  TaskStatus status;

  EventTask({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.rewards,
    this.status = TaskStatus.ongoing,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.index,
    };
  }
}

class TaskRewardManager {
  static const String _storageKey = 'mythic_event_tasks';

  static List<EventTask> tasks = [
    EventTask(
      id: 'task_kill_enemy',
      title: '降妖除魔',
      description: '击败10名敌人',
      iconPath: 'assets/item/item1.png', 
      rewards: {'spirit_stone': 500, 'gold': 1000},
      status: TaskStatus.ongoing,
    ),
    EventTask(
      id: 'task_level_up',
      title: '境界突破',
      description: '达到练气后期',
      iconPath: 'assets/item/item22.png',
      rewards: {'summon_ticket': 2, 'rare_material': 50},
      status: TaskStatus.ongoing,
    ),
    EventTask(
      id: 'task_login_3',
      title: '问道三日',
      description: '累计登录3天',
      iconPath: 'assets/item/item23.png', 
      rewards: {'adv_ticket': 1, 'legendary_material': 1},
      status: TaskStatus.ongoing,
    ),
  ];

  static Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      for (var json in jsonList) {
        final id = json['id'];
        final statusIdx = json['status'];
        
        final taskIndex = tasks.indexWhere((t) => t.id == id);
        if (taskIndex != -1) {
          tasks[taskIndex].status = TaskStatus.values[statusIdx];
        }
      }
    }
    
    // Mock progress update (In a real app, this would be event-driven)
    _updateMockProgress();
  }

  static void _updateMockProgress() {
    // For demonstration, let's say "Login 2 Days" is completed if we are on day 2 or more
    // We can import DailyLoginManager, but to avoid circular dependency issues if not careful,
    // we'll just use a simple check or rely on the caller to update progress.
    // For now, let's auto-complete the first task for demo purposes if it's ongoing.
    
    // Example: If task_login_2 is ongoing, mark it as completed for demo
    // if (tasks[1].status == TaskStatus.ongoing) {
    //   tasks[1].status = TaskStatus.completed;
    // }
  }

  static Future<void> claimTask(String taskId) async {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1 && tasks[index].status == TaskStatus.completed) {
      tasks[index].status = TaskStatus.claimed;
      await _saveTasks();
    }
  }

  // Debug method to force complete a task
  static Future<void> debugCompleteTask(String taskId) async {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1 && tasks[index].status == TaskStatus.ongoing) {
      tasks[index].status = TaskStatus.completed;
      await _saveTasks();
    }
  }

  static Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
