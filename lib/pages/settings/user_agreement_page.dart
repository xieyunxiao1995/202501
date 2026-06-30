import 'package:flutter/material.dart';

import '../../widgets/legal_document_page.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      title: '用户协议',
      updatedAt: '2026年6月21日',
      intro: '欢迎使用 CPDD小屋。使用本应用即表示你理解并同意以下基本规则。',
      sections: [
        LegalSection(
          '1. 服务说明',
          'CPDD小屋 提供本地穿搭记录、衣橱管理和 AI 辅助建议。首版不提供账户、云同步或社交发布功能。',
        ),
        LegalSection(
          '2. 用户内容',
          '你应确保添加的图片和文字拥有合法使用权。内容默认保存在你的设备中，你可以随时编辑、删除或清空。',
        ),
        LegalSection(
          '3. AI 服务与数据传输',
          'CPDD小屋 集成了由杭州深度求索科技有限公司（DeepSeek）提供的 AI 穿搭助手功能。使用 AI 功能时，你的文字输入、衣橱物品文字描述、愿望清单和近期穿搭文字摘要会被传输至 DeepSeek 服务器进行处理。图片文件不会被传输。\n\n'
          'AI 输出仅作为穿搭、购物和日常养护参考，不构成专业清洗、健康或商业承诺。重要衣物请优先遵循洗标和品牌说明。\n\n'
          '如你不同意上述数据传输，可选择不使用 AI 助手功能，其他功能不受影响。',
        ),
        LegalSection(
          '4. 合理使用',
          '请勿利用服务生成违法、侵权、欺诈或危害他人的内容，也不要尝试干扰应用或第三方 AI 服务的正常运行。',
        ),
        LegalSection('5. 服务变更', '我们可能根据产品改进调整功能与文本。重大变化会在后续版本中以适当方式说明。'),
      ],
    );
  }
}
