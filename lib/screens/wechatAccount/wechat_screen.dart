import 'package:flutter/material.dart';

class WechatScreen extends StatelessWidget {
  const WechatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Image.asset(
          'assets/images/wxPublic.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 116),
                  const Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '加载失败',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
