# App Store Release Checklist · HomeMeasure

This project is **not guaranteed to pass App Review**, and no one can guarantee a review outcome. It is designed to minimize predictable issues, but it must be finalized and run on a Mac using Xcode before submission.

## Publisher-owned information (must be real)

- [ ] Confirm your Apple Developer membership, legal seller name and tax/banking requirements as applicable.
- [ ] Verify rights to the app name **HomeMeasure**, creative brand **HomeMeasure Studio**, artwork, icons and screenshots. A currently listed iOS app called **Home Measure** exists; check naming availability and differentiation with the actual publisher before launch.
- [ ] Replace `com.homemeasure.studio` and the test target bundle ID with identifiers owned and available to your team. Configure signing.
- [ ] Create a publicly accessible privacy policy page under a domain or hosting account you control, with real publisher identification and accurate data handling disclosures. Set its working URL in App Store Connect.
- [ ] Host a legitimate support page with an actual monitored email or contact method. Set the working Support URL in App Store Connect. **Do not invent an address**.
- [ ] Have your legal/policy advisor review in-app Terms and Privacy Policy to ensure they correspond to the actual publisher and jurisdiction.
- [ ] Check all marketing metadata, copyright notice and support contact are accurate and don't reference features that aren't in the app.

## Review preparation

- [ ] Install with Xcode 16+ on an iPhone/iOS 17+ and a current iOS simulator; run tests and a Release build.
- [ ] Test create/edit/delete projects, doors/windows, floor/tile/paint calculations, overrides, shopping statuses, JSON and PDF on-device.
- [ ] Import invalid JSON, empty libraries, oversized backups; verify alerts and no data loss.
- [ ] Test long names, large lists (multi-page PDF), phone accessibility settings, VoiceOver and portrait layouts.
- [ ] Test photos from the PhotosPicker and cleanup after deletion; verify no full photo library permission is requested.
- [ ] Test with Airplane Mode enabled; core functionality should work.
- [ ] Answer App Privacy questions for the FINAL binary. As delivered it has no remote data collection/advertising/tracking, but validate any last-minute integrations.
- [ ] Verify generated privacy manifest and any required reason API declarations against final code and dependencies.
- [ ] Check App Store Connect app version, iPhone screenshots, descriptions, keywords, age rating and support URLs.
- [ ] Submit a concise review note: "Offline home renovation planning with local SwiftData storage, optional system-selected room photos, manual material estimates, local JSON export/import and PDF reports. No account or internet service is required."
- [ ] Archive and submit from Xcode; respond to reviewer feedback if needed.

## Data and export caveats to disclose

- Uses user-entered prices, coverage and local tax values; not supplier quotations.
- Rectangular rooms and metric units only.
- User-chosen JSON backups **do not include room images**; this is explained in Help.
- The in-app Feedback screen provides system sharing/copy rather than transmitting to a dedicated support backend.
- The default app is iPhone and portrait only; not an iPad-specific landscape interface.

Official requirements (verify again when releasing):

- https://developer.apple.com/app-store/review/guidelines/
- https://developer.apple.com/app-store/app-privacy-details/
- https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy
