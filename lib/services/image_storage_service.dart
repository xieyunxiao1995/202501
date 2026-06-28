import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  Future<String> persistImage(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw const FileSystemException('选择的图片不存在');
    }

    final documents = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory(
      path.join(documents.path, 'cpcloth_images'),
    );
    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }

    final extension = path.extension(sourcePath).isEmpty
        ? '.jpg'
        : path.extension(sourcePath).toLowerCase();
    final fileName = 'image_${DateTime.now().microsecondsSinceEpoch}$extension';
    final destination = path.join(imageDirectory.path, fileName);
    await source.copy(destination);
    return destination;
  }

  Future<void> deleteImage(String imagePath) async {
    if (imagePath.isEmpty) return;
    final file = File(imagePath);
    if (await file.exists()) await file.delete();
  }

  Future<void> clearAllImages() async {
    final documents = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory(
      path.join(documents.path, 'cpcloth_images'),
    );
    if (await imageDirectory.exists()) {
      await imageDirectory.delete(recursive: true);
    }
  }
}
