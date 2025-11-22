import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/common/user_info_field.dart';
import 'package:zhenyu_flutter/screens/register/registration_result_helper.dart';
import 'package:zhenyu_flutter/screens/tag/user_tag_screen.dart';
import 'package:zhenyu_flutter/shared/picker_utils.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class BasicDataScreen extends StatefulWidget {
  final UserRegisterData baseData;

  const BasicDataScreen({super.key, required this.baseData});

  @override
  State<BasicDataScreen> createState() => _BasicDataScreenState();
}

class _BasicDataScreenState extends State<BasicDataScreen> {
  static final DateTime _minBirthday = DateTime(1975, 1, 1);
  static final DateTime _maxBirthday = DateTime(2007, 12, 31);

  List<String> _figureOptions = [];
  List<String> _occupationOptions = [];
  String? _selectedFigure;
  String? _selectedOccupation;
  DateTime? _birthday;
  int? _height;
  int? _weight;
  bool _loadingOptions = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.baseData.birthday != null) {
      final parsed = DateTime.tryParse(widget.baseData.birthday!);
      if (parsed != null) {
        _birthday = _clampBirthday(parsed);
      }
    }
    _fetchOptions();
  }

  Future<void> _fetchOptions() async {
    try {
      final resp = await UserApi.getFigureAndOccupation();
      if (!mounted) return;

      if (resp.code == 0 && resp.data != null) {
        final figures = _splitOptions(resp.data!.defaultFigure);
        final occupations = _splitOptions(resp.data!.defaultOccupation);

        setState(() {
          _figureOptions = figures;
          _occupationOptions = occupations;
          if (!_figureOptions.contains(_selectedFigure)) {
            _selectedFigure = null;
          }
          if (!_occupationOptions.contains(_selectedOccupation)) {
            _selectedOccupation = null;
          }
        });
      } else {
        showMsg(context, resp.message ?? '获取选项失败');
      }
    } catch (_) {
      if (mounted) {
        showMsg(context, '获取选项失败');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingOptions = false;
        });
      }
    }
  }

  List<String> _splitOptions(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  Future<void> _submit() async {
    if (_submitting) return;

    if (_selectedFigure == null || _selectedOccupation == null) {
      showMsg(context, '请选择完整信息');
      return;
    }

    if (_birthday == null) {
      showMsg(context, '请选择生日');
      return;
    }
    if (_selectedOccupation == null) {
      showMsg(context, '请选择职业');
      return;
    }
    if (_height == null) {
      showMsg(context, '请选择身高');
      return;
    }
    if (_weight == null) {
      showMsg(context, '请选择体重');
      return;
    }

    setState(() {
      _submitting = true;
    });

    final req = FemaleRegisterData(
      avatar: widget.baseData.avatar,
      birthday: _birthday?.toIso8601String().split('T').first,
      customName: widget.baseData.customName,
      extraParam: widget.baseData.extraParam,
      figure: _selectedFigure,
      height: _height,
      inviteCode: widget.baseData.inviteCode,
      mobile: widget.baseData.mobile,
      occupation: _selectedOccupation,
      sex: widget.baseData.sex,
      smsCode: widget.baseData.smsCode,
      userName: widget.baseData.userName,
      weight: _weight,
    );

    try {
      final resp = await UserApi.femaleRegister(req);
      if (resp.code == 0 && resp.data != null) {
        await handleRegistrationSuccess(
          this,
          resp.data!,
          redirectToPersonalData: true,
        );
      } else {
        showMsg(context, resp.message ?? '注册失败');
      }
    } catch (_) {
      showMsg(context, '注册失败，请稍后重试');
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const StyledText('完善资料')),
      body: _loadingOptions
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StyledText.primaryBold('基本信息', fontSize: 18),
                  const SizedBox(height: 10),
                  StyledText.secondary('请完善你的基础信息', fontSize: 14),
                  const SizedBox(height: 30),
                  _buildBirthdayField(),
                  const SizedBox(height: 20),
                  _buildOccupationField(),
                  const SizedBox(height: 20),
                  _buildHeightField(),
                  const SizedBox(height: 20),
                  _buildWeightField(),
                  const SizedBox(height: 20),
                  _buildFigureSelector(),
                  const SizedBox(height: 40),
                  StyledButton(
                    onPressed: _submit,
                    height: 48,
                    borderRadius: BorderRadius.circular(24),
                    gradient: AppGradients.primaryGradient,
                    child: StyledText.inButton(_submitting ? '提交中...' : '下一步'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFigureSelector() {
    final displayValue = _selectedFigure ?? '请选择';
    return UserInfoField(
      onTap: _figureOptions.isEmpty
          ? null
          : () async {
              final selected = await PickerUtils.showFigureDialog(
                context,
                _selectedFigure,
                _figureOptions,
              );
              if (selected != null && selected != _selectedFigure) {
                setState(() {
                  _selectedFigure = selected;
                });
              }
            },
      label: '身材',
      value: displayValue,
      highlightValue: _selectedFigure != null,
    );
  }

  Widget _buildOccupationField() {
    final displayValue = _selectedOccupation ?? '请选择';
    return UserInfoField(
      onTap: () async {
        if (_occupationOptions.isEmpty) return;
        final selected = await Navigator.of(context).push<String>(
          MaterialPageRoute(
            builder: (_) => UserTagScreen(
              title: '选择职业',
              type: 'Occupation',
              isSign: true,
              defaultData: _selectedOccupation,
              occupationList: _occupationOptions,
            ),
          ),
        );
        if (selected != null && selected != _selectedOccupation) {
          setState(() {
            _selectedOccupation = selected;
          });
        }
      },
      label: '职业',
      value: displayValue,
      highlightValue: _selectedOccupation != null,
    );
  }

  Widget _buildBirthdayField() {
    final displayValue = _birthday == null
        ? '请选择'
        : '${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}';
    return UserInfoField(
      onTap: () async {
        final selected = await PickerUtils.showDatePicker(context, _birthday);
        if (selected != null && selected != _birthday) {
          setState(() {
            _birthday = selected;
          });
        }
      },
      label: '生日',
      value: displayValue,
      highlightValue: _birthday != null,
    );
  }

  Widget _buildHeightField() {
    final displayValue = _height == null ? '请选择' : '${_height!}cm';
    return UserInfoField(
      onTap: () async {
        final selected = await PickerUtils.showHeightPicker(context, _height);
        if (selected != null && selected != _height) {
          setState(() {
            _height = selected;
          });
        }
      },
      label: '身高',
      value: displayValue,
      highlightValue: _height != null,
    );
  }

  Widget _buildWeightField() {
    final displayValue = _weight == null ? '请选择' : '${_weight!}kg';
    return UserInfoField(
      onTap: () async {
        final selected = await PickerUtils.showWeightPicker(context, _weight);
        if (selected != null && selected != _weight) {
          setState(() {
            _weight = selected;
          });
        }
      },
      label: '体重',
      value: displayValue,
      highlightValue: _weight != null,
    );
  }

  DateTime _clampBirthday(DateTime value) {
    if (value.isBefore(_minBirthday)) return _minBirthday;
    if (value.isAfter(_maxBirthday)) return _maxBirthday;
    return value;
  }
}
