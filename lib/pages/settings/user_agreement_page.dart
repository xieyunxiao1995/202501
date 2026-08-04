import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/app_widgets.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  static const List<(String, String)> _sections = [
    ('协议的接受', '欢迎使用「可伴 AI」。当你下载、安装或使用本应用时，即表示你已阅读并同意接受本协议的全部条款。如果你不同意本协议的任何内容，请停止使用本应用。'),
    ('服务说明', '本应用为你提供穿搭记录、衣橱管理、AI 搭配推荐及穿搭灵感等功能。我们可能会根据产品发展调整、优化或新增功能，部分功能可能需要联网或授权相应权限方可使用。'),
    ('账号与数据', '本应用的数据主要存储在你的本地设备中。请妥善保管你的设备，因设备丢失或损坏导致的数据损失，我们将尽力提供技术支持，但不承担相应责任。'),
    ('用户行为规范', '你承诺不会利用本应用从事任何违反法律法规的活动，不会上传违法、侵权或不良信息，也不会以任何方式干扰本应用的正常运行。'),
    ('知识产权', '本应用内的全部内容，包括但不限于界面设计、图标、文案、算法及品牌标识，均受知识产权法律保护。未经授权，你不得复制、修改或用于商业用途。'),
    ('免责声明', 'AI 搭配推荐仅供参考，不构成任何专业建议。对于因使用本应用产生的间接损失，我们将在法律允许的范围内承担有限责任。'),
    ('协议的修改', '我们保留随时修改本协议的权利。协议更新后，继续使用本应用即视为你接受修改后的条款。重大变更将通过应用内公告等方式通知你。'),
  ];

  @override
  Widget build(BuildContext context) => PageFrame(
    title: '用户协议',
    action: Icons.close_rounded,
    onAction: () => Navigator.pop(context),
    children: [
      Row(
        children: [
          const Icon(Icons.description_outlined, size: 15, color: AppColors.lavender),
          const SizedBox(width: 6),
          Text(
            '最后更新：2024 年 1 月',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13)
          ),
        ],
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
