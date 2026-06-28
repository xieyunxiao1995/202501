import 'package:cpcloth/app/app_theme.dart';
import 'package:cpcloth/pages/launch/consent_login_page.dart';
import 'package:cpcloth/pages/launch/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> render(WidgetTester tester, Widget child, String file) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: RepaintBoundary(key: const Key('preview'), child: child),
      ),
    );
    await tester.pumpAndSettle();
    final imageFinder = find.byType(Image).first;
    final image = tester.widget<Image>(imageFinder);
    await tester.runAsync(
      () => precacheImage(image.image, tester.element(imageFinder)),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('preview')),
      matchesGoldenFile('goldens/$file.png'),
    );
  }

  testWidgets('onboarding preview', (tester) async {
    await render(
      tester,
      OnboardingPage(onSkip: () {}, onFinished: () {}),
      'onboarding',
    );
  });

  testWidgets('consent login preview', (tester) async {
    await render(tester, ConsentLoginPage(onLogin: () {}), 'consent_login');
  });
}
