import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanguogame/pages/activity/activity_pages.dart';

void main() {
  testWidgets('activity pages render their primary titles', (tester) async {
    const pages = <Widget>[
      DailyActivityPage(),
      DailySignInPage(),
      LimitedGiftPage(),
      WorldRecruitEventPage(),
    ];
    const titles = ['日常活跃', '每日签到', '限时大礼包', '通关世界童节'];

    for (var i = 0; i < pages.length; i++) {
      await tester.pumpWidget(MaterialApp(home: pages[i]));
      expect(find.text(titles[i]), findsWidgets);
    }
  });
}
