import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../utils/responsive_helper.dart';
import '../models/data.dart';

class OutfitIdea {
  final String image;
  final String tag;
  final String title;
  final String description;
  final String scene;
  final String style;
  final List<String> items;
  final String tips;

  OutfitIdea({
    required this.image,
    required this.tag,
    required this.title,
    required this.description,
    this.scene = '',
    this.style = '',
    this.items = const [],
    this.tips = '',
  });
}

final List<OutfitIdea> outfitIdeas = [
  OutfitIdea(
    image: 'assets/dapei/dapei_01.png',
    tag: '雅痞休闲',
    title: '灰色休闲西装 + 黑色T恤',
    description: '雅痞范十足的酒吧穿搭，简约不失格调',
    scene: '酒吧 / 聚会',
    style: '雅痞风',
    items: ['灰色休闲西装', '黑色圆领T恤', '深色休闲裤', '皮鞋'],
    tips: '西装选择修身但不紧身的版型，T恤选纯棉质感更好',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_02.png',
    tag: '初秋日常',
    title: '灯芯绒外套 + 白色高领',
    description: '银杏树下的温暖质感，初秋必备穿搭',
    scene: '日常 / 约会',
    style: '温柔风',
    items: ['浅棕灯芯绒外套', '白色高领打底衫', '深色半身裙', '短靴'],
    tips: '灯芯绒材质自带复古感，搭配高领衫更显气质',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_03.png',
    tag: '高级极简',
    title: '黑色V领连衣裙',
    description: '会议室里的优雅力量，极简美学典范',
    scene: '职场 / 会议',
    style: '极简风',
    items: ['黑色V领连衣裙', '尖头高跟鞋', '简约手表'],
    tips: '剪裁是关键，选择垂坠感好的面料更显高级',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_04.png',
    tag: '海岛度假',
    title: '亚麻衬衫 + 牛仔短裤',
    description: '海边度假的清爽公式，自在又时尚',
    scene: '度假 / 海边',
    style: '度假风',
    items: ['白色亚麻衬衫', '牛仔短裤', '草编包', '凉鞋'],
    tips: '亚麻衬衫下摆打结更显比例，透气又防晒',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_05.png',
    tag: '极简Cityboy',
    title: '白色半高领T恤',
    description: '一杯咖啡一件白T，Cityboy的极简哲学',
    scene: '咖啡店 / 逛街',
    style: '极简风',
    items: ['白色半高领T恤', '宽松休闲裤', '帆布鞋'],
    tips: '版型要宽松但不邋遢，面料选重磅棉更有质感',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_06.png',
    tag: '互联网休闲',
    title: '浅蓝条纹牛津纺衬衫',
    description: '互联网人的舒适与专业并存',
    scene: '办公室 / 通勤',
    style: '休闲商务',
    items: ['浅蓝条纹牛津纺衬衫', '卡其色休闲裤', '小白鞋'],
    tips: '下摆半塞更显腿长，袖子卷起更利落',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_07.png',
    tag: '秋冬暖男',
    title: '北欧风粗绞花毛衣',
    description: '咖啡店里的秋冬温暖穿搭',
    scene: '咖啡店 / 约会',
    style: '暖男风',
    items: ['米色粗绞花毛衣', '深咖色休闲裤', '皮质休闲鞋'],
    tips: '粗绞花毛衣自带温暖感，搭配深色裤子平衡视觉',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_08.png',
    tag: '日系盐系',
    title: '藏青色半高领T恤',
    description: '书店里的文艺盐系穿搭',
    scene: '书店 / 文艺',
    style: '盐系风',
    items: ['藏青色半高领T恤', '宽松阔腿裤', '帆布鞋', '帆布包'],
    tips: '盐系穿搭重在干净清爽，颜色不超过三种',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_09.png',
    tag: '冬日氛围',
    title: '深灰羊毛大衣',
    description: '冬日阳台的温暖穿搭灵感',
    scene: '日常 / 通勤',
    style: '绅士风',
    items: ['深灰羊毛大衣', '灰色圆领毛衣', '深色西裤', '皮鞋'],
    tips: '羊毛大衣长度过膝更显气场，内搭同色系更高级',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_10.png',
    tag: '晚间散步',
    title: 'Oversize连帽卫衣',
    description: '江边夜步的自在穿搭',
    scene: '运动 / 休闲',
    style: '运动休闲',
    items: ['深色连帽卫衣', '运动裤', '运动鞋'],
    tips: 'Oversize卫衣选落肩款更慵懒，搭配束脚裤显比例',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_11.png',
    tag: '滑板少年',
    title: '印花T恤 + 阔腿牛仔裤',
    description: '滑板公园的街头穿搭',
    scene: '街头 / 运动',
    style: '街头风',
    items: ['印花T恤', '水洗做旧阔腿牛仔裤', '滑板鞋'],
    tips: '阔腿裤选高腰款，搭配短款上衣更显腿长',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_12.png',
    tag: '夏日办公',
    title: '浅蓝短袖衬衫',
    description: '夏日会议室的清爽职场穿搭',
    scene: '办公室 / 会议',
    style: '商务休闲',
    items: ['浅蓝短袖衬衫', '深灰西装长裤', '皮鞋'],
    tips: '短袖衬衫选挺括面料，避免软塌没精神',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_13.png',
    tag: '复古美式',
    title: '水洗牛仔夹克',
    description: '机车旁的复古美式穿搭',
    scene: '户外 / 骑行',
    style: '复古风',
    items: ['水洗蓝牛仔夹克', '白色印花T恤', '工装裤', '马丁靴'],
    tips: '牛仔夹克选做旧款更有味道，内搭白T最经典',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_14.png',
    tag: '复古街头',
    title: 'Oversize做旧皮夹克',
    description: '城市街头的酷感穿搭',
    scene: '街头 / 拍照',
    style: '复古街头',
    items: ['做旧皮夹克', '黑色打底衫', '破洞牛仔裤', '马丁靴'],
    tips: '皮夹克选Oversize款更街头，做旧质感更自然',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_15.png',
    tag: '痞帅机车',
    title: '棕色皮质飞行员夹克',
    description: '跑车旁的痞帅穿搭',
    scene: '户外 / 机车',
    style: '机车风',
    items: ['棕色皮飞行员夹克', '黑色高领毛衣', '黑色休闲裤', '皮靴'],
    tips: '飞行员夹克选皮质款更硬朗，内搭高领更显层次',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_16.png',
    tag: '公园野餐',
    title: '法式碎花连衣裙',
    description: '公园野餐的浪漫穿搭',
    scene: '野餐 / 约会',
    style: '法式风',
    items: ['碎花吊带连衣裙', '草编帽', '编织包', '平底凉鞋'],
    tips: '碎花选小碎花更法式，方领泡泡袖更显身材',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_17.png',
    tag: '居家慵懒',
    title: '浅灰针织家居服',
    description: '周末居家的慵懒穿搭',
    scene: '居家 / 休闲',
    style: '慵懒风',
    items: ['浅灰针织家居服套装', '毛绒拖鞋'],
    tips: '家居服选纯棉针织更舒适，颜色选浅色系更温馨',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_18.png',
    tag: '工装机能',
    title: '军绿工装裤 + 印花T恤',
    description: '酷帅机能风穿搭',
    scene: '街头 / 户外',
    style: '工装机能',
    items: ['印花T恤', '军绿工装裤', '运动鞋', '斜挎包'],
    tips: '工装裤口袋不要太多，2-4个最实用',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_19.png',
    tag: '互联网风',
    title: '摇粒绒马甲 + 浅蓝衬衫',
    description: '工位实用穿搭',
    scene: '办公室 / 工位',
    style: '实用风',
    items: ['深色摇粒绒马甲', '浅蓝衬衫', '休闲裤', '运动鞋'],
    tips: '摇粒绒马甲保暖又方便敲键盘，互联网人必备',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_20.png',
    tag: '温柔韩系',
    title: '米色粗针织毛衣',
    description: '咖啡馆里的韩系温柔穿搭',
    scene: '咖啡馆 / 约会',
    style: '韩系风',
    items: ['米色粗针织毛衣', '百褶超短裙', '长筒靴'],
    tips: '粗针织毛衣选宽松款，搭配短裙平衡厚重感',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_21.png',
    tag: '温柔知性',
    title: '杏色V领开衫',
    description: '图书馆的知性穿搭灵感',
    scene: '图书馆 / 办公',
    style: '知性风',
    items: ['杏色V领开衫', '深棕百褶裙', '乐福鞋'],
    tips: 'V领开衫内搭衬衫更知性，颜色选大地色系',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_22.png',
    tag: '清新春日',
    title: '碎花裙 + 牛仔夹克',
    description: '春日公园的清新穿搭',
    scene: '公园 / 郊游',
    style: '清新风',
    items: ['碎花吊带连衣裙', '浅蓝牛仔夹克', '小白鞋'],
    tips: '碎花裙外搭牛仔夹克，甜酷平衡刚刚好',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_23.png',
    tag: '周末咖啡馆',
    title: '粗麻花毛衣 + 碎花裙',
    description: '露天咖啡座的惬意穿搭',
    scene: '咖啡馆 / 周末',
    style: '温柔风',
    items: ['米色粗麻花毛衣', '碎花半身裙', '短靴'],
    tips: '粗麻花毛衣有分量感，搭配轻盈碎花裙更平衡',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_24.png',
    tag: '雅痞轻熟',
    title: '灰色休闲西装',
    description: '商务区的轻熟雅痞穿搭',
    scene: '商务区 / 通勤',
    style: '轻熟风',
    items: ['灰色休闲西装', '白色T恤', '休闲西裤', '皮鞋'],
    tips: '休闲西装内搭T恤更年轻，避免太正式',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_25.png',
    tag: '商务出差',
    title: '抗皱风衣 + 藏青Polo',
    description: '机场候机的商务穿搭',
    scene: '机场 / 出差',
    style: '商务风',
    items: ['抗皱风衣', '藏青色Polo衫', '休闲西裤', '乐福鞋'],
    tips: '出差选抗皱面料，下飞机依然体面',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_26.png',
    tag: '夏日度假',
    title: '印花丝绸衬衫',
    description: '音乐节的夏日度假穿搭',
    scene: '音乐节 / 度假',
    style: '度假风',
    items: ['印花丝绸衬衫', '白色坎肩', '短裤', '凉鞋'],
    tips: '丝绸衬衫敞开穿更洒脱，内搭白T防走光',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_27.png',
    tag: '创意行业',
    title: 'Oversize黑色西装',
    description: '设计工作室的创意穿搭',
    scene: '工作室 / 创意',
    style: '创意风',
    items: ['Oversize黑色西装', '黑色打底衫', '休闲裤', '设计感鞋履'],
    tips: '创意行业穿搭可以更大胆，Oversize西装是利器',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_28.png',
    tag: '周五半正式',
    title: '粗花呢外套 + 真丝吊带',
    description: '周五Smart Casual穿搭',
    scene: '办公室 / 聚餐',
    style: '半正式',
    items: ['粗花呢外套', '白色真丝吊带裙', '高跟鞋'],
    tips: '周五可以稍微放松，粗花呢+真丝精致不刻板',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_29.png',
    tag: '法式职场',
    title: '米色双排扣风衣',
    description: '通勤路上的法式优雅穿搭',
    scene: '通勤 / 职场',
    style: '法式风',
    items: ['米色双排扣风衣', '黑色高领针织衫', '直筒裤', '短靴'],
    tips: '法式风衣选双排扣更经典，长度过膝最佳',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_30.png',
    tag: '滑板街头',
    title: '黑色连帽卫衣',
    description: '滑板场的街头酷感穿搭',
    scene: '滑板场 / 街头',
    style: '街头风',
    items: ['黑色连帽卫衣', '水洗做旧阔腿牛仔裤', '滑板鞋'],
    tips: '黑色卫衣百搭，搭配做旧牛仔裤更有街头感',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_31.png',
    tag: '商场购物',
    title: '针织短袖 + 高腰牛仔裙',
    description: '商场逛街的活力穿搭',
    scene: '商场 / 购物',
    style: '活力风',
    items: ['修身针织短袖', '高腰A字牛仔裙', '小白鞋'],
    tips: '高腰裙显腿长，逛街舒适又好看',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_32.png',
    tag: '运动休闲',
    title: '黑色防风运动套装',
    description: '天台的利落运动穿搭',
    scene: '运动 / 天台',
    style: '运动风',
    items: ['黑色防风外套', '同款运动裤', '白色运动鞋'],
    tips: '运动套装选同色系更利落，防风面料实用',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_33.png',
    tag: '运动高街',
    title: '拼色防风外套 + 束脚裤',
    description: '地铁站的运动高街穿搭',
    scene: '通勤 / 街头',
    style: '运动高街',
    items: ['拼色防风外套', '黑色束脚裤', '厚底运动鞋'],
    tips: '拼色外套是亮点，束脚裤显腿型',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_34.png',
    tag: '干练商务',
    title: '深灰西服套装 + 白衬衫',
    description: '写字楼的专业气场穿搭',
    scene: '写字楼 / 商务',
    style: '商务风',
    items: ['深灰西服套装', '白色衬衫', '尖头高跟鞋'],
    tips: '西服套装选合身剪裁，白衬衫是最安全的选择',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_35.png',
    tag: '老钱风职场',
    title: '米色羊毛开衫 + 牛津纺衬衫',
    description: '写字楼大堂的低调奢华',
    scene: '写字楼 / 职场',
    style: '老钱风',
    items: ['米色羊毛开衫', '白色牛津纺衬衫', '卡其裤', '乐福鞋'],
    tips: '老钱风重在质感，面料和剪裁比款式更重要',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_36.png',
    tag: '运动混搭',
    title: '黑色短款夹克 + 瑜伽裤',
    description: '健身房出来的时尚穿搭',
    scene: '健身房 / 街头',
    style: '运动混搭',
    items: ['黑色短款防风夹克', '深灰瑜伽裤', '运动鞋'],
    tips: '短款夹克+瑜伽裤，运动风也能很时尚',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_37.png',
    tag: '现代商务',
    title: '藏青色西装 + 白衬衫',
    description: '办公室的经典商务穿搭',
    scene: '办公室 / 商务',
    style: '商务风',
    items: ['藏青色西装', '白色正装衬衫', '西裤', '皮鞋'],
    tips: '藏青西装是职场标配，合身比品牌更重要',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_38.png',
    tag: '创意总监',
    title: '深棕灯芯绒衬衫',
    description: '设计公司的质感穿搭',
    scene: '设计公司 / 创意',
    style: '创意风',
    items: ['深棕灯芯绒衬衫', '白色打底T恤', '休闲裤', '皮质休闲鞋'],
    tips: '灯芯绒衬衫敞开穿更有层次，质感满分',
  ),
  OutfitIdea(
    image: 'assets/dapei/dapei_39.png',
    tag: '复古学院',
    title: '菱格纹针织开衫 + 白衬衫',
    description: '书店里的文艺穿搭',
    scene: '书店 / 文艺',
    style: '学院风',
    items: ['菱格纹针织开衫', '白色衬衫', '休闲裤', '帆布鞋'],
    tips: '菱格纹开衫是学院风经典单品，搭配衬衫更斯文',
  ),
];

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String _selectedCategory = '全部';

  final List<String> _allCategories = [
    '全部',
    '职场通勤',
    '休闲日常',
    '运动街头',
    '度假约会',
    '创意文艺',
  ];

  Map<String, List<String>> get _categoryMap => {
    '职场通勤': ['高级极简', '夏日办公', '干练商务', '现代商务', '老钱风职场', '法式职场', '商务出差', '周五半正式', '互联网休闲', '互联网风', '雅痞轻熟'],
    '休闲日常': ['雅痞休闲', '初秋日常', '极简Cityboy', '秋冬暖男', '日系盐系', '冬日氛围', '晚间散步', '居家慵懒', '周末咖啡馆', '温柔韩系', '温柔知性', '商场购物'],
    '运动街头': ['滑板少年', '复古街头', '滑板街头', '运动休闲', '运动高街', '运动混搭', '工装机能'],
    '度假约会': ['海岛度假', '公园野餐', '清新春日', '夏日度假', '复古美式', '痞帅机车'],
    '创意文艺': ['创意行业', '创意总监', '复古学院'],
  };

  List<OutfitIdea> get _filteredIdeas {
    if (_selectedCategory == '全部') return outfitIdeas;
    final tags = _categoryMap[_selectedCategory] ?? [];
    return outfitIdeas.where((idea) => tags.contains(idea.tag)).toList();
  }

  Future<void> _toggleFavorite(int index) async {
    await AppState.instance.toggleOutfitFavorite(index);
    if (mounted) setState(() {});
  }

  void _showDetail(OutfitIdea idea, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OutfitDetailSheet(
        idea: idea,
        isFavorite: AppState.instance.isOutfitFavorite(index),
        onToggleFavorite: () => _toggleFavorite(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryChips(),
          Expanded(
            child: _buildGridView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final scale = ResponsiveHelper.getScaleFactor(context);
    final padding = ResponsiveHelper.responsivePadding(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16 * scale),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundLight,
            Color(0xFFF3E8FF),
            Color(0xFFE8F4FD),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * scale,
                vertical: 8 * scale,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.gradientPinkStart,
                    AppColors.gradientPinkEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientPinkStart.withOpacity(0.3),
                    blurRadius: 10 * scale,
                    offset: Offset(0, 3 * scale),
                  ),
                ],
              ),
              child: Text(
                '穿搭创意',
                style: TextStyle(
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scale,
                vertical: 6 * scale,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, size: 16 * scale, color: Colors.pink.shade400),
                  SizedBox(width: 4 * scale),
                  Text(
                    '${AppState.instance.favoriteCount}',
                    style: TextStyle(
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink.shade400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8 * scale),
            Text(
              '${outfitIdeas.length} 套搭配',
              style: TextStyle(
                fontSize: 14 * scale,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _allCategories.map((category) {
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [
                              AppColors.gradientPurpleStart,
                              AppColors.gradientPurpleEnd,
                            ],
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.gradientPurpleStart
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    final ideas = _filteredIdeas;

    if (ideas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.style_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              '暂无该分类的穿搭创意',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: ideas.length,
      itemBuilder: (context, index) {
        final idea = ideas[index];
        final globalIndex = outfitIdeas.indexOf(idea);
        final isFavorite = AppState.instance.isOutfitFavorite(globalIndex);
        return GestureDetector(
          onTap: () => _showDetail(idea, globalIndex),
          child: _OutfitCardWidget(
            idea: idea,
            globalIndex: globalIndex,
            isFavorite: isFavorite,
            onToggleFavorite: () => _toggleFavorite(globalIndex),
          ),
        );
      },
    );
  }

}

class _OutfitCardWidget extends StatefulWidget {
  final OutfitIdea idea;
  final int globalIndex;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _OutfitCardWidget({
    required this.idea,
    required this.globalIndex,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<_OutfitCardWidget> createState() => _OutfitCardWidgetState();
}

class _OutfitCardWidgetState extends State<_OutfitCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_likeController);
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_OutfitCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite && widget.isFavorite) {
      _likeController.forward(from: 0);
    }
  }

  void _handleFavorite(TapDownDetails details) {
    _likeController.forward(from: 0);
    widget.onToggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Image.asset(
                    widget.idea.image,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientPinkStart,
                        AppColors.gradientPinkEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.idea.tag,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTapDown: _handleFavorite,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: widget.isFavorite ? _scaleAnimation.value : 1.0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: widget.isFavorite
                                ? Colors.pink
                                : Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.idea.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      widget.idea.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutfitDetailSheet extends StatefulWidget {
  final OutfitIdea idea;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _OutfitDetailSheet({
    required this.idea,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<_OutfitDetailSheet> createState() => _OutfitDetailSheetState();
}

class _OutfitDetailSheetState extends State<_OutfitDetailSheet>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _likeController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_likeController);
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_OutfitDetailSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      _isFavorite = widget.isFavorite;
    }
  }

  void _handleToggleFavorite() {
    _likeController.forward(from: 0);
    widget.onToggleFavorite();
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      widget.idea.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.gradientPinkStart,
                              AppColors.gradientPinkEnd,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.idea.tag,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (widget.idea.style.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gradientPurpleStart.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.gradientPurpleStart.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            widget.idea.style,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.gradientPurpleStart,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _handleToggleFavorite,
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isFavorite ? _scaleAnimation.value : 1.0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _isFavorite
                                      ? Colors.pink.shade50
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 20,
                                  color: _isFavorite
                                      ? Colors.pink
                                      : Colors.grey.shade600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.idea.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.idea.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.idea.scene.isNotEmpty) ...[
                    _buildSectionTitle('适用场景'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.place_outlined, size: 18, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            widget.idea.scene,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.idea.items.isNotEmpty) ...[
                    _buildSectionTitle('搭配单品'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.idea.items.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.idea.tips.isNotEmpty) ...[
                    _buildSectionTitle('穿搭技巧'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gradientPurpleStart.withOpacity(0.05),
                            AppColors.gradientPinkStart.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.gradientPurpleStart.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, size: 18, color: AppColors.gradientPurpleStart),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.idea.tips,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.gradientPurpleStart,
                AppColors.gradientPinkStart,
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
      ],
    );
  }
}
