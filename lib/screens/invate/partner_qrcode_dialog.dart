import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/theme.dart';

/// 显示合伙人二维码弹窗
void showPartnerQRCodeDialog(BuildContext context, String? qrCodeUrl) {
  if (qrCodeUrl == null || qrCodeUrl.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('暂无合伙人二维码')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 320,
        height: 350,
        child: Stack(
          children: [
            // 背景图片
            Positioned.fill(
              child: Image.asset(
                'assets/images/invate/bg.png',
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.secondaryGradientStart,
                          AppColors.secondaryGradientEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                },
              ),
            ),
            // 顶部标题
            const Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '联系我们，了解更多',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // 二维码（居中）
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  qrCodeUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.qr_code,
                        size: 80,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            // 底部标题
            const Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '微信扫一扫添加好友',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // 关闭按钮
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
