# HomeMeasure — iOS 家装材料估算与采购管理完整开发规范

**版本**：1.0.0 | **日期**：2026-10-27 | **技术路线**：Swift / SwiftUI / SwiftData | **设备**：iPhone，竖屏 | **语言**：英文 | **网络**：核心能力完全离线

## 1. 产品定位与非目标

**核心价值**：记录房间尺寸，按实际扣除门窗面积，估算材料需求、包装采购数量、费用，形成可核对的英文采购清单，并可本地导出。

**主要用户**：独立进行装修规划的业主、室内设计从业者、施工准备人员、小型装修团队。

**目标体验**：打开即用，不注册、不弹出不必要权限提示、不依赖云服务；先建立项目，再添加房间，最后添加材料并导出报告。不是电商平台，也不是现场精密测绘设备。

**版本范围**：手动输入矩形房间及门窗；不支持不规则多边形房间自动绘图，不支持实时商品价格、条码识别、自动 OCR、跨设备实时同步、团队协作、建筑规范检验。这些功能不应在 App Store 宣传中暗示已经实现。

## 2. 开发技术与约束

| 层级 | 标准 | 已实现方式 |
|---|---|---|
| iOS | iOS 17+ | Xcode Deployment Target 17.0 |
| 语言 | Swift 5 兼容设置 | 所有业务源码为 `.swift` |
| UI | SwiftUI | 四栏目 TabView，独立 NavigationStack |
| 持久化 | SwiftData | `ProjectRecord` 本地模型 |
| 架构 | 轻 MVVM / View + Service | SwiftUI View 持有界面状态；计算、备份、媒体、PDF 独立 Service |
| 图片 | PhotosUI、ImageIO | 用户主动选图、沙盒 JPEG 文件 |
| 文件 | FileImporter / FileExporter | JSON 备份、PDF 输出 |
| PDF | PDFKit、CoreGraphics / UIKit PDF renderer | A4 报告与原生预览 |
| 网络 | 无（不引入 URLSession） | 无账户、无远端 API |
| 测试 | XCTest | 核心面积、损耗、预算回归测试 |

### 数据边界

- ProjectRecord 包含项目 ID、名称、位置描述、创建和更新时间、可编码项目内容。
- 一个项目内容包含多间 RoomPlan、多条 MaterialPlan、币种、税率、运费、备注。
- 每间房包含长度、宽度、高度、门窗数组及可选图片文件名。
- 每条材料包含所属房间、材料类别、应用表面、包装覆盖量、损耗、层数、单价、采购状态、人工覆盖数量。
- 数据修改以修改结构化副本、写回 SwiftData 对象为单位，避免不同视图独立保存引起计算结果不一致。
- 业务计算服务不得直接操作 SwiftUI 状态或 UI 控件；PDF 服务不修改业务模型。

## 3. 视觉系统：Arctic Slate / Glacier

### 3.1 调色

| Design Token | 十六进制 | 场景 |
|---|---|---|
| `deep` | `#173B4B` | 主标题、按钮、导航文字，深海峡湾蓝 |
| `slate` | `#467E94` | 次级操作、导航图标、控件主色，石板青蓝 |
| `glacier` | `#75B3BF` | 已购标识、辅助提示，冰川水蓝 |
| `mist` | `#DCEFF0` | 轻量背景、图标容器 |
| `paper` | `#F7FAF9` | 页面底色，淡灰绿白 |
| `gold` | `#E2AD72` | 极少量强调，可用于未来的洞察卡 |
| `white` | `#FFFFFF` | 内容卡背景 |

避免普通高饱和系统蓝占据主界面，也避免高对比霓虹蓝。深色文本与浅色背景保持清晰。屏幕默认采用一致的浅色主题；注意使用大号系统字与 VoiceOver 做可访问性检查。

### 3.2 排版、尺寸、留白

- 系统 SF 字体。封面大标题：系统 Large Title，rounded/bold；分区标题 Headline；正文 Body；辅助 Caption。
- 页面外边距 18–20 pt；卡片内边距 16–22 pt；常用卡片圆角 18–24 pt；主按钮圆角 15 pt。
- 以单列纵向 ScrollView 为主，Overview 统计指标允许两列；表单优先 Form；不要做横向被截断的核心操作。
- 关键金额需要货币符号、清晰的小数位；数量显示包装单位、数量来源和浪费率。
- 常用 SF Symbols：`house`、`square.stack`、`cart`、`gearshape`、`ruler`、`doc.richtext`、`checkmark.circle`。
- 空状态必须说明下一步，不能仅显示空白屏。

### 3.3 应用图标

- 图标无文字，以屋顶/测量三角尺/装修材料堆叠为核心隐喻，背景深海蓝，辅以冰川蓝和暖金窗格。
- 已放置 1024×1024 sRGB、不透明 PNG 于 `Assets.xcassets/AppIcon.appiconset`，同时提供 `Branding/HomeMeasure-App-Icon.png`。
- 发布前需核对名称、商标和视觉独立性。图标不能伪装系统服务或冒用第三方品牌。

## 4. 信息架构与完整导航

四个 Tab 必须始终在根层可访问（导航进入项目详情时仍由 TabView 管理）：

```
RootTabView
├── Overview (summary + new project + recent projects)
├── Projects
│   ├── New/Edit Project
│   └── Project Detail
│       ├── Add/Edit Room (doors/windows/photos)
│       ├── Add/Edit Material
│       ├── Budget Options
│       └── PDF Preview → Save PDF
├── Shopping (project sections + purchase status)
└── Settings
    ├── About Us          -> AboutUsView.swift
    ├── Terms of Use      -> TermsOfUseView.swift
    ├── Privacy Policy    -> PrivacyPolicyView.swift
    ├── Help & FAQ        -> HelpView.swift
    ├── Feedback          -> FeedbackView.swift
    ├── Export Backup     -> system FileExporter
    ├── Import Backup     -> system FileImporter
    └── Delete All Projects
```

首页、项目列表、采购页、设置页独立 NavigationStack。编辑使用 Sheet + Cancel/Save；删除使用上下文菜单或滑动操作，全部删除额外确认。

## 5. 页面逐项功能与状态

### 5.1 Overview

- 顶部品牌欢迎语 `Your renovation, in focus`；主行动 `Start a Project`。
- 四张统计卡：Active Projects、Rooms Planned、Material Lines、Items Purchased。
- 汇总预算**仅统计 USD 计价项目**，避免混币种错误；非美元项目在项目页内独立展示。
- 最近项目卡显示项目名、用户输入位置、房间数、材料数；点击进入详情。
- 0 项目状态给出创建引导，不自动填充虚假项目数据。

### 5.2 Projects

- 创建项目：必填项目名称，位置描述选填；设置默认 USD、税率 0、运费 0。
- 列表支持本地搜索名称/位置、滑动删除、进入详情；最新更新时间靠前。
- 编辑项目仅修改名称、位置，不改变关联尺寸材料。
- 删除项目同时删除关联房间、采购项和本地房间图片；建议用户先备份。

### 5.3 房间编辑

- 字段：Room name、Length (m)、Width (m)、Height (m)、Opening kind、Opening width/height、Count、Room photo、Notes。
- 所有长度必须有限、严格大于 0；房间基本尺寸不超过 1000m；门窗可添加多条；数量 1–30。
- `Add Door or Window` 支持门/窗区分；滑动删除一条 opening。
- 图片由系统 PhotosPicker 主动选取，使用 ImageIO 压缩并保存在 Application Support；不要求读取全相册权限。
- 页面摘要：floor、net wall、baseboard；房间图片或默认图标。
- 删除房间时移除引用该房间的材料行，避免幽灵采购项。

### 5.4 材料编辑

| 英文类别 | 默认对象 | 默认包装范围（仅初始建议，使用者需核实商品） | 默认损耗 |
|---|---|---|---|
| Tile | Floor | 1.44 m² / box | 10% |
| Flooring | Floor | 2 m² / pack | 8% |
| Paint | Walls | 35 m² / can, 2 coats | 5% |
| Wallpaper | Walls | 5 m² / roll | 15% |
| Baseboard | Baseboard length | 2.4 m / piece | 10% |
| Other | Manual quantity | 1 unit / item | 0% |

*上述数字仅为表单初始输入值，不代表真实品牌产品标准或价格。商品单价初始 0，避免误导。*

字段包括 Material name、Category、Room、Measure surface、Coverage per package、Package label、Waste allowance、Coats、Price per package、Override calculated packages、Notes。新增材料必须绑定已存在的房间。编辑保存后立即影响预算、采购清单、PDF。

### 5.5 Project Detail

- 顶部显示项目名、用户输入地点、房间和材料数。
- `Estimated Total` 卡展示总体成本，Budget options 配置 Currency、Sales tax、Shipping、Report notes。
- 房间卡展示地面、净墙、踢脚线面积/长度。三点菜单执行编辑/删除。
- 材料卡展示名称、房间、分类、整包数量、价格、需要的总覆盖量、损耗比例、采购状态。三点菜单编辑/切换采购/删除。
- `Preview & Export PDF` 进入系统 PDFKit 预览，`Save PDF` 打开系统文件存储界面。

### 5.6 Shopping

- 跨项目显示各自材料行，按项目分区；相同名称的不同项目材料目前**不自动合并**，避免不同批次、包装和价格混淆。
- 顶部进度显示已采购 / 总数，包含“Show purchased items”筛选。
- 点选圆圈切换 purchased 状态，持久化到来源项目，详情页同步更新。
- 支持按材料名称搜索。实际金额使用来源项目币种，不能跨币种加总。

### 5.7 Settings

- 顶部应用品牌块和版本号，不强制登录。
- 五个独立 `.swift` 子页面：首页列出导航入口。页面内容实际说明应用功能，不放 `test` / `demo` / `123` 类假数据。
- About Us：品牌定位、产品价值、产品作者品牌和版本号。Apple 上的真实 Seller 必须与实际开发者账号相符。
- Terms of Use：使用范围、估算局限、用户数据责任、第三方分享、专业责任。
- Privacy Policy：离线处理说明、收集与存储范围、系统选择照片、导出分享、删除和备份、跟踪状态。
- Help & FAQ：实际操作、面积公式、损耗取整、覆盖量、导出 PDF、JSON 备份及照片限制。
- Feedback & Suggestions：主题、类别、详细描述；分享和复制由用户显式触发。不伪造邮箱和提交成功。
- Export Backup：JSON 文件导出；Import Backup：校验 schema 和大小，导入**作为独立副本**；Delete All Projects：确认后删库及本地图片。

## 6. 计算逻辑与精度规范

### 6.1 房间

设 `L` 长、`W` 宽、`H` 高，门窗条目分别为 `(w_i,h_i,count_i)`：

```text
FloorArea      = L × W
CeilingArea    = L × W
GrossWallArea  = 2 × (L + W) × H
OpeningsArea   = Σ (w_i × h_i × count_i)
NetWallArea    = max(0, GrossWallArea − OpeningsArea)
Perimeter      = 2 × (L + W)
Baseboard      = max(0, Perimeter − Σ(door.width × door.count))
```

假设矩形平面、墙等高、平面天花板；没有独立扣除踢脚线缝、柱、壁龛、斜屋顶。不规则户型必须分拆成多个矩形空间输入。

### 6.2 材料与包装

```text
BaseQuantity       = AppliedAreaOrLengthOrManualQuantity × Coats
WithWaste          = BaseQuantity × (1 + WastePercent / 100)
ComputedPackages   = ceil(WithWaste / UsableCoveragePerPackage)
PurchasedPackages  = ManualOverride ?? ComputedPackages
LineCost           = roundCurrency(PurchasedPackages × PricePerPackage)
Subtotal           = Σ LineCost
Tax                = roundCurrency(Subtotal × TaxPercent / 100)
GrandTotal         = Subtotal + Tax + Shipping
```

- 覆盖量不得为零或负数；waste 0–100%；coats 1–10；单价和运费不得为负。
- 最终包装数量向上取整，不允许购买 3.7 盒地砖；用户可自主 override。
- 层数对所有 surface 生效：粉刷两层是典型用法；其它材料通常为 1。
- 价格由用户录入，不包含供应商实时报价。金额内部使用 Decimal 并四舍五入 2 位。
- 仅显示 USD Overview 预算累计；单项目支持 USD/EUR/GBP/CAD/AUD/JPY/SGD/CHF/CNY/HKD。币种切换不自动换算。

### 6.3 验证样例

房间 4 × 3 × 2.7m，一扇门 0.9 × 2.1m，一扇窗 1.2 × 1.5m：

```text
Floor = 12.00 m²
Gross walls = 37.80 m²
Openings = 3.69 m²
Net walls = 34.11 m²
Baseboard = 13.10 m
Tile (1.44 m²/box, 10% waste) = ceil(13.2/1.44) = 10 boxes
Tile (38 USD/box) = 380 USD
Tax 7.5% + delivery 25 USD => 433.50 USD total
```

## 7. 数据持久化、备份、照片

- SwiftData `ProjectRecord` 与项目内容封装，避免多个关系对象孤立保存。
- 以 `@Query` 观察 SwiftData 变化，不需要自研数据库观察或网络同步。
- `ProjectContent` 为 Codable 结构；建议未来 schema 升级时加入迁移策略及破坏性变更测试。
- JSON Backup 格式键：`format = "HomeMeasureBackup"`，`version = 1`，`exportedAt` 与项目数组；日期 ISO 8601；文件大小上限 20 MB。
- Import 写入新 ProjectRecord，保留原房间 ID 和材料 roomID 关联；外部照片路径置空以避免“照片缺失”错误。
- 照片通过系统 picker 显式选择后缩放 JPEG，仅存沙盒目录；本地删除清理照片，系统分享的外部副本不受 App 管理。
- 出口可通过用户选择的文件位置存储至本地 Files 或 iCloud Drive（这属于用户选择的系统目标，不代表 App 自建云同步）。
- 数据库文件/系统备份由操作系统管理；不应声称卸载能清除用户自行导出的任何文件。

## 8. PDF 结构与导出规则

| PDF 区块 | 内容 |
|---|---|
| Branding | HOMEMEASURE、RENOVATION PURCHASE REPORT |
| Project header | 项目名称、手动输入地点、报告生成日期 |
| Room Measurements | 房间名称、Floor/Net Walls/Baseboard |
| Materials & Quantities | 材料、房间、整包数、包装单价、行总额、是否采购 |
| Costs | subtotal、tax、delivery、estimated total |
| Notes | 用户项目备注 |
| Disclaimer | 估算值、请核对规格/供应商/当地税费 |

- 使用 CoreGraphics 和 UIGraphicsPDFRenderer 绘制 A4 风格页面，超长列表跨页，每页报告抬头和页码。
- PDFKit 仅作本地预览；无需云打印，也不设置 PDF 密码或加密。
- 系统 FileExporter 返回文件目的地；不存在未授权写入下载目录的行为。
- 文件名取用户项目名的安全字符后附加 `-Purchase-Report`，限制长度。

## 9. 代码规范与架构边界

```
HomeMeasureApp
  └─ RootTabView ── OverviewView / ProjectsView / ShoppingView / SettingsView
                            │               │
                            └── ProjectDetailView
                                  ├── RoomEditorSheet
                                  ├── MaterialEditorSheet
                                  ├── BudgetEditorSheet
                                  └── PDFPreviewView
Services ── EstimationService / PDFReportService / BackupService / RoomPhotoService
Models   ── ProjectRecord / ProjectContent / RoomPlan / MaterialPlan / RoomOpening
Design   ── AppTheme / MetricCard / EmptyPanel / SectionTitle / PrimaryActionStyle
```

- 单个 View 负责所需屏幕表单 State、UI 验证和导航；Service 负责无界面算法。
- 服务默认无单例、无隐藏环境网络依赖，易做单元测试。
- 明确 `onSave` 闭包回传值对象，尽量不让表单在键盘输入时反复写数据库。
- 命名：类型 PascalCase，函数/变量 lowerCamelCase；非业务常量集中于 Design。
- SF Symbols 系统字体，与 SwiftUI 动态类型保持兼容；可点击组件应带有清晰英文标签。
- 系统危险操作需二次确认，输入区有取消路径；错误应报告原因，不应伪造完成提示。

## 10. QA 场景与验收标准

1. 新装应用无账户页面、无登录门槛，能够立即创建项目。
2. 底部 Overview/Projects/Shopping/Settings 四栏目均可进入、返回正常。
3. 无项目/无房间/无材料时展示实用空状态，引导下一步。
4. 创建、编辑、删除项目后关闭重开 App，数据保持正确。
5. 4×3×2.7 房间扣门窗后净墙面积精确显示为 34.11m²。
6. Baseboard 仅扣门宽，窗宽不扣除；不会出现负数。
7. 10% 损耗 + 1.44 m² 每盒 → 12 m² 地面采购 10 盒。
8. 涂料多遍覆盖按 coats 翻倍，支持人工包装覆盖数量。
9. 0 覆盖量、负价格、负面积不能通过保存。
10. 一条材料购买状态切换后，项目详情/购物页一致。
11. 删除房间时其材料行同时移除；删除项目时相关照片清理。
12. 混合币种项目时 Overview 不把金额强行转换相加。
13. JSON 能导出和恢复，恢复为新副本，不破坏原有项目。
14. 导出 JSON 的照片链接不导致恢复项目显示坏图。
15. PDF 在多页材料列表下有页眉、页码、正确金额和备注。
16. PhotosPicker 取消不要求整相册授权，无相册权限拒绝崩溃。
17. 反馈按钮仅打开系统分享，不会显示虚假的“已发给开发者”。
18. 删除全部项目后二次确认，重启数据不再存在。
19. UI 在较小 iPhone 屏幕及大文字下不出现遮挡操作。
20. Xcode 编译、XCTest、实际设备测算回归、App Store Connect 元数据检查全部完成。

## 11. App Store 审核策略（不等于保证过审）

- 功能完整：真实实现材料估算、预算、购物、PDF 等核心能力，避免只有跳转页面的空壳 App。
- 隐私最小化：无登录、无用户跟踪、无广告 SDK；使用 PhotosPicker 选择特定照片；无需 Location/Camera 权限声明。
- 合理报备：App Store Privacy Nutrition Labels 必须如实按最终包行为填写；如增加 SDK 或网络需重新审核声明。
- 隐私政策：Settings 内可直接阅读；**上架时仍必须有可公开访问的 Privacy Policy URL**，与店铺填写一致。
- 支持链接：发布者应在自己的受控网站提供真正可用的 Support URL 和持续监控的联系方式；没有开发者联系方式时不能冒充真实邮箱。
- 开发者真实身份：App Store 卖家名称由 Apple 开发者账号确定，不能用虚构工作室名称伪装法律主体；本项目中的 HomeMeasure Studio 只作为品牌称呼。
- 商标与素材：核对 HomeMeasure 名称可用性、图标独创性、截图无侵权内容。
- 无购买/订阅：无需 IAP，无误导性“在线报价”承诺。
- 发布前：在 macOS Xcode 的最新稳定版本进行 Simulator、真机和 Archive 检查；填写年龄分级、类别、隐私回答、审核备注、联系方式和截图。

权威参考：
- https://developer.apple.com/app-store/review/guidelines/
- https://developer.apple.com/app-store/app-privacy-details/
- https://developer.apple.com/documentation/xcode/configuring-your-app-icon

## 12. 可扩展但不包含于当前版本

- 不规则房间多边形/墙面分段、门窗误差校验、材料零售价格导入、供应商 SKU 合并、项目模板、CSV 清单、多语言单位切换、施工图片 OCR、分房间预算图表、可选本地通知。
- 若升级这些功能必须保留当前离线可用性、明确的隐私边界，并增加迁移及回归测试。
