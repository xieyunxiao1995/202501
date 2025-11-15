import 'package:flutter/material.dart';
import '../models/workflow.dart';

class WorkflowDialog extends StatefulWidget {
  final Workflow? workflow;

  const WorkflowDialog({super.key, this.workflow});

  @override
  State<WorkflowDialog> createState() => _WorkflowDialogState();
}

class _WorkflowDialogState extends State<WorkflowDialog> {
  late TextEditingController _nameController;
  late TextEditingController _cyclesController;
  final List<_StageData> _stages = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workflow?.name ?? '');
    _cyclesController = TextEditingController(
      text: widget.workflow?.cycles.toString() ?? '1',
    );

    if (widget.workflow != null) {
      _stages.addAll(
        widget.workflow!.stages.map(
          (s) => _StageData(
            nameController: TextEditingController(text: s.name),
            durationController: TextEditingController(
              text: (s.duration ~/ 60).toString(),
            ),
          ),
        ),
      );
    } else {
      _addStage();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cyclesController.dispose();
    for (var stage in _stages) {
      stage.nameController.dispose();
      stage.durationController.dispose();
    }
    super.dispose();
  }

  void _addStage() {
    setState(() {
      _stages.add(_StageData(
        nameController: TextEditingController(),
        durationController: TextEditingController(),
      ));
    });
  }

  void _removeStage(int index) {
    setState(() {
      _stages[index].nameController.dispose();
      _stages[index].durationController.dispose();
      _stages.removeAt(index);
    });
  }

  void _save() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a workflow name')),
      );
      return;
    }

    if (_stages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one stage')),
      );
      return;
    }

    final stages = <WorkflowStage>[];
    for (var stage in _stages) {
      if (stage.nameController.text.isEmpty ||
          stage.durationController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all stage fields')),
        );
        return;
      }
      stages.add(WorkflowStage(
        name: stage.nameController.text,
        duration: int.parse(stage.durationController.text) * 60,
      ));
    }

    final workflow = Workflow(
      id: widget.workflow?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      stages: stages,
      cycles: int.tryParse(_cyclesController.text) ?? 1,
    );

    Navigator.pop(context, workflow);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.workflow == null ? 'Create Workflow' : 'Edit Workflow',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Workflow Name',
                  labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF6366F1)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _cyclesController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Cycles',
                  labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF6366F1)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Stages',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _addStage,
                    icon: const Icon(Icons.add_circle, color: Color(0xFF6366F1)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._stages.asMap().entries.map((entry) {
                final index = entry.key;
                final stage = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: stage.nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Stage Name',
                            labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF334155)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF334155)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF6366F1)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: stage.durationController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Minutes',
                            labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF334155)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF334155)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF6366F1)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeStage(index),
                        icon: const Icon(Icons.remove_circle, color: Color(0xFFEF4444)),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StageData {
  final TextEditingController nameController;
  final TextEditingController durationController;

  _StageData({
    required this.nameController,
    required this.durationController,
  });
}
