import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:zhenyu_flutter/utils/http.dart'; // 确保您的http工具路径正确
import 'package:zhenyu_flutter/models/upload_api_model.dart';

class UploadApi {
  // 1. 获取上传策略/预签名
  static Future<UploadPolicy?> _getUploadPolicy(String extension) async {
    try {
      final response = await Http.post(
        '/file/policy',
        data: {'ext': extension},
      );
      if (response.data['code'] == 0 && response.data['data'] != null) {
        return UploadPolicy.fromJson(response.data['data']);
      }
      print('获取上传策略失败: ${response.data['message']}');
      return null;
    } catch (e) {
      print('获取上传策略异常: $e');
      return null;
    }
  }

  // URL编码
  static String _camSafeUrlEncode(String str) {
    return Uri.encodeComponent(str)
        .replaceAll('!', '%21')
        .replaceAll('\'', '%27')
        .replaceAll('(', '%28')
        .replaceAll(')', '%29')
        .replaceAll('*', '%2A');
  }

  // 压缩图片并返回File对象
  static Future<File?> _compressImage(XFile imageFile) async {
    final file = File(imageFile.path);
    final size = await file.length();

    int quality = 70;
    if (size > 30 * 1024 * 1024) {
      // 30MB
      quality = 40;
    } else if (size > 10 * 1024 * 1024) {
      // 10MB
      quality = 50;
    }

    if (size < 1 * 1024 * 1024) {
      // 小于1MB不压缩
      return file;
    }

    final tempDir = await getTemporaryDirectory();
    final targetPath = p.join(
      tempDir.path,
      "${DateTime.now().millisecondsSinceEpoch}_compressed.jpg",
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      quality: quality,
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }

  // 2. 核心上传方法
  static Future<String?> uploadImage(XFile imageFile) async {
    // 压缩图片
    final compressedFile = await _compressImage(imageFile);
    if (compressedFile == null) {
      print('图片压缩失败');
      return null;
    }

    final extension = p.extension(compressedFile.path).replaceAll('.', '');

    // 获取上传策略
    final policy = await _getUploadPolicy(extension);
    if (policy == null) {
      return null;
    }

    // 准备上传
    final uploadUrl = 'https://${policy.cosHost}';
    final formData = FormData.fromMap({
      'key': policy.cosKey,
      'policy': policy.policy,
      'success_action_status': 200,
      'q-sign-algorithm': policy.qsignAlgorithm,
      'q-ak': policy.qak,
      'q-key-time': policy.qkeyTime,
      'q-signature': policy.qsignature,
      'file': await MultipartFile.fromFile(
        compressedFile.path,
        filename: p.basename(compressedFile.path),
      ),
    });

    try {
      final dio = Dio();
      final response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        final fileUrl =
            '$uploadUrl/${_camSafeUrlEncode(policy.cosKey).replaceAll('%2F', '/')}';
        return fileUrl;
      } else {
        print('上传失败，状态码: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('上传异常: $e');
      return null;
    }
  }

  // 3. 封装从图库选择并上传的完整流程
  static Future<String?> pickAndUploadImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      // 这里可以加入一个显示加载中的UI提示
      final String? url = await uploadImage(image);
      // 这里可以关闭加载中的UI提示
      return url;
    }
    return null;
  }

  // 4. 上传视频文件（不压缩）
  static Future<String?> uploadVideo(XFile videoFile) async {
    final file = File(videoFile.path);
    final extension = p.extension(videoFile.name).replaceAll('.', '');

    // 获取上传策略
    final policy = await _getUploadPolicy(extension);
    if (policy == null) {
      return null;
    }

    // 准备上传
    return _uploadFileToCOS(file, policy);
  }

  // 5. 上传裁剪后的图片或其他预处理过的文件（不压缩）
  static Future<String?> uploadRawFile(File file) async {
    final extension = p.extension(file.path).replaceAll('.', '');

    // 获取上传策略
    final policy = await _getUploadPolicy(extension);
    if (policy == null) {
      return null;
    }

    // 准备上传
    return _uploadFileToCOS(file, policy);
  }

  // 内部通用的上传执行方法
  static Future<String?> _uploadFileToCOS(
    File file,
    UploadPolicy policy,
  ) async {
    final uploadUrl = 'https://${policy.cosHost}';
    final formData = FormData.fromMap({
      'key': policy.cosKey,
      'policy': policy.policy,
      'success_action_status': 200,
      'q-sign-algorithm': policy.qsignAlgorithm,
      'q-ak': policy.qak,
      'q-key-time': policy.qkeyTime,
      'q-signature': policy.qsignature,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: p.basename(file.path),
      ),
    });

    try {
      final dio = Dio();
      final response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        final fileUrl =
            '$uploadUrl/${_camSafeUrlEncode(policy.cosKey).replaceAll('%2F', '/')}';
        return fileUrl;
      } else {
        print('上传失败，状态码: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('上传异常: $e');
      return null;
    }
  }
}
