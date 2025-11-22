import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';

import 'package:zhenyu_flutter/api/upload_api.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_dialog.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/utils/common.dart';
import 'package:zhenyu_flutter/utils/image_cropper_helper.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/screens/user/basic_data_screen.dart';
import 'package:zhenyu_flutter/screens/register/registration_result_helper.dart';

class UserDataScreen extends StatefulWidget {
  final String extraParam;
  final String mobile;
  final String smsCode;

  const UserDataScreen({
    super.key,
    required this.extraParam,
    required this.mobile,
    required this.smsCode,
  });

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  // true: 完善资料, false: 选择性别
  bool _changePage = false;
  int? _selectedSex; // 1 for male, 0 for female in API
  String _activeSexText = '';

  final _userNameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  String _avatarUrl = '';
  bool _customName = false;
  bool _isUploading = false;
  String _submitButtonText = '下一步';
  bool _isSubmitting = false;

  late UserRegisterData _formData;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _formData = UserRegisterData(
      extraParam: widget.extraParam,
      mobile: widget.mobile,
      smsCode: widget.smsCode,
    );
    _userNameController.addListener(() {
      setState(() {
        _customName = true;
      });
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  void _changeSex(String text, int type) {
    setState(() {
      _activeSexText = text;
      _selectedSex = type;
      // API requires 0 for female, 1 for male
      _formData = UserRegisterData(
        extraParam: _formData.extraParam,
        mobile: _formData.mobile,
        smsCode: _formData.smsCode,
        sex: type == 2 ? 0 : 1,
        userName: _formData.userName,
        avatar: _formData.avatar,
        customName: _formData.customName,
        inviteCode: _formData.inviteCode,
      );
    });

    if (type == 1) {
      // Auto-generate avatar and name for males
      _getRandomAvatar();
    }
  }

  Future<void> _getRandomAvatar() async {
    try {
      // Assuming randomAvatar API exists and returns a URL in the 'data' field
      final response = await UserApi.randomAvatar(
        RandomAvatarReq(sex: _formData.sex!),
      );
      if (response.code == 0 && response.data != null) {
        setState(() {
          _avatarUrl = response.data!;
          _formData = UserRegisterData(
            extraParam: _formData.extraParam,
            mobile: _formData.mobile,
            smsCode: _formData.smsCode,
            sex: _formData.sex,
            userName: _formData.userName,
            avatar: _avatarUrl,
            customName: _formData.customName,
            inviteCode: _formData.inviteCode,
          );
        });
        _getRandomName(); // Chain call to get name after avatar
      }
    } catch (e) {
      print('Failed to get random avatar: $e');
    }
  }

  Future<void> _getRandomName() async {
    try {
      // Assuming getUserName API exists and returns a name in the 'data' field
      final response = await UserApi.getUserName(
        RandomNameReq(sex: _formData.sex!),
      );
      if (response.code == 0 && response.data != null) {
        setState(() {
          _userNameController.text = response.data!;
          _formData = UserRegisterData(
            extraParam: _formData.extraParam,
            mobile: _formData.mobile,
            smsCode: _formData.smsCode,
            sex: _formData.sex,
            userName: response.data!,
            avatar: _formData.avatar,
            customName: 0, // Reset custom name flag
            inviteCode: _formData.inviteCode,
          );
          _customName = false;
        });
      }
    } catch (e) {
      print('Failed to get random name: $e');
    }
  }

  void _nextStep() {
    if (_selectedSex == null) {
      showMsg(context, '请先选择性别~');
      return;
    }
    StyledDialog.show(
      context: context,
      titleText: '确认性别',
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: textStylePrimary.copyWith(color: Colors.white, fontSize: 14),
          children: [
            const TextSpan(text: '您当前选择的性别为 '),
            TextSpan(
              text: _activeSexText,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: '，注册成功后性别不可修改，是否确认？'),
          ],
        ),
      ),
      onConfirm: (ctx) {
        setState(() {
          _changePage = true;
          _submitButtonText = _selectedSex == 1 ? '立即进入' : '下一步';
        });
      },
      confirmText: '确认',
      cancelText: '取消',
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    if (_selectedSex == null) {
      showMsg(context, '请选择性别');
    } else if (_userNameController.text.isEmpty) {
      showMsg(context, '请输入昵称');
    } else if (_avatarUrl.isEmpty) {
      showMsg(context, '请上传头像');
    } else {
      final inviteCode = _inviteCodeController.text.trim();
      if (inviteCode.isNotEmpty) {
        try {
          final checkResp = await UserApi.checkInviteCode(
            CheckInviteCodeReq(inviteCode: inviteCode),
          );
          if (checkResp.code != 0) {
            showMsg(context, checkResp.message ?? '邀请码校验失败');
            return;
          }
        } catch (_) {
          showMsg(context, '邀请码校验失败');
          return;
        }
      }
      final finalData = UserRegisterData(
        extraParam: _formData.extraParam,
        mobile: _formData.mobile,
        smsCode: _formData.smsCode,
        sex: _selectedSex == 2 ? 0 : 1,
        userName: _userNameController.text,
        avatar: _avatarUrl,
        inviteCode: inviteCode.isNotEmpty ? inviteCode : null,
        customName: _customName ? 1 : 0,
      );

      setState(() {
        _isSubmitting = true;
      });

      try {
        final redirectToBasic = await _shouldNavigateToBasicData(finalData);
        if (redirectToBasic) {
          if (!mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BasicDataScreen(baseData: finalData),
            ),
          );
          return;
        }

        final response = await UserApi.userRegister(finalData);
        if (response.code == 0 && response.data != null) {
          // 女生（sex == 0）需要跳转到个人资料页面
          await handleRegistrationSuccess(
            this,
            response.data!,
            redirectToPersonalData: finalData.sex == 0,
          );
        } else {
          showMsg(context, response.message ?? '注册失败');
        }
      } catch (e) {
        showMsg(context, '注册时发生错误');
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  Future<bool> _shouldNavigateToBasicData(UserRegisterData data) async {
    if (data.sex != 0) return false;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final initConfig = userProvider.initConfig;
    if (initConfig != null) {
      return (initConfig.reviewEnvStatus ?? 1) == 0;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledText(_changePage ? '完善资料' : '选择性别')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: _changePage ? _buildProfileForm() : _buildSexSelection(),
      ),
    );
  }

  Widget _buildSexSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const StyledText.primaryBold('欢迎来到真遇', fontSize: 24),
        const SizedBox(height: 8),
        const StyledText.secondary('请选择你的性别', fontSize: 16),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSexCard(
              '男',
              1,
              'assets/images/register/boy_unselected.png',
              'assets/images/register/boy_selected.png',
            ),
            const SizedBox(width: 40),
            _buildSexCard(
              '女',
              2,
              'assets/images/register/girl_unselected.png',
              'assets/images/register/girl_selected.png',
            ),
          ],
        ),
        const SizedBox(height: 60),
        SizedBox(height: 60),
        Align(
          alignment: Alignment.center,
          child: StyledButton(
            onPressed: _nextStep,
            width: 400.w, // 或者直接 double 值
            height: 90.h,
            borderRadius: BorderRadius.circular(63.r),
            gradient: AppGradients.primaryGradient,
            child: StyledText.inButton('下一步', fontSize: 32.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildSexCard(
    String text,
    int type,
    String normalImg,
    String selectedImg,
  ) {
    bool isSelected = _selectedSex == type;
    return GestureDetector(
      onTap: () => _changeSex(text, type),
      child: Column(
        children: [
          Image.asset(
            isSelected ? selectedImg : normalImg,
            width: 130,
            height: 130,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20.h, 20.w, 20.h),
            child: StyledButton(
              onPressed: () => _changeSex(text, type),
              width: 150.w,
              height: 70.h,
              borderRadius: BorderRadius.circular(50.r),
              gradient: isSelected ? AppGradients.primaryGradient : null,
              backgroundColor: isSelected ? null : const Color(0xFF2C2B30),
              child: StyledText.inButton(
                text,
                fontSize: 28.sp,
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: StyledText.primaryBold('欢迎来到真遇', fontSize: 14),
        ),
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: StyledText.secondary('资料完善后就可以开始交友了', fontSize: 16),
        ),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : (_avatarUrl.isNotEmpty ? NetworkImage(_avatarUrl) : null)
                          as ImageProvider?,
                child: _imageFile == null && _avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.black54,
                child: Image.asset(
                  'assets/images/register/Camera.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        StyledText.secondary('请上传本人正面头像', fontSize: 12),

        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: StyledText('起个好听的昵称', fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
            controller: _userNameController,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: '请输入昵称',
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              counterText: '',
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _getRandomName,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: StyledText('输入邀请码', fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
            controller: _inviteCodeController,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: '非必填',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
        const SizedBox(height: 40),
        Align(
          alignment: Alignment.center,
          child: StyledButton(
            onPressed: _submit,
            width: 400.w, // 或者直接 double 值
            height: 90.h,
            borderRadius: BorderRadius.circular(63.r),
            gradient: AppGradients.primaryGradient,
            child: StyledText.inButton(_submitButtonText, fontSize: 32.sp),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    // 防止重复点击和上传中点击
    if (_isUploading) {
      debugPrint('[PickImage] Already uploading, ignoring click');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final file = await ImageCropperHelper.pickAndCropAvatar();

      // 用户取消选择
      if (file == null) {
        debugPrint('[PickImage] User cancelled image selection');
        return;
      }

      setState(() {
        _imageFile = file;
      });

      // 上传图片
      final uploadedUrl = await UploadApi.uploadImage(XFile(file.path));

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        setState(() {
          _avatarUrl = uploadedUrl;
          _formData = UserRegisterData(
            extraParam: _formData.extraParam,
            mobile: _formData.mobile,
            smsCode: _formData.smsCode,
            sex: _formData.sex,
            userName: _formData.userName,
            avatar: _avatarUrl,
          );
        });
        if (mounted) {
          showMsg(context, '头像上传成功！');
        }
      } else {
        // 上传失败，清除本地文件
        setState(() {
          _imageFile = null;
        });
        if (mounted) {
          showMsg(context, '头像上传失败，请重试');
        }
      }
    } on PlatformException catch (e) {
      debugPrint('[PickImage] PlatformException: ${e.code} - ${e.message}');

      // 用户取消或其他平台异常，不显示错误提示
      if (e.code != 'multiple_request' && e.code != 'photo_access_denied') {
        if (mounted) {
          showMsg(context, '选择图片失败，请重试');
        }
      }

      setState(() {
        _imageFile = null;
      });
    } catch (e) {
      debugPrint('[PickImage] Error: $e');
      setState(() {
        _imageFile = null;
      });
      if (mounted) {
        showMsg(context, '头像上传失败: $e');
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
