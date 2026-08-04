import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';

class SizeProfilePage extends StatefulWidget {
  const SizeProfilePage({super.key});

  @override
  State<SizeProfilePage> createState() => _SizeProfilePageState();
}

class _SizeProfilePageState extends State<SizeProfilePage> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _topSizeController = TextEditingController();
  final _bottomSizeController = TextEditingController();
  final _shoeSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _heightController.text = prefs.getString('height') ?? '';
        _weightController.text = prefs.getString('weight') ?? '';
        _topSizeController.text = prefs.getString('top_size') ?? '';
        _bottomSizeController.text = prefs.getString('bottom_size') ?? '';
        _shoeSizeController.text = prefs.getString('shoe_size') ?? '';
      });
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('height', _heightController.text.trim());
    await prefs.setString('weight', _weightController.text.trim());
    await prefs.setString('top_size', _topSizeController.text.trim());
    await prefs.setString('bottom_size', _bottomSizeController.text.trim());
    await prefs.setString('shoe_size', _shoeSizeController.text.trim());
    if (mounted) {
      showAppSnackBar(context, '尺码信息已保存', icon: Icons.check_circle_outline);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _topSizeController.dispose();
    _bottomSizeController.dispose();
    _shoeSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '尺码管理',
    subtitle: '帮助 AI 更精准推荐适合你的尺码',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      const SectionTitle(title: '身体数据'),
      SoftCard(
        child: Column(
          children: [
            _buildInputRow(
              icon: Icons.height,
              label: '身高',
              hint: '例如：165',
              suffix: 'cm',
              controller: _heightController,
            ),
            const Divider(height: 1, color: Color(0xFFF5E8EE)),
            _buildInputRow(
              icon: Icons.monitor_weight_outlined,
              label: '体重',
              hint: '例如：55',
              suffix: 'kg',
              controller: _weightController,
            ),
          ],
        ),
      ),
      const SectionTitle(title: '常用尺码'),
      SoftCard(
        child: Column(
          children: [
            _buildInputRow(
              icon: Icons.checkroom,
              label: '上衣尺码',
              hint: '例如：M / 165/88A',
              controller: _topSizeController,
            ),
            const Divider(height: 1, color: Color(0xFFF5E8EE)),
            _buildInputRow(
              icon: Icons.airline_seat_legroom_reduced,
              label: '下装尺码',
              hint: '例如：28 / 165/72A',
              controller: _bottomSizeController,
            ),
            const Divider(height: 1, color: Color(0xFFF5E8EE)),
            _buildInputRow(
              icon: Icons.ice_skating,
              label: '鞋码',
              hint: '例如：37',
              controller: _shoeSizeController,
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      SoftCard(
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.lavender.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: AppColors.deepLavender,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                '完善尺码信息后，AI 搭配推荐会更精准',
                style: TextStyle(fontSize: 14, color: Colors.grey)
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: FilledButton(onPressed: _save, child: const Text('保存尺码信息')),
      ),
    ],
  );

  Widget _buildInputRow({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    String? suffix,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppColors.lavender),
        const SizedBox(width: 10),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: suffix != null
                ? TextInputType.number
                : TextInputType.text,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
              suffixText: suffix,
              suffixStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
