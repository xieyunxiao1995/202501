import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  Future<File?> captureFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) return null;

      return await _saveImageToLocal(File(image.path));
    } catch (e) {
      throw ImageServiceException('Failed to capture image from camera: $e');
    }
  }

  Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) return null;

      return await _saveImageToLocal(File(image.path));
    } catch (e) {
      throw ImageServiceException('Failed to pick image from gallery: $e');
    }
  }

  Future<List<File>> pickMultipleFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      final List<File> savedImages = [];
      for (final image in images) {
        final saved = await _saveImageToLocal(File(image.path));
        savedImages.add(saved);
      }

      return savedImages;
    } catch (e) {
      throw ImageServiceException('Failed to pick images from gallery: $e');
    }
  }

  Future<File> _saveImageToLocal(File sourceFile) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'repair_${_uuid.v4()}.jpg';

      // Create app-specific directory if it doesn't exist
      final Directory imagesDir = Directory('${appDir.path}/repair_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final File newFile =
          await sourceFile.copy('${imagesDir.path}/$fileName');
      return newFile;
    } catch (e) {
      throw ImageServiceException('Failed to save image locally: $e');
    }
  }

  Future<bool> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      throw ImageServiceException('Failed to delete image: $e');
    }
  }

  Future<bool> imageExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<void> clearAllImages() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imagesDir = Directory('${appDir.path}/repair_images');

      if (await imagesDir.exists()) {
        await imagesDir.delete(recursive: true);
      }
    } catch (e) {
      throw ImageServiceException('Failed to clear images: $e');
    }
  }
}

class ImageServiceException implements Exception {
  final String message;

  ImageServiceException(this.message);

  @override
  String toString() => 'ImageServiceException: $message';
}