import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/register/registration_result_helper.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

// todo 这个页面没有完整测试，以为要注册的时候返回 2005
class InvitationScreen extends StatefulWidget {
  final String? reviewParam;
  final int? reviewStatus;

  const InvitationScreen({super.key, this.reviewParam, this.reviewStatus});

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final List<String> _sourceOptions = const [
    '百度',
    '知乎',
    '网上看到',
    '朋友告知',
    '使用过同类推荐',
    '应用商店推荐',
    '其他',
  ];

  late final String _reviewParam;
  int _reviewStatus = 0;
  bool _isSubmitting = false;
  bool _isApplying = false;
  bool _loadingCities = false;

  List<String> _cityOptions = [];
  String? _lastSelectedCity;
  String? _lastSelectedSource;

  @override
  void initState() {
    super.initState();
    _reviewParam = widget.reviewParam ?? '';
    _reviewStatus = widget.reviewStatus ?? 0;
    _loadCities();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadCities() async {
    setState(() => _loadingCities = true);
    try {
      final resp = await UserApi.getCities();
      if (resp.code == 0 && resp.provinces != null) {
        setState(() {
          _cityOptions = _flattenCities(resp.provinces!);
        });
      } else {
        showMsg(context, resp.message ?? '获取城市列表失败');
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '获取城市列表失败');
      }
    } finally {
      if (mounted) {
        setState(() => _loadingCities = false);
      }
    }
  }

  List<String> _flattenCities(List<ProvinceCityInfo> list) {
    final result = <String>[];
    for (final province in list) {
      if (province.name != null && province.name!.isNotEmpty) {
        result.add(province.name!);
      }
      final cities = province.cities ?? [];
      for (final city in cities) {
        if (city.isNotEmpty) {
          result.add(city);
        }
      }
    }
    return result.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const StyledText('填写邀请码', fontSize: 18),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            StyledText.secondary('为确保用户素质', fontSize: 14),
            StyledText.secondary('平台仅向拥有邀请码的用户提供服务', fontSize: 14),
            const SizedBox(height: 32),
            _buildCodeInput(),
            const SizedBox(height: 16),
            StyledButton(
              onPressed: _isSubmitting ? null : () => _submitCode(),
              height: 48,
              borderRadius: BorderRadius.circular(24),
              gradient: AppGradients.primaryGradient,
              child: StyledText.inButton(_isSubmitting ? '提交中...' : '确认'),
            ),
            const SizedBox(height: 40),
            StyledText.secondary('没有邀请码？您可以通过以下方式获取', fontSize: 14),
            const SizedBox(height: 16),
            _buildApplyCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _codeController,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: const InputDecoration(
          hintText: '请填写邀请码',
          hintStyle: TextStyle(color: AppColors.textFieldHint),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildApplyCard() {
    final statusWidget = _buildStatusText();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StyledText.primaryBold('免费申请', fontSize: 16),
          const SizedBox(height: 12),
          StyledText.secondary('你需要填写一些个人资料，审核通过后会给你发送邀请码', fontSize: 14),
          const SizedBox(height: 24),
          StyledButton(
            onPressed: (_isApplying || _reviewStatus == 1)
                ? null
                : () => _showApplySheet(),
            height: 48,
            width: double.infinity,
            borderRadius: BorderRadius.circular(24),
            gradient: AppGradients.primaryGradient,
            child: StyledText.inButton(
              _reviewStatus == 1 ? '审核中' : (_isApplying ? '提交中...' : '马上申请'),
            ),
          ),
          if (statusWidget != null) ...[
            const SizedBox(height: 12),
            statusWidget,
          ],
        ],
      ),
    );
  }

  Widget? _buildStatusText() {
    switch (_reviewStatus) {
      case 2:
        return const StyledText(
          '审核已通过',
          fontSize: 14,
          color: Color(0xFFFFE492),
        );
      case 3:
        return const StyledText(
          '审核未通过',
          fontSize: 14,
          color: AppColors.lightRed,
        );
      default:
        return null;
    }
  }

  Future<void> _submitCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      showMsg(context, '请输入邀请码');
      return;
    }
    if (_reviewParam.isEmpty) {
      showMsg(context, '缺少必要参数，请重新登录');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final resp = await UserApi.reviewInviteCode(
        ReviewInviteCodeData(reviewParam: _reviewParam, inviteCode: code),
      );
      if (!mounted) return;

      if (resp.code == 0 && resp.data != null) {
        await handleRegistrationSuccess(this, resp.data!);
      } else {
        showMsg(context, resp.message ?? '校验失败');
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '校验失败，请稍后重试');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _showApplySheet() async {
    if (_loadingCities) {
      showMsg(context, '城市列表加载中，请稍候');
      return;
    }
    if (_cityOptions.isEmpty) {
      showMsg(context, '暂无可申请城市');
      return;
    }

    String? selectedCity = _lastSelectedCity ?? _cityOptions.first;
    String? selectedSource = _lastSelectedSource ?? _sourceOptions.first;

    final result = await showModalBottomSheet<({String city, String source})>(
      context: context,
      backgroundColor: AppColors.pickUtilsColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (sheetCtx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StyledText.primaryBold('申请使用', fontSize: 18),
                  const SizedBox(height: 24),
                  _buildDropdown(
                    title: '您所在的城市',
                    value: selectedCity,
                    items: _cityOptions,
                    onChanged: (value) {
                      setSheetState(() => selectedCity = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    title: '从哪里知道我们',
                    value: selectedSource,
                    items: _sourceOptions,
                    onChanged: (value) {
                      setSheetState(() => selectedSource = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  StyledButton(
                    onPressed: () {
                      if (selectedCity == null || selectedSource == null) {
                        showMsg(sheetCtx, '请完善资料');
                        return;
                      }
                      Navigator.of(
                        sheetCtx,
                      ).pop((city: selectedCity!, source: selectedSource!));
                    },
                    height: 48,
                    borderRadius: BorderRadius.circular(24),
                    gradient: AppGradients.primaryGradient,
                    child: StyledText.inButton('确定'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      _applyInviteCode(result.city, result.source);
    }
  }

  Widget _buildDropdown({
    required String title,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledText.secondary(title, fontSize: 14),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              iconEnabledColor: Colors.black87,
              dropdownColor: Colors.white,
              onChanged: onChanged,
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _applyInviteCode(String city, String source) async {
    if (_isApplying) return;
    setState(() => _isApplying = true);

    try {
      final response = await UserApi.applyForInviteCode({
        'userArea': city,
        'accessToInfo': source,
        'reviewParam': _reviewParam,
      });

      final data = response.data;
      final success = data is Map<String, dynamic> && data['code'] == 0;
      final message = data is Map<String, dynamic>
          ? data['message'] as String?
          : null;

      if (success) {
        setState(() {
          _reviewStatus = 1;
          _lastSelectedCity = city;
          _lastSelectedSource = source;
        });
        showMsg(context, message ?? '申请已提交');
      } else {
        showMsg(context, message ?? '申请失败');
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '申请失败，请稍后重试');
      }
    } finally {
      if (mounted) {
        setState(() => _isApplying = false);
      }
    }
  }
}
