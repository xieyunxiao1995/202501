import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/user_model.dart';
import 'creator_profile_screen.dart';

/// 达人露营分享界面 - 类似微信朋友圈/微博的社交分享界面
class ExpertCampingScreen extends StatefulWidget {
  const ExpertCampingScreen({super.key});

  @override
  State<ExpertCampingScreen> createState() => _ExpertCampingScreenState();
}

class _ExpertCampingScreenState extends State<ExpertCampingScreen> {
  final ScrollController _scrollController = ScrollController();
  final DataService _dataService = DataService();
  List<CampingPost> _campingPosts = [];

  @override
  void initState() {
    super.initState();
    _loadCampingPosts();
  }

  void _loadCampingPosts() {
    final users = _dataService.getUsers();
    final campingPhotos = [
      'assets/ly/15631764000831_.pic_hd.jpg',
      'assets/ly/15641764000832_.pic_hd.jpg',
      'assets/ly/15651764000833_.pic_hd.jpg',
      'assets/ly/15661764000834_.pic_hd.jpg',
      'assets/ly/15671764000835_.pic_hd.jpg',
      'assets/ly/15681764000836_.pic_hd.jpg',
      'assets/ly/15691764000837_.pic_hd.jpg',
      'assets/ly/15701764000838_.pic_hd.jpg',
      'assets/ly/15711764000839_.pic_hd.jpg',
      'assets/ly/15721764000840_.pic_hd.jpg',
      'assets/ly/15731764000841_.pic_hd.jpg',
      'assets/ly/15741764000842_.pic_hd.jpg',
      'assets/ly/15751764000843_.pic_hd.jpg',
      'assets/ly/15761764000844_.pic_hd.jpg',
      'assets/ly/15771764000845_.pic_hd.jpg',
      'assets/ly/15781764000846_.pic_hd.jpg',
      'assets/ly/15791764000847_.pic_hd.jpg',
      'assets/ly/15801764000848_.pic_hd.jpg',
      'assets/ly/15811764000849_.pic_hd.jpg',
      'assets/ly/15821764000850_.pic_hd.jpg',
      'assets/ly/15831764000851_.pic_hd.jpg',
      'assets/ly/15841764000853_.pic_hd.jpg',
      'assets/ly/15851764000854_.pic_hd.jpg',
      'assets/ly/15861764000855_.pic_hd.jpg',
      'assets/ly/15871764000856_.pic_hd.jpg',
      'assets/ly/15881764000857_.pic_hd.jpg',
      'assets/ly/15891764000858_.pic_hd.jpg',
      'assets/ly/15901764000859_.pic_hd.jpg',
      'assets/ly/15911764000860_.pic_hd.jpg',
      'assets/ly/15921764000861_.pic_hd.jpg',
      'assets/ly/15931764000862_.pic_hd.jpg',
    ];

    final locations = [
      '云南·香格里拉',
      '四川·稻城亚丁',
      '新疆·喀纳斯',
      '贵州·梵净山',
      '青海·青海湖',
      '内蒙古·响沙湾',
      '西藏·纳木错',
      '海南·三亚',
      '内蒙古·呼伦贝尔',
      '陕西·华山',
      '甘肃·张掖',
      '湖南·张家界',
      '广西·桂林',
      '福建·武夷山',
      '江西·庐山',
      '安徽·黄山',
      '山东·泰山',
      '河南·嵩山',
      '山西·五台山',
      '辽宁·千山',
      '吉林·长白山',
      '黑龙江·大兴安岭',
      '浙江·天目山',
      '江苏·紫金山',
      '上海·佘山',
      '重庆·武隆',
      '四川·九寨沟',
      '云南·大理',
      '贵州·黄果树',
      '广东·丹霞山',
      '台湾·阿里山',
    ];

    final campingContents = [
      '🏕️ 独自在深山中度过了完美的周末。清晨的阳光透过帐篷，听着鸟儿的歌声醒来，这就是我想要的生活。装备不在于价格，而在于合适。',
      '⛺ 这次带了新的装备配置出来测试！MSR的帐篷在恶劣天气下表现出色，值得推荐给大家。野外生存最重要的是准备充分。',
      '🌅 凌晨4点起床就是为了这一刻！山间日出的壮丽景色让所有的辛苦都值得了。篝火旁的故事总是最动人的。',
      '🍳 今晚用铸铁锅做了完美的牛排！户外烹饪的乐趣在于用简单的工具创造美味。分享一个小贴士：记得让牛排回到室温再下锅。',
      '🌲 今天在森林里越野跑了15公里，然后在这个隐秘的地方扎营。在迷失中找到自己，这就是森林的魅力。',
      '✨ 谁说露营不能奢华？精心布置的营地，舒适的床品，还有香槟配日落。奢华与野性的完美结合！',
      '🌌 找到了一个完美的暗夜观星营地！银河清晰可见，流星划过天际。这里的光污染几乎为零，天文爱好者的天堂！',
      '🎒 这次测试了几款超轻量装备，总重量控制在8公斤以内。科技的进步让我们能够更轻松地享受户外生活。详细测评稍后发布！',
      '🚣 湖边露营+皮划艇，完美的组合！清晨在湖面上划行，看着太阳从山后升起，这种宁静无法用言语形容。',
      '❄️ -15°C的夜晚，但是看到这样的雪景，一切都值得！雪地露营需要更多的准备和经验，但回报是无与伦比的美景。',
      '🏃‍♂️ 开辟了一条新的徒步路线！虽然路途艰险，但发现了这个绝美的露营地。探险的乐趣就在于未知的惊喜。',
      '👨‍👩‍👧‍👦 带着全家人来露营，孩子们第一次看到满天繁星，那种兴奋和好奇让我想起了自己的童年。家庭露营的美好回忆。',
      '🎒 超轻量装备测试完成！这次背包总重量只有6.5公斤，证明了少即是多的理念。每一克都很重要。',
      '🏖️ 海滩露营有着独特的魅力，听着海浪声入睡，看着日出从海平面升起。记得做好防风措施！',
      '📷 用胶片相机记录下了这些珍贵的瞬间。复古装备配上经典的露营体验，时光仿佛倒流。',
      '💪 独自带娃露营的挑战完成！证明了妈妈们也可以征服户外。给所有勇敢的妈妈们点赞！',
      '🏜️ 沙漠露营是完全不同的体验！白天炎热，夜晚寒冷，但是沙漠的日落和星空绝对值得！记得多带水。',
      '📸 今天拍到了完美的露营照片！光线、构图、时机都恰到好处。摄影和露营的完美结合。',
      '🎣 钓鱼+露营的完美组合！今天收获满满，晚餐就是新鲜的鱼汤。大自然的馈赠最珍贵。',
      '🚐 房车生活第100天！家就是我停车的地方，自由就是我想要的生活方式。',
      '🚴‍♂️ 骑行50公里后在这里扎营，脚踏动力的旅行让每一个目的地都更有意义。',
      '🍄 今天学会了识别几种可食用的野生蘑菇，大自然就是最好的超市。觅食的乐趣无穷。',
      '🌳 吊床露营的第一夜！不需要帐篷，直接睡在树间，感受微风轻抚。这就是自由的感觉。',
      '🧗‍♂️ 攀岩后在山顶露营，征服岩壁的成就感配上星空下的宁静，这就是我要的生活。',
      '🦅 今天观察到了三种珍稀鸟类！为了拍到它们的照片，在这里守候了整整一天。值得！',
      '🏕️ 荒野生存技能又升级了！今天学会了用原始方法生火，技能胜过装备的道理再次得到验证。',
      '🧘‍♀️ 在大自然中练瑜伽，身心都得到了净化。山间的清新空气是最好的能量补充。',
      '🐕 和我最好的朋友一起冒险！狗狗比我更兴奋，它天生就是户外探险家。',
      '🏛️ 在古代遗址旁露营，仿佛能听到历史的回声。文化和自然的完美结合。',
      '✍️ 在荒野中写作，灵感如泉涌。大自然是最好的缪斯女神，每一个故事都值得记录。',
      '🌱 今天教授了一群孩子不留痕迹的露营原则。保护环境从每一次露营开始，教育是最好的传承。',
    ];

    final commentContents = [
      '太美了！这个地方在哪里？',
      '装备清单能分享一下吗？',
      '下次一起去！',
      '景色绝美，羡慕！',
      '这个帐篷是什么牌子的？',
      '安全第一，注意保暖！',
      '拍照技术真棒！',
      '想去同款地点！',
      '经验分享很有用！',
      '大自然太治愈了',
      '专业！学到了',
      '勇敢的冒险家！',
      '家庭露营真温馨',
      '技能满分！',
      '海边露营要注意潮汐',
      '胶片质感真好',
      '独立女性的榜样！',
      '沙漠露营太酷了',
      '摄影大师！',
      '自由的生活方式',
      '骑行+露营完美',
      '野外求生技能',
      '树上睡觉有趣',
      '攀岩高手！',
      '观鸟需要耐心',
      '生存技能学习了',
      '瑜伽+自然很棒',
      '狗狗也很棒！',
      '历史文化很有意思',
      '写作灵感来源',
      '环保意识很重要',
    ];

    // 为所有31位达人创建露营分享内容，每人一张照片
    _campingPosts = [];
    for (int i = 0; i < users.length && i < campingPhotos.length; i++) {
      final user = users[i];
      final hoursAgo = i * 3 + 2; // 每个达人间隔3小时发布

      // 为每个帖子生成2-5条评论
      final commentCount = 2 + (i % 4);
      final postComments = <Comment>[];

      for (int j = 0; j < commentCount; j++) {
        final commentUser = users[(i + j + 1) % users.length]; // 使用不同的用户评论
        postComments.add(
          Comment(
            id: 'comment_${i}_$j',
            user: commentUser,
            content: commentContents[(i + j) % commentContents.length],
            timestamp: DateTime.now().subtract(
              Duration(hours: hoursAgo - j - 1),
            ),
          ),
        );
      }

      _campingPosts.add(
        CampingPost(
          id: (i + 1).toString(),
          user: user,
          campingImages: [campingPhotos[i]], // 每人只分享一张照片
          content:
              '${campingContents[i]} ${user.tags.isNotEmpty ? user.tags.join(' ') : ''}',
          location: locations[i],
          timestamp: DateTime.now().subtract(Duration(hours: hoursAgo)),
          likes: 50 + (i * 17) % 400, // 随机点赞数
          comments: postComments,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.6, 1.0],
            colors: [
              Color(0xFFF8FAFF),
              Color(0xFFEDF4FF),
              Color(0xFFE8F2FF),
              Color(0xFFF0F8FF),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [_buildModernHeader(), _buildCampingFeed()],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '达人露营',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1D29),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '分享精彩露营时光，记录美好户外生活',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.explore_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '露营动态',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1D29),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '发现达人们的精彩露营分享',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${_campingPosts.length}条',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampingFeed() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: ModernCampingPostCard(post: _campingPosts[index]),
          );
        }, childCount: _campingPosts.length),
      ),
    );
  }



  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

/// 评论数据模型
class Comment {
  final String id;
  final User user;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.timestamp,
  });
}

/// 露营分享数据模型
class CampingPost {
  final String id;
  final User user;
  final List<String> campingImages;
  final String content;
  final String location;
  final DateTime timestamp;
  final int likes;
  final List<Comment> comments;

  CampingPost({
    required this.id,
    required this.user,
    required this.campingImages,
    required this.content,
    required this.location,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });
}

/// 露营分享卡片组件
class ModernCampingPostCard extends StatefulWidget {
  final CampingPost post;

  const ModernCampingPostCard({super.key, required this.post});

  @override
  State<ModernCampingPostCard> createState() => _ModernCampingPostCardState();
}

class _ModernCampingPostCardState extends State<ModernCampingPostCard> {
  bool _isLiked = false;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户头部信息
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildModernUserHeader(),
          ),
          // 图片区域
          _buildModernImageSection(),
          // 内容区域
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContent(),
                const SizedBox(height: 12),
                _buildLocation(),
                const SizedBox(height: 16),
                _buildModernActionBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                widget.post.user.avatarUrl ??
                    'assets/tx/15311764000720_.pic_hd.jpg',
              ),
            ),
            if (widget.post.user.isVerified)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 10),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.post.user.displayName ?? widget.post.user.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (widget.post.user.tags.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.post.user.tags.first,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                _formatTimestamp(widget.post.timestamp),
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: Color(0xFF999999)),
          onSelected: (String value) {
            _handleMenuAction(value);
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('删除', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.report_outlined, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text('举报', style: TextStyle(color: Colors.orange)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      widget.post.content,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF333333),
        height: 1.4,
      ),
    );
  }

  Widget _buildImageGrid() {
    final images = widget.post.campingImages;
    if (images.isEmpty) return const SizedBox.shrink();

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          images[0],
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: images.length == 2 ? 2 : 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: images.length > 9 ? 9 : images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(images[index], fit: BoxFit.cover),
        );
      },
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 14,
          color: Color(0xFF666666),
        ),
        const SizedBox(width: 4),
        Text(
          widget.post.location,
          style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: _toggleLike,
          child: Row(
            children: [
              Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: _isLiked ? Colors.red : const Color(0xFF666666),
              ),
              const SizedBox(width: 4),
              Text(
                _likeCount.toString(),
                style: TextStyle(
                  fontSize: 13,
                  color: _isLiked ? Colors.red : const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: _showComments,
          child: Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: Color(0xFF666666),
              ),
              const SizedBox(width: 4),
              Text(
                widget.post.comments.length.toString(),
                style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
              ),
            ],
          ),
        ),

        if (widget.post.comments.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildCommentsPreview(),
        ],
      ],
    );
  }

  Widget _buildCommentsPreview() {
    // 显示前2条评论
    final previewComments = widget.post.comments.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: previewComments.map((comment) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
              children: [
                TextSpan(
                  text:
                      '${comment.user.displayName ?? comment.user.username}: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: comment.content),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 头部标题
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '评论',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1D29),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${widget.post.comments.length}条',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 评论列表
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: widget.post.comments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final comment = widget.post.comments[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 头像
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.asset(
                                    comment.user.avatarUrl ??
                                        'assets/tx/15311764000720_.pic_hd.jpg',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.grey[400],
                                          size: 18,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // 评论内容
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.user.displayName ??
                                          comment.user.username,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1D29),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatTimestamp(comment.timestamp),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  comment.content,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'delete':
        _showDeleteDialog();
        break;
      case 'report':
        _showReportDialog();
        break;
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除动态'),
          content: const Text('确定要删除这条动态吗？删除后无法恢复。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePost();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('举报动态'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('请选择举报原因：'),
              const SizedBox(height: 16),
              ...['垃圾信息', '不当内容', '虚假信息', '侵权内容', '其他'].map(
                (reason) => ListTile(
                  title: Text(reason),
                  onTap: () {
                    Navigator.of(context).pop();
                    _reportPost(reason);
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  void _deletePost() {
    // 从父组件的列表中删除这个帖子
    final parentState = context
        .findAncestorStateOfType<_ExpertCampingScreenState>();
    if (parentState != null) {
      parentState.setState(() {
        parentState._campingPosts.removeWhere(
          (post) => post.id == widget.post.id,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('动态已删除', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _reportPost(String reason) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已举报：$reason'), backgroundColor: Colors.orange),
    );
    // TODO: 实际举报逻辑
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${timestamp.month}月${timestamp.day}日';
    }
  }

  Widget _buildModernUserHeader() {
    return Row(
      children: [
        // 现代化头像设计
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreatorProfileScreen(user: widget.post.user),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.post.user.avatarUrl ??
                            'assets/tx/15311764000720_.pic_hd.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.grey[400],
                              size: 24,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.post.user.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 8,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.post.user.displayName ?? widget.post.user.username,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1D29),
                      ),
                    ),
                  ),
                  if (widget.post.user.tags.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.post.user.tags.first,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _formatTimestamp(widget.post.timestamp),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_horiz_rounded,
            color: Colors.grey[600],
            size: 20,
          ),
          onSelected: (String value) {
            _handleMenuAction(value);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text('删除', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.report_outlined, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Text('举报', style: TextStyle(color: Colors.orange)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernImageSection() {
    final images = widget.post.campingImages;
    if (images.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _showImageViewer(images[0]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(
              images[0],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey[400],
                    size: 48,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showImageViewer(String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            // 背景点击关闭
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
            // 图片显示
            Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // 关闭按钮
            Positioned(
              top: 50,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernActionBar() {
    return Row(
      children: [
        // 点赞按钮
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: _toggleLike,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isLiked
                    ? Colors.red.withValues(alpha: 0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isLiked
                      ? Colors.red.withValues(alpha: 0.3)
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                    color: _isLiked ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _likeCount.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      color: _isLiked ? Colors.red : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 评论按钮
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: _showComments,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.post.comments.length.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
