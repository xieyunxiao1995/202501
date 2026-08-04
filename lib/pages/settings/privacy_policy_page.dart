import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/app_widgets.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const List<String> _promises = [
    '数据本地存储，绝不擅自上传服务器',
    '不向任何第三方出售你的个人信息',
    '相机与相册权限仅用于你主动操作时',
  ];

  static const List<(String, String)> _sections = [
    ('我们收集的信息', '为提供穿搭记录与搭配推荐服务，我们可能收集你主动上传的衣物照片、穿搭记录，以及你设置的风格偏好、尺码等个人信息。'),
    ('信息的使用方式', '我们仅将收集的信息用于：生成个性化搭配推荐、优化产品体验、提供技术支持。不会将你的个人信息用于与服务无关的用途。'),
    ('信息的存储与保护', '你的数据主要存储于本地设备。我们采用加密、访问控制等安全措施保护你的信息，防止未经授权的访问、泄露或丢失。'),
    ('权限使用说明', '相机权限：用于拍摄衣物与穿搭照片；相册权限：用于从相册选择照片。上述权限均在你主动使用相关功能时请求，你可随时在系统设置中关闭。'),
    ('第三方服务', '本应用可能接入必要的第三方服务（如崩溃统计）。我们会要求第三方遵守相应的隐私保护义务，但不对第三方的独立行为承担责任。'),
    ('你的权利', '你有权随时访问、修改或删除你的个人数据。你可以通过应用内的设置功能管理数据，或通过客服邮箱联系我们行使上述权利。'),
    ('未成年人保护', '我们重视对未成年人信息的保护。若你是未满 14 周岁的未成年人，请在监护人指导下使用本应用，并由监护人协助阅读本协议。'),
  ];

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '隐私协议',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      Row(
        children: [
          const Icon(Icons.shield_outlined, size: 15, color: AppColors.lavender),
          const SizedBox(width: 6),
          Text(
            '最后更新：2024 年 1 月',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13)
          ),
        ],
      ),
      SoftCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: [
            for (final p in _promises) _promiseRow(p),
          ],
        ),
      ),
      SoftCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < _sections.length; i++) ...[
              if (i > 0) const SizedBox(height: 20),
              _section(i + 1, _sections[i].$1, _sections[i].$2),
            ],
          ],
        ),
      ),
    ],
  );

  Widget _promiseRow(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF8EE),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 13,
            color: Color(0xFF4C9A67),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
          ),
        ),
      ],
    ),
  );

  Widget _section(int index, String title, String content) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.lavender,
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)
            ),
          ),
        ],
      ),
      const SizedBox(height: 9),
      Padding(
        padding: const EdgeInsets.only(left: 28),
        child: Text(
          content,
          style: const TextStyle(fontSize: 14, height: 1.8, color: AppColors.ink)
        ),
      ),
    ],
  );
}
