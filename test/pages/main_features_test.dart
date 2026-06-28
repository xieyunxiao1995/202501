import 'package:cpcloth/models/clothing_item.dart';
import 'package:cpcloth/pages/assistant/assistant_page.dart';
import 'package:cpcloth/pages/outfits/edit_outfit_page.dart';
import 'package:cpcloth/pages/settings/about_page.dart';
import 'package:cpcloth/pages/settings/feedback_page.dart';
import 'package:cpcloth/pages/settings/help_page.dart';
import 'package:cpcloth/pages/settings/privacy_policy_page.dart';
import 'package:cpcloth/pages/settings/settings_page.dart';
import 'package:cpcloth/pages/settings/user_agreement_page.dart';
import 'package:cpcloth/pages/wardrobe/edit_clothing_page.dart';
import 'package:cpcloth/pages/wardrobe/wardrobe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('wardrobe category filter hides unrelated items', (tester) async {
    final now = DateTime(2026, 6, 21);
    final items = [
      ClothingItem(
        id: 'top',
        imagePath: '',
        name: '蓝色衬衫',
        category: '上衣',
        color: '蓝色',
        season: '春秋',
        isPurchased: true,
        careNotes: '',
        createdAt: now,
      ),
      ClothingItem(
        id: 'pants',
        imagePath: '',
        name: '直筒长裤',
        category: '裤装',
        color: '黑色',
        season: '四季',
        isPurchased: true,
        careNotes: '',
        createdAt: now,
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: WardrobePage(
          items: items,
          onSave: (_) async {},
          onDelete: (_) async {},
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilterChip, '上衣'));
    await tester.pump();
    expect(find.text('蓝色衬衫'), findsOneWidget);
    expect(find.text('直筒长裤'), findsNothing);
  });

  testWidgets('assistant exposes shopping and care quick questions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AssistantPage(
          outfits: const [],
          clothingItems: const [],
          messages: const [],
          onMessagesChanged: (_) async {},
        ),
      ),
    );

    expect(find.text('今天穿什么？'), findsOneWidget);
    expect(find.text('衣橱缺什么？'), findsOneWidget);
    expect(find.text('衣服怎么养护？'), findsOneWidget);
  });

  testWidgets('edit forms reject missing required fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: EditOutfitPage(clothingItems: [])),
    );
    await tester.tap(find.widgetWithText(TextButton, '保存'));
    await tester.pump();
    expect(find.text('请给这套穿搭起个名字'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: EditClothingPage()));
    await tester.tap(find.widgetWithText(TextButton, '保存'));
    await tester.pump();
    expect(find.text('请填写单品名称'), findsOneWidget);
    expect(find.text('请填写主要颜色'), findsOneWidget);
  });

  testWidgets('all requested settings subpages are reachable', (tester) async {
    final destinations = <(String, Type)>[
      ('使用帮助', HelpPage),
      ('反馈与建议', FeedbackPage),
      ('关于我们', AboutPage),
      ('用户协议', UserAgreementPage),
      ('隐私协议', PrivacyPolicyPage),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage(
          outfitCount: 0,
          clothingCount: 0,
          onClearData: () async {},
        ),
      ),
    );

    for (final destination in destinations) {
      await tester.scrollUntilVisible(
        find.text(destination.$1),
        260,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(destination.$1));
      await tester.pumpAndSettle();
      expect(find.byType(destination.$2), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });
}
