import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/screens/common/user_info_field.dart';
import 'package:zhenyu_flutter/screens/tag/user_tag_screen.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';

class HobbyDataScreen extends StatefulWidget {
  const HobbyDataScreen({super.key, this.initialTags, this.isSign = false});

  /// 预设的标签数据，key 对应标签类型 (例如 `FITNESS`、`MUSIC`)，value 为已选择的标签列表。
  final Map<String, List<String>>? initialTags;

  final bool isSign;

  @override
  State<HobbyDataScreen> createState() => _HobbyDataScreenState();
}

class _HobbyDataScreenState extends State<HobbyDataScreen> {
  late final Map<String, List<String>> _tags;

  final List<_HobbyItem> _items = const [
    _HobbyItem(label: '我喜欢的运动', type: 'FITNESS'),
    _HobbyItem(label: '我喜欢的音乐', type: 'MUSIC'),
    _HobbyItem(label: '我喜欢的美食', type: 'FOOD'),
    _HobbyItem(label: '我喜欢的电影', type: 'VIDEOS'),
    _HobbyItem(label: '我的足迹', type: 'TO_CITY'),
  ];

  @override
  void initState() {
    super.initState();
    _tags = {}
      ..addAll(widget.initialTags ?? {})
      ..removeWhere((key, value) => value.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const StyledText('兴趣爱好', fontSize: 18),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemBuilder: (context, index) {
          final item = _items[index];
          final selected = _tags[item.type] ?? const [];
          final rightText = selected.isEmpty ? '去添加' : selected.join('、');

          return UserInfoField(
            onTap: () => _onTapItem(item, selected),
            label: item.label,
            value: rightText,
            highlightValue: false,
            highlightLabel: true,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: _items.length,
      ),
    );
  }

  Future<void> _onTapItem(_HobbyItem item, List<String> current) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => UserTagScreen(
          title: item.label,
          type: item.type,
          isSign: widget.isSign,
        ),
      ),
    );

    if (!mounted) return;

    if (result is List<String>) {
      setState(() {
        if (result.isEmpty) {
          _tags.remove(item.type);
        } else {
          _tags[item.type] = result;
        }
      });
    }
  }
}

class _HobbyItem {
  const _HobbyItem({required this.label, required this.type});

  final String label;
  final String type;
}
