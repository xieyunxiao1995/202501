import 'package:flutter/material.dart';
import '../../DaZitheme/app_colors.dart';
import '../../DaZitheme/app_text_styles.dart';

class HelpTutorialScreen extends StatefulWidget {
  const HelpTutorialScreen({super.key});

  @override
  State<HelpTutorialScreen> createState() => _HelpTutorialScreenState();
}

class _HelpTutorialScreenState extends State<HelpTutorialScreen> {
  final List<_ExpandableSection> _sections = [
    _ExpandableSection(
      title: '入门指南',
      icon: Icons.rocket_launch_outlined,
      items: [
        _HelpItem(
          question: 'CP嗒啧 是什么？',
          answer:
              'CP嗒啧 是一款专为金缮匠人设计的伴侣应用。它帮助您记录修复项目、为您的作品生成诗意叙事，并向名为金绪的 AI 向导学习。',
        ),
        _HelpItem(
          question: '如何创建新的修复项目？',
          answer: '点击屏幕底部的"新建"标签。拍摄或选择破损物品的照片，描述损坏情况，选择材质和美学偏好，然后保存您的项目。',
        ),
        _HelpItem(
          question: '我的照片存储在哪里？',
          answer: '所有照片都存储在您的设备本地，从不上传到外部服务器。这确保了您的隐私并保护您的作品安全。',
        ),
      ],
    ),
    _ExpandableSection(
      title: '拍照指南',
      icon: Icons.camera_alt_outlined,
      items: [
        _HelpItem(
          question: '如何拍出好的修复照片？',
          answer: '尽可能使用自然光。聚焦裂痕或损坏区域。从多个角度拍摄。拍照前确保物品干净干燥。',
        ),
        _HelpItem(
          question: '可以为一个项目添加多张照片吗？',
          answer: '可以，您可以在不同阶段拍摄照片来记录修复进度。每个项目可以有多张照片，展示修复前、修复中和修复后的状态。',
        ),
        _HelpItem(
          question: '应该使用什么照片质量？',
          answer: '应用会自动优化照片的存储和显示。为获得最佳效果，请确保光线充足并在拍摄时稳住设备。',
        ),
      ],
    ),
    _ExpandableSection(
      title: '使用 AI 助手',
      icon: Icons.chat_bubble_outline,
      items: [
        _HelpItem(
          question: '金绪能帮我做什么？',
          answer: '金绪可以回答关于金缮技术的问题，推荐材料和工具，解释侘寂哲学，并为您的修复项目生成诗意叙事。',
        ),
        _HelpItem(
          question: '我的对话是否私密？',
          answer: '您的文字消息会发送到 DeepSeek AI 以生成回复。但您的照片和项目数据保留在设备上，从不共享。',
        ),
        _HelpItem(
          question: '金绪能提供医疗或法律建议吗？',
          answer: '不能。金绪专为金缮和艺术相关指导而设计。它不会提供医疗、法律、财务或其他专业建议。',
        ),
      ],
    ),
    _ExpandableSection(
      title: '项目管理',
      icon: Icons.folder_outlined,
      items: [
        _HelpItem(
          question: '如何跟踪修复进度？',
          answer: '每个项目都有进度指示器。在完成修复过程中更新进度，以跟踪完成情况并在画廊中查看统计数据。',
        ),
        _HelpItem(
          question: '可以归档旧项目吗？',
          answer: '可以，向左滑动项目卡片可显示归档选项。已归档项目从主画廊隐藏，但以后可以访问。',
        ),
        _HelpItem(
          question: '如何删除项目？',
          answer: '长按项目卡片可显示删除选项。确认删除以从设备中移除项目及其关联照片。',
        ),
      ],
    ),
    _ExpandableSection(
      title: '数据与隐私',
      icon: Icons.lock_outline,
      items: [
        _HelpItem(
          question: '我的数据有备份吗？',
          answer: '不提供外部备份。所有数据都存储在您的设备本地。如有需要，请考虑手动备份重要照片。',
        ),
        _HelpItem(
          question: '可以导出我的项目吗？',
          answer: '目前，项目存储在应用本地。如果照片已保存到设备相册，可以通过相册访问。',
        ),
        _HelpItem(
          question: '如果删除应用会怎样？',
          answer: '删除应用会移除所有本地存储的数据，包括项目、照片和聊天记录。这些数据无法恢复。',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '帮助与教程',
          style: AppTextStyles.headline3.copyWith(
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(horizontalPadding),
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          return _buildExpandableSection(_sections[index], isSmallScreen);
        },
      ),
    );
  }

  Widget _buildExpandableSection(
    _ExpandableSection section,
    bool isSmallScreen,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 14 : 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 14 : 16,
          vertical: isSmallScreen ? 6 : 8,
        ),
        childrenPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 14 : 16,
          vertical: isSmallScreen ? 6 : 8,
        ),
        leading: Container(
          width: isSmallScreen ? 36 : 40,
          height: isSmallScreen ? 36 : 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withAlpha(51),
            borderRadius: BorderRadius.circular(isSmallScreen ? 9 : 10),
          ),
          child: Icon(
            section.icon,
            color: AppColors.primary,
            size: isSmallScreen ? 18 : 20,
          ),
        ),
        title: Text(
          section.title,
          style: AppTextStyles.labelLarge.copyWith(
            fontSize: isSmallScreen ? 15 : 16,
          ),
        ),
        children: section.items.map((item) {
          return _buildHelpItem(item, isSmallScreen);
        }).toList(),
      ),
    );
  }

  Widget _buildHelpItem(_HelpItem item, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.question,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontSize: isSmallScreen ? 12 : 13,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            item.answer,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: isSmallScreen ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableSection {
  final String title;
  final IconData icon;
  final List<_HelpItem> items;

  const _ExpandableSection({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class _HelpItem {
  final String question;
  final String answer;

  const _HelpItem({required this.question, required this.answer});
}
