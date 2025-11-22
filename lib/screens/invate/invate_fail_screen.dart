import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:zhenyu_flutter/api/invite_api.dart';
import 'package:zhenyu_flutter/api/upload_api.dart';
import 'package:zhenyu_flutter/models/invite_api_model.dart';
import 'package:zhenyu_flutter/theme.dart';

class InvateFailScreen extends StatefulWidget {
  const InvateFailScreen({super.key});

  @override
  State<InvateFailScreen> createState() => _InvateFailScreenState();
}

class _InvateFailScreenState extends State<InvateFailScreen> {
  final _mobileController = TextEditingController();
  final _reasonController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<File> _images = [];
  final List<String> _uploadedImageUrls = [];

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_images.length >= 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('最多上传6张图片')));
      return;
    }

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      // 立即显示本地图片以提供即时反馈
      setState(() {
        _images.add(file);
      });

      // 在后台上传图片
      try {
        final imageUrl = await UploadApi.uploadImage(pickedFile);
        if (imageUrl != null) {
          _uploadedImageUrls.add(imageUrl);
          print('图片上传成功: $imageUrl');
        } else {
          // 上传失败，从UI中移除刚刚添加的图片
          setState(() {
            _images.remove(file);
          });
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('图片上传失败，请重试')));
          }
        }
      } catch (e) {
        // 异常处理
        setState(() {
          _images.remove(file);
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('图片上传出错: $e')));
        }
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      // 如果URL列表和图片列表长度一致，也移除对应的URL
      if (index < _uploadedImageUrls.length) {
        _uploadedImageUrls.removeAt(index);
      }
    });
  }

  void _submit() async {
    final mobile = _mobileController.text.trim();
    final reason = _reasonController.text.trim();

    if (mobile.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入对方手机号码~')));
      return;
    }
    if (reason.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入申请说明~')));
      return;
    }
    if (_images.isNotEmpty && _uploadedImageUrls.length != _images.length) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('部分图片还在上传中，请稍候...')));
      return;
    }

    try {
      final req = InviteBindUserReq(
        mobile: mobile,
        bindReason: reason,
        imageUrl: _uploadedImageUrls.join(','),
      );
      final resp = await InviteApi.inviteBindUser(req);
      if (mounted) {
        if (resp.code == 0) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('提交成功~')));
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(resp.message ?? '提交失败')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('提交出错: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('绑定邀请关系申请'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescription(),
                _buildPhoneInput(),
                _buildReasonInput(),
                _buildImagePicker(),
                const SizedBox(height: 150),
              ],
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('说明：', style: TextStyle(color: Colors.white, fontSize: 15.5)),
          SizedBox(height: 10),
          Text(
            '1.已邀请他人注册，注册人未填写邀请码，可提交邀请相关证明申请绑定邀请关系；',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.6),
              fontSize: 13.5,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '2.申请需通过人工审核，审核时间为72小时内；',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.6),
              fontSize: 13.5,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '3.申请审核通过后，系统将补发邀请奖励。',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.6),
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '对方的手机号码:',
            style: TextStyle(color: Colors.white, fontSize: 15.5),
          ),
          const SizedBox(height: 15.5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.containerBlackColor,
              borderRadius: BorderRadius.circular(6.5),
            ),
            child: TextField(
              controller: _mobileController,
              keyboardType: TextInputType.number,
              maxLength: 11,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: '请输入对方的手机号码',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '申请说明:',
            style: TextStyle(color: Colors.white, fontSize: 15.5),
          ),
          const SizedBox(height: 15.5),
          Container(
            height: 145,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.08),
              borderRadius: BorderRadius.circular(6.5),
            ),
            child: Stack(
              children: [
                TextField(
                  controller: _reasonController,
                  maxLines: null,
                  maxLength: 200,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: '输入申请说明~',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    '${_reasonController.text.length}/200',
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.6),
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '证据照片：(最多上传6张）',
            style: TextStyle(color: Colors.white, fontSize: 15.5),
          ),
          const SizedBox(height: 15.5),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.5,
              mainAxisSpacing: 12.5,
            ),
            itemCount: _images.length + 1,
            itemBuilder: (context, index) {
              if (index == _images.length) {
                return _images.length < 6
                    ? GestureDetector(
                        onTap: _pickImage,
                        child: DottedBorder(
                          options: const RectDottedBorderOptions(
                            color: AppColors.borderColor,
                            strokeWidth: 1,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }
              return Stack(
                children: [
                  Image.file(
                    _images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Positioned(
      bottom: 15,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: _submit,
          child: Container(
            width: 337.5,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.secondaryGradientStart,
                  AppColors.secondaryGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(31.5),
            ),
            child: const Text(
              '申请提交',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
