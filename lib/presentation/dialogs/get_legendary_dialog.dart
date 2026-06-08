import 'package:flutter/material.dart';

/// 获得传说武将弹窗
///
/// 获得传说（5星）武将时的全屏特效展示弹窗。
class GetLegendaryDialog {
  /// 显示获得传说武将弹窗
  static Future<void> show({
    required BuildContext context,
    required String generalName,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade900, Colors.deepOrange.shade900],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '传说降临',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Icon(Icons.stars, size: 80, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                generalName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确认'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
