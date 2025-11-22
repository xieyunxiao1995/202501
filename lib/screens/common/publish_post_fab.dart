import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zhenyu_flutter/screens/post/publish_post_screen.dart';

class PublishPostFab extends StatelessWidget {
  const PublishPostFab({super.key, this.onReturn});

  final Future<void> Function()? onReturn;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30.h,
      right: 30.w,
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const PublishPostScreen()));
          if (onReturn != null) {
            await onReturn!();
          }
        },
        child: Image.asset(
          'assets/images/publish_post.png',
          width: 100.w,
          height: 100.h,
        ),
      ),
    );
  }
}
