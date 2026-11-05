# App Store 提审资料（English store copy）

> 下列文案可直接粘贴到 App Store Connect。带 `<...>` 的内容必须替换为提交者的真实信息后再送审。App 内 `AppInfo.swift` 的品牌信息（当前为 Independent Developer / support@example.com 中性占位值）也必须同步替换，不能携带占位值送审。

## App Information

- **Name（30 字符内）**: SunShadowPad
- **Subtitle（30 字符内）**: Sun & Shadow Planning
- **Primary category**: Productivity
- **Secondary category**: Utilities
- **Age rating**: 4+
- **Price**: Free（无内购、无广告）
- **Support URL**: `<https://your-domain.example/support>`
- **Privacy Policy URL**: `<https://your-domain.example/privacy>`
- **Copyright**: `<2026 Your Legal Name>`
- **Bundle ID**: `<com.yourcompany.sunshadowpad>`

## Promotional Text（170 字符内）

Plan planting, patios and photo sessions in an interactive 3D sun and shadow model. Works offline, keeps projects on your iPhone, and exports PDF and PNG plans.

## Description

SunShadowPad is a visual planning aid for gardeners, photographers and outdoor space designers. Model your site in an interactive 3D scene: place buildings, walls, trees, fences and canopies, orbit and pinch to inspect them, and drag objects to rearrange the layout. Watch real-time shadows sweep across your site as the day advances, then switch to the 2D plan view whenever you need exact dimensions.

KEY FEATURES

• Interactive 3D model of your site: orbit, pinch to zoom and drag objects into place.
• 2D plan view for precise dimension work, with the same scene and true-north setting.
• Metric dimensions and a true-north setting that is independent of canvas orientation.
• Obstacle library: building, wall, column, tree, fence, solid canopy and custom rectangle.
• Observation points and planting areas with your own minimum-sunlight targets.
• Shadow simulator with a local-time slider, playback speeds and 5, 15 or 30-minute steps.
• Jump straight to sunrise, solar noon or sunset.
• Sunlight timeline with direct-sun blocks, blocked periods, first and last exposure, the longest sunny period and target achievement.
• Spatial heatmap of theoretical direct-sun hours.
• Date-to-date comparison, a monthly representative-day trend, and equinox/solstice season comparison.
• Side-by-side layout comparison for two saved versions of the same site.
• Export a PDF planning report, a PNG scene image or a portable JSON project.

PRIVACY

No account, no sign-in, no location access and no analytics. Your projects stay on your device until you choose to export them.

ACCURACY

Sun positions use published NOAA approximation formulas. Shadows assume level ground and opaque obstacles; canopies and tree crowns are projected as opaque shapes. Results are theoretical estimates for early-stage planning, not survey measurements or engineering certification.

## Keywords（100 字符内，逗号分隔）

sun,shadow,garden,planning,solar,simulator,sunlight,landscape,photography,patio,heatmap,offline

## What's New（1.0）

First release.

## App Privacy（问卷建议答案）

- **Data Collection**: No, we do not collect data from this app.
- 不访问定位、通讯录、照片（导出经系统分享面板，App 本身不读取照片库）。
- 不包含第三方 SDK、广告或分析。
- 网络：无。用户点击邮件反馈时才离开 App 进入系统邮件客户端。
- 随包提供 `SunShadowPad/Resources/PrivacyInfo.xcprivacy`：不跟踪、无收集数据类型，仅声明本地 `UserDefaults` 访问理由 `CA92.1`。App Privacy 问卷答案必须与此清单保持一致。

> 以实际构建为准。若后续加入统计或云端功能，必须重新申报。

## Review Notes（审核备注）

SunShadowPad is fully offline and has no account system. All four tabs are reachable without setup:
1. Scenes contains three editable sample projects.
2. Shadow Simulator renders the site as an interactive 3D scene (drag to orbit, pinch to zoom) or as a 2D plan, and shows shadows for the selected date and time.
3. Timeline shows sunlight analysis and, after duplicating a scene, a layout comparison.
4. Settings contains About Us, User Agreement, Privacy Policy, Use Help and Feedback.

In the Scene Editor the same scene is shown in 3D, where objects can be dragged to a new position; the 2D plan view is available at any time for dimensional editing. The 3D view is an object-based layout of the site (box, cylinder and cone primitives for the obstacle library), not a mesh-sculpting tool.

Exports use the system share sheet (PDF/PNG/JSON). No permissions are requested. Sun and shadow values are explicitly labelled as theoretical estimates.

## Screenshot shot list（用真机/模拟器实际截图）

1. Scenes grid — three sample projects and metadata.
2. Shadow Simulator in 3D — strong cast shadows, ground compass, sun badge and Plan/3D toggle.
3. Shadow Simulator in 2D plan — same scene with the plan view selected.
4. Timeline — sunlight blocks and target result.
5. Heatmap — spatial exposure.
6. Scene Editor in 3D — dragged object, object library and inspector (optional, seventh slot: PDF report page).

设备尺寸：6.9"（iPhone 16/17/18 Pro Max 类）与 6.5"（iPhone 11 Pro Max 类）各一套，或使用 App Store Connect 要求的当前尺寸。截图中不得出现调试信息、占位品牌或非真实数据。
