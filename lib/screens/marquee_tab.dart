import 'package:flutter/material.dart';
import '../models/marquee.dart';
import '../widgets/glass_card.dart';
import '../utils/storage_service.dart';
import '../utils/toast_helper.dart';
import 'fullscreen_marquee.dart';

class MarqueeTab extends StatefulWidget {
  const MarqueeTab({super.key});

  @override
  State<MarqueeTab> createState() => _MarqueeTabState();
}

class _MarqueeTabState extends State<MarqueeTab> {
  final TextEditingController _textController = TextEditingController(text: 'Welcome to FlowCanvas!');
  Color _selectedColor = const Color(0xFF00FF9D);
  double _speed = 5.0;
  List<MarqueeConfig> _savedMarquees = [];
  bool _isLoading = true;

  final List<Color> _colors = [
    const Color(0xFF00FF9D),
    const Color(0xFF4A6CF7),
    const Color(0xFFFF7A30),
    const Color(0xFFFF2E63),
    const Color(0xFFF9ED32),
    const Color(0xFFFFFFFF),
  ];

  @override
  void initState() {
    super.initState();
    _loadMarquees();
  }

  Future<void> _loadMarquees() async {
    final marquees = await StorageService.loadMarquees();
    setState(() {
      _savedMarquees = marquees;
      _isLoading = false;
    });
    
    if (_savedMarquees.isEmpty) {
      _loadSampleMarquees();
    }
  }

  void _loadSampleMarquees() {
    _savedMarquees.addAll([
      MarqueeConfig(
        id: '1',
        text: 'Welcome Home!',
        color: const Color(0xFF00FF9D),
        speed: 5.0,
      ),
      MarqueeConfig(
        id: '2',
        text: 'Happy Birthday!',
        color: const Color(0xFFFF7A30),
        speed: 8.0,
      ),
    ]);
    _saveMarquees();
  }

  Future<void> _saveMarquees() async {
    await StorageService.saveMarquees(_savedMarquees);
  }

  Future<void> _saveCurrentMarquee() async {
    if (_textController.text.isEmpty) {
      ToastHelper.showToast(context, 'Please enter some text', isError: true);
      return;
    }

    final marquee = MarqueeConfig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _textController.text,
      color: _selectedColor,
      speed: _speed,
    );

    setState(() {
      _savedMarquees.add(marquee);
    });
    await _saveMarquees();
    if (mounted) {
      ToastHelper.showToast(context, 'Marquee saved successfully!');
    }
  }

  Future<void> _deleteMarquee(MarqueeConfig marquee) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Delete Marquee', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${marquee.text}"?',
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
        _savedMarquees.removeWhere((m) => m.id == marquee.id);
      });
      await _saveMarquees();
      if (mounted) {
        ToastHelper.showToast(context, 'Marquee deleted');
      }
    }
  }

  String _getSpeedLabel() {
    if (_speed > 7) return 'Fast';
    if (_speed > 3) return 'Medium';
    return 'Slow';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildPreview(),
        const SizedBox(height: 20),
        _buildQuickTemplates(),
        const SizedBox(height: 20),
        _buildSettings(),
        const SizedBox(height: 20),
        _buildSavedMarquees(),
      ],
    );
  }

  Widget _buildPreview() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tv, color: Color(0xFF818CF8), size: 22),
              SizedBox(width: 10),
              Text(
                'Marquee Preview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: _MarqueePreview(
                text: _textController.text.isEmpty ? 'Enter your message...' : _textController.text,
                color: _selectedColor,
                speed: _speed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTemplates() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFF818CF8), size: 22),
              SizedBox(width: 10),
              Text(
                'Quick Templates',
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
              _buildTemplateButton(Icons.home, 'Welcome', 'Welcome Home!'),
              _buildTemplateButton(Icons.cake, 'Birthday', 'Happy Birthday!'),
              _buildTemplateButton(Icons.emoji_events, 'Achievement', 'Congratulations!'),
              _buildTemplateButton(Icons.favorite, 'Love', 'I Love You!'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateButton(IconData icon, String label, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _textController.text = text;
        });
      },
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

  Widget _buildSettings() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.edit, color: Color(0xFF818CF8), size: 22),
              SizedBox(width: 10),
              Text(
                'Marquee Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _textController,
            style: const TextStyle(
              color: Color(0xFFF1F5F9),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your message...',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: const Color(0xFF475569).withValues(alpha: 0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF64748B), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF64748B), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFF818CF8), width: 2),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _colors.map((color) {
              final isSelected = color == _selectedColor;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  transform: isSelected 
                      ? (Matrix4.identity()..scale(1.2, 1.2, 1.0))
                      : Matrix4.identity(),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Speed',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF1F5F9),
                ),
              ),
              Text(
                _getSpeedLabel(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFC7D2FE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF818CF8),
              inactiveTrackColor: const Color(0xFF475569),
              thumbColor: const Color(0xFF818CF8),
              overlayColor: const Color(0xFF818CF8).withValues(alpha: 0.3),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: _speed,
              min: 1,
              max: 10,
              onChanged: (value) => setState(() => _speed = value),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_textController.text.isEmpty) {
                      ToastHelper.showToast(
                        context,
                        'Please enter some text first',
                        isError: true,
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullscreenMarquee(
                          text: _textController.text,
                          color: _selectedColor,
                          speed: _speed,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.fullscreen, size: 22),
                  label: const Text(
                    'Fullscreen',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                  onPressed: _saveCurrentMarquee,
                  icon: const Icon(Icons.save, size: 22),
                  label: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34D399),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 4,
                    shadowColor: const Color(0xFF34D399).withValues(alpha: 0.5),
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

  Widget _buildSavedMarquees() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bookmark, color: Color(0xFF818CF8), size: 22),
              SizedBox(width: 10),
              Text(
                'My Marquees',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (_savedMarquees.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.comment_bank,
                      size: 50,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No saved marquees yet',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._savedMarquees.map((marquee) => _buildMarqueeItem(marquee)),
        ],
      ),
    );
  }

  Widget _buildMarqueeItem(MarqueeConfig marquee) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF818CF8).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF818CF8).withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: marquee.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  marquee.text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF1F5F9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  'Speed: ${marquee.speed > 7 ? 'Fast' : marquee.speed > 3 ? 'Medium' : 'Slow'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _textController.text = marquee.text;
                    _selectedColor = marquee.color;
                    _speed = marquee.speed;
                  });
                  ToastHelper.showToast(context, 'Marquee loaded');
                },
                icon: const Icon(Icons.edit, color: Color(0xFF818CF8), size: 22),
              ),
              IconButton(
                onPressed: () => _deleteMarquee(marquee),
                icon: const Icon(Icons.delete, color: Color(0xFFF87171), size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MarqueePreview extends StatefulWidget {
  final String text;
  final Color color;
  final double speed;

  const _MarqueePreview({
    required this.text,
    required this.color,
    required this.speed,
  });

  @override
  State<_MarqueePreview> createState() => _MarqueePreviewState();
}

class _MarqueePreviewState extends State<_MarqueePreview> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (25 - widget.speed * 2).toInt()),
    )..repeat();
  }

  @override
  void didUpdateWidget(_MarqueePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      _controller.duration = Duration(seconds: (25 - widget.speed * 2).toInt());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return OverflowBox(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(
              MediaQuery.of(context).size.width * (1 - _controller.value * 2),
              0,
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}
