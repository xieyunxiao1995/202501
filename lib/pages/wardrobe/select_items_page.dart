import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';
import '../../data/local_storage.dart';
import '../../models/outfit_models.dart';
import '../../widgets/app_widgets.dart';

class SelectItemsPage extends StatefulWidget {
  final List<String> selectedIds;
  const SelectItemsPage({super.key, this.selectedIds = const []});
  @override
  State<SelectItemsPage> createState() => _SelectItemsPageState();
}

class _SelectItemsPageState extends State<SelectItemsPage> {
  List<ClothingItem> items = [];
  final selected = <String>{};
  String filter = '全部';
  final filters = ['全部', '上衣', '裙装', '裤装', '外套', '鞋包', '配饰'];
  @override
  void initState() {
    super.initState();
    selected.addAll(widget.selectedIds);
    LocalStorage().readWardrobe().then((v) {
      if (mounted) setState(() => items = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visible = filter == '全部'
        ? items
        : items.where((item) => item.type == filter).toList();
    return Scaffold(
      backgroundColor: AppBackground.base,
      body: SafeArea(
        child: PageFrame(
          title: '选择今日单品',
          subtitle: '已选 ${selected.length} 件 · 建议 3~5 件',
          action: Icons.close_rounded,
          onAction: () => Navigator.pop(context),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  children: [
                    for (final value in filters)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(value),
                          selected: filter == value,
                          onSelected: (_) => setState(() => filter = value),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (visible.isEmpty) const EmptyState(message: '衣橱里还没有单品'),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .9,
              ),
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final item = visible[index];
                final isSelected = selected.contains(item.id);
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => setState(
                    () => isSelected
                        ? selected.remove(item.id)
                        : selected.add(item.id),
                  ),
                  child: SoftCard(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SmartImageWidget(
                                path: item.image,
                                isLocal: item.isLocalImage,
                              ),
                            ),
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Pill(item.type),
                          ],
                        ),
                        if (isSelected)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutBack,
                              builder: (context, value, child) => Transform.scale(
                                scale: value,
                                child: child,
                              ),
                              child: const CircleAvatar(
                                radius: 13,
                                backgroundColor: Colors.deepPurple,
                                child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SlideFadeIn(
              index: 0,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: selected.isEmpty
                      ? null
                      : () => Navigator.pop(
                          context,
                          items.where((item) => selected.contains(item.id)).toList(),
                        ),
                  icon: const Icon(Icons.check),
                  label: Text('确认选择（${selected.length}）'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
