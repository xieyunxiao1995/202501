import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zhenyu_flutter/api/invite_api.dart';
import 'package:zhenyu_flutter/models/invite_api_model.dart';
import 'package:zhenyu_flutter/theme.dart';

// 分享海报页面
class InvatePosterScreen extends StatefulWidget {
  const InvatePosterScreen({super.key});

  @override
  State<InvatePosterScreen> createState() => _InvatePosterScreenState();
}

class _InvatePosterScreenState extends State<InvatePosterScreen> {
  final GlobalKey _posterKey = GlobalKey();
  InvitePageData? _inviteData;
  bool _isLoading = true;
  bool _hasError = false;
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _fetchInviteData();
  }

  Future<void> _fetchInviteData() async {
    try {
      final resp = await InviteApi.getInvitePage();
      if (mounted) {
        if (resp.code == 0 && resp.data != null) {
          setState(() {
            _inviteData = resp.data;
            _isLoading = false;
          });
        } else {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _captureAndSavePoster() async {
    try {
      RenderRepaintBoundary boundary =
          _posterKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        _showToast('生成图片失败');
        return;
      }
      _imageData = byteData.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(
        _imageData!,
        quality: 100,
        name: "invite_poster_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (mounted) {
        if (result['isSuccess']) {
          _showToast('图片已保存到相册');
        } else {
          _showToast('保存失败: ${result['errorMessage']}');
        }
      }
    } catch (e) {
      _showToast('保存图片时发生错误: $e');
    }
  }

  void _showToast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          _buildContent(),
          _buildTopNavBar(context),
          if (!_isLoading && !_hasError) _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset('assets/images/invate/bjthree.png', fit: BoxFit.cover);
  }

  Widget _buildTopNavBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topPadding,
      left: 0,
      right: 0,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Text(
              '分享海报',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 48), // Placeholder for alignment
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned.fill(
      top: 120,
      child: Column(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_hasError)
            Center(
              child: Column(
                children: [
                  const Text('加载失败', style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: _fetchInviteData,
                    child: const Text('重试'),
                  ),
                ],
              ),
            )
          else
            _buildPoster(),
          const SizedBox(height: 30),
          const Text(
            '微信搜索"真遇"或者长按图片识别和保存',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildPoster() {
    return RepaintBoundary(
      key: _posterKey,
      child: Container(
        width: 300,
        height: 450,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/invate/codeImageBac.png',
              fit: BoxFit.fill,
              width: 300,
              height: 450,
            ),
            Positioned(
              top: 95,
              child: Container(
                padding: const EdgeInsets.all(2),
                color: Colors.white,
                child: QrImageView(
                  data: _inviteData?.inviteUrlH5 ?? '',
                  version: QrVersions.auto,
                  size: 180.0,
                ),
              ),
            ),
            Positioned(
              bottom: 105,
              child: Text(
                '邀请码: ${_inviteData?.inviteCode ?? ''}',
                style: const TextStyle(
                  color: AppColors.secondaryGradientStart,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Positioned(
      bottom: 75,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: _captureAndSavePoster,
          child: Container(
            width: 325,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.secondaryGradientStart,
                  AppColors.secondaryGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(63),
            ),
            child: const Text(
              '保存图片',
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
