import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zhenyu_flutter/api/upload_api.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/authentication/real_person_auth_screen.dart';
import 'package:zhenyu_flutter/screens/common/user_info_field.dart';
import 'package:zhenyu_flutter/screens/tag/user_tag_screen.dart';
import 'package:zhenyu_flutter/screens/user/hobby_data_screen.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final List<String> _albums = [];
  final TextEditingController _bioController = TextEditingController();

  List<String> _characterTags = [];
  Map<String, List<String>> _hobbyTags = {};
  bool _savingSignature = false;

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const StyledText('资料完善', fontSize: 18),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StyledText.primaryBold('个性资料', fontSize: 18),
            const SizedBox(height: 8),
            StyledText.secondary('请完善你的个性选项', fontSize: 14),
            const SizedBox(height: 20),
            StyledText('请上传相册 (${_albums.length}/6)', fontSize: 14),
            const SizedBox(height: 12),
            _buildAlbumSection(),
            const SizedBox(height: 24),
            UserInfoField(
              label: '性格标签',
              value: '请选择',
              highlightLabel: true,
              onTap: _pickCharacterTags,
            ),
            const SizedBox(height: 16),
            UserInfoField(
              label: '兴趣爱好',
              value: '请选择',
              highlightLabel: true,
              onTap: _pickHobbies,
            ),
            const SizedBox(height: 24),
            const StyledText('个人简介', fontSize: 14),
            const SizedBox(height: 12),
            _buildBioInput(),
            const SizedBox(height: 32),
            StyledButton(
              onPressed: _onNext,
              height: 48,
              borderRadius: BorderRadius.circular(24),
              gradient: AppGradients.primaryGradient,
              child: StyledText.inButton(_savingSignature ? '保存中...' : '下一步'),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _skip,
                child: const StyledText(
                  '跳过',
                  fontSize: 14,
                  color: AppColors.secondaryGradientStart,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumSection() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ..._albums.asMap().entries.map(
          (entry) => Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  entry.value,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 4,
                top: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _albums.removeAt(entry.key)),
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_albums.length < 6)
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
          ),
      ],
    );
  }

  Widget _buildBioInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _bioController,
            maxLength: 50,
            maxLines: 5,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '输入个人简介~',
              hintStyle: TextStyle(color: Colors.white54),
              counterText: '',
            ),
          ),
          StyledText.secondary(
            '${_bioController.text.length}/50',
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Future<void> _pickCharacterTags() async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) =>
            const UserTagScreen(title: '标签', type: 'CHARACTER', isSign: true),
      ),
    );

    if (!mounted) return;

    if (result is List<String>) {
      setState(() {
        _characterTags = result;
      });
    }
  }

  Future<void> _pickHobbies() async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => HobbyDataScreen(initialTags: _hobbyTags),
      ),
    );

    if (!mounted) return;

    if (result is Map<String, List<String>>) {
      setState(() {
        _hobbyTags = result;
      });
    }
  }

  Future<void> _pickImages() async {
    if (_albums.length >= 6) {
      showMsg(context, '最多上传6张相册');
      return;
    }

    final picker = ImagePicker();
    try {
      final picked = await picker.pickMultiImage();
      if (picked == null || picked.isEmpty) return;

      final capacity = 6 - _albums.length;
      final queue = picked.take(capacity).toList();
      if (queue.isEmpty) {
        showMsg(context, '已达到相册上限');
        return;
      }

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      for (final image in queue) {
        final uploadUrl = await UploadApi.uploadImage(image);
        if (uploadUrl == null) {
          showMsg(context, '图片上传失败，请重试');
          break;
        }

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
          showMsg(context, message ?? '保存相册失败');
          break;
        }
      }
    } catch (e) {
      showMsg(context, '选择图片失败: $e');
    } finally {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  void _onNext() {
    if (_savingSignature) return;

    final bio = _bioController.text.trim();
    if (bio.isEmpty) {
      _skip();
      return;
    }

    setState(() {
      _savingSignature = true;
    });

    UserApi.updateUserProfile(
          UpdateUserProfileReq(updateDateType: 'SIGNATURE', signature: bio),
        )
        .then((resp) {
          final data = resp.data;
          final success = data is Map<String, dynamic> && data['code'] == 0;
          final message = data is Map<String, dynamic>
              ? data['message'] as String?
              : null;

          if (success) {
            showMsg(context, message ?? '修改成功');
            _skip();
          } else {
            showMsg(context, message ?? '保存失败');
          }
        })
        .catchError((_) {
          showMsg(context, '保存失败，请稍后重试');
        })
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _savingSignature = false;
            });
          }
        });
  }

  void _skip() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const RealPersonAuthScreen(isLoginAuth: true),
      ),
    );
  }
}
