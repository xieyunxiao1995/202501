# SunShadowPad 1.0 — 完整功能、UI 与代码架构规范

> 交付日期：2026-11-02  
> 产品语言：English（界面、帮助、隐私文本统一英文）  
> 运行终端：iPhone、竖屏  
> 开发栈：Swift 5、SwiftUI、SwiftData、Swift Charts、CoreGraphics、UIGraphicsPDFRenderer  
> 最低系统：iOS 17  
> 连接方式：完全离线；无账号、无服务器、无推送通知、无应用内购买  
> 本文状态：**与随附源码对应的 V1.0 实施规范**。没有写成源码的后续设想单独列出，不假装已实现。

---

## 01. 产品目标与设计原则

### 1.1 用户核心任务

SunShadowPad 是一个二维日照与阴影规划工作台，而不是只输出太阳角度的计算器。使用者可从空白场地或可修改的默认场景开始，设置经纬度、时区和北向，摆放场景中的建筑、墙体、柱子、树木、围栏与实心遮阳棚，放置观测点/种植区域，观察日内阴影变化，通过采样获得理论直射日照时数，比较两种布局，再将结果导出为报告和本地备份。

完整闭环：**创建场景 → 设置地点与北向 → 添加障碍物 → 放置观测目标 → 模拟时刻 → 分析全天日照 → 修改或复制布局 → 方案对比 → 导出报告**。

### 1.2 明确的科学边界

所有结果都属于**theoretical direct sunlight / geometric shadow estimates**。初版假定地面完全水平，建筑、墙体、围栏是实体不透明立柱/棱柱，树冠是简化不透明冠幅投影，遮阳棚是水平实体顶面投影。没有云、天气、地形高差、窗玻璃、建筑外立面反射、未知邻近建筑或树叶透光率建模。不能将结果视为建筑合规报告、农业产量预测、专业工程测绘或天气预报。

太阳位置计算使用 NOAA Global Monitoring Division 的公开近似方程（不是 NREL 完整 SPA 实现）。日出/日落采用太阳几何高度角过零时刻的数值搜索，未对大气折射做精细修正，因此与天气/日历中的视日出日落时间可有差异。模型会显示这一限制。

### 1.3 产品约束

- **离线优先**：不调用 URLSession 或第三方网络服务。定位由用户手动输入，不请求 Core Location 权限。
- **可核查**：一个场景所有数据存于统一的 SwiftData 行（JSON 文档），模拟、时间线、导出都读同一场景结构。
- **有实际价值**：所有四个 Tab、默认场景、编辑、模型计算、保存、对比、文件导出、法律与帮助入口都有可访问的实现。
- **深蓝背景，暖黄色太阳**：对比度清晰，图形比解释文案承担更多说明任务。
- **不编造开发者身份**：没有虚构的公司、邮箱、地址、下载量或第三方认证。发布者身份与真实支持网址由实际 App Store 账号持有人补齐。

---

## 02. 信息架构：四个底部 Tab

| Tab（英文显示） | 页面标题 | 用户心智模型 | 主要入口/结果 |
|---|---|---|---|
| Scenes | Scenes | 管理需要分析的空间 | 卡片或列表、创建、复制、归档、删除、收藏、JSON 导入导出、场景编辑器 |
| Simulator | Shadow Simulator | 在某一天移动太阳 | 日期、当地时间滑杆、播放、日出/正午/日落跳转、阴影画布、太阳高度/方位、阴影长度、PNG/PDF |
| Timeline | Sunlight Timeline | 明确一个点或一块区域每天晒多久 | Day、Heatmap、Seasons、Compare，采样精度设置，报告导出 |
| Settings | Settings | 管理单位、资料与合规信息 | 单位、时制、备份、帮助、反馈、关于我们、隐私政策、用户协议 |

切换 Tab 时的共享状态由 `WorkspaceState` 管理，包括：`selectedSceneID`、`inspectionDate`、`minuteOfDay`、`selectedTab`、`comparisonSceneID` 与强制刷新标识。保存同一个 `StoredScene` 后，其余页面重读 `StoredScene.document` 并重新计算，而非各自维护互不相容的数据版本。

**选场景与切换场景**：Scenes 上点击 Simulate，`WorkspaceState.select(record)` 将选中的 UUID 写入共享状态并切到 Simulator；后者和 Timeline 均有选择器可切换活跃场景。如果用户删除活跃场景，根视图优先选择下一条未归档场景。

---

## 03. 视觉系统与交互准则

### 3.1 色彩

| 语义 | SwiftUI 定义 | 用途 |
|---|---|---|
| Navy | `#0B1425` 附近 | 主背景、深色画布外区域 |
| Panel | `#152237` 附近 | 卡片、参数面板、工具容器 |
| Elevated | 蓝灰 | 高层控件、进度轨 |
| Solar Yellow | 暖金 `#FFBF45` 附近 | 日光、主要 CTA、时间高亮 |
| Grass | 绿色 | 观测区域、合格日照、增加曝光 |
| Shadow | 冷蓝灰 | 遮挡与阴影 |
| Muted Text | 灰蓝 | 仅用于必要的次级信息 |

> 源码中的色值以 `UI/Components/Theme.swift` 为准，此表为视觉描述。

### 3.2 字体与层级

- 顶部系统导航标题：SwiftUI NavigationStack，标题通常 17–20pt。
- 关键指标：圆角系统数字字形，约 23–30pt；最多三张横向指标卡。
- 主卡标题：17pt semibold，正文 14–16pt，描述字尽可能少。
- 按钮保留动词：Add Object、Simulate、Export Report、Import Project。
- “Avoid unnecessary secondary labels and descriptions. Let the layout do the explaining.”：每张卡只有一个主要数字或决策，不重复标签描述。

### 3.3 场景画布

- 背景是独立二维几何画布，而非背景截图。
- 采用 `SwiftUI.Canvas` 和 `Path` 绘制网格、实体顶视图、矩形观测区、圆形观测点、太阳阴影与北向指针。
- 物体颜色按语义分类：树木绿、建筑暖灰、墙体浅灰、遮阳棚浅蓝。
- `CanvasProjection` 在世界单位（米）与屏幕点之间转换，默认以完整场地居中自适应。
- 场景编辑支持：单指拖拽物体、点击选中、双指缩放、在背景拖拽平移；选中后出现实际属性编辑页面。
- 编辑控件均为原生 SwiftUI；不用嵌入 WebView。

### 3.4 通用操作反馈

- 文件读写失败显示用户可理解的 Alert；取消系统文件选择不会修改场景。
- 第一次进入显示四页引导，支持跳过；引导完成记录于 AppStorage。
- 设置与属性编辑采用原生 Form，滚动时可以收起键盘，触摸非输入区域触发 resignFirstResponder。
- 破坏性操作（删除场景、清空所有场景）需要明确二次确认。
- 提醒“无数据/无匹配方案”的页面是说明性空状态，而不是死按钮。

---

## 04. Scenes：场景管理与编辑工作流

### 4.1 场景首页

首页上部包含项目数、卡片/列表切换、新建按钮、Active/Archived 分组切换。中部每个项目卡片包含通过当前模型即时绘制的微缩画布、名称、场景类别、障碍物数量，以及 Simulate、编辑和更多操作。搜索支持按场景名筛选。更多操作包括 Favorite、Duplicate as New Layout、Archive/Restore、Export JSON、Delete。

初次进入自动创建三个可修改场景，且只在**首次安装初始化一次**，用户删除后不会反复出现：

1. `Courtyard Garden`：伦敦庭院、边界围墙、小型建筑、树、菜畦、香草区、观测点。
2. `Balcony Planning`：纽约阳台、分隔墙、遮阳顶棚、种植槽。
3. `Outdoor Photo Setup`：洛杉矶摄影场地、建筑、树、栅栏与拍摄点。

这些样例是持久化、可编辑的实景结构演示数据，拥有具体真实格式的经纬度、IANA 时区、尺寸和几何参数；不使用系统假数据账户。

### 4.2 场景属性页

- 场景名 `name`：自由文本。
- 类别 `SceneKind`：Garden / Patio / Balcony / Photography / Custom。
- 纬度 `latitude`：范围 [-90, 90]，东经为正。
- 经度 `longitude`：范围 [-180, 180]，东经为正。
- 时区 `timeZoneID`：IANA 标识，例如 `Europe/London` 或 `Asia/Kuala_Lumpur`；要按具体日期遵守 DST 规则，不能写死 UTC+8。
- `width`, `height`：范围 1–2000 m；内部统一以米保存，避免英尺换算累积误差。
- `northDegrees`：0° 代表画布上方为真北，90° 代表真北指向画布右侧；允许 0–359° 调整。
- 文字备注。

### 4.3 二维设计器

画布占主屏可视区域的大部分；底部为 `Add Object`、`Layers`、`Undo`、`Redo` 工具行。对象添加位置为当前场景中心，之后可拖动或输入精确数字。点击物体或图层列表项，打开元素独立属性页。编辑器支持对象复制、移动、改名、显示/隐藏、锁定/解锁、删除和数值编辑。

已经实现 **“添加 / 移动 / 删除”型事务的撤销、重做**，历史深度上限 50；当前数值输入直接保存，不进入撤销栈。这一边界必须在 QA 中保留，不应误标为全编辑事务撤销。

### 4.4 障碍物库

| ElementKind | 形状 | 字段 | 物理模型 |
|---|---|---|---|
| Building | 可旋转矩形 | x/y、宽、深、高、rotation | 不透明矩形棱柱的地面阴影 |
| Wall | 窄矩形 | x/y、长、厚、高、rotation | 不透明薄棱柱 |
| Column | 圆形 | x/y、直径、高 | 近似圆柱投影 |
| Tree | 圆形树冠+树干 | 位置、冠径、高、冠底高度 | 不透明冠幅投影加简化树干 |
| Fence | 窄矩形 | x/y、长、厚、高 | **首版视作实心**，不模拟孔洞 |
| Solid Canopy | 矩形顶棚 | x/y、宽、深、顶高 | 仅顶面投影，不包含立柱 |
| Custom Rectangle | 可旋转矩形 | 通用尺寸/高度 | 实心棱柱 |

`crownBaseHeight` 被存储供以后模型升级；当前冠层投影采用由冠径与顶高推导的简化有效高度，因此不得在 App 文案里声称准确叶片通光或真实椭球体投影。物体隐藏后不绘制也不参与模型，锁定阻止手势拖拽，但仍参与阴影计算。

### 4.5 观测目标与规划区

`ObservationTarget` 包括点和矩形区域，类型为 Observation Point、Vegetable Bed、Flower Bed、Herb Garden、Seating Area、Custom Area。字段包含名字、X/Y、矩形宽深、用户自行输入的 `targetHours` 和备注。除点目标外，区域用 3 × 3 空间点估算其平均日照，不能将中心点读数冒充区域均值。

画布中观测点用小圆靶标显示，区域用绿色半透明矩形表示。目标可以直接拖动，也可以通过 inspector 精确编辑位置。`Meets Target` 判断严格依据用户配置的小时阈值，而非内部植物栽培知识库。

---

## 05. Simulator：太阳/阴影实时实验台

### 5.1 页面结构

1. 场景选择器 + 日期选择器（显示所选场景的时区）。
2. 主画布：模拟指定日期和当地时刻的顶视阴影；阴影始终重新从物理模型生成。
3. Time of Day 面板：当前时刻大字、00:00–23:59 滑杆、暂停/播放、-15/+15 分钟、1×/3×/6× 播放速度、Sunrise / Solar Noon / Sunset 跳转。
4. 指标栏：Sun Elevation、Sun Azimuth、示例障碍物阴影长度（米/英尺）。
5. 当前主要观测点：是否获得理论直射太阳；若被遮挡，列出参与遮挡的物体名称。
6. `Save Image`：当前画布 PNG；`Export Report`：生成 PDF 规划报告。

### 5.2 操作边界

- 播放过程不触发联网和推送通知；仅更新内存中的当前时刻。
- 夜间不生成太阳直射阴影，显示 Sun Below Horizon。
- 极昼可能没有日出/日落，相关跳转按钮自动禁用而不是凭空给出时间。
- 影长公式 `L = H / tan(α)`。α<=0 时不定义直射阴影。太阳接近地平线时会出现极长投影；绘图层用大上限保护坐标数值安全，场景画布按可见范围裁剪，不把屏幕内长度冒充实际长度。
- 若用户选择英尺，阴影长度显示转换为 ft；场景的编辑坐标仍始终以 m 标注。

---

## 06. Timeline：全天、区域、季节与对比

### 6.1 Day

- 选择观测目标或查看 Site-Wide Average。
- 全天条带：黄色为该点理论直射日照，蓝灰为白天阴影，深色为太阳低于地平线。
- 对于指定观测目标显示 `Direct Sunlight`、`Blocked Duration`、`First Sun Exposure`、`Last Sun Exposure`、`Longest Sunny Period`、`Meets Target / Below Target`。
- 太阳事件显示当地时区的日出、太阳正午和日落。
- 用户可设置 5/10/15/30 min 时间步长，在采样精度与速度间取舍。

### 6.2 Heatmap

通过 `ExposureAnalysisEngine` 遍历全天太阳高度>0 的采样片段，并对场地内部 M×N 网格中点判断是否在**任一**障碍物阴影内。每一网格累积理论直射小时数；阴影重叠按布尔覆盖计算，**不重复累计**遮挡时间。

- 默认水平 18 列，纵向列数依据场地宽高比例确定，约束 6–32 行；可切换 12/18/24/30 列。
- 颜色从低曝光冷蓝过渡到高曝光暖黄。
- 展示每个观测区域的小时数及与用户目标的关系。
- `maxSunHours` 是所选日采样的理论太阳高于地平线总时长，不是物理实测光照。

### 6.3 Seasons

用户选择一个点后，对所选年份每个月 **15 日** 估计该点理论直射时数，采用 15 分钟采样；Swift Charts 绘制 12 个月柱状图，显示亮度较高/较低的代表月份。

**Important**：每月 15 日代表点的结果**不等于整月平均值**，更不等于全年真实有效太阳小时数。界面显式写出 Representative Day / 15th of Each Month。

### 6.4 Compare

1. 用户在 Scenes 内 `Duplicate as New Layout`，原布局不变，副本作为另一个 `SceneDocument`。
2. 修改副本障碍物位置、高度或尺寸。
3. Timeline → Compare 自动列出**同一纬度、经度、时区、画布尺寸和北向**的其他布局，避免不同地点的结果产生伪比较。
4. 系统使用同一个日期与采样精度分别计算两个场景。
5. 显示 Original vs Alternative 小画布、原时数、替代时数、小时差，以及绿色增加/金色减少的空间差异图。
6. 导出附比较页 PDF。

若两个场景的目标名称一致，比较对应目标的模拟小时数；没有可匹配目标时，显示场地空间平均变化。原布局和副本的对象 UUID 会不同，不能依赖对象 UUID 对齐。

---

## 07. 坐标、太阳位置与阴影算法

### 7.1 坐标系

定义世界场景：`(0,0)` 为画布左上角，X 向右，Y 向下，单位米。画布法向上方仅代表场景的局部方向；场景与真正地理北向的关系由 `northDegrees` 明确指定。

设太阳方位 `A` 为从真北开始顺时针计的角度，阴影方向为 `A+180°`。设画布真北方向顺时针旋转 `N` 度，阴影长度 `L`，二维屏幕偏移为：

```
shadowBearing = (A + 180 + N) * π / 180
dx = L * sin(shadowBearing)
dy = -L * cos(shadowBearing)
```

例如 N=0 时真北位于画布上方；太阳在真东时，阴影向画布左侧。N=90 时整幅地理方向相对于画布旋转 90°，但建筑底面本身不跟着修改尺寸。

`CanvasProjection` 处理世界米→视图像素转换：以场地尺寸适配 viewport、居中、应用 zoom 与 pan；不将屏幕单位混入物理模拟。

### 7.2 太阳位置

使用 NOAA 近似数学模型：

```
γ = 2π / N * (dayOfYear - 1 + (localHours - 12) / 24)
EoT = 229.18 * (0.000075 + 0.001868 cosγ - 0.032077 sinγ
                - 0.014615 cos2γ - 0.040849 sin2γ)
δ = 0.006918 - 0.399912 cosγ + 0.070257 sinγ
    - 0.006758 cos2γ + 0.000907 sin2γ
    - 0.002697 cos3γ + 0.00148 sin3γ
TST = localMinutes + EoT + 4 * longitude - 60 * utcOffsetHours(at Instant)
HA = TST/4 - 180
cos(zenith) = sin(latitude) sinδ + cos(latitude) cosδ cosHA
elevation = 90 - zenith
azimuth = atan2(sinHA, cosHA sin(latitude) - tanδ cos(latitude)) + 180
```

局部时区始终使用 `TimeZone(identifier:)` + `secondsFromGMT(for: actualDate)`，以避免夏令时/标准时混淆。计算每天的真实时间区间 `Calendar.dateInterval(of:.day,for:)`，因此 DST 转换日可以是 23 或 25 小时。

该 NOAA 方法是天文位置估计而不是完美的真太阳大气模型：若 App 需要工程级精度，未来应改用经独立对照校验的 NREL SPA 及可选择的地形遮挡，而不扩大当前 V1.0 的准确性承诺。

### 7.3 日出/日落

对当日时区日界内的绝对时刻每 5 分钟扫描太阳几何高度角是否过零；在发生状态切换的区间用 10 次二分法收敛到近似事件时刻。找不到过零并且全天高度>0 时返回 `alwaysAbove=true`；全天高度<=0 时返回 `alwaysBelow=true`。`solarNoon` 取扫描中太阳高度最大的时刻（约 5 分钟分辨率）。

### 7.4 阴影投影

- 以旋转矩形四顶点作为建筑、墙、棚的几何底面；柱子和树冠按 24 点圆近似。
- 某个立体棱柱的地面阴影是「底面顶点」与「顶面同形顶点平移 L」的凸包。
- 不透明顶棚只投射顶面多边形，不错误地将顶棚内部直接填成实心墙。
- 树木使用简化圆形冠层和窄树干阴影，不能预测枝叶间隙阳光。
- 所有障碍物对同一点的遮挡统一通过 `ShadowGeometryEngine.isShaded(point, polygons:)` 的 anyContains 判断；面积曝光绝不对重叠阴影重复计数。

对于太阳高度过低而产生的非常长投影，可视化只以一个大尺度上限控制浮点数；不能在数值展示中谎称投影真实长度等于这个上限。

### 7.5 目标空间平均的定义

- Point：采样一个坐标。
- Area：对其矩形内等间距的 3×3 位置计算明暗比例，按比例乘以采样时间累积理论直射小时数。
- First/Last Sun Exposure 和 Longest Sunny Period：区域以当前采样时段 **至少 50% 空间点被照亮** 定义该时段“区域处于日照状态”，与按比例累计小时数的口径不完全相同；页面中应以小时估算值理解，而不是断言每一点都有持续同样长的日照。

---

## 08. 本地持久化与场景文件

### 8.1 持久化架构

SwiftData 中只管理一个主实体：

```
@Model final class StoredScene {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    var updatedAt: Date
    var isFavorite: Bool
    var isArchived: Bool
    var json: Data
}
```

`json` 编码/解码为版本化 `SceneDocument`。这样可以将场景属性、对象列表和目标列表在一次 `ModelContext.save()` 中一起持久化，避免多个页面分别维护几何数据而不一致，也避免复杂的 SwiftData 对象关系。UI 对编辑中的 `SceneDocument` 使用 `@State` 和 Binding，修改后调用 `record.update(with:)` 再保存。没有 CoreData 网络同步或 CloudKit。

### 8.2 数据结构

```
SceneDocument {
    schemaVersion, id, name, kind,
    latitude, longitude, timeZoneID, width, height, northDegrees,
    notes, elements: [SceneElement], targets: [ObservationTarget]
}
SceneElement {
    id, name, kind,
    x, y, width, depth, height, rotation,
    crownDiameter, crownBaseHeight, isLocked, isHidden
}
ObservationTarget {
    id, name, kind,
    x, y, width, depth, targetHours, notes
}
```

所有物体尺寸、位置均用米，UI 可以额外格式化为英尺显示；经纬度为双精度角度，时区使用 IANA ID 而不是整数 UTC offset。

### 8.3 JSON 项目格式

单个项目导出一个 `SceneDocument` 的 Codable JSON。批量备份使用：

```
LocalProjectArchive {
    app: "SunShadowPad",
    formatVersion: 1,
    exportedAt: Date,
    scenes: [SceneDocument]
}
```

- 文件由用户通过系统 `fileExporter` 选择保存位置；没有后台或云端自动同步。
- 使用 `fileImporter` 打开 JSON，读取前请求安全域访问权限，读取后归还。
- 导入时检查场景尺寸、地理坐标和 IANA 时区；遇到已有 UUID 则复制为新场景，避免覆盖当前用户资料。
- 一次导入最多 500 个场景，防止意外资源消耗。
- 不使用硬编码用户路径，不要求账号，不推送资料到服务器。

### 8.4 删除与隐私

单个场景可在 Scenes 删除，Settings → Backup & Data 可删除全部场景。删除数据本地完成，无服务端删除请求。App 可在用户主动操作时通过系统 ShareSheet 分享反馈文本、PDF、PNG 或 JSON；分享发生在系统提供的外部目标中，用户自己决定是否发送。

---

## 09. PDF、PNG 与报告信息结构

PDF 使用 `UIGraphicsPDFRenderer`；场景轮廓、太阳几何阴影和网格数据全部来自同一计算引擎。

- **第 1 页：Site Study** — 设备生成日期/所选分析日、名称、经纬度、尺寸、时区、北向、09:00/12:00/16:00 三张示意快照、日出/正午/日落、模型约束。
- **第 2 页：Exposure Analysis** — 日照热力图、实际采样时间步长与网格尺寸、最多 8 个观测目标的实算时数、目标达标状态，以及精度/限制说明。
- **第 3 页（可选）：Layout Comparison** — 原方案与备选方案热力图、全场平均小时数及差值，提醒确保地理属性一致。

Simulator 的 Save Image 通过 SwiftUI `ImageRenderer` 将真实画布按输出尺寸渲染成 PNG；它与屏幕同用 `SceneCanvasView` 绘图路径。JSON 可直接作为以后导入的可编辑场景，而不是一张失去几何信息的图片。

---

## 10. 代码目录及职责

```text
SunShadowPad_Delivery/
├── SunShadowPad.xcodeproj/      # 可直接在 Xcode 打开；非空的 pbxproj
├── SunShadowPad/
│   ├── App/
│   │   ├── SunShadowPadApp.swift # @main, SwiftData ModelContainer
│   │   ├── RootTabView.swift    # 4 Tab、首次数据初始化、引导
│   │   ├── WorkspaceState.swift # Tabs 间共享状态
│   │   └── OnboardingView.swift # 4 页可跳过引导
│   ├── Models/
│   │   ├── SceneDocument.swift   # Codable 几何模型
│   │   ├── StoredScene.swift     # SwiftData 项目实体
│   │   └── SimulationResult.swift # Sun/Exposure/Heat 等结果类型
│   ├── Services/
│   │   ├── TimeService.swift
│   │   ├── SolarPositionEngine.swift
│   │   ├── ShadowGeometryEngine.swift
│   │   ├── ExposureAnalysisEngine.swift
│   │   ├── ScenarioComparisonService.swift
│   │   ├── ProjectBackupService.swift
│   │   ├── ReportExportService.swift
│   │   └── SceneSamples.swift
│   ├── UI/
│   │   ├── Components/        # 主题、图形画布、指标卡
│   │   ├── Scenes/            # 场景列表与操作菜单
│   │   ├── Editor/            # 编辑画布、障碍物/目标属性
│   │   ├── Simulator/         # 时间滑杆、太阳数据、PNG/PDF
│   │   ├── Timeline/          # 一日、空间热力、月度代表日
│   │   ├── Compare/           # 双场景比较与差异图
│   │   └── Settings/          # 设置和独立帮助/协议/反馈页面
│   └── Resources/
│       ├── Info.plist
│       └── Assets.xcassets/AppIcon.appiconset/
├── SunShadowPadTests/
│   └── SolarAndShadowTests.swift
├── Docs/
│   └── SunShadowPad_功能UI与代码架构规范.md
├── tools/generate_project.py
└── README.md
```

核心服务之间的依赖方向：

```
Scene UI --> SwiftData StoredScene --> Codable SceneDocument
   |                                      |
   |                                      +--> SolarPositionEngine
   |                                      +--> ShadowGeometryEngine
   +--> Simulator UI --> dynamic Canvas & computed sun
   +--> Timeline UI  --> ExposureAnalysisEngine --> Sun / Shadow
   +--> Compare UI   --> ScenarioComparisonService --> Exposure
   +--> Settings UI  --> ProjectBackupService
   +--> Export UI    --> ReportExportService --> Scene + Exposure
```

太阳引擎、阴影引擎、曝光分析器设计成无全局状态的静态纯函数。可不启动 UI 而直接进行核心算法验证。耗时的全场采样在 Timeline/Compare 中通过 `Task.detached(priority: .userInitiated)` 在后台线程执行，任务过期时检查 cancellation，避免快速切换场景时将旧结果覆盖新结果。

---

## 11. 关键数据流与状态同步

### 11.1 建场景

`ScenesView.addScene()` → `SceneDocument.blank()` → `StoredScene(document:)` → `ModelContext.insert/save()` → `SceneEditorView(record:)` → 用户改动 `@State document` → `record.update(with:)` → `context.save()`。

### 11.2 模拟

`WorkspaceState.selectedSceneID` → 找到 `StoredScene` → 解码 `SceneDocument` → 从 local day + minute 构造真实 `Date` → `SolarPositionEngine.position` → `ShadowGeometryEngine.shadowPolygons` → `SceneCanvasView` 同帧绘制。导出 PNG 读取同一 scene/moment。

### 11.3 曝光分析

`sceneID + updatedAt + date + targetID + stepMinutes + columns` 生成刷新标识 → 生成后台分析任务 → 返回 `ExposureResult` → Day/Heatmap 重新绘制 → PDF 使用该同一结果。

### 11.4 对比

`sameSite()` 验证经纬度、时区、场地宽高、北向 → A/B 共用日期 → 分别运行 `ExposureAnalysisEngine` → `ScenarioDifference` 汇总目标或场地平均值与网格小时差 → Compare 页面 + 可选 PDF 第三页。

---

## 12. UI 与技术验收用例

### 12.1 常规体验

| 编号 | 操作 | 预期 |
|---|---|---|
| UI-01 | 首次启动，Skip | 进入 Scenes 且看到三个不同的可编辑项目 |
| UI-02 | 新建场景，修改经纬度时区 | 保存后重启，参数持久保留 |
| UI-03 | 添加 2m 高墙、拖动、数值改高 | 画布中物体新位置/影子立即同步 |
| UI-04 | 点击 Undo / Redo | 撤销与重做添加/移动/删除类事务 |
| UI-05 | 在 Simulator 拖动时间到午夜 | 夜间无直射阴影，太阳高度为负 |
| UI-06 | 在 Timeline 中选择菜畦 | 目标日照小时与目标阈值判断有值 |
| UI-07 | 修改墙体位置后返回 Timeline | 同一场景的时数按新几何重新计算 |
| UI-08 | 复制布局并编辑 | 两个场景可比较且原场景不受修改影响 |
| UI-09 | 导出 PDF、PNG 和 JSON | 系统文件保存窗口可使用，导出文件可读取 |
| UI-10 | 导入 JSON 到有同 UUID 的设备 | 出现复制项目而非覆盖旧项目 |
| UI-11 | 在 Backup & Data 删除全部 | SwiftData 删除成功；下次启动不重新种入样例 |
| UI-12 | 关闭网络访问权限或启用飞行模式 | 编辑、模拟、统计、导入导出仍可用 |
| UI-13 | 设置 24-hour/12-hour 与 m/ft | 时间标签和模拟器影长按选项显示 |
| UI-14 | 点击非输入区域 | 软键盘收起，场景操作仍可进行 |

### 12.2 计算边界

- 2026 夏至伦敦太阳正午高度合理，正午太阳方位近南；夜间小于零。
- 赤道春分附近正午太阳高度高。
- 英国 DST 春季日长 23 h、秋季日长 25 h。
- 78°N 夏至极昼、冬至极夜：不得显示虚构日出/日落。
- 0 高度物体不应生成面积阴影；负尺寸与非数字值应在导入/编辑校验中拒绝。
- 阴影长于画布时绘制区域裁剪；重叠阴影统计不叠加重复计数。
- 不同北向旋转对应阴影方位改变，但不改变太阳高度与理论直接日照物理本质。
- 为面积目标求空间平均，不可用单中心值替换。
- 短时间采样 5/10/15 分钟与 12/18/24/30 列网格结果存在合理收敛性。

### 12.3 项目当前已执行的静态验证

开发容器是 **Linux**，没有 `xcodebuild`、iOS SDK 和 iPhone Simulator。因此已经使用 Linux Swift 6.2.1 执行：

- `swiftc -frontend -parse`：全部 Swift 文件语法解析通过。
- `swiftc -typecheck`：不依赖 SwiftUI/UIKit 的模型和算法服务通过类型检查。
- 核心引擎可执行验证：伦敦夏至 12:00 UTC 得高度角约 61.94°；返回有效的日出日落和非零网格日照。
- `Calendar` 验证：伦敦 2026-03-29 日长 23 h；2026-10-25 日长 25 h。
- 极昼极夜：78°N 夏至/冬至正确返回全天明亮/全天黑暗。
- Xcode `.pbxproj` 与 `Info.plist` 经过 `plutil` 结构验证。

**尚未完成**：macOS Xcode 的完整 App target 编译、iPhone Simulator 启动、真实设备触控/文件导出、截图检查与 App Store 审核。这些验收必须在 Mac 上完成，不能把 Linux 静态检查说成 Xcode 实际构建成功。

---

## 13. 发布前 App Store 准备要求

以下与 App Store Review Guidelines 核心条款对齐，但不构成通过审核保证：

1. **2.1 App Completeness**：确认没有崩溃、空功能、不可用链接；真实手机测试场景创建、删除、导出、恢复、后台切前台。每个二级页面是独立 Swift 源文件，不是点击后留白。
2. **4.2 Minimum Functionality**：实际可编辑几何、阴影模型、日照统计、布局差异与报告是核心实用价值；不是网页套壳，也不是单纯显示太阳角度。
3. **5.1 Privacy**：不请求定位、不登录、不集成第三方分析追踪。商店元数据必须填写可公开访问的**真实隐私政策 URL**；App 内已经提供可阅读的政策正文。要求支持网址和必要联系信息真实有效。
4. **4.1 Copycats / 4.3 Spam**：坚持“离线建模 + 可编辑种植区 + 前后数值比较 + 本地报告”差异化，不复制已有产品的商标、图标和截图。
5. **版权与图标**：图标是本工程专用的原创生成资产；使用前建议开发者再次核查其商用授权及与已存在图标的相似性。
6. **签名与标识**：本工程 `com.sunshadowpad.local` 是开发用 bundle identifier，并不是已注册的真实发行主体。上架前必须替换为开发者账户拥有且唯一的 ID，并设置开发者 Team。
7. **截图与描述**：App Store 截图必须来自构建运行的真实界面；描述中的每个功能都应由该发行版实现；不得承诺天气预报、建筑认证或未来功能。
8. **No account / No push / No IAP**：无需登录；项目里不包含推送、通知、广告网络、支付、内购或 App Tracking Transparency 请求。

Apple 官方参考：

- https://developer.apple.com/app-store/review/guidelines/
- https://developer.apple.com/documentation/swiftdata
- https://gml.noaa.gov/grad/solcalc/solareqns.PDF
- https://www.gml.noaa.gov/grad/solcalc/calcdetails.html

---

## 14. 源码当前实现范围与版本边界

### V1.0 已编码的能力

- 完整 SwiftUI 四 Tab 导航及引导页。
- 三套可修改样例、场景新增/编辑/复制/收藏/归档/删除/列表筛选。
- 场景属性与经纬度、IANA 时区、北向、尺寸设置。
- 七种不透明障碍物模型、六种观测目标、矩形规划区域、选择/拖动/缩放、数值参数表单与图层入口。
- 几何太阳高度/方位、时区日界处理、极昼极夜、阴影绘制。
- 动画时间轴、太阳事件快捷跳转、阴影长度指标、目标点遮挡解释。
- 单日点/区域曝光、全天图条、空间热力图、12 个代表日季节柱状图。
- 相同场地的布局 A/B 对比与空间增减日照图。
- JSON 单个/全部导入导出，PNG 画布，2 页报告 PDF，以及可选第 3 页对比。
- Settings 五个独立二级页面：About Us、User Agreement、Privacy Policy、Use Help、Feedback & Suggestions，另有 Backup & Data。
- 无联网依赖、无登录、无推送、无通知、无内购。

### V1.1 / V2.0 才建议加入（此 ZIP 不声称已经实现）

- 多边形自由绘制与控制点编辑、群组/图层排序、吸附/参考线、背景图比例校准、复杂形状组合。
- 树叶透光率、栅栏镂空、百叶窗细节、复杂屋顶、地形和三维阴影引擎。
- 全年逐日统计、更细粒度时间误差控制与 NREL SPA 高精度太阳位置算法校验。
- 图形差分连续轮廓、区域任意点查询、更多导出模板、交互性能缓存。
- AR 摄像头太阳轨迹、第三方地图或远程卫星影像。此类增强会改变权限和隐私审查范围，须重新评估后再做。

---

## 15. 推荐 Codex 后续迭代顺序

1. 在 Mac 上打开工程，使用 iOS 17+ Simulator 执行 `Cmd+B`。首先修复 Xcode / SwiftUI 特定的实际编译报错（如有）；不要先扩展产品功能。
2. 运行 `SunShadowPadTests`，对照 NOAA 与另一个独立基准核验春秋分、极昼极夜、DST、太阳正午结果。
3. 真机走通一整条核心路径：新建庭院 → 加 2m 围墙 → 加 6h 菜圃 → 上午到下午滑动 → 改高到 3m → 查看热力差异 → 复制布局 → 比较 → PDF/JSON 导出。
4. 特别检查 iPhone 小屏幕中 Simulator 的长场景名、Time panel、三指标横排与英文文案截断；可根据真机截图微调触控区域。
5. 补强导入校验、编辑属性防负值、精细季节时间线缓存，记录 App Store 元数据所需的测试证据。
6. 发行前以真实开发者身份、Bundle ID、支持 URL、隐私 URL 完成签名、归档、上架材料。

---

## 16. 交付物说明

本交付同时包含：

- 可打开的 `SunShadowPad.xcodeproj`，通过普通 PBXGroup 持有全部 31 个 App Swift 文件与 XCTest target。
- 完整模型/Services/UI/Settings Swift 源代码和可实际编译所需的资源 `Info.plist`、AppIcon asset catalog。
- SwiftData 场景持久化、初始样例、JSON/PDF/PNG 导出逻辑。
- XCTest 算法用例、说明文档及可重复生成 `.xcodeproj` 的脚本。

**交付定义**：真实 Xcode 工程源码 + 可运行的算法核心 + 架构规范，而**不是**声称已经在 Linux 编译成 iOS `.app` 或已经通过 Apple 审核。若 Xcode 真机测试发现额外兼容问题，须以苹果开发工具的实际构建日志为准修复。
