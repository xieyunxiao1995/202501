# CPDD小屋 iOS App Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a polished iOS-only Flutter app for outfit journaling, wardrobe management, and contextual DeepSeek shopping assistance.

**Architecture:** Use a lightweight feature-first structure with handwritten models, `setState` for UI state, and service classes for preferences, local image persistence, and DeepSeek requests. Keep the application local-first and pass wardrobe/outfit summaries to the AI as text only.

**Tech Stack:** Flutter/Dart, Material 3 with iOS conventions, shared_preferences, image_picker, path_provider, http, url_launcher, Flutter tests.

---

### Task 1: Configure dependencies, theme, and application shell

**Files:**
- Modify: `pubspec.yaml`
- Replace: `lib/main.dart`
- Create: `lib/app/app.dart`
- Create: `lib/app/app_theme.dart`
- Create: `lib/pages/shell_page.dart`
- Test: `test/app_smoke_test.dart`

**Steps:**
1. Write a smoke test expecting four bottom navigation destinations.
2. Run `flutter test test/app_smoke_test.dart` and verify it fails.
3. Add dependencies and the root theme/shell with four destinations.
4. Run the test and verify it passes.

### Task 2: Implement handwritten models and preference storage

**Files:**
- Create: `lib/models/outfit_entry.dart`
- Create: `lib/models/clothing_item.dart`
- Create: `lib/models/chat_message.dart`
- Create: `lib/services/local_storage_service.dart`
- Test: `test/models/model_serialization_test.dart`
- Test: `test/services/local_storage_service_test.dart`

**Steps:**
1. Write failing JSON round-trip and storage tests.
2. Run the focused tests and confirm failure.
3. Implement handwritten `toJson`, `fromJson`, `copyWith`, and preferences storage.
4. Run focused tests and confirm success.

### Task 3: Generate and register original visual assets

**Files:**
- Create: `assets/images/outfit_empty.png`
- Create: `assets/images/wardrobe_empty.png`
- Create: `assets/images/ai_assistant_header.png`
- Create: `assets/images/app_about.png`
- Modify: `pubspec.yaml`

**Steps:**
1. Generate each raster asset using the approved blue/pink fashion-editorial direction.
2. Inspect every output for palette, composition, lack of text, and UI suitability.
3. Copy selected assets into `assets/images/` and register the directory.
4. Run `flutter pub get` and verify asset resolution.

### Task 4: Build image persistence and reusable UI components

**Files:**
- Create: `lib/services/image_storage_service.dart`
- Create: `lib/widgets/ambient_background.dart`
- Create: `lib/widgets/empty_state.dart`
- Create: `lib/widgets/image_card.dart`
- Create: `lib/widgets/section_header.dart`
- Test: `test/widgets/empty_state_test.dart`

**Steps:**
1. Write the empty-state widget test.
2. Implement application-document image copying and resilient image widgets.
3. Add reusable atmospheric background and section components.
4. Run focused widget tests.

### Task 5: Build outfit journal CRUD

**Files:**
- Create: `lib/pages/outfits/outfits_page.dart`
- Create: `lib/pages/outfits/edit_outfit_page.dart`
- Create: `lib/pages/outfits/outfit_detail_page.dart`
- Test: `test/pages/outfits_page_test.dart`

**Steps:**
1. Write tests for empty state, two-column grid, and add action.
2. Implement the journal header, filters, cards, detail, edit, and delete flows.
3. Connect gallery selection and local persistence callbacks.
4. Run focused tests.

### Task 6: Build wardrobe CRUD and filtering

**Files:**
- Create: `lib/pages/wardrobe/wardrobe_page.dart`
- Create: `lib/pages/wardrobe/edit_clothing_page.dart`
- Create: `lib/pages/wardrobe/clothing_detail_page.dart`
- Test: `test/pages/wardrobe_page_test.dart`

**Steps:**
1. Write tests for category chips and filtering.
2. Implement the two-column wardrobe, filters, detail, edit, and delete flows.
3. Connect gallery selection and local persistence callbacks.
4. Run focused tests.

### Task 7: Implement DeepSeek contextual assistant

**Files:**
- Create: `lib/config/deepseek_config.dart`
- Create: `lib/services/deepseek_service.dart`
- Create: `lib/pages/assistant/assistant_page.dart`
- Test: `test/services/deepseek_service_test.dart`
- Test: `test/pages/assistant_page_test.dart`

**Steps:**
1. Write tests for system prompt context, shopping rules, and quick prompts.
2. Implement the API config and injectable HTTP service.
3. Build chat bubbles, quick questions, loading/error/retry states, and auto-scroll.
4. Ensure taps outside the input dismiss the keyboard.
5. Run focused tests.

### Task 8: Build settings and independent information pages

**Files:**
- Create: `lib/pages/settings/settings_page.dart`
- Create: `lib/pages/settings/about_page.dart`
- Create: `lib/pages/settings/user_agreement_page.dart`
- Create: `lib/pages/settings/privacy_policy_page.dart`
- Create: `lib/pages/settings/help_page.dart`
- Create: `lib/pages/settings/feedback_page.dart`
- Create: `lib/widgets/legal_document_page.dart`
- Test: `test/pages/settings_page_test.dart`

**Steps:**
1. Write navigation tests for every settings destination.
2. Implement data statistics and destructive clear confirmation.
3. Implement each requested destination in its own Dart file.
4. Implement feedback mail launch with clipboard fallback.
5. Run focused tests.

### Task 9: Configure iOS permissions and integration polish

**Files:**
- Modify: `ios/Runner/Info.plist`
- Modify: `lib/pages/shell_page.dart`
- Modify: affected UI files

**Steps:**
1. Add the iOS photo-library usage description.
2. Load persisted data during shell initialization.
3. Verify keyboard dismissal across all input screens.
4. Check safe areas, Dynamic Type, dark text contrast, and 44pt tap targets.

### Task 10: Full verification

**Files:**
- Modify: any files required by verification findings

**Steps:**
1. Run `dart format lib test`.
2. Run `flutter analyze` and resolve all findings.
3. Run `flutter test` and resolve all failures.
4. Run `flutter build ios --simulator` and resolve build failures.
5. Compare the finished app against every item in the approved design document.

> Note: the workspace is not a Git repository, so the plan's normal per-task commits cannot be performed unless Git is initialized by the user.
