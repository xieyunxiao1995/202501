# CPDD小屋 Onboarding and EULA Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a four-screen editorial onboarding carousel and a no-credentials EULA consent login gate before the existing iOS app shell.

**Architecture:** Keep launch state in memory inside `LaunchFlowPage`, with callback-driven transitions from onboarding to consent login to the existing `ShellPage`. Use separate widgets for slides, login, and EULA, and do not persist completion or consent.

**Tech Stack:** Flutter/Dart, Material 3, `PageView`, `setState`, existing CPDD小屋 theme and generated PNG assets.

---

### Task 1: Add launch-flow behavior tests

**Files:**
- Create: `test/pages/launch_flow_test.dart`

**Steps:**
1. Write tests for initial onboarding, skip, disabled login, EULA navigation, consent, and returning to the four-tab shell.
2. Run `flutter test --no-pub test/pages/launch_flow_test.dart`.
3. Confirm tests fail because launch pages do not exist.

### Task 2: Generate and register onboarding illustrations

**Files:**
- Create: `assets/images/onboarding/journal.png`
- Create: `assets/images/onboarding/wardrobe.png`
- Create: `assets/images/onboarding/assistant.png`
- Create: `assets/images/onboarding/identity.png`

**Steps:**
1. Generate four text-free illustrations in the approved fashion-editorial style.
2. Inspect composition, palette, absence of text, and mobile readability.
3. Copy and optimize final assets into the project.
4. Verify Flutter resolves the already registered `assets/images/` tree.

### Task 3: Implement the onboarding carousel

**Files:**
- Create: `lib/pages/launch/onboarding_slide.dart`
- Create: `lib/pages/launch/onboarding_page.dart`

**Steps:**
1. Implement the immutable slide specification.
2. Implement four `PageView` slides, skip, next, final continue, and animated indicators.
3. Add scroll fallback for Dynamic Type and semantics for accessibility.
4. Run the focused launch-flow tests.

### Task 4: Implement EULA login and document pages

**Files:**
- Create: `lib/pages/launch/consent_login_page.dart`
- Create: `lib/pages/launch/eula_page.dart`

**Steps:**
1. Implement the standalone EULA document page with all approved sections.
2. Implement the login page with a user-controlled checkbox and disabled/enabled button states.
3. Ensure returning from EULA does not automatically grant consent.
4. Run focused tests.

### Task 5: Integrate launch flow into the app

**Files:**
- Create: `lib/pages/launch/launch_flow_page.dart`
- Modify: `lib/app/app.dart`
- Modify: `test/app_smoke_test.dart`

**Steps:**
1. Implement in-memory onboarding/login/app transitions.
2. Replace the root `ShellPage` with `LaunchFlowPage`.
3. Update the smoke test to complete onboarding consent before asserting the four tabs.
4. Verify recreating the root widget starts from onboarding again.

### Task 6: Visual review and full verification

**Files:**
- Create or update: `test/goldens/onboarding.png`
- Create or update: `test/goldens/consent_login.png`
- Modify: files required by review findings

**Steps:**
1. Render onboarding and login on a 390×844 iPhone viewport and inspect the snapshots.
2. Run `dart format --output=none --set-exit-if-changed lib test`.
3. Run `flutter analyze --no-pub`.
4. Run `flutter test --no-pub`.
5. Run `flutter build ios --simulator --no-pub`.
6. Scan production code for TODOs, placeholders, and dead launch paths.

> Note: this workspace is not a Git repository, so worktree creation and per-task commits are not available.
