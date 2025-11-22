import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';

import 'package:zhenyu_flutter/api/real_api.dart';
import 'package:zhenyu_flutter/api/upload_api.dart';
import 'package:zhenyu_flutter/models/real_api_model.dart';
import 'package:zhenyu_flutter/screens/common/front_camera_screen.dart';
import 'package:zhenyu_flutter/screens/main_frame.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';
import 'package:zhenyu_flutter/utils/image_cropper_helper.dart';

/// 真人认证页面
class RealPersonAuthScreen extends StatefulWidget {
  const RealPersonAuthScreen({super.key, this.isLoginAuth = false});

  final bool isLoginAuth;

  @override
  State<RealPersonAuthScreen> createState() => _RealPersonAuthScreenState();
}

class _RealPersonAuthScreenState extends State<RealPersonAuthScreen> {
  final TextEditingController _wxController = TextEditingController();
  final TextEditingController _qqController = TextEditingController();
  final FocusNode _wxFocusNode = FocusNode();
  final FocusNode _qqFocusNode = FocusNode();

  File? _avatarFile;
  String? _avatarUrl;

  File? _realPhotoFile;
  String? _realPhotoUrl;

  String _contactType = 'WX';
  int _realNameStatus = 0; // 0未认证,1已认证,2审核中,3拒绝
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isMale = false; // sex == 1 ?

  @override
  void initState() {
    super.initState();
    _initialize();
    _wxFocusNode.addListener(() {
      if (_wxFocusNode.hasFocus && _contactType != 'WX') {
        setState(() => _contactType = 'WX');
      }
    });
    _qqFocusNode.addListener(() {
      if (_qqFocusNode.hasFocus && _contactType != 'QQ') {
        setState(() => _contactType = 'QQ');
      }
    });
  }

  @override
  void dispose() {
    _wxController.dispose();
    _qqController.dispose();
    _wxFocusNode.dispose();
    _qqFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _loadUserInfo();
    await _fetchRealStatus();
  }

  Future<void> _loadUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    if (currentUser != null) {
      setState(() {
        _avatarUrl = currentUser.avatar;
        _isMale = currentUser.sex == 1;
      });
    }
  }

  Future<void> _fetchRealStatus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('call getRealStatus()');
    if (!mounted) return;
    setState(() {
      _realNameStatus = 0;
      _isLoading = false;
    });
  }

  Future<void> _pickAvatar() async {
    final file = await ImageCropperHelper.pickAndCropAvatar();
    if (file != null && mounted) {
      setState(() {
        _avatarFile = file;
      });
      debugPrint('avatar cropped: ${file.path}');
    }
  }

  Future<void> _takeRealPhoto() async {
    // 使用自定义的前置摄像头页面
    final String? photoPath = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const FrontCameraScreen()),
    );

    // 用户取消拍照或拍照失败
    if (photoPath == null) return;

    setState(() {
      _realPhotoFile = File(photoPath);
    });
    debugPrint('real person photo captured: $photoPath');
  }

  void _submit() async {
    // 验证真人照片
    if (_realPhotoFile == null &&
        (_realPhotoUrl == null || _realPhotoUrl!.isEmpty)) {
      _showMessage('必须上传真人照片');
      return;
    }

    // 女生需要填写联系方式
    if (!_isMale) {
      if (_contactType == 'WX' && _wxController.text.trim().length < 6) {
        _showMessage('微信长度需 6~20 位');
        return;
      }
      if (_contactType == 'QQ') {
        final qq = _qqController.text.trim();
        if (qq.length < 5 || qq.length > 10) {
          _showMessage('QQ 长度需 5~10 位');
          return;
        }
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // 1. 上传头像（如果有本地文件）
      String? avatarUrl = _avatarUrl;
      if (_avatarFile != null) {
        debugPrint('[RealAuth] Uploading avatar...');
        avatarUrl = await UploadApi.uploadImage(XFile(_avatarFile!.path));
        if (avatarUrl == null || avatarUrl.isEmpty) {
          throw Exception('头像上传失败');
        }
      }

      // 2. 上传真人照片
      String? realPhotoUrl = _realPhotoUrl;
      if (_realPhotoFile != null) {
        debugPrint('[RealAuth] Uploading real person photo...');
        realPhotoUrl = await UploadApi.uploadImage(XFile(_realPhotoFile!.path));
        if (realPhotoUrl == null || realPhotoUrl.isEmpty) {
          throw Exception('真人照片上传失败');
        }
      }

      // 3. 构建请求参数
      final accountType = _isMale
          ? null
          : (_contactType == 'WX' ? AccountType.wx : AccountType.qq);

      final wxAccount = _isMale
          ? null
          : (_contactType == 'WX' ? _wxController.text.trim() : null);

      final request = RealNameReq(
        accountType: accountType,
        avatarUrl: avatarUrl,
        realPersonUrl: realPhotoUrl!,
        wxAccount: wxAccount,
      );

      debugPrint('[RealAuth] Submitting real name authentication...');

      // 4. 调用真人认证接口
      final response = await RealApi.realName(request);

      if (!mounted) return;

      if (response.code == 0) {
        // 认证提交成功
        setState(() {
          _isSubmitting = false;
          _realNameStatus = 2; // 审核中
        });

        showMsg(context, '提交成功，等待审核');

        // 延迟后跳转到主页
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (!mounted) return;

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainFrame()),
            (route) => false,
          );
        });
      } else {
        setState(() {
          _isSubmitting = false;
        });
        showMsg(context, response.message ?? '提交失败，请稍后重试');
      }
    } on PlatformException catch (e) {
      debugPrint('[RealAuth] PlatformException: ${e.code} - ${e.message}');
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        if (e.code == 'multiple_request' || e.code == 'photo_access_denied') {
          showMsg(context, '操作已取消');
        } else {
          showMsg(context, '提交失败: ${e.message}');
        }
      }
    } catch (e) {
      debugPrint('[RealAuth] Error: $e');
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        showMsg(context, '提交失败: $e');
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Color _statusColor() {
    switch (_realNameStatus) {
      case 1:
        return AppGradients.primaryGradient.colors.last;
      case 2:
      case 3:
        return Colors.red;
      default:
        return Colors.white.withOpacity(0.5);
    }
  }

  String _statusLabel() {
    switch (_realNameStatus) {
      case 1:
        return '已真人';
      case 2:
        return '审核中';
      case 3:
        return '审核拒绝';
      default:
        return '未认证';
    }
  }

  Widget _buildAvatar() {
    Widget child;
    if (_avatarFile != null) {
      child = Image.file(_avatarFile!, fit: BoxFit.cover);
    } else if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      child = Image.network(_avatarUrl!, fit: BoxFit.cover);
    } else {
      child = const Icon(Icons.person, size: 72, color: Colors.white54);
    }

    return GestureDetector(
      onTap: _pickAvatar,
      child: CircleAvatar(
        radius: 83.5.w,
        backgroundColor: Colors.white12,
        child: ClipOval(child: SizedBox.expand(child: child)),
      ),
    );
  }

  Widget _buildRealPhotoBox() {
    Widget content;
    if (_realPhotoFile != null) {
      content = Image.file(_realPhotoFile!, fit: BoxFit.cover);
    } else if (_realPhotoUrl != null && _realPhotoUrl!.isNotEmpty) {
      content = Image.network(_realPhotoUrl!, fit: BoxFit.cover);
    } else {
      content = Container(
        decoration: BoxDecoration(
          color: AppColors.tabBarBackground,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: const Center(
          child: Text(
            '点击开始拍照',
            style: TextStyle(
              color: AppColors.secondaryGradientEnd,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _takeRealPhoto,
      child: SizedBox(
        width: 400.w,
        height: 400.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: content,
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    if (_isMale) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 32.h),
        Text(
          '联系方式：',
          style: TextStyle(color: Colors.white, fontSize: 28.sp),
        ),
        SizedBox(height: 24.h),
        _buildContactItem(
          type: 'WX',
          controller: _wxController,
          keyboardType: TextInputType.text,
          hint: '请输入微信号',
          assetPath: 'assets/images/WXICON.png',
          focusNode: _wxFocusNode,
        ),
        SizedBox(height: 16.h),
        _buildContactItem(
          type: 'QQ',
          controller: _qqController,
          keyboardType: TextInputType.number,
          hint: '请输入 QQ 号',
          assetPath: 'assets/images/QQ.png',
          focusNode: _qqFocusNode,
        ),
        SizedBox(height: 12.h),
        Text(
          '(你的微信/QQ账号可在聊天中与他人交换)',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 25.sp,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required String type,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String hint,
    required String assetPath,
    required FocusNode focusNode,
  }) {
    final selected = _contactType == type;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() => _contactType = type);
        FocusScope.of(context).requestFocus(focusNode);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? AppColors.goldGradientStart : Colors.white,
              size: 25.sp,
            ),
            SizedBox(width: 12.w),
            Image.asset(assetPath, width: 62.5.w, height: 62.5.w),
            SizedBox(width: 12.w),
            Container(
              width: 330.w,
              height: 73.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(83.r),
                border: Border.all(
                  color: selected
                      ? AppColors.goldGradientStart
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                onTap: () {
                  setState(() => _contactType = type);
                  FocusScope.of(context).requestFocus(focusNode);
                },
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('认证中心'),
        leading: widget.isLoginAuth
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        kToolbarHeight -
                        32.h, // 减去 vertical padding
                    minWidth: double.infinity, // 确保宽度占满屏幕
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    _buildAvatar(),
                    SizedBox(height: 12.h),
                    Text(
                      '当前头像 (可以点击修改)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 31.sp,
                        height: 1.4,
                      ),
                    ),
                    Text(
                      '头像照片将于真人照片进行对比',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 25.sp,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    _buildRealPhotoBox(),
                    SizedBox(height: 16.h),
                    Text(
                      _realPhotoFile == null &&
                              (_realPhotoUrl == null || _realPhotoUrl!.isEmpty)
                          ? '拍照上传真人照片'
                          : '点击重新拍摄',
                      style: TextStyle(color: Colors.white, fontSize: 31.sp),
                    ),
                    Text(
                      '(真人照片仅用于审核，不对外展示)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 25.sp,
                      ),
                    ),
                    _buildContactForm(),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: 560.w,
                      height: 84.h,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style:
                            ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(83.r),
                              ),
                            ).merge(
                              ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                      (states) =>
                                          states.contains(
                                            MaterialState.disabled,
                                          )
                                          ? Colors.white24
                                          : null,
                                    ),
                              ),
                            ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            borderRadius: BorderRadius.circular(83.r),
                          ),
                          child: Center(
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.black,
                                      ),
                                    ),
                                  )
                                : Text(
                                    '提交',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 31.sp,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      _statusLabel(),
                      style: TextStyle(
                        color: _statusColor(),
                        fontSize: 27.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
