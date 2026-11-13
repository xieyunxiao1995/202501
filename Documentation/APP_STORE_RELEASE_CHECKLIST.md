# Pre-release review checklist - Tideverse

This is an implementation checklist, not a promise of App Store acceptance.

## Must pass before submission

- [ ] Xcode 16+ `Product > Build` succeeds for current iPhone Simulator and physical iPhone.
- [ ] All XCTest tests pass; no crashes on launch or SwiftData migration.
- [ ] Exactly four tabs work in portrait mode: Discover, Chats, Journeys, Settings.
- [ ] All 40 portraits, avatars and scenes appear without missing image assets; image alt/accessibility labels are reasonable.
- [ ] All 328 authored chapters offer two distinct choices. Save a choice, force quit, relaunch, confirm that progress and Story Moment are retained.
- [ ] Verify optional online chat with current Ark account and real HTTPS backend. Confirm text/photo requests and authenticated, rate-limited, daily capped model usage.
- [ ] Remove the exposed Ark key from the provider and rotate it; scan git history, IPA, Info.plist, build output and config for embedded secrets.
- [ ] Confirm cloud consent is off by default; refusing it never calls `/v1/chat`. Deleting memories and messages really removes them locally.
- [ ] Verify local photo metadata removal and Vision OCR on several images.
- [ ] JSON export/import round trip works and archive contains no secrets. Delete All Local Data works, including attached images.
- [ ] PDFKit preview and FileExporter PDF save work on device.
- [ ] User-visible Terms, Privacy Policy, Support and Developer Information contain **verified actual publisher details**, real contact/URL, policy effective date and legally reviewed wording.
- [ ] Feedback/reporting has a **real supported delivery destination and response workflow**, not only the system share sheet.
- [ ] Configure server-side client attestation or equivalent, layered rate limits, spend caps, content moderation and abuse escalation for paid-model access.
- [ ] Disclose third-party model service, region and cross-border transfer rules accurately for jurisdictions where offered. Check current App Store privacy label and applicable data rules.
- [ ] Confirm the product name and all names/artwork are sufficiently original and commercially usable; confirm no misleading live/online indicators for fictional people.
- [ ] Review Apple App Review Guidelines 4.3 and 1.2, account deletion if accounts are added later, App Tracking Transparency if applicable, and in-app purchases if monetization is added.
- [ ] Test VoiceOver, Dynamic Type, Reduce Motion, dark appearance, keyboard, offline mode, landscape enforcement, Voice Control and reduced network conditions.
- [ ] Screenshots and preview video come from the **actual build**, not AI-generated concept art or fake device screenshots.

## Reference URLs

- https://developer.apple.com/app-store/review/guidelines/
- https://docs.volcengine.com/docs/ark/model-list?lang=zh
- https://docs.volcengine.com/docs/ark/create-model-responses-api?lang=zh

## Additional Midnight Blue / adult art release check

- [ ] Confirm all 40 character art files in the installed iOS app look cartoon-styled, modest, and explicitly adult; no underage personas.
- [ ] Verify Discover, Chats, Journeys, onboarding, Settings and all child pages remain dark with the device in both system appearance modes.
- [ ] Manually test `UIImage(named:)` for all 120 images in the iOS application target.
- [ ] Verify optional AI model content safety and real reporting/moderation flows; prompt text alone is insufficient.
