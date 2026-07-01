import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../models/clothing_item.dart';
import '../../widgets/local_image.dart';
import 'edit_clothing_page.dart';

class ClothingDetailPage extends StatefulWidget {
  const ClothingDetailPage({
    super.key,
    required this.item,
    required this.onSave,
    required this.onDelete,
  });

  final ClothingItem item;
  final Future<void> Function(ClothingItem item) onSave;
  final Future<void> Function(String id) onDelete;

  @override
  State<ClothingDetailPage> createState() => _ClothingDetailPageState();
}

class _ClothingDetailPageState extends State<ClothingDetailPage> {
  late ClothingItem _item = widget.item;

  Future<void> _edit() async {
    final result = await Navigator.of(context).push<ClothingItem>(
      MaterialPageRoute(builder: (_) => EditClothingPage(initialItem: _item)),
    );
    if (result != null) {
      await widget.onSave(result);
      if (mounted) setState(() => _item = result);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('从衣橱删除？'),
        content: const Text('删除后无法恢复，已有穿搭记录不会被删除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.onDelete(_item.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _edit, icon: const Icon(Icons.edit_outlined)),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _delete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'delete', child: Text('删除单品')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LocalImage(path: _item.imagePath),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [Color(0x66000000), Colors.transparent],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _item.name,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: _item.isPurchased
                            ? AppColors.surfaceElevated
                            : AppColors.blush,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _item.isPurchased ? '已拥有' : '愿望清单',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(label: '分类', value: _item.category),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InfoCard(label: '颜色', value: _item.color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InfoCard(label: '季节', value: _item.season),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text('养护方式', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _item.careNotes.isEmpty
                        ? '暂未记录。建议先查看衣物洗标，再补充自己的养护经验。'
                        : _item.careNotes,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
