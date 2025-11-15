import 'package:flutter/material.dart';
import '../models/combo.dart';
import '../models/workflow.dart';
import '../models/marquee.dart';
import '../widgets/glass_card.dart';
import '../widgets/combo_dialog.dart';
import '../utils/storage_service.dart';
import '../utils/toast_helper.dart';
import 'fullscreen_timer.dart';
import 'fullscreen_marquee.dart';

class ComboTab extends StatefulWidget {
  const ComboTab({super.key});

  @override
  State<ComboTab> createState() => _ComboTabState();
}

class _ComboTabState extends State<ComboTab> {
  List<Combo> _combos = [];
  List<Workflow> _workflows = [];
  List<MarqueeConfig> _marquees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final combos = await StorageService.loadCombos();
    final workflows = await StorageService.loadWorkflows();
    final marquees = await StorageService.loadMarquees();
    
    setState(() {
      _combos = combos;
      _workflows = workflows;
      _marquees = marquees;
      _isLoading = false;
    });
    
    if (_combos.isEmpty && _workflows.isNotEmpty && _marquees.isNotEmpty) {
      _loadSampleCombos();
    }
  }

  void _loadSampleCombos() {
    if (_workflows.isNotEmpty && _marquees.isNotEmpty) {
      _combos.addAll([
        Combo(
          id: '1',
          name: 'Airport Pickup',
          description: 'Wait timer followed by welcome marquee',
          workflowId: _workflows.first.id,
          marqueeId: _marquees.first.id,
        ),
      ]);
      _saveCombos();
    }
  }

  Future<void> _saveCombos() async {
    await StorageService.saveCombos(_combos);
  }

  Future<void> _createOrEditCombo([Combo? combo]) async {
    if (_workflows.isEmpty) {
      ToastHelper.showToast(
        context,
        'Please create a workflow first',
        isError: true,
      );
      return;
    }

    if (_marquees.isEmpty) {
      ToastHelper.showToast(
        context,
        'Please create a marquee first',
        isError: true,
      );
      return;
    }

    final result = await showDialog<Combo>(
      context: context,
      builder: (context) => ComboDialog(
        combo: combo,
        workflows: _workflows,
        marquees: _marquees,
      ),
    );

    if (result != null) {
      setState(() {
        if (combo == null) {
          _combos.add(result);
          ToastHelper.showToast(context, 'Combo created successfully!');
        } else {
          final index = _combos.indexWhere((c) => c.id == combo.id);
          if (index != -1) {
            _combos[index] = result;
            ToastHelper.showToast(context, 'Combo updated successfully!');
          }
        }
      });
      await _saveCombos();
    }
  }

  Future<void> _deleteCombo(Combo combo) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Delete Combo', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${combo.name}"?',
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
        _combos.removeWhere((c) => c.id == combo.id);
      });
      await _saveCombos();
      if (mounted) {
        ToastHelper.showToast(context, 'Combo deleted');
      }
    }
  }

  Future<void> _runCombo(Combo combo) async {
    final workflow = _workflows.firstWhere(
      (w) => w.id == combo.workflowId,
      orElse: () => _workflows.first,
    );
    final marquee = _marquees.firstWhere(
      (m) => m.id == combo.marqueeId,
      orElse: () => _marquees.first,
    );

    // Navigate to fullscreen timer
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenTimer(workflow: workflow),
      ),
    );

    // After timer completes, show marquee
    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullscreenMarquee(
            text: marquee.text,
            color: marquee.color,
            speed: marquee.speed,
          ),
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
        _buildCreateButton(),
        const SizedBox(height: 20),
        _buildFeaturedCombos(),
        const SizedBox(height: 20),
        if (_combos.isEmpty)
          _buildEmptyState()
        else
          ..._combos.map((combo) => _buildComboCard(combo)),
      ],
    );
  }

  Widget _buildCreateButton() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF818CF8).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Combos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF1F5F9),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Combine timers & marquees into automated scenes',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF818CF8).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF818CF8).withValues(alpha: 0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFFFBBF24), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tip: Create a timer and marquee first, then combine them',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFCBD5E1),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _createOrEditCombo(),
              icon: const Icon(Icons.add_circle_outline, size: 22),
              label: const Text(
                'Create New Combo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF818CF8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 6,
                shadowColor: const Color(0xFF818CF8).withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCombos() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.12),
            const Color(0xFF6366F1).withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.stars, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Featured Scenes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF1F5F9),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildFeaturedItem(Icons.flight_takeoff, 'Pickup', const Color(0xFF3B82F6)),
              _buildFeaturedItem(Icons.school, 'Study', const Color(0xFF8B5CF6)),
              _buildFeaturedItem(Icons.work_outline, 'Work', const Color(0xFF10B981)),
              _buildFeaturedItem(Icons.sports_esports, 'Game', const Color(0xFFEC4899)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedItem(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF1F5F9),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return GlassCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF818CF8).withValues(alpha: 0.2),
                      const Color(0xFF6366F1).withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  size: 64,
                  color: Color(0xFF818CF8),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Combos Yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF1F5F9),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Create your first automated scene\nand let timers and marquees work together',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () => _createOrEditCombo(),
                icon: const Icon(Icons.add_circle_outline, size: 22),
                label: const Text(
                  'Create Combo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF818CF8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 16,
                  ),
                  elevation: 6,
                  shadowColor: const Color(0xFF818CF8).withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComboCard(Combo combo) {
    final workflow = _workflows.firstWhere(
      (w) => w.id == combo.workflowId,
      orElse: () => Workflow(
        id: '',
        name: 'Unknown',
        stages: [],
        cycles: 1,
      ),
    );
    final marquee = _marquees.firstWhere(
      (m) => m.id == combo.marqueeId,
      orElse: () => MarqueeConfig(
        id: '',
        text: 'Unknown',
        color: Colors.white,
        speed: 5.0,
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF818CF8).withValues(alpha: 0.15),
            const Color(0xFF6366F1).withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF818CF8).withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF818CF8).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Area
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF818CF8).withValues(alpha: 0.1),
                    const Color(0xFF6366F1).withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF818CF8).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          combo.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF1F5F9),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          combo.description,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF94A3B8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _runCombo(combo),
                    icon: const Icon(Icons.play_arrow, size: 20),
                    label: const Text(
                      'Run',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 4,
                      shadowColor: const Color(0xFF10B981).withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Color(0xFF94A3B8), size: 22),
                    color: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _createOrEditCombo(combo);
                      } else if (value == 'delete') {
                        _deleteCombo(combo);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18, color: Color(0xFF818CF8)),
                            SizedBox(width: 12),
                            Text('Edit', style: TextStyle(color: Color(0xFFF1F5F9))),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Color(0xFFF1F5F9))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Flow Display Area
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildComboStep(
                      Icons.timer_outlined,
                      workflow.name,
                      '${workflow.totalDuration ~/ 60} min',
                      const Color(0xFF6366F1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF818CF8).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF818CF8),
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildComboStep(
                      Icons.text_fields,
                      marquee.text.length > 12
                          ? '${marquee.text.substring(0, 12)}...'
                          : marquee.text,
                      'Marquee',
                      const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComboStep(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF1F5F9),
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}