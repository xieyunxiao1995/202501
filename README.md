# HomeMeasure · Native iPhone Renovation Planner

A complete **Swift + SwiftUI + SwiftData** Xcode source project for an English-language, portrait-only, local-first home renovation estimator and purchase planner. Includes a custom 1024×1024 app icon, App Store privacy manifest, a four-page first-run Welcome Tour, four-tab UI, five standalone settings pages, PDF output, photos, JSON backup, and XCTest cases.

## Open in Xcode

1. Unzip the archive on a Mac running **Xcode 16 or newer** with an iOS 17+ simulator installed.
2. Double-click **`HomeMeasure.xcodeproj`** and select the shared **HomeMeasure** scheme.
3. Choose an iPhone simulator, then **Product → Run** (`⌘R`).
4. To install on a personal iPhone, open **HomeMeasure target → Signing & Capabilities**, select your Apple Developer Team, replace the bundle identifier with one you control, and run on a connected iPhone.
5. Use **Product → Test** (`⌘U`) to execute `HomeMeasureTests`.
6. To archive for App Store Connect, set the appropriate bundle ID, legal seller details, support URL and privacy URL, then use **Product → Archive**.

The archive contains **source code and an Xcode project, not a compiled .ipa**. The project has no third-party packages and does not require an API key or network service. The generated Xcode project is checked into the ZIP. Its definition can be regenerated with `python3 Tools/generate_xcode_project.py` when Swift files are added.

## The product

| Tab | Purpose |
|---|---|
| Overview | Hero action, project/room/material counters, purchased count, recent projects, totals in USD only |
| Projects | Create, search, edit and delete projects; enter rooms and openings; add and edit materials; costs, photos and PDF |
| Shopping | Search material lines across all projects and mark them purchased |
| Settings | About Us, Terms of Use, Privacy Policy, Help & FAQ, Feedback & Suggestions; replayable Welcome Tour; JSON export/import; delete all |

On first launch the app opens a four-page Welcome Tour (measure → estimate → shop → start). It can be skipped, paged with Continue or a swipe, and replayed later from **Settings → Welcome Tour**. Completion is stored locally with `@AppStorage` and never leaves the device.

### Supported calculations

- Rectangular room: floor = length × width; ceiling = floor; gross walls = 2 × (length + width) × height.
- Net wall area = max(0, gross wall area − summed door/window openings).
- Baseboard = max(0, 2 × (length + width) − door widths). Window widths are not deducted.
- Tile, flooring, paint, wallpaper, baseboard and custom materials. Units: meter (m), square meter (m²), and manual unit quantities.
- Packages = ceil(measured quantity × coats × (1 + waste percentage/100) / usable coverage per package).
- Package count can be overridden. Item cost = whole packages × package price; project total = subtotal + tax + delivery.
- When switching a project's currency, prices are **not automatically converted**. Overview budget is explicitly limited to USD projects.
- Estimates are planning aids, not real supplier quotes or professional surveying.

## Implementation notes

- Database: one `@Model ProjectRecord` per project; its `ProjectContent` is JSON-encoded into a SwiftData external-storage `Data` field. Rooms and material lines are value objects updated atomically with the project. No server synchronization.
- Photos: PhotosPicker reads only selected photos, and ImageIO converts them to local JPEGs. Photo files do **not** travel with JSON backups. Remove-all deletes the photo directory; deleting a project deletes its linked photos.
- PDF: `UIGraphicsPDFRenderer` generates multi-page A4-style reports with tables, room summaries, estimated pricing and notes. `PDFKit` previews the result; `fileExporter` saves it.
- Backups: explicit export/import of JSON. Imports create separate projects, to avoid accidentally overwriting originals. The backup schema is versioned (`version: 1`).
- Feedback: draft text and let the user choose a recipient through the iOS share sheet, or copy it. **No automatic submission, no invented developer email or inbox.**
- Privacy: `PrivacyInfo.xcprivacy` declares no tracking and no off-device collection in this project as delivered, and covers the `UserDefaults` access used for Welcome Tour completion (`CA92.1`). Re-evaluate all declarations if you add SDKs or network features.
- Overview statistics, the Shopping list and project detail each build their derived values and estimates once per body evaluation instead of re-decoding per row.

## Important requirements before shipping

The **developer name displayed by Apple, legal seller identity, verified support email, functioning support website, publicly accessible privacy policy URL, final bundle ID, and App Store Connect metadata** belong to the actual publisher. They cannot be truthfully invented in a source package. `HomeMeasure Studio` is a product/creative brand, **not a claim of registered legal entity or domain ownership**. The included `Documentation/APP_STORE_RELEASE_CHECKLIST.md` explains every manual publishing step. Apple's approval is **not guaranteed**; submit only after testing on current devices and completing review information.

## File map

```
HomeMeasure.xcodeproj/
HomeMeasure/
  App/             # entry point and four-tab navigation
  Design/          # brand colors and reusable cards
  Models/          # SwiftData project + Codable value objects
  Services/        # math, local photo storage, backup and PDF
  Features/
    Onboarding/    # four-page Welcome Tour
    Overview/
    Projects/      # project/room/material/budget forms
    Shopping/
    Settings/      # 5 individual Swift pages + main settings page
  Assets.xcassets/ # official app icon PNG
  Resources/       # privacy manifest
HomeMeasureTests/ # estimation and backup unit tests
Documentation/    # full specification and release checklist
Branding/         # exportable 1024px icon
Tools/            # deterministic project generator
```

## Build verification provided with this package

Verified with Xcode 27.0 against the iOS 27 simulator (iPhone 18 Pro): the app target builds without warnings, and all 13 unit tests pass (`xcodebuild test`). The Welcome Tour, Overview, Projects, Shopping and Settings screens were installed and viewed in the simulator, including the tour at the largest accessibility text size. Room, material, budget, PDF and backup flows remain covered by unit tests and manual review; complete an interactive pass on a physical device before shipping.
