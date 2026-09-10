import 'dart:io';
import 'package:flutter/material.dart';
import '../../DaZitheme/app_text_styles.dart';

class PhotoFullscreenScreen extends StatefulWidget {
  const PhotoFullscreenScreen({super.key});

  @override
  State<PhotoFullscreenScreen> createState() => _PhotoFullscreenScreenState();
}

class _PhotoFullscreenScreenState extends State<PhotoFullscreenScreen> {
  String? _photoPath;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _photoPath = ModalRoute.of(context)?.settings.arguments as String?;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: _photoPath != null
              ? InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.file(
                    File(_photoPath!),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white54,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Image not available',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white54,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No image provided',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
