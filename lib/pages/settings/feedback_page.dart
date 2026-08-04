import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _controller = TextEditingController();
  int _typeIndex = 0;
  bool _submitted = false;

  static const List<(IconData, String)> _types = [
    (Icons.bug_report_rounded, '功能异常'),
    (Icons.lightbulb_outline_rounded, '功能建议'),
    (Icons.palette_outlined, '界面体验'),
    (Icons.chat_bubble_outline_rounded, '其他'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '反馈与建议',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      if (_submitted)
        _successCard()
      else ...[
        const SectionTitle(title: '反馈类型'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < _types.length; i++) _typeChip(i),
          ],
        ),
        const SizedBox(height: 4),
        const SectionTitle(title: '问题描述'),
        SoftCard(
          padding: const EdgeInsets.all(14),
          child: TextField(
            controller: _controller,
            maxLines: 6,
            maxLength: 500,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 14, height: 1.6),
            decoration: const InputDecoration(
              hintText: '请详细描述你遇到的问题或建议，我们会尽快跟进～',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFFF0EAF1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Color(0xFFF0EAF1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: AppColors.lavender),
              ),
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.send_rounded, size: 17),
          label: const Text('提交反馈'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    ],
  );

  Widget _typeChip(int i) {
    final selected = _typeIndex == i;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _typeIndex = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF8F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.lavender : const Color(0xFFF0EAF1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _types[i].$1,
              size: 14,
              color: selected ? AppColors.deepLavender : Colors.grey,
            ),
            const SizedBox(width: 5),
            Text(
              _types[i].$2,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.deepLavender : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _successCard() => SoftCard(
    padding: const EdgeInsets.symmetric(vertical: 30),
    child: Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xFFEFE6FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppColors.deepLavender,
            size: 27,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          '提交成功',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        ),
        const SizedBox(height: 6),
        const Text(
          '感谢你的反馈，我们会认真倾听每一条建议',
          style: TextStyle(color: Colors.grey, fontSize: 13)
        ),
      ],
    ),
  );

  void _submit() {
    if (_controller.text.trim().isEmpty) {
      showAppSnackBar(context, '请先填写反馈内容', icon: Icons.edit_note);
      return;
    }
    setState(() => _submitted = true);
  }
}
