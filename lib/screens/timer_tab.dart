import 'package:flutter/material.dart';
import 'dart:async';
import '../models/workflow.dart';
import '../widgets/glass_card.dart';
import '../widgets/workflow_dialog.dart';
import '../utils/storage_service.dart';
import '../utils/toast_helper.dart';
import 'fullscreen_timer.dart';

class TimerTab extends StatefulWidget {
  const TimerTab({super.key});

  @override
  State<TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab> {
  Timer? _timer;
  int _remainingSeconds = 527;
  bool _isRunning = true;
  List<Workflow> _workflows = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkflows();
    _startTimer();
  }

  Future<void> _loadWorkflows() async {
    final workflows = await StorageService.loadWorkflows();
    setState(() {
      _workflows = workflows;
      _isLoading = false;
    });
    
    if (_workflows.isEmpty) {
      _loadSampleWorkflows();
    }
  }

  void _loadSampleWorkflows() {
    _workflows.addAll([
      Workflow(
        id: '1',
        name: 'HIIT Training',
        stages: [
          WorkflowStage(name: 'Warm-up', duration: 300),
          WorkflowStage(name: 'Sprint', duration: 1200),
          WorkflowStage(name: 'Rest', duration: 180),
        ],
        cycles: 3,
      ),
      Workflow(
        id: '2',
        name: 'Study Session',
        stages: [
          WorkflowStage(name: 'Focus', duration: 1500),
          WorkflowStage(name: 'Break', duration: 300),
        ],
        cycles: 5,
      ),
      Workflow(
        id: '3',
        name: 'Meditation Practice',
        stages: [
          WorkflowStage(name: 'Preparation', duration: 300),
          WorkflowStage(name: 'Deep Breathing', duration: 600),
          WorkflowStage(name: 'Sitting', duration: 1200),
          WorkflowStage(name: 'Closing', duration: 300),
        ],
        cycles: 1,
      ),
    ]);
    _saveWorkflows();
  }

  Future<void> _saveWorkflows() async {
    await StorageService.saveWorkflows(_workflows);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning && _remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _createOrEditWorkflow([Workflow? workflow]) async {
    final result = await showDialog<Workflow>(
      context: context,
      builder: (context) => WorkflowDialog(workflow: workflow),
    );

    if (result != null) {
      setState(() {
        if (workflow == null) {
          _workflows.add(result);
          ToastHelper.showToast(context, 'Workflow created successfully!');
        } else {
          final index = _workflows.indexWhere((w) => w.id == workflow.id);
          if (index != -1) {
            _workflows[index] = result;
            ToastHelper.showToast(context, 'Workflow updated successfully!');
          }
        }
      });
      await _saveWorkflows();
    }
  }

  Future<void> _deleteWorkflow(Workflow workflow) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Delete Workflow', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${workflow.name}"?',
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _workflows.removeWhere((w) => w.id == workflow.id);
      });
      await _saveWorkflows();
      if (mounted) {
        ToastHelper.showToast(context, 'Workflow deleted');
      }
    }
  }

  void _startQuickAction(String type) {
    Workflow? workflow;
    switch (type) {
      case 'Pomodoro':
        workflow = Workflow(
          id: 'quick_pomodoro',
          name: 'Pomodoro',
          stages: [
            WorkflowStage(name: 'Focus', duration: 1500),
            WorkflowStage(name: 'Break', duration: 300),
          ],
          cycles: 4,
        );
        break;
      case 'Workout':
        workflow = Workflow(
          id: 'quick_workout',
          name: 'Quick Workout',
          stages: [
            WorkflowStage(name: 'Warm-up', duration: 300),
            WorkflowStage(name: 'Exercise', duration: 1200),
            WorkflowStage(name: 'Cool-down', duration: 300),
          ],
          cycles: 1,
        );
        break;
      case 'Reading':
        workflow = Workflow(
          id: 'quick_reading',
          name: 'Reading Session',
          stages: [
            WorkflowStage(name: 'Read', duration: 1800),
            WorkflowStage(name: 'Rest', duration: 300),
          ],
          cycles: 3,
        );
        break;
      case 'Meditation':
        workflow = Workflow(
          id: 'quick_meditation',
          name: 'Meditation',
          stages: [
            WorkflowStage(name: 'Breathe', duration: 600),
            WorkflowStage(name: 'Meditate', duration: 1200),
          ],
          cycles: 1,
        );
        break;
    }

    if (workflow != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullscreenTimer(workflow: workflow!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildCurrentWorkflow(),
        const SizedBox(height: 20),
        _buildQuickStart(),
        const SizedBox(height: 20),
        _buildTodayStats(),
        const SizedBox(height: 20),
        _buildMyWorkflows(),
      ],
    );
  }

  Widget _buildCurrentWorkflow() {
    return GlassCard(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF6366F1).withValues(alpha: 0.2),
          const Color(0xFF10B981).withValues(alpha: 0.1),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Currently Running',
                style: TextStyle(
                  color: Color(0xFFC7D2FE),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'HIIT Workout',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF1F5F9),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _formatTime(_remainingSeconds),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _isRunning = !_isRunning),
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pause' : 'Resume'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF818CF8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 4,
                    shadowColor: const Color(0xFF818CF8).withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB923C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 4,
                    shadowColor: const Color(0xFFFB923C).withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStart() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt, color: Color(0xFF818CF8), size: 22),
              SizedBox(width: 10),
              Text(
                'Quick Start',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildQuickAction(Icons.access_time, 'Pomodoro'),
              _buildQuickAction(Icons.fitness_center, 'Workout'),
              _buildQuickAction(Icons.book, 'Reading'),
              _buildQuickAction(Icons.psychology, 'Meditation'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label) {
    return GestureDetector(
      onTap: () => _startQuickAction(label),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF818CF8).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF818CF8).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF818CF8), size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF1F5F9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.show_chart, color: Color(0xFF818CF8), size: 22),
              SizedBox(width: 10),
              Text(
                'Today\'s Stats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('3', 'Sessions'),
              _buildStatCard('2.5h', 'Focus Time'),
              _buildStatCard('85%', 'Completion'),
              _buildStatCard('12', 'Day Streak'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF818CF8).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF818CF8).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF818CF8),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyWorkflows() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.list, color: Color(0xFF818CF8), size: 22),
                  SizedBox(width: 10),
                  Text(
                    'My Workflows',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF1F5F9),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _createOrEditWorkflow(),
                icon: const Icon(Icons.add_circle, color: Color(0xFF818CF8), size: 28),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (_workflows.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.timer_off,
                      size: 50,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No workflows yet',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () => _createOrEditWorkflow(),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Workflow'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF818CF8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFF818CF8).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._workflows.map((workflow) => _buildWorkflowCard(workflow)),
        ],
      ),
    );
  }

  Widget _buildWorkflowCard(Workflow workflow) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF818CF8).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF818CF8).withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  workflow.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF1F5F9),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    '${workflow.cycles} ${workflow.cycles == 1 ? 'cycle' : 'cycles'}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFC7D2FE),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Color(0xFF94A3B8)),
                    color: const Color(0xFF1E293B),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _createOrEditWorkflow(workflow);
                      } else if (value == 'delete') {
                        _deleteWorkflow(workflow);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18, color: Color(0xFF6366F1)),
                            SizedBox(width: 10),
                            Text('Edit', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Color(0xFFEF4444)),
                            SizedBox(width: 10),
                            Text('Delete', style: TextStyle(color: Color(0xFFF1F5F9))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            workflow.stages.map((s) => s.name).join(' → '),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFCBD5E1),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${workflow.totalDuration ~/ 60} minutes',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFA5B4FC),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullscreenTimer(workflow: workflow),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF818CF8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  elevation: 3,
                  shadowColor: const Color(0xFF818CF8).withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
