import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        '怎样添加一套穿搭？',
        '进入“穿搭”页，点击右上角加号或空状态按钮。从系统相册选择图片，填写标题、日期、场合和心情后保存。图片并非必填，你也可以先记录文字。',
      ),
      (
        '怎样整理我的衣橱？',
        '在“衣橱”页添加单品并选择分类、颜色和季节。标记“已经拥有”或关闭它作为愿望清单，AI 会据此区分已有衣物与购物计划。',
      ),
      ('AI 助手会读取什么？', 'AI 会读取衣橱和近期穿搭的文字摘要，不会上传你的本地图片。你也可以直接点击聊天顶部的预设问题。'),
      ('为什么 AI 无法回复？', '请先确认网络正常且项目已配置有效的 DeepSeek API Key。错误消息下方可以直接点击“重试”。'),
      ('图片为什么不显示？', '请确认相册权限已开启。应用会把选择的图片复制到自身目录；如果系统清理了应用数据，图片可能无法恢复。'),
      ('怎样删除所有数据？', '进入“设置”，点击“清空本地数据”。确认后穿搭、衣橱和聊天记录会被清除，此操作无法撤销。'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('使用帮助')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.mistBlue, AppColors.blush],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.primary,
                  size: 30,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    '从记录第一件常穿的衣服开始，不必一次整理完整个衣橱。',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...items.map(
            (item) => Card(
              elevation: 0,
              color: const Color(0xFFF8F9FC),
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 17),
                title: Text(
                  item.$1,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.$2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
