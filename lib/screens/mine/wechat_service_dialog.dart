import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:typed_data';

/// 显示微信服务号二维码弹窗
void showWechatServiceDialog(BuildContext context, {String? qrCodeUrl}) {
  showDialog(
    context: context,
    builder: (context) => _WechatServiceDialog(qrCodeUrl: qrCodeUrl),
  );
}

/// 微信服务号二维码弹窗 Widget
class _WechatServiceDialog extends StatefulWidget {
  final String? qrCodeUrl;

  const _WechatServiceDialog({this.qrCodeUrl});

  @override
  State<_WechatServiceDialog> createState() => _WechatServiceDialogState();
}

class _WechatServiceDialogState extends State<_WechatServiceDialog> {
  Uint8List? _cachedImageBytes; // 缓存的图片数据
  bool _isDownloading = false; // 是否正在下载

  @override
  void initState() {
    super.initState();
    // 预下载图片到内存
    if (widget.qrCodeUrl != null && widget.qrCodeUrl!.isNotEmpty) {
      _preloadImage();
    }
  }

  /// 预加载图片到内存
  Future<void> _preloadImage() async {
    if (_cachedImageBytes != null || _isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final response = await Dio().get(
        widget.qrCodeUrl!,
        options: Options(responseType: ResponseType.bytes),
      );
      if (mounted) {
        setState(() {
          _cachedImageBytes = Uint8List.fromList(response.data);
          _isDownloading = false;
        });
      }
    } catch (e) {
      debugPrint('预加载图片失败: $e');
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  /// 保存图片到相册（使用缓存的图片数据）
  Future<void> _saveImageToGallery() async {
    final startTime = DateTime.now();
    debugPrint('===== 开始保存图片 =====');

    try {
      // 如果还没有缓存，先下载
      if (_cachedImageBytes == null) {
        debugPrint('图片未缓存，需要先下载');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('正在准备图片，请稍后再试...')),
        );
        await _preloadImage();
        return;
      }

      debugPrint('使用缓存的图片数据，大小: ${_cachedImageBytes!.length} bytes');

      // iOS 14+ 只需要 "Add Photos Only" 权限，ImageGallerySaver 会自动处理
      // Android 需要手动请求存储权限
      if (Platform.isAndroid) {
        debugPrint('Android平台，检查存储权限...');
        final permissionStart = DateTime.now();

        // Android: 检查并请求存储权限
        PermissionStatus status = await Permission.storage.status;

        if (status.isPermanentlyDenied) {
          debugPrint('存储权限被永久拒绝');
          if (mounted) {
            _showPermissionDialog();
          }
          return;
        }

        if (!status.isGranted) {
          debugPrint('请求存储权限...');
          status = await Permission.storage.request();
          debugPrint('权限请求结果: $status');
        }

        if (!status.isGranted) {
          if (mounted) {
            if (status.isPermanentlyDenied) {
              _showPermissionDialog();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('需要存储权限才能保存图片')),
              );
            }
          }
          return;
        }

        final permissionDuration = DateTime.now().difference(permissionStart);
        debugPrint('权限检查耗时: ${permissionDuration.inMilliseconds}ms');
      } else {
        debugPrint('iOS平台，ImageGallerySaver会自动处理权限');
      }

      // 直接使用缓存的图片数据保存
      debugPrint('开始保存到相册...');
      final saveStart = DateTime.now();

      final result = await ImageGallerySaver.saveImage(
        _cachedImageBytes!,
        quality: 100,
        name: 'wechat_qrcode_${DateTime.now().millisecondsSinceEpoch}',
      );

      final saveDuration = DateTime.now().difference(saveStart);
      debugPrint('ImageGallerySaver.saveImage 耗时: ${saveDuration.inMilliseconds}ms');
      debugPrint('保存结果: $result');

      if (mounted) {
        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('图片已保存到相册')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('保存失败，请重试')),
          );
        }
      }

      final totalDuration = DateTime.now().difference(startTime);
      debugPrint('===== 保存完成，总耗时: ${totalDuration.inMilliseconds}ms =====');
    } catch (e) {
      debugPrint('保存图片失败: $e');
      final totalDuration = DateTime.now().difference(startTime);
      debugPrint('===== 保存失败，总耗时: ${totalDuration.inMilliseconds}ms =====');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    }
  }

  /// 显示权限设置对话框
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要存储权限'),
        content: const Text('保存图片需要存储权限，请在设置中开启。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 275,
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 二维码图片
                  GestureDetector(
                    onTap: () {
                      if (widget.qrCodeUrl != null &&
                          widget.qrCodeUrl!.isNotEmpty) {
                        _showFullScreenImage(context, widget.qrCodeUrl!);
                      }
                    },
                    onLongPress: _saveImageToGallery,
                    child: Container(
                      width: 200,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: widget.qrCodeUrl != null &&
                              widget.qrCodeUrl!.isNotEmpty
                          ? Image.network(
                              widget.qrCodeUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.qr_code,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.qr_code,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 提示文字
                  const Text(
                    '使用微信扫描二维码关注公众号后，不会错过真遇圈消息哦~',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '点击查看二维码,长按保存',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '(或直接截图)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // 关闭按钮
            Positioned(
              bottom: -50,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 显示全屏图片预览
void _showFullScreenImage(BuildContext context, String imageUrl) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => _FullScreenImageViewer(imageUrl: imageUrl),
    ),
  );
}

/// 全屏图片查看器
class _FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;

  const _FullScreenImageViewer({required this.imageUrl});

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  Uint8List? _cachedImageBytes;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _preloadImage();
  }

  /// 预加载图片
  Future<void> _preloadImage() async {
    if (_cachedImageBytes != null || _isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final response = await Dio().get(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (mounted) {
        setState(() {
          _cachedImageBytes = Uint8List.fromList(response.data);
          _isDownloading = false;
        });
      }
    } catch (e) {
      debugPrint('预加载图片失败: $e');
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  /// 保存图片到相册
  Future<void> _saveImage() async {
    final startTime = DateTime.now();
    debugPrint('===== [全屏] 开始保存图片 =====');

    try {
      if (_cachedImageBytes == null) {
        debugPrint('[全屏] 图片未缓存，需要先下载');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('正在准备图片，请稍后再试...')),
        );
        await _preloadImage();
        return;
      }

      debugPrint('[全屏] 使用缓存的图片数据，大小: ${_cachedImageBytes!.length} bytes');

      if (Platform.isAndroid) {
        debugPrint('[全屏] Android平台，检查存储权限...');
        final permissionStart = DateTime.now();

        PermissionStatus status = await Permission.storage.status;
        if (status.isPermanentlyDenied) {
          debugPrint('[全屏] 存储权限被永久拒绝');
          if (mounted) _showPermissionDialog();
          return;
        }
        if (!status.isGranted) {
          debugPrint('[全屏] 请求存储权限...');
          status = await Permission.storage.request();
          debugPrint('[全屏] 权限请求结果: $status');
        }
        if (!status.isGranted) {
          if (mounted) {
            if (status.isPermanentlyDenied) {
              _showPermissionDialog();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('需要存储权限才能保存图片')),
              );
            }
          }
          return;
        }

        final permissionDuration = DateTime.now().difference(permissionStart);
        debugPrint('[全屏] 权限检查耗时: ${permissionDuration.inMilliseconds}ms');
      } else {
        debugPrint('[全屏] iOS平台，ImageGallerySaver会自动处理权限');
      }

      debugPrint('[全屏] 开始保存到相册...');
      final saveStart = DateTime.now();

      final result = await ImageGallerySaver.saveImage(
        _cachedImageBytes!,
        quality: 100,
        name: 'wechat_qrcode_${DateTime.now().millisecondsSinceEpoch}',
      );

      final saveDuration = DateTime.now().difference(saveStart);
      debugPrint('[全屏] ImageGallerySaver.saveImage 耗时: ${saveDuration.inMilliseconds}ms');
      debugPrint('[全屏] 保存结果: $result');

      if (mounted) {
        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('图片已保存到相册')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('保存失败，请重试')),
          );
        }
      }

      final totalDuration = DateTime.now().difference(startTime);
      debugPrint('===== [全屏] 保存完成，总耗时: ${totalDuration.inMilliseconds}ms =====');
    } catch (e) {
      debugPrint('[全屏] 保存图片失败: $e');
      final totalDuration = DateTime.now().difference(startTime);
      debugPrint('===== [全屏] 保存失败，总耗时: ${totalDuration.inMilliseconds}ms =====');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要存储权限'),
        content: const Text('保存图片需要存储权限，请在设置中开启。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        onLongPress: _saveImage,
        child: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 60,
                      ),
                      SizedBox(height: 16),
                      Text('图片加载失败', style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _saveImage,
            tooltip: '保存图片',
          ),
        ],
      ),
    );
  }
}
