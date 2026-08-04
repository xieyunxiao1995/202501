import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/animations/app_animations.dart';
import '../../widgets/app_widgets.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const List<(String, String)> _steps = [
    ('添加衣物', '进入「我的衣橱」，点击右下角「+」按钮，拍照或从相册选择衣物，填写分类、颜色等信息后保存。'),
    ('记录穿搭', '在「今日穿搭」页点击「快速记录」，选择今天穿的单品，写一句心情，即可生成一篇可伴。'),
    ('AI 搭配', '在「AI 穿搭」页选择场合与风格偏好，AI 会从你的衣橱中为你生成专属搭配方案。'),
    ('回顾日记', '在「可伴」页按月历浏览历史记录，点击任意一天即可查看当天的穿搭详情。'),
  ];

  static const List<(String, String)> _faqs = [
    ('AI 搭配的结果不准确怎么办？', 'AI 推荐基于你衣橱中的单品生成。添加更多衣物、完善颜色与分类信息，并设置准确的风格偏好，都能让推荐更贴合你的口味。'),
    ('照片会上传到服务器吗？', '不会。你的衣物照片与穿搭数据默认仅存储在本地设备中，我们不会擅自上传，请放心使用。'),
    ('如何修改风格偏好？', '进入「设置」页，点击「风格偏好」，即可调整你喜欢的风格、常穿尺码等信息，AI 会据此优化推荐。'),
    ('数据会丢失吗？', '数据存储在本地。卸载应用或清除应用数据会导致记录丢失，建议定期通过截图等方式备份重要穿搭记录。'),
    ('支持哪些设备？', '本应用支持 iOS 与 Android 主流机型。如遇到显示异常，请尝试更新到最新版本。'),
    ('如何反馈问题？', '在「设置」页点击「反馈与建议」，填写问题描述后提交，我们会尽快跟进处理。'),
  ];

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '使用帮助',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      SlideFadeIn(index: 0, child: const SectionTitle(title: '快速入门')),
      SlideFadeIn(
        index: 1,
        child: SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              for (var i = 0; i < _steps.length; i++)
                _step(i + 1, _steps[i].$1, _steps[i].$2),
            ],
          ),
        ),
      ),
      SlideFadeIn(index: 2, child: const SectionTitle(title: '常见问题')),
      SlideFadeIn(
        index: 3,
        child: SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Column(
            children: _faqs.map((faq) => _FaqTile(faq.$1, faq.$2)).toList(),
          ),
        ),
      ),
      SlideFadeIn(index: 4, child: const SectionTitle(title: '联系我们')),
      SlideFadeIn(
        index: 5,
        child: SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: const [
              _ContactRow(icon: Icons.mail_outline_rounded, label: '客服邮箱', value: 'support@kexingapp.com'),
              _ContactRow(icon: Icons.chat_bubble_outline_rounded, label: '微信公众号', value: '可伴AI'),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _step(int number, String title, String caption) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: AppColors.lavender,
          child: Text(
            '$number',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)
              ),
              const SizedBox(height: 3),
              Text(
                caption,
                style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.5)
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FaqTile extends StatelessWidget {
  final String question, answer;
  const _FaqTile(this.question, this.answer);

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 14),
      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      iconColor: AppColors.lavender,
      collapsedIconColor: Colors.grey,
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)
      ),
      children: [
        Text(
          answer,
          style: const TextStyle(color: AppColors.ink, fontSize: 14, height: 1.7)
        ),
      ],
    ),
  );
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _ContactRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Icon(icon, size: 17, color: AppColors.lavender),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const Spacer(),
        Text(value, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    ),
  );
}
