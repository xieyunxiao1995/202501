import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:zhenyu_flutter/api/posts_api.dart';
import 'package:zhenyu_flutter/api/upload_api.dart';
import 'package:zhenyu_flutter/models/posts_api_model.dart';
import 'package:zhenyu_flutter/screens/common/vip_dialog.dart';
import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/theme.dart';

class PublishPostScreen extends StatefulWidget {
  const PublishPostScreen({super.key});

  @override
  State<PublishPostScreen> createState() => _PublishPostScreenState();
}

class _PublishPostScreenState extends State<PublishPostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<String> _imageUrls = [];
  bool _isSubmitting = false;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_imageUrls.length >= 9 || _isUploadingImage) {
      return;
    }
    setState(() {
      _isUploadingImage = true;
    });
    try {
      final url = await UploadApi.pickAndUploadImage();
      if (!mounted) return;
      if (url != null) {
        setState(() {
          if (_imageUrls.length < 9) {
            _imageUrls.add(url);
          }
        });
      } else {
        _showMessage('图片上传失败，请重试');
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('选择图片出错: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final content = _contentController.text.trim();

    setState(() {
      _isSubmitting = true;
    });

    try {
      final resp = await PostsApi.createPost(
        PostsCreateReq(
          content: content,
          imageList: List<String>.from(_imageUrls),
          // latitude: latitude,
          // longitude: longitude,
        ),
      );

      if (!mounted) return;

      if (resp.code == 2006) {
        _showVipDialog();
        return;
      }

      if (resp.code == 0) {
        _showMessage(resp.message ?? '发布成功');
        Navigator.of(context).pop(true);
      } else {
        _showMessage(resp.message ?? '发布失败');
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('发布失败: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showVipDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => const VipDialog(),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('发布动态'),
        // actions: [
        //   TextButton(
        //     onPressed: _showVipDialog,
        //     child: const Text('开通会员', style: TextStyle(color: Colors.white)),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContentInput(),
                  const SizedBox(height: 24),
                  _buildImageSection(),
                  const SizedBox(height: 200),
                ],
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: StyledButton(
                onPressed: _isSubmitting ? () {} : _submit,
                height: 52,
                borderRadius: BorderRadius.circular(32),
                gradient: AppGradients.primaryGradient,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        '确定发布',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            if (_isUploadingImage)
              Positioned.fill(
                child: Container(
                  color: Colors.black38,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          TextField(
            controller: _contentController,
            maxLines: 6,
            minLines: 4,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '开始分享你的生活~',
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Text(
              '${_contentController.text.length}/50',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '添加照片 (${_imageUrls.length}/9)',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...List.generate(_imageUrls.length, (index) {
              return _buildImageTile(_imageUrls[index], index);
            }),
            if (_imageUrls.length < 9)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white24,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white54, size: 36),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageTile(String url, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 110,
              height: 110,
              color: Colors.white10,
              child: const Icon(Icons.broken_image, color: Colors.white38),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
