import 'package:flutter/material.dart';

import '../../widgets/legal_document_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      title: '隐私协议',
      updatedAt: '2026年6月21日',
      intro: '我们坚持本地优先，并尽量减少不必要的数据收集。',
      sections: [
        LegalSection('1. 本地保存的数据', '穿搭记录、衣橱信息、聊天记录和本地图片路径保存在你的设备中。应用不要求注册账户。'),
        LegalSection(
          '2. 相册权限',
          '只有当你主动添加图片时，应用才会请求访问系统相册。应用不申请相机权限，也不会在后台扫描你的照片。',
        ),
        LegalSection(
          '3. AI 数据传输',
          '向 AI 助手发送问题时，你的问题、衣橱文字摘要、愿望清单和近期穿搭文字摘要会传输至 DeepSeek。图片文件不会发送给 AI。',
        ),
        LegalSection(
          '4. 数据删除',
          '你可以删除单条记录，也可以在设置中清空全部本地数据。卸载应用通常也会移除应用沙盒内的数据。',
        ),
        LegalSection(
          '5. 反馈信息',
          '反馈页会在你确认后调用系统邮件应用。邮件内容和联系方式由你主动填写，CPDD小屋 不会在后台自动提交。',
        ),
        LegalSection('6. 安全提醒', '当前测试版本在客户端配置 AI 密钥，不适合公开发布。正式发行前应改用安全的服务端代理。'),
      ],
    );
  }
}
