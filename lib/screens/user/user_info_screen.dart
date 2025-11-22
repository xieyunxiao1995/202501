import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/screens/tag/user_tag_screen.dart';
import 'package:zhenyu_flutter/shared/picker_utils.dart';
import 'package:zhenyu_flutter/screens/user/hobby_data_screen.dart';
import 'package:zhenyu_flutter/api/index_api.dart';
import 'package:zhenyu_flutter/api/upload_api.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/index_api_model.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/common/tag_chip.dart';
import 'package:zhenyu_flutter/screens/people/widgets/city_picker.dart';
import 'package:zhenyu_flutter/shared/styled_dialog.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';
import 'package:zhenyu_flutter/utils/image_cropper_helper.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  UpdateInfoData? _updateInfo;
  LoginRespData? _loginInfo;
  List<String> _albums = [];
  List<String> _albumsReview = [];
  List<ActiveCityInfo> _activeCities = [];
  List<String> _tags = [];
  List<String> _hobbies = [];
  bool _loading = true;
  bool _updatingProfile = false;
  bool _isUploadingAvatar = false;
  File? _avatarFile;
  List<CityInfo> _cityData = [];
  List<String> _figureOptions = [];
  List<String> _occupationOptions = [];
  List<UserProfileItem> _profileItems = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final login = userProvider.currentUser;

      final updateResp = await UserApi.getUpdateInfo();
      final profileResp = await UserApi.getUserProfile();
      final cityResp = await IndexApi.getCityList();
      final figureAndOccupationResp = await UserApi.getFigureAndOccupation();

      if (!mounted) return;

      if (updateResp.code != 0) {
        showMsg(context, updateResp.message ?? '获取资料失败');
      }
      if (profileResp.code != 0) {
        showMsg(context, profileResp.message ?? '获取标签失败');
      }

      setState(() {
        _loginInfo = login;
        _updateInfo = updateResp.data;
        _albums = _splitComma(updateResp.data?.albums);
        _albumsReview = _splitComma(updateResp.data?.albumsReview);
        _activeCities = updateResp.data?.activeCityList ?? [];
        _profileItems = profileResp.data?.userProfile ?? [];
        _tags = _extractLabels(_profileItems, 'CHARACTER');
        _hobbies = _extractHobbies(_profileItems);
        _cityData = cityResp.code == 0 && cityResp.data != null
            ? cityResp.data!
            : [];
        if (figureAndOccupationResp.code == 0 &&
            figureAndOccupationResp.data != null) {
          _figureOptions = _splitOptions(
            figureAndOccupationResp.data!.defaultFigure,
          );
          _occupationOptions = _splitOptions(
            figureAndOccupationResp.data!.defaultOccupation,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        showMsg(context, '加载失败: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<String> _splitComma(String? value) {
    if (value == null || value.isEmpty) return [];
    return value.split(',').where((e) => e.isNotEmpty).toList();
  }

  List<String> _splitOptions(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  List<String> _extractLabels(List<UserProfileItem> list, String type) {
    for (final item in list) {
      if (item.name == type) {
        return item.useLabels ?? [];
      }
    }
    return [];
  }

  List<String> _extractHobbies(List<UserProfileItem> list) {
    final result = <String>[];
    for (final item in list) {
      if (item.name != null && item.name != 'CHARACTER') {
        result.addAll(item.useLabels ?? []);
      }
    }
    return result;
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.textFieldBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  String? _value(String key) {
    switch (key) {
      case 'avatar':
        return _updateInfo?.avatar;
      case 'userName':
        return _updateInfo?.userName;
      case 'city':
        return _updateInfo?.city;
      case 'height':
        return _updateInfo?.height?.toString();
      case 'weight':
        return _updateInfo?.weight?.toString();
      case 'figure':
        return _updateInfo?.figure;
      case 'birthday':
        return _updateInfo?.birthday;
      case 'occupation':
        return _updateInfo?.occupation;
      case 'signature':
        return _updateInfo?.signature;
      default:
        return null;
    }
  }

  Future<bool> _updateProfile(UpdateUserProfileReq req) async {
    if (_updatingProfile) return false;
    setState(() => _updatingProfile = true);
    try {
      final response = await UserApi.updateUserProfile(req);
      final data = response.data;
      final success = data is Map<String, dynamic> && data['code'] == 0;
      final message = data is Map<String, dynamic>
          ? data['message'] as String?
          : null;
      showMsg(context, message ?? (success ? '修改成功' : '修改失败'));
      return success;
    } catch (_) {
      showMsg(context, '保存失败，请稍后重试');
      return false;
    } finally {
      if (mounted) {
        setState(() => _updatingProfile = false);
      }
    }
  }

  Future<void> _editNickname() async {
    final initial = _value('userName') ?? '';
    final result = await _showInputDialog(
      title: '修改昵称',
      initial: initial,
      maxLength: 6,
      placeholder: '请输入昵称',
    );
    if (result == null) return;
    final trimmed = result.trim();
    if (trimmed.isEmpty) {
      showMsg(context, '请输入昵称');
      return;
    }
    if (trimmed == initial) return;

    final success = await _updateProfile(
      UpdateUserProfileReq(updateDateType: 'USER_NAME', userName: trimmed),
    );
    if (success && mounted) {
      setState(() {
        _updateInfo = (_updateInfo ?? UpdateInfoData()).copyWith(
          userName: trimmed,
        );
      });
    }
  }

  Future<void> _editSignature() async {
    final initial = _value('signature') ?? '';
    final result = await _showInputDialog(
      title: '个人介绍',
      initial: initial,
      maxLength: 50,
      placeholder: 'Ta很懒,什么都没留下~',
      multiline: true,
    );
    if (result == null) return;
    final trimmed = result.trim();
    if (trimmed.isEmpty) {
      showMsg(context, '请输入个人介绍');
      return;
    }
    if (trimmed == initial) return;

    final success = await _updateProfile(
      UpdateUserProfileReq(updateDateType: 'SIGNATURE', signature: trimmed),
    );
    if (success && mounted) {
      setState(() {
        _updateInfo = (_updateInfo ?? UpdateInfoData()).copyWith(
          signature: trimmed,
        );
      });
    }
  }

  Future<void> _pickAvatar() async {
    // 防止重复点击和上传中点击
    if (_isUploadingAvatar) {
      debugPrint('[PickAvatar] Already uploading, ignoring click');
      return;
    }

    setState(() {
      _isUploadingAvatar = true;
    });

    try {
      final file = await ImageCropperHelper.pickAndCropAvatar();

      // 用户取消选择
      if (file == null) {
        debugPrint('[PickAvatar] User cancelled image selection');
        return;
      }

      setState(() {
        _avatarFile = file;
      });

      // 上传图片
      final uploadedUrl = await UploadApi.uploadImage(XFile(file.path));

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        // 更新头像到服务器
        final success = await _updateProfile(
          UpdateUserProfileReq(updateDateType: 'AVATAR', avatar: uploadedUrl),
        );

        if (success && mounted) {
          setState(() {
            _updateInfo = (_updateInfo ?? UpdateInfoData()).copyWith(
              avatar: uploadedUrl,
            );
          });
          showMsg(context, '头像上传成功！');
        } else {
          // 更新失败，清除本地文件
          setState(() {
            _avatarFile = null;
          });
        }
      } else {
        // 上传失败，清除本地文件
        setState(() {
          _avatarFile = null;
        });
        if (mounted) {
          showMsg(context, '头像上传失败，请重试');
        }
      }
    } on PlatformException catch (e) {
      debugPrint('[PickAvatar] PlatformException: ${e.code} - ${e.message}');

      // 用户取消或其他平台异常，不显示错误提示
      if (e.code != 'multiple_request' && e.code != 'photo_access_denied') {
        if (mounted) {
          showMsg(context, '选择图片失败，请重试');
        }
      }

      setState(() {
        _avatarFile = null;
      });
    } catch (e) {
      debugPrint('[PickAvatar] Error: $e');
      setState(() {
        _avatarFile = null;
      });
      if (mounted) {
        showMsg(context, '头像上传失败: $e');
      }
    } finally {
      setState(() {
        _isUploadingAvatar = false;
      });
    }
  }

  Future<void> _pickAlbumPhoto() async {
    // 检查相册数量限制
    if (_albums.length >= 6) {
      if (mounted) showMsg(context, '最多上传6张相册');
      return;
    }

    final picker = ImagePicker();
    try {
      final picked = await picker.pickMultiImage();
      if (picked.isEmpty) return;

      // 计算还可以上传的数量
      final capacity = 6 - _albums.length;
      final queue = picked.take(capacity).toList();
      if (queue.isEmpty) {
        if (mounted) showMsg(context, '已达到相册上限');
        return;
      }

      // 显示加载对话框
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // 逐个上传图片
      for (final image in queue) {
        final uploadUrl = await UploadApi.uploadImage(image);
        if (uploadUrl == null) {
          if (mounted) showMsg(context, '图片上传失败，请重试');
          break;
        }

        // 每上传一张就调用一次 API
        final resp = await UserApi.updateUserProfile(
          UpdateUserProfileReq(updateDateType: 'ALBUMS', albums: uploadUrl),
        );

        final data = resp.data;
        final success = data is Map<String, dynamic>
            ? data['code'] == 0
            : false;

        if (success) {
          setState(() {
            _albums.add(uploadUrl);
          });
        } else {
          final message = data is Map<String, dynamic>
              ? data['message'] as String?
              : null;
          if (mounted) showMsg(context, message ?? '保存相册失败');
          break;
        }
      }

      // 关闭加载对话框
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // 关闭加载对话框（如果已打开）
      if (mounted) {
        try {
          Navigator.of(context).pop();
        } catch (_) {
          // 对话框可能没打开，忽略错误
        }
      }
      if (mounted) showMsg(context, '选择图片失败: $e');
    }
  }

  Future<void> _deleteAlbumPhoto(String imageUrl) async {
    // 显示确认对话框
    final confirmed = await StyledDialog.show<bool>(
      context: context,
      titleText: '删除相册',
      content: const Text('确定要删除这张照片吗？'),
      showCancelButton: true,
      confirmText: '删除',
      cancelText: '取消',
      dismissOnConfirm: false,
      dismissOnCancel: false,
      onConfirm: (dialogCtx) => Navigator.of(dialogCtx).pop(true),
      onCancel: (dialogCtx) => Navigator.of(dialogCtx).pop(false),
    );

    if (confirmed != true) return;

    try {
      // 显示加载对话框
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // 调用删除 API
      final resp = await UserApi.updateUserProfile(
        UpdateUserProfileReq(
          updateDateType: 'ALBUMS',
          albums: imageUrl,
          hasDel: true,
        ),
      );

      // 关闭加载对话框
      if (mounted) {
        Navigator.of(context).pop();
      }

      final data = resp.data;
      final success = data is Map<String, dynamic> ? data['code'] == 0 : false;
      final message = data is Map<String, dynamic>
          ? data['message'] as String?
          : null;

      if (success) {
        // 删除成功，从本地列表中移除（可能在 _albums 或 _albumsReview 中）
        setState(() {
          _albums.remove(imageUrl);
          _albumsReview.remove(imageUrl);
        });
        if (mounted) {
          showMsg(context, message ?? '删除成功');
        }
      } else {
        if (mounted) {
          showMsg(context, message ?? '删除失败');
        }
      }
    } catch (e) {
      // 关闭加载对话框（如果已打开）
      if (mounted) {
        try {
          Navigator.of(context).pop();
        } catch (_) {
          // 对话框可能没打开，忽略错误
        }
      }
      if (mounted) {
        showMsg(context, '删除失败: $e');
      }
    }
  }

  Future<String?> _showInputDialog({
    required String title,
    required String? initial,
    required int maxLength,
    required String placeholder,
    bool multiline = false,
  }) async {
    final controller = TextEditingController(text: initial ?? '');
    String current = controller.text;

    return StyledDialog.show<String>(
      context: context,
      titleText: title,
      showCancelButton: true,
      confirmText: '确认',
      cancelText: '取消',
      dismissOnConfirm: false,
      dismissOnCancel: false,
      onConfirm: (dialogCtx) {
        Navigator.of(dialogCtx).pop(controller.text);
      },
      onCancel: (dialogCtx) => Navigator.of(dialogCtx).pop(null),
      content: StatefulBuilder(
        builder: (dialogCtx, setStateDialog) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.tabBarBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: controller,
                  maxLength: maxLength,
                  maxLines: multiline ? 4 : 1,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: placeholder,
                    hintStyle: const TextStyle(color: Colors.white54),
                    counterText: '',
                  ),
                  onChanged: (value) => setStateDialog(() {
                    current = value;
                  }),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: StyledText.secondary(
                  '${current.length}/$maxLength',
                  fontSize: 12,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const StyledText('编辑资料', fontSize: 18),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatarCard(),
                  _buildNicknameCard(),
                  _buildGenderCard(),
                  const SizedBox(height: 20),
                  _buildAlbumSection(),
                  // if ((_loginInfo?.sex ?? 0) == 0)
                  //   _buildSimpleRow(
                  //     '短视频',
                  //     actionText: '去上传',
                  //     onTap: () => 未开发,
                  //   ),
                  _buildSimpleRow('所在城市', value: _value('city')),
                  _buildActiveCityRow(),
                  _buildPickerRow(
                    '身高',
                    _value('height') != null ? '${_value('height')}cm' : '请选择',
                    _editHeight,
                  ),
                  _buildPickerRow(
                    '体重',
                    _value('weight') != null ? '${_value('weight')}kg' : '请选择',
                    _editWeight,
                  ),
                  _buildPickerRow('身材', _value('figure') ?? '请选择', _editFigure),
                  _buildPickerRow(
                    '生日',
                    _value('birthday') ?? '请选择',
                    _editBirthday,
                  ),
                  _buildPickerRow(
                    '职业',
                    _value('occupation') ?? '请选择',
                    _editOccupation,
                  ),
                  _buildTagSection('标签', _tags, _editCharacterTags),
                  _buildTagSection('兴趣爱好', _hobbies, _editHobbies),
                  _buildSignatureSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildAvatarCard() {
    return _CardContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const StyledText('头像', fontSize: 16),
          GestureDetector(
            onTap: _pickAvatar,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildImage(_value('avatar'), size: 60),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _buildImage('assets/images/Camera.png', size: 28),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameCard() {
    return _CardContainer(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const StyledText('昵称', fontSize: 16),
          GestureDetector(
            onTap: _editNickname,
            child: Row(
              children: [
                StyledText(
                  _value('userName') ?? '请选择',
                  fontSize: 14,
                  color: AppColors.userInfoGrayColor,
                ),
                const SizedBox(width: 8),
                _buildImage('assets/images/arrow.png', size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard() {
    return _CardContainer(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const StyledText('性别', fontSize: 16),
          StyledText(
            (_loginInfo?.sex ?? 0) == 1 ? '男' : '女',
            fontSize: 14,
            color: AppColors.userInfoGrayColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumSection() {
    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StyledText('个人相册', fontSize: 16),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAlbumAddButton(),
                const SizedBox(width: 16),
                ..._albums.map((url) => _buildAlbumItem(url)).toList(),
                ..._albumsReview
                    .map((url) => _buildAlbumItem(url, pending: true))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumAddButton() {
    return GestureDetector(
      onTap: _pickAlbumPhoto,
      child: Container(
        width: 85,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildAlbumItem(String url, {bool pending = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildImage(url, width: 85, height: 100),
          ),
          if (pending)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 8),
                child: const StyledText('审核中', fontSize: 12),
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _deleteAlbumPhoto(url),
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 短视频 所在城市
  Widget _buildSimpleRow(
    String label, {
    String? value,
    String? actionText,
    VoidCallback? onTap,
  }) {
    return _CardContainer(
      height: 50,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledText(label, fontSize: 16),
            Row(
              children: [
                StyledText(
                  actionText ?? value ?? '请选择',
                  fontSize: 14,
                  color: const Color(0xFF818084),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: 8),
                  _buildImage('assets/images/arrow.png', size: 20),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 活跃城市
  Widget _buildActiveCityRow() {
    final display = _activeCities.isNotEmpty
        ? _activeCities.map((e) => e.name ?? '').join(',')
        : '请选择';
    return _CardContainer(
      height: 50,
      child: GestureDetector(
        onTap: _showCityDialog,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const StyledText('活跃城市', fontSize: 16),
            Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: StyledText(
                    display,
                    fontSize: 14,
                    color: const Color(0xFF818084),
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
                const SizedBox(width: 8),
                _buildImage('assets/images/arrow.png', size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 身高，体重，身材，生日，职业
  Widget _buildPickerRow(String label, String value, VoidCallback onTap) {
    return _CardContainer(
      height: 50,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledText(label, fontSize: 16),
            Row(
              children: [
                StyledText(value, fontSize: 14, color: const Color(0xFF818084)),
                const SizedBox(width: 8),
                _buildImage('assets/images/arrow.png', size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 标签爱好
  Widget _buildTagSection(String title, List<String> tags, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardContainer(
          height: 50,
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledText(title, fontSize: 16),
                Row(
                  children: [
                    StyledText(
                      tags.isEmpty ? '请选择' : '去编辑',
                      fontSize: 14,
                      color: const Color(0xFF818084),
                    ),
                    const SizedBox(width: 8),
                    _buildImage('assets/images/arrow.png', size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: AppColors.tabBarBackground),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: tags.isNotEmpty
                ? tags
                      .map(
                        (tag) => TagChip(
                          label: tag,
                          selected: false,
                          enabled: false,
                          onTap: () {},
                          horizontal: 10,
                          vertical: 6,
                        ),
                      )
                      .toList()
                : const [
                    StyledText('暂未设置', fontSize: 14, color: Colors.white54),
                  ],
          ),
        ),
      ],
    );
  }

  Widget _buildPickerTile(String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StyledText(title, fontSize: 14),
            Row(
              children: [
                StyledText(value, fontSize: 14, color: const Color(0xFF818084)),
                const SizedBox(width: 8),
                _buildImage('assets/images/arrow.png', size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCityDialog() async {
    if (_cityData.isEmpty) {
      showMsg(context, '暂无城市数据');
      return;
    }

    List<ActiveCityInfo> tempSelected = List.from(_activeCities);
    CityInfo? selectedProvince;
    CityInfo? selectedCity;

    if (_activeCities.isNotEmpty) {
      final first = _activeCities.first;
      for (final province in _cityData) {
        final cities = province.list ?? [];
        final matchIndex = cities.indexWhere((city) => city.code == first.code);
        if (matchIndex != -1) {
          selectedProvince = province;
          selectedCity = cities[matchIndex];
          break;
        }
        if (province.code == first.code) {
          selectedProvince = province;
          break;
        }
      }
    }

    selectedProvince ??= _cityData.first;
    selectedCity ??=
        (selectedProvince.list != null && selectedProvince.list!.isNotEmpty)
        ? selectedProvince.list!.first
        : selectedProvince;

    final result = await StyledDialog.show<List<ActiveCityInfo>>(
      context: context,
      titleText: '活跃城市',
      showCancelButton: true,
      confirmText: '确定',
      cancelText: '取消',
      dismissOnConfirm: false,
      dismissOnCancel: false,
      onConfirm: (dialogCtx) => Navigator.of(dialogCtx).pop(tempSelected),
      onCancel: (dialogCtx) => Navigator.of(dialogCtx).pop(null),
      content: StatefulBuilder(
        builder: (dialogCtx, setStateDialog) {
          Future<T?> showPicker<T>({
            required String title,
            required List<T> items,
            required String Function(T) itemLabel,
          }) async {
            return await showDialog<T>(
              context: context,
              builder: (pickerCtx) => AlertDialog(
                backgroundColor: const Color(0xFF131218),
                title: StyledText(title),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: StyledText(itemLabel(item)),
                        onTap: () => Navigator.of(context).pop(item),
                      );
                    },
                  ),
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StyledText('已选择', fontSize: 14),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.textFieldBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: tempSelected.isEmpty
                    ? const StyledText(
                        '还没选择城市~',
                        fontSize: 14,
                        color: Colors.white54,
                      )
                    : Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: tempSelected
                            .map(
                              (city) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      city.name ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        setStateDialog(() {
                                          tempSelected.remove(city);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
              const SizedBox(height: 24),
              const StyledText('选择地区', fontSize: 14),
              const SizedBox(height: 12),
              _buildPickerTile('点击下拉选择', '请选择', () async {
                final result =
                    await showModalBottomSheet<Map<String, CityInfo?>>(
                      context: context,
                      builder: (context) => CityPicker(provinces: _cityData),
                    );
                if (result != null) {
                  final city = result['city'] ?? result['province'];
                  if (city == null) return;
                  if (tempSelected.length >= 5) {
                    showMsg(context, '最多只能添加5个城市');
                    return;
                  }
                  final active = ActiveCityInfo(
                    code: city.code,
                    name: city.name,
                  );
                  final exists = tempSelected.any((c) => c.code == active.code);
                  if (exists) {
                    showMsg(context, '${active.name}已存在');
                    return;
                  }
                  setStateDialog(() {
                    tempSelected.add(active);
                  });
                }
              }),
            ],
          );
        },
      ),
    );

    if (result != null) {
      final formatted = result
          .map((city) => '${city.code ?? ''}_${city.name ?? ''}')
          .join(',');
      final success = await _updateProfile(
        UpdateUserProfileReq(
          updateDateType: 'ACTIVE_CITY',
          activeCity: formatted,
        ),
      );
      if (success && mounted) {
        setState(() {
          _activeCities = result;
          _updateInfo = (_updateInfo ?? UpdateInfoData()).copyWith(
            activeCityList: result,
          );
        });
      }
    }
  }

  // 个人介绍
  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardContainer(
          height: 50,
          child: GestureDetector(
            onTap: _editSignature,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const StyledText('个人介绍', fontSize: 16),
                _buildImage('assets/images/arrow.png', size: 20),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(color: AppColors.tabBarBackground),
          child: StyledText(
            _value('signature') ?? 'Ta很懒,什么都没留下~。',
            fontSize: 14,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  // Pickers and Edit methods
  Future<void> _editHeight() async {
    final initialHeight = _updateInfo?.height;
    final selected = await PickerUtils.showHeightPicker(context, initialHeight);
    if (selected != null && selected != initialHeight) {
      final success = await _updateProfile(
        UpdateUserProfileReq(updateDateType: 'HEIGHT', height: selected),
      );
      if (success && mounted) {
        setState(() {
          _updateInfo = (_updateInfo ?? UpdateInfoData()).copyWith(
            height: selected,
          );
        });
      }
    }
  }

  Future<void> _editWeight() async {
    final initialWeight = _updateInfo?.weight;
    final selected = await PickerUtils.showWeightPicker(context, initialWeight);
    if (selected != null && selected != initialWeight) {
      final success = await _updateProfile(
        UpdateUserProfileReq(updateDateType: 'WEIGHT', weight: selected),
      );
      if (success && mounted) {
        setState(() {
          _updateInfo = (_updateInfo ?? UpdateInfoData()).copyWith(
            weight: selected,
          );
        });
      }
    }
  }

  Future<void> _editFigure() async {
    if (_figureOptions.isEmpty) {
      showMsg(context, '身材选项加载失败');
      return;
    }
    final initialFigure = _updateInfo?.figure;
    final selected = await PickerUtils.showFigureDialog(
      context,
      initialFigure,
      _figureOptions,
    );
    if (selected != null && selected != initialFigure) {
      final success = await _updateProfile(
        UpdateUserProfileReq(updateDateType: 'FIGURE', figure: selected),
      );
      if (success && mounted) {
        setState(() {
          _updateInfo = (_updateInfo ?? UpdateInfoData()).copyWith(
            figure: selected,
          );
        });
      }
    }
  }

  Future<void> _editBirthday() async {
    final initialBirthdayStr = _updateInfo?.birthday;
    final initialBirthday = initialBirthdayStr != null
        ? DateTime.tryParse(initialBirthdayStr)
        : null;
    final selected = await PickerUtils.showDatePicker(context, initialBirthday);
    if (selected != null && selected != initialBirthday) {
      final formatted = selected.toIso8601String().split('T').first;
      final success = await _updateProfile(
        UpdateUserProfileReq(updateDateType: 'BIRTHDAY', birthday: formatted),
      );
      if (success && mounted) {
        setState(() {
          _updateInfo = (_updateInfo ?? UpdateInfoData()).copyWith(
            birthday: formatted,
          );
        });
      }
    }
  }

  Future<void> _editOccupation() async {
    if (_occupationOptions.isEmpty) {
      showMsg(context, '职业选项加载失败');
      return;
    }
    final initialOccupation = _updateInfo?.occupation;
    final selected = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => UserTagScreen(
          title: '选择职业',
          type: 'Occupation',
          isSign: true,
          defaultData: initialOccupation,
          occupationList: _occupationOptions,
        ),
      ),
    );
    if (selected != null && selected != initialOccupation) {
      final success = await _updateProfile(
        UpdateUserProfileReq(
          updateDateType: 'OCCUPATION',
          occupation: selected,
        ),
      );
      if (success && mounted) {
        setState(() {
          _updateInfo = (_updateInfo ?? UpdateInfoData()).copyWith(
            occupation: selected,
          );
        });
      }
    }
  }

  Future<void> _editCharacterTags() async {
    await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) =>
            const UserTagScreen(title: '标签', type: 'CHARACTER', isSign: false),
      ),
    );
    if (mounted) {
      _loadData();
    }
  }

  Future<void> _editHobbies() async {
    final initialHobbies = <String, List<String>>{};
    for (final item in _profileItems) {
      if (item.name != null && item.name != 'CHARACTER') {
        initialHobbies[item.name!] = item.useLabels ?? [];
      }
    }

    await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) =>
            HobbyDataScreen(initialTags: initialHobbies, isSign: false),
      ),
    );
    if (mounted) {
      _loadData();
    }
  }

  Widget _buildImage(
    String? path, {
    double size = 48,
    double? width,
    double? height,
  }) {
    final resolvedWidth = width ?? size;
    final resolvedHeight = height ?? size;
    if (path == null || path.isEmpty) {
      return _imagePlaceholder(resolvedWidth, resolvedHeight);
    }

    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: resolvedWidth,
        height: resolvedHeight,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            _imagePlaceholder(resolvedWidth, resolvedHeight),
      );
    }

    final assetPath = path.startsWith('/') ? path.substring(1) : path;
    return Image.asset(
      assetPath,
      width: resolvedWidth,
      height: resolvedHeight,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          _imagePlaceholder(resolvedWidth, resolvedHeight),
    );
  }

  Widget _imagePlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.white24,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, color: Colors.white54),
    );
  }
}

class _CardContainer extends StatelessWidget {
  const _CardContainer({required this.child, this.height});

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: AppColors.tabBarBackground),
      child: child,
    );
  }
}
