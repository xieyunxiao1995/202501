import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 账号页
///
/// 账号管理页面，包括绑定手机、修改密码和切换账号。
class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('账号')),
      body: const Center(
        child: Text('账号管理 - 待实现'),
      ),
    );
  }
}
