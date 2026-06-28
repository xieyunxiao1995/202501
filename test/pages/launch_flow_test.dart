import 'package:cpcloth/app/app.dart';
import 'package:cpcloth/pages/launch/consent_login_page.dart';
import 'package:cpcloth/pages/launch/eula_page.dart';
import 'package:cpcloth/pages/launch/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('app starts with onboarding on every fresh mount', (
    tester,
  ) async {
    await tester.pumpWidget(const CpClothApp());

    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.text('把穿搭，写成生活的注脚'), findsOneWidget);
    expect(find.text('穿搭'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const CpClothApp());

    expect(find.text('把穿搭，写成生活的注脚'), findsOneWidget);
  });

  testWidgets('skip opens the no-credentials consent login page', (
    tester,
  ) async {
    await tester.pumpWidget(const CpClothApp());
    await tester.tap(find.text('跳过'));
    await tester.pumpAndSettle();

    expect(find.byType(ConsentLoginPage), findsOneWidget);
    expect(find.text('欢迎回来'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('next moves through all four onboarding slides', (tester) async {
    await tester.pumpWidget(const CpClothApp());

    await tester.tap(find.text('下一页'));
    await tester.pumpAndSettle();
    expect(find.text('看见衣橱真正的秩序'), findsOneWidget);

    await tester.tap(find.text('下一页'));
    await tester.pumpAndSettle();
    expect(find.text('少买一点，更会搭一点'), findsOneWidget);

    await tester.tap(find.text('下一页'));
    await tester.pumpAndSettle();
    expect(find.text('每一次选择，都更接近自己'), findsOneWidget);

    await tester.tap(find.text('开始使用'));
    await tester.pumpAndSettle();
    expect(find.byType(ConsentLoginPage), findsOneWidget);
  });

  testWidgets('EULA can be read without automatically granting consent', (
    tester,
  ) async {
    await tester.pumpWidget(const CpClothApp());
    await tester.tap(find.text('跳过'));
    await tester.pumpAndSettle();

    final loginButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '登录并进入'),
    );
    expect(loginButton.onPressed, isNull);

    await tester.tap(find.text('《最终用户许可协议》'));
    await tester.pumpAndSettle();
    expect(find.byType(EulaPage), findsOneWidget);
    expect(find.text('许可授权'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    final buttonAfterReading = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '登录并进入'),
    );
    expect(buttonAfterReading.onPressed, isNull);
  });

  testWidgets('explicit EULA consent enters the four-tab app shell', (
    tester,
  ) async {
    await tester.pumpWidget(const CpClothApp());
    await tester.tap(find.text('跳过'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.tap(find.text('登录并进入'));
    await tester.pumpAndSettle();

    expect(find.text('穿搭'), findsOneWidget);
    expect(find.text('衣橱'), findsOneWidget);
    expect(find.text('AI 助手'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });

  testWidgets('consent page remains usable with large accessibility text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 700),
            textScaler: TextScaler.linear(1.8),
          ),
          child: ConsentLoginPage(onLogin: () {}),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('登录并进入'), findsOneWidget);
  });
}
