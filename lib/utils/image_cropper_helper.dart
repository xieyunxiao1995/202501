import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// 图片裁剪工具，统一头像裁剪配置
class ImageCropperHelper {
  /// 选择图片并裁剪为 1:1，返回裁剪后的 `File`
  static Future<File?> pickAndCropAvatar({
    ImageSource source = ImageSource.gallery,
  }) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source);
    if (picked == null) return null;

    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '裁剪头像',
          toolbarWidgetColor: Colors.white,
          toolbarColor: Colors.black,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: '裁剪头像',
          aspectRatioLockEnabled: true,
          doneButtonTitle: '完成',
          cancelButtonTitle: '取消',
          aspectRatioPickerButtonHidden: true,
          resetButtonHidden: true,
        ),
      ],
    );

    if (cropped == null) return null;
    return File(cropped.path);
  }
}
