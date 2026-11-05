# 构建、测试与界面验证记录 — 2026-11-03

## 运行环境

- macOS，Xcode 27.0（27A266a），iOS 27.0 SDK
- Swift 6.4 工具链，项目以 Swift 5 language mode 编译
- 部署目标 iOS 17.0，仅 iPhone、仅竖屏
- 模拟器：iPhone 18 Pro（A2ECCCDB-F1D7-459E-B942-1037F9FB44F3），iOS 27.0；此前亦在 iPhone 17 上完成构建/测试

## 已执行并通过

### 1. 工程生成与编译

```sh
python3 tools/generate_project.py
xcodebuild -project SunShadowPad.xcodeproj -scheme SunShadowPad \
  -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 18 Pro' \
  -derivedDataPath build CODE_SIGNING_ALLOWED=NO build
```

结果：`** BUILD SUCCEEDED **`（35 个 App 源文件、1 个单元测试源文件、1 个 UI 测试源文件）。3D 视图采用 SceneKit（`SCNView` + `UIViewRepresentable`）：`RealityView` 在 iOS 18 起才可用，而部署目标为 iOS 17，SceneKit 在 iOS 27 SDK 中仍受支持。

### 2. Release 配置编译

```sh
xcodebuild -project SunShadowPad.xcodeproj -scheme SunShadowPad \
  -configuration Release -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath build-release CODE_SIGNING_ALLOWED=NO build
```

结果：`** BUILD SUCCEEDED **`。除 Xcode 对未使用 AppIntents 的常规元数据提示外，无源码警告。完成 AX5 布局调整后于 2026-11-03 重新执行 Release 构建（`-destination 'generic/platform=iOS'`），仍为 `** BUILD SUCCEEDED **`。加入 SceneKit 3D 视图后再次执行 Debug 与 Release 构建，均成功。

### 3. 单元测试与界面测试

```sh
xcodebuild -project SunShadowPad.xcodeproj -scheme SunShadowPad \
  -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 18 Pro' \
  -derivedDataPath build CODE_SIGNING_ALLOWED=NO test
```

结果：`** TEST SUCCEEDED **`，共 27 项单元测试与 4 项 XCUITest 全部通过（完成 AX5 布局调整、3D 视图与卡片交互后于 2026-11-03 重新执行）。UI 测试在独立的模拟器克隆中运行，不依赖手工触摸注入：

| 测试 | 验证内容 |
| --- | --- |
| `testSummerNoonAtLondonIsAboveSixtyDegrees` | NOAA 位置解在伦敦夏至正午落在 60–64° |
| `testEquatorNoonOnEquinoxIsHigh` | 赤道春分正午太阳高度 > 87° |
| `testAzimuthTravelsFromEastToWestAcrossTheDay` | 方位角自晨至午后单调增大 |
| `testNightProducesNoDirectShadows` | 夜间不产生任何阴影多边形 |
| `testNorthernNoonShadowPointsNorth` | 北半球正午阴影向北、长度 = 高度 |
| `testShadowLengthMatchesHeightOverTangent` | 阴影长度 = H / tan(仰角) |
| `testZeroHeightObstacleCastsNoShadow` | 零高度物体不投影 |
| `testSunrisePrecedesSolarNoonAndSunset` | 日出 < 太阳正午 < 日落 |
| `testPolarDayAndPolarNight` | 78°N 夏至极昼、冬至极夜 |
| `testDaylightSavingUsesActualDayLength` | 伦敦夏令时切换日长度为 23 h / 25 h |
| `testDaylightHasFiniteSampledHours` | 热力网格数量、目标日照时长边界 |
| `testProjectContainsThreeEditableScenes` | 三个示例场景完整、可编辑、ID 唯一 |
| `testSameSiteRulesDisallowDifferentLatitude` | A/B 对比的同址约束 |
| `testSceneJSONRoundTripPreservesGeometry` | JSON 导出/导入无损还原场景 |
| `testInvalidSceneValuesAreRejected` | 非法纬度、尺寸、时区、负高度被拒绝 |
| `testPDFReportRendersInventoryAndExposurePages` | PDFKit 读出 3 页，含封面、场景清单、曝光分析文本 |
| `testComparisonPDFAddsLayoutComparisonPage` | 有对比方案时 PDF 为 4 页并含 LAYOUT COMPARISON |
| `testCanvasTapMapsToSceneCoordinates` | 热力图点击坐标正确映射到场景坐标，场地外点击被忽略 |
| `testSeasonalMarkersCompareEquinoxesAndSolstices` | 四季代表日顺序、月份、伦敦日照排序与春/秋分≈12 h |
| `testPrivacyManifestDeclaresNoTrackingAndUserDefaultsReason` | App 包内 `PrivacyInfo.xcprivacy` 存在，声明不跟踪，且 `UserDefaults` 使用理由为 `CA92.1` |
| `testSubmissionConfigurationStaysPortraitAndOffline` | `Info.plist` 仅竖屏、无定位用途声明、出口加密合规标志为 false |
| `test3DWorldPointCentersSite` | 平面坐标到 3D 世界坐标的场地居中映射 |
| `test3DSunDirectionIsVerticalAtZenith` | 太阳高度 90° 时方向向量竖直向上 |
| `test3DSunDirectionFollowsBearingAndSceneNorth` | 3D 太阳方向随方位角与场地真北旋转一致 |
| `test3DRotationKeepsPlanViewClockwise` | 平面顺时针旋转在 SceneKit 中保持视觉方向一致 |
| `test3DCameraOrbitsAroundSiteCenter` | 轨道相机始终位于场地中心球面上 |
| `test3DPlacementClampsInsideSite` | 3D 拖动物体/目标被夹取在场地边界内 |

界面测试（`SunShadowPadUITests`）：

| 测试 | 验证内容 |
| --- | --- |
| `testTappingSceneCardOpensSimulator` | 点击场景卡片（缩略图+文字整体为一个按钮）后进入 Shadow Simulator，且不会误开编辑器 |
| `testTappingSceneRowOpensSimulator` | 切换到列表后，点击整行同样进入 Shadow Simulator |
| `testEditorShadowsShortcutOpensSimulator` | 编辑器右上角太阳按钮保存并返回 Simulator，编辑器同时关闭 |
| `testSimulatorOffersSceneEditing` | Simulator 标题旁铅笔可打开对应场景的编辑器 |

### 4. 模拟器界面走查

通过 `xcrun simctl install/launch/io screenshot` 启动 Debug 构建并截图核对：

- 首次启动引导 4 页可翻页并完成；
- Scenes：3 个示例场景以卡片网格展示（类别、物体数、目标数、更新时间、收藏、模拟/编辑/更多操作）；整张卡片（缩略图与文字区）都是进入 Simulator 的按钮，底部保留显式 “Simulate”，当前场景带黄色 “Current” 标记；列表行同样整行可点，并显示 “Open in Simulator” 提示；归档卡片的整卡点击进入编辑器，并提供 “Restore” 主操作；铅笔与更多按钮的点击区域扩大到 28 pt；
- Shadow Simulator：场景选择、场景旁铅笔（直接编辑当前场景）、日期、可交互 3D 视图（默认）、时间滑块、播放、5/15/30 分钟步进菜单、速度菜单、日出/正午/日落快捷按钮；
- 3D 视图：场地以立体网格平台呈现，建筑/墙/树/雨棚按真实高度建模；平行光按 NOAA 太阳方位与高度角实时投射阴影，夜间切换为无投影的冷色环境光；地面纹理内置真北罗盘，随 `northDegrees` 旋转；单指拖动环绕、双指捏合缩放，右下角 Plan/3D 按钮可切回平面视图；
- Scene Editor 3D：默认 3D 建模模式，点击选中物体或观察目标（黄色高亮），拖动即在地面平面上移动并夹取在场地边界内，松手后写入一次撤销历史；拖动空白地面旋转相机，双指缩放；切到 Plan 仍保留原有二维编辑与缩放行为；
- Timeline：日照时间线、目标选择、热力图视图；Day 下可开启第二个日期做 A/B 日期对比（含差值），Seasons 下显示 12 个代表日柱状趋势（Jan–Dec 横轴）与春分/夏至/秋分/冬至四项季节对比；
- Settings：全部子页面入口、计量单位（米/英尺）与 24 小时制切换、数据管理；
- Scene Editor：3D 建模视图的相机、选中高亮、拖放与边界夹取（代码走查 + 模拟器截图）；平面模式保留对象属性与键盘收起行为；
- 3D 性能与生命周期：仅在场次/选中变化时重建几何，太阳光每帧仅更新方向与强度；地面纹理按尺寸与真北缓存；离开页面时恢复外层 `UIScrollView` 滚动；
- 卡片结构：`Surface` 统一包裹内容，修复此前多子视图被拆分成分段卡片的问题；Simulator 时间卡与 Timeline 各分析卡均显示为单一圆角面板；
- 空状态：Scenes 在无场景、搜索无结果、归档为空时分别给出专用提示，无场景时提供 “Create Scene” 按钮；Simulator 与 Timeline 无场景时提供 “Go to Scenes” 按钮；Timeline 对比模式无候选方案时可直接 “Duplicate Current Layout”；空白 Scene Editor 显示下一步操作提示；
- Compare：复制当前布局后会立即选中新副本，避免对比页停留在无匹配状态；A/B 两个画布在辅助功能字号下改为纵向排布；
- 辅助功能字号（Accessibility XL）：Scenes 自动切换为单列卡片/纵向行布局，Simulator 顶栏换行显示完整场景名与日期，Timeline 的 Analysis 模式改为菜单、采样精度与模式同行，目标选择可显示两行，日期对比的 “Second Date” 改为纵向排布，Settings 行正常换行；文字无截断或重叠。
- 最大辅助功能字号（AX5，`accessibility-extra-extra-extra-large`）：Timeline 的日期、摘要与指标改为纵向排列，“Analysis” 通过 `ViewThatFits` 缩短为图标菜单标签，无逐字断行；Simulator 场景名可换行 3 行，时间读数使用可缩放字体；时间轴步进/播放/速度控件在辅助字号下拆为“播放控制一行 + 步进/速度一行”，播放按钮改用图标并保留 VoiceOver 标签；Save Image / Export Report 在横向空间不足时自动纵向堆叠。
- 联系方式占位：未配置真实邮箱时，About Us 不显示可点击邮件链接，改显示 “Contact details are provided on the App Store product page.”；Privacy Policy 与 User Agreement 复用同一句联系方式说明，避免提交占位值产生死链。
- 热力图：网格可点击并高亮，读数面板显示单元格编号、中心坐标与理论直射小时数（映射逻辑由单元测试覆盖）。

截图保存在 `/tmp/sunshadow/`（`01-launch.png`、`scenes-v3.png`、`simulator-v2.png`、`simulator-fixed.png`、`timeline-day-fixed.png`、`timeline-heatmap-fixed.png`、`timeline-seasons-fixed.png`、`timeline-compare-fixed2.png`、`timeline-axl-final-header.png`、`timeline-compare-axl-fixed2.png`、`timeline-ax5-fixed2.png`、`simulator-ax5.png`、`editor-empty-fixed.png`、`settings.png`、`03-editor.png`、`3d-final2.png`、`3d-editor.png`、`scenes-tap-v1.png`、`scenes-empty-v2.png`、`simulator-empty-v2.png`、`timeline-empty-v2.png`、`simulator-edit-shortcut.png`）。

### 5. 资源与合规扫描

- AppIcon 1024×1024，RGB 无 alpha 通道；
- `Info.plist`：仅 iPhone、仅竖屏、`UILaunchScreen`、`ITSAppUsesNonExemptEncryption=false`；无定位、推送、通知、相机或麦克风用途声明；
- `Resources/PrivacyInfo.xcprivacy` 已加入 Copy Bundle Resources：`NSPrivacyTracking=false`、无跟踪域、无收集数据类型，`UserDefaults` 访问理由为 `CA92.1`；由单元测试从 App 包内读取校验；
- 源码中无 `StoreKit`、`UserNotifications`、APNs、账号登录、广告或网络请求；
- 全局点击空白处收起键盘（`KeyboardDismissInstaller`），输入控件点击不受影响。

## 未执行 / 不能宣称

- 未在真机上测试手势、性能与后台恢复。
- 卡片/按钮的单击导航已由 XCUITest 覆盖；3D 的连续多指手势（旋转、捏合、拖动建模）仍无法在无 GUI 环境中自动化，仅通过代码走查与静态截图验证，3D 数学与边界夹取由 6 项单元测试覆盖。
- 未进行 VoiceOver、Reduce Motion 的完整人工走查；最大辅助功能字号（AX5）已通过模拟器截图检查主要页面，但未能自动化滚动到所有页面底部。
- 未上传 TestFlight，未提交 App Store 审核，因此不能宣称“已通过审核”。
- 未替换占位信息：`AppInfo.swift` 中的 **Independent Developer / support@example.com** 是明确的中性占位值（不是虚构公司或真实域名），提交前必须改为提交者真实开发者名称与可用邮箱，并同步 About / Privacy / User Agreement / Feedback。

## 提交前必做

见 `Docs/RELEASE_CHECKLIST.md` 与 `Docs/APP_STORE_SUBMISSION.md`。
