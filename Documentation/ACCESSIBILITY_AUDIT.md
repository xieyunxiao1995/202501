# Main-tab accessibility audit — 2026-11-11

System XCTest performAccessibilityAudit was run on Discover, Chats, Journeys and Settings at the simulator's default text size. It reports 40 issues across contrast, partially unsupported Dynamic Type sizes and clipped text. This audit is **not passing**. Some reported elements already use semantic SwiftUI fonts and high-contrast tokens, so inspect each finding against its captured element rather than assuming either a false positive or a confirmed visual failure.

Changed:
- Replaced system search bars (whose prompt tint was ignored) with a shared SwiftUI text field.
- Added explicit prompt/text color, semantic font, a 44-point clear action, keyboard search submission and focus handling.
- Shortened search prompts to avoid excessive placeholder length.
- Added a functional search/no-result/clear recovery test, which passed before the final shortened-prompt build.

Evidence:
- Result bundle: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_10-55-46-+0800.xcresult
- Exported issue descriptions, element screenshots and main-tab captures: /tmp/tideverse-audit-attachments
- Inspected Discover capture: search prompt is visible against the midnight-blue field.
- Failure diagnostics collection hung after tests finished; its simctl diagnose subprocesses were terminated to let Xcode finalize the existing result bundles. The actual test failures remain recorded.
- Functional regression is run separately with this known failing audit explicitly excluded. That does not establish accessibility compliance.

Still required: resolve the audit findings, validate all text sizes and inspect VoiceOver/Voice Control/Reduce Motion on a device. Real publisher, production service, support operations and signing also remain outstanding.

Final functional regression: 19 unit tests and 6 UI tests passed with the known failing accessibility audit explicitly excluded. Covers story relaunch, full ending, chat story choice, accessibility text-size library, discovery filters and search recovery. This is not a passing accessibility audit.

## Follow-up refinement

The next audit reports 35 issues (12 contrast, 20 partially unsupported Dynamic Type, 3 clipping), down from 40 but still failing. Increased muted text from #9EB3D1 to #B2C6E0, used explicit muted colors in Settings, allowed the consent label to wrap, and hid the decorative Settings avatar from accessibility. Search now supports multiple lines, semantic body font and interactive keyboard dismissal.

Updated audit evidence: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_11-04-53-+0800.xcresult; exported attachments in /tmp/tideverse-audit-refine-attachments. No findings were suppressed.

Search follow-up runtime evidence:
- At accessibility XXXL, the safe-area-inset search field had a visible clear button that was not hittable. Moving the shared field into a VStack sibling above the scrolling content fixed the actual tap path.
- Added an explicit Done action while editing and stable clear-button accessibility identifier.
- Final run: 19 unit tests + 3 UI tests passed (maximum-size long search/clear, normal search recovery, maximum-size library).
- Captured and inspected the maximum-size search view. Result bundle: /tmp/tideverse-review-build/Logs/Test/Test-Tideverse-2026.11.11_11-14-36-+0800.xcresult.
- The 35-issue audit precedes this final layout change; it must be rerun before claiming any further reduction.

Latest main-tab audit after search-layout changes: 37 reports (13 contrast, 21 Dynamic Type, 3 clipping), still failing. See SEARCH_RESULTS_REFINEMENT.md for current runtime evidence.

Detailed audit logging now preserves page, audit type, exact accessible label and element frame while returning false for every issue (no suppression). Example: the reported Cinema element begins at x=356.7 and extends beyond the horizontal viewport; the Saved characters label is below the initial viewport. These observations alone do not waive either finding. Nominal solid-surface token contrast for muted #B2C6E0 is 8.08:1 or higher on canvas/card/soft; accent #429EFF is 5.08:1 or higher. These ratios do not cover image backdrops, opacity or system surfaces.

## Scope update from user

The user asked to prioritize normal text-size display and stop investigating unreliable maximum-size heading lookup. The experimental heading-comparison UI test was removed. Existing adaptive layout and stable accessibility behavior are retained. This scope decision does not certify or silently clear the system audit findings.
