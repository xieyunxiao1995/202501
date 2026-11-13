# Settings information pages

All six destinations are implemented in separate Swift files and are included in the app target:

- About Us — `Tideverse/Features/Settings/AboutUsView.swift`
- User agreement — `Tideverse/Features/Settings/TermsOfUseView.swift`
- Privacy policy — `Tideverse/Features/Settings/PrivacyPolicyView.swift`
- Help — `Tideverse/Features/Settings/HelpView.swift`
- Feedback and suggestions — `Tideverse/Features/Settings/FeedbackSuggestionsView.swift`
- Developer information — `Tideverse/Features/Settings/DeveloperInformationView.swift`

Product copy describes actual authored content, local storage, optional AI, backup and report behavior. Removed user-facing scaffold/development wording from terms, privacy and developer information. Story prose using ordinary words such as “test” or “sample” remains intact; those describe fictional events and objects, not placeholder metadata.

Publisher name, support mailbox, policy URL and support URL remain configured through AppConfiguration/Info.plist. Missing identity/contact details are not replaced with invented people, companies or unowned domains. The developer page displays verified product information and only displays a publisher or external contact when configured. The Release metadata guard remains enabled. Legal review and actual publisher details are still required for distribution.

Verification: Debug simulator build passed. `Tools/verify_package.py` and mocked gateway integration passed. `testSettingsInformationPagesAndFeedback` passed (40.2 seconds), covering all six navigation destinations, EULA-related help search, feedback entry, share-button availability and clearing the draft. It did not send a message. Screenshots are in `Documentation/SettingsPages/`.

## Creative brand

At the user's request, the app adopts the newly coined creative brand **Bluehour Storyworks**. `TIDEVERSE_STUDIO_NAME` supplies the visible studio attribution in About Us and Developer Information. It is a creative identity, not a claim of a registered legal entity. No company registration, address, unowned domain or fabricated support mailbox has been added. Verified publisher/contact fields and the Release guard remain separate.
