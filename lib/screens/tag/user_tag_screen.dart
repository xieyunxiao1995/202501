import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/common/tag_chip.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class UserTagScreen extends StatefulWidget {
  const UserTagScreen({
    super.key,
    required this.title,
    required this.type,
    this.isSign = false,
    this.defaultData,
    this.occupationList,
  });

  final String title;
  final String type;
  final bool isSign;
  final String? defaultData;
  final List<String>? occupationList;

  @override
  State<UserTagScreen> createState() => _UserTagScreenState();
}

class _UserTagScreenState extends State<UserTagScreen> {
  final List<String> _selectedTags = [];
  List<String> _recommendations = [];
  bool _loading = true;
  bool _saving = false;
  int _limit = 3;

  bool get _isOccupation => widget.type == 'Occupation';

  @override
  void initState() {
    super.initState();
    if (widget.defaultData != null && widget.defaultData!.isNotEmpty) {
      _selectedTags.add(widget.defaultData!);
    }
    if (_isOccupation) {
      _limit = 1;
      _recommendations = List<String>.from(widget.occupationList ?? []);
      _loading = false;
    } else {
      _fetchTags();
    }
  }

  Future<void> _fetchTags() async {
    setState(() {
      _loading = true;
    });
    try {
      final resp = await UserApi.getUserProfile();
      if (resp.code == 0 && resp.data?.userProfile != null) {
        final item = _findProfileItem(resp.data!.userProfile!);
        if (mounted) {
          setState(() {
            _limit = item?.limit ?? 3;
            final defaults = item?.defaultLabels;
            _recommendations = defaults != null
                ? List<String>.from(defaults)
                : <String>[];

            final used = item?.useLabels;
            if (used != null && used.isNotEmpty) {
              _selectedTags
                ..clear()
                ..addAll(used);
            }
            if (_selectedTags.length > _limit) {
              _selectedTags.removeRange(_limit, _selectedTags.length);
            }
          });
        }
      } else {
        if (mounted) {
          showMsg(context, resp.message ?? '获取标签失败');
        }
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '获取标签失败');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  UserProfileItem? _findProfileItem(List<UserProfileItem> list) {
    for (final item in list) {
      if (item.name == widget.type) return item;
    }
    return null;
  }

  void _toggleTag(String tag) {
    if (_isOccupation) {
      setState(() {
        _selectedTags
          ..clear()
          ..add(tag);
      });
      return;
    }

    final index = _selectedTags.indexOf(tag);
    if (index >= 0) {
      setState(() {
        _selectedTags.removeAt(index);
      });
    } else {
      if (_selectedTags.length >= _limit) {
        showMsg(context, '最多设置$_limit 个标签哦~');
        return;
      }
      setState(() {
        _selectedTags.add(tag);
      });
    }
  }

  Future<void> _save() async {
    if (_saving) {
      debugPrint(
        '[UserTagScreen] Ignoring save tap, request already in flight.',
      );
      return;
    }
    debugPrint(
      '[UserTagScreen] Save tapped. type=${widget.type}, selected=$_selectedTags',
    );
    if (_isOccupation && _selectedTags.isEmpty) {
      showMsg(context, '请选择职业');
      return;
    }

    if (widget.isSign) {
      Navigator.of(context).pop(
        _isOccupation
            ? (_selectedTags.isNotEmpty ? _selectedTags.first : null)
            : List<String>.from(_selectedTags),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      UpdateUserProfileReq req;
      if (_isOccupation) {
        req = UpdateUserProfileReq(
          updateDateType: 'OCCUPATION',
          occupation: _selectedTags.first,
        );
      } else {
        req = UpdateUserProfileReq(
          updateDateType: 'INTEREST_LABEL',
          interestLabelType: widget.type,
          interestLabel: _selectedTags.join(','),
        );
      }

      final payload = req.toJson();
      debugPrint('[UserTagScreen] Submitting payload: $payload');

      final response = await UserApi.updateUserProfile(req);
      debugPrint(
        '[UserTagScreen] Response status: ${response.statusCode} data: ${response.data}',
      );
      final data = response.data;
      if (!mounted) return;

      if (data is Map<String, dynamic> && data['code'] == 0) {
        debugPrint('[UserTagScreen] Save succeeded.');
        showMsg(context, (data['message'] as String?) ?? '修改成功');
        Navigator.of(context).pop(
          _isOccupation
              ? _selectedTags.first
              : List<String>.from(_selectedTags),
        );
      } else {
        debugPrint('[UserTagScreen] Save failed with payload: $data');
        showMsg(
          context,
          data is Map<String, dynamic>
              ? (data['message'] as String?) ?? '保存失败'
              : '保存失败',
        );
      }
    } catch (error) {
      debugPrint('[UserTagScreen] Exception while saving: ${error}');
      if (mounted) {
        showMsg(context, '保存失败，请稍后重试');
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
        debugPrint('[UserTagScreen] Save flow finished.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: StyledText(widget.title, fontSize: 18),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_isOccupation) ...[
                          StyledText.primaryBold(
                            '我的标签 (${_selectedTags.length} / $_limit)',
                            fontSize: 16,
                          ),
                          const SizedBox(height: 12),
                          _buildSelectedSection(),
                          const SizedBox(height: 36),
                        ],
                        StyledText.primaryBold(
                          _isOccupation ? '选择职业' : '推荐标签',
                          fontSize: 16,
                        ),
                        const SizedBox(height: 16),
                        _buildRecommendationSection(),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: StyledButton(
                      onPressed: () => _save(),
                      height: 48,
                      borderRadius: BorderRadius.circular(24),
                      gradient: AppGradients.primaryGradient,
                      child: StyledText.inButton(_saving ? '保存中...' : '保存'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSelectedSection() {
    if (_selectedTags.isEmpty) {
      return const Text(
        '贴上标签，做有个性的自己',
        style: TextStyle(color: Colors.white54, fontSize: 14),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _selectedTags
          .map(
            (tag) => TagChip(
              label: tag,
              selected: true,
              onTap: () {},
              enabled: false,
            ),
          )
          .toList(),
    );
  }

  Widget _buildRecommendationSection() {
    if (_recommendations.isEmpty) {
      return const Text(
        '暂无可用标签',
        style: TextStyle(color: Colors.white54, fontSize: 14),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _recommendations
          .map(
            (tag) => TagChip(
              label: tag,
              selected: _selectedTags.contains(tag),
              onTap: () => _toggleTag(tag),
            ),
          )
          .toList(),
    );
  }
}
