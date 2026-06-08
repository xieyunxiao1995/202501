import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 邮件页
///
/// 邮件系统页面，展示邮件列表和邮件详情。
class MailPage extends ConsumerWidget {
  const MailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('邮件')),
      body: const Center(
        child: Text('邮件 - 待实现'),
      ),
    );
  }
}
