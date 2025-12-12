import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/wiki_model.dart';
import '../models/camp_model.dart';
import '../models/gear_model.dart';
import '../models/log_model.dart';
import '../models/circle_model.dart';
import '../models/topic_model.dart';
import '../models/camping_tip_model.dart';

/// Data service providing mock data and data operations
class DataService {
  // Singleton
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Avatar paths for 31 users
  static const List<String> _avatarPaths = [
    'assets/tx/15311764000720_.pic_hd.jpg',
    'assets/tx/15321764000721_.pic_hd.jpg',
    'assets/tx/15331764000722_.pic_hd.jpg',
    'assets/tx/15341764000723_.pic_hd.jpg',
    'assets/tx/15351764000731_.pic_hd.jpg',
    'assets/tx/15361764000731_.pic_hd.jpg',
    'assets/tx/15371764000732_.pic_hd.jpg',
    'assets/tx/15381764000733_.pic_hd.jpg',
    'assets/tx/15391764000734_.pic_hd.jpg',
    'assets/tx/15401764000737_.pic_hd.jpg',
    'assets/tx/15411764000737_.pic_hd.jpg',
    'assets/tx/15421764000738_.pic_hd.jpg',
    'assets/tx/15431764000739_.pic_hd.jpg',
    'assets/tx/15441764000742_.pic_hd.jpg',
    'assets/tx/15451764000742_.pic_hd.jpg',
    'assets/tx/15461764000743_.pic_hd.jpg',
    'assets/tx/15471764000744_.pic_hd.jpg',
    'assets/tx/15481764000745_.pic_hd.jpg',
    'assets/tx/15491764000746_.pic_hd.jpg',
    'assets/tx/15501764000749_.pic_hd.jpg',
    'assets/tx/15511764000750_.pic_hd.jpg',
    'assets/tx/15521764000752_.pic_hd.jpg',
    'assets/tx/15531764000753_.pic_hd.jpg',
    'assets/tx/15541764000754_.pic_hd.jpg',
    'assets/tx/15551764000755_.pic_hd.jpg',
    'assets/tx/15561764000756_.pic_hd.jpg',
    'assets/tx/15571764000757_.pic_hd.jpg',
    'assets/tx/15581764000758_.pic_hd.jpg',
    'assets/tx/15591764000759_.pic_hd.jpg',
    'assets/tx/15601764000760_.pic_hd.jpg',
    'assets/tx/15611764000761_.pic_hd.jpg',
  ];

  // Camping photo paths
  static const List<String> _campingPhotos = [
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

  // Teaching card images
  static const List<String> _teachingImages = [
    'assets/jx/15941764033615_.pic_hd.jpg',
    'assets/jx/15951764033616_.pic_hd.jpg',
    'assets/jx/15961764033617_.pic_hd.jpg',
  ];

  // Mock users - 31 camping enthusiasts
  List<User> getUsers() {
    return [
      User(
        id: '1',
        username: 'wildhiker',
        displayName: '野外徒步者',
        bio: '摄影师 | 野外生存 | 寻找宁静\n装备不在于价格，而在于合适。分享我的所有装备配置。',
        avatarUrl: _avatarPaths[0],
        coverUrl: _campingPhotos[0],
        followers: 12500,
        trips: 48,
        plans: 108,
        tags: const ['#野外生存', '#独自露营', '#胶片摄影'],
        isVerified: true,
      ),
      User(
        id: '2',
        username: 'alexwild',
        displayName: 'Alex·野外达人',
        bio: '野外生存爱好者 | 装备控',
        avatarUrl: _avatarPaths[1],
        coverUrl: _campingPhotos[1],
        followers: 850,
        trips: 12,
        plans: 25,
        tags: const ['#野外生存', '#装备'],
        isVerified: false,
      ),
      User(
        id: '3',
        username: 'mountainsoul',
        displayName: '山之魂',
        bio: '为山间日出和篝火故事而生',
        avatarUrl: _avatarPaths[2],
        coverUrl: _campingPhotos[2],
        followers: 5800,
        trips: 32,
        plans: 67,
        tags: const ['#登山', '#冒险', '#自然'],
        isVerified: true,
      ),
      User(
        id: '4',
        username: 'campchef',
        displayName: '露营大厨',
        bio: '户外烹饪专家 | 铸铁锅爱好者',
        avatarUrl: _avatarPaths[3],
        coverUrl: _campingPhotos[3],
        followers: 9200,
        trips: 41,
        plans: 89,
        tags: const ['#露营烹饪', '#铸铁锅', '#美食家'],
        isVerified: true,
      ),
      User(
        id: '5',
        username: 'forestwanderer',
        displayName: '森林漫步者',
        bio: '在迷失中找到自己 | 越野跑者',
        avatarUrl: _avatarPaths[4],
        coverUrl: _campingPhotos[4],
        followers: 3400,
        trips: 28,
        plans: 42,
        tags: const ['#徒步', '#越野跑', '#森林'],
        isVerified: false,
      ),
      User(
        id: '6',
        username: 'glampguru',
        displayName: '豪华露营大师',
        bio: '奢华与野性的完美结合 | 白天是室内设计师',
        avatarUrl: _avatarPaths[5],
        coverUrl: _campingPhotos[5],
        followers: 15600,
        trips: 36,
        plans: 94,
        tags: const ['#豪华露营', '#奢华', '#设计'],
        isVerified: true,
      ),
      User(
        id: '7',
        username: 'stargazer',
        displayName: '观星者',
        bio: '天文爱好者 | 寻找最佳暗夜观星营地',
        avatarUrl: _avatarPaths[6],
        coverUrl: _campingPhotos[6],
        followers: 6700,
        trips: 52,
        plans: 78,
        tags: const ['#天文', '#夜空', '#暗夜'],
        isVerified: true,
      ),
      User(
        id: '8',
        username: 'gearhead',
        displayName: '装备达人',
        bio: '自2015年起专业测评露营装备',
        avatarUrl: _avatarPaths[7],
        coverUrl: _campingPhotos[7],
        followers: 11200,
        trips: 65,
        plans: 142,
        tags: const ['#装备测评', '#超轻量', '#科技'],
        isVerified: true,
      ),
      User(
        id: '9',
        username: 'lakeshore',
        displayName: '湖畔露营者',
        bio: '湖边露营专家 | 皮划艇爱好者',
        avatarUrl: _avatarPaths[8],
        coverUrl: _campingPhotos[8],
        followers: 4200,
        trips: 38,
        plans: 56,
        tags: const ['#湖泊', '#皮划艇', '#水上运动'],
        isVerified: false,
      ),
      User(
        id: '10',
        username: 'wintercamper',
        displayName: '冬季露营者',
        bio: '雪地露营专家 | -20°C只是开始',
        avatarUrl: _avatarPaths[9],
        coverUrl: _campingPhotos[9],
        followers: 7800,
        trips: 44,
        plans: 71,
        tags: const ['#冬季露营', '#雪地', '#极限'],
        isVerified: true,
      ),
      User(
        id: '11',
        username: 'trailblazer',
        displayName: '开路先锋',
        bio: '走不寻常路 | 天生探险家',
        avatarUrl: _avatarPaths[10],
        coverUrl: _campingPhotos[10],
        followers: 5300,
        trips: 56,
        plans: 83,
        tags: const ['#探险家', '#冒险', '#小径'],
        isVerified: false,
      ),
      User(
        id: '12',
        username: 'campingfam',
        displayName: '露营家庭',
        bio: '家庭冒险 | 教孩子们热爱自然',
        avatarUrl: _avatarPaths[11],
        coverUrl: _campingPhotos[11],
        followers: 8900,
        trips: 29,
        plans: 48,
        tags: const ['#家庭露营', '#亲子', '#美好回忆'],
        isVerified: true,
      ),
      User(
        id: '13',
        username: 'minimalist',
        displayName: '极简主义者',
        bio: '少即是多 | 超轻量背包倡导者',
        avatarUrl: _avatarPaths[12],
        coverUrl: _campingPhotos[12],
        followers: 10400,
        trips: 71,
        plans: 95,
        tags: const ['#超轻量', '#极简主义', '#背包客'],
        isVerified: true,
      ),
      User(
        id: '14',
        username: 'beachcamper',
        displayName: '海滩露营者',
        bio: '脚趾间的沙子 | 海岸露营爱好者',
        avatarUrl: _avatarPaths[13],
        coverUrl: _campingPhotos[13],
        followers: 6100,
        trips: 34,
        plans: 52,
        tags: const ['#海滩', '#海岸', '#冲浪'],
        isVerified: false,
      ),
      User(
        id: '15',
        username: 'vintage',
        displayName: '复古露营者',
        bio: '老派露营 | 经典装备收藏家',
        avatarUrl: _avatarPaths[14],
        coverUrl: _campingPhotos[14],
        followers: 7200,
        trips: 48,
        plans: 86,
        tags: const ['#复古', '#经典', '#怀旧'],
        isVerified: true,
      ),
      User(
        id: '16',
        username: 'adventuremom',
        displayName: '冒险妈妈',
        bio: '独自带娃 | 证明女性无所不能',
        avatarUrl: _avatarPaths[15],
        coverUrl: _campingPhotos[15],
        followers: 9800,
        trips: 37,
        plans: 64,
        tags: const ['#独立妈妈', '#励志', '#坚强女性'],
        isVerified: true,
      ),
      User(
        id: '17',
        username: 'desertrat',
        displayName: '沙漠之鼠',
        bio: '沙漠居民 | 干燥露营专家',
        avatarUrl: _avatarPaths[16],
        coverUrl: _campingPhotos[16],
        followers: 4800,
        trips: 53,
        plans: 77,
        tags: const ['#沙漠', '#干燥露营', '#西南'],
        isVerified: false,
      ),
      User(
        id: '18',
        username: 'photographer',
        displayName: '露营摄影师',
        bio: '捕捉荒野瞬间 | 尼康摄影师',
        avatarUrl: _avatarPaths[17],
        coverUrl: _campingPhotos[17],
        followers: 13400,
        trips: 59,
        plans: 92,
        tags: const ['#摄影', '#风景', '#尼康'],
        isVerified: true,
      ),
      User(
        id: '19',
        username: 'fisherman',
        displayName: '钓鱼露营者',
        bio: '白天钓鱼，夜晚露营',
        avatarUrl: _avatarPaths[18],
        coverUrl: _campingPhotos[18],
        followers: 5600,
        trips: 42,
        plans: 68,
        tags: const ['#钓鱼', '#垂钓者', '#户外'],
        isVerified: false,
      ),
      User(
        id: '20',
        username: 'vanlife',
        displayName: '房车生活',
        bio: '过着房车生活 | 家就是我停车的地方',
        avatarUrl: _avatarPaths[19],
        coverUrl: _campingPhotos[19],
        followers: 18200,
        trips: 124,
        plans: 156,
        tags: const ['#房车生活', '#游牧', '#自由'],
        isVerified: true,
      ),
      User(
        id: '21',
        username: 'cyclist',
        displayName: '自行车露营者',
        bio: '自行车旅行 | 脚踏动力冒险',
        avatarUrl: _avatarPaths[20],
        coverUrl: _campingPhotos[20],
        followers: 6900,
        trips: 68,
        plans: 103,
        tags: const ['#自行车包装', '#骑行', '#旅行'],
        isVerified: true,
      ),
      User(
        id: '22',
        username: 'wildcook',
        displayName: '野外厨师',
        bio: '觅食专家 | 烹饪大自然提供的食物',
        avatarUrl: _avatarPaths[21],
        coverUrl: _campingPhotos[21],
        followers: 8100,
        trips: 46,
        plans: 74,
        tags: const ['#觅食', '#野生食物', '#烹饪'],
        isVerified: false,
      ),
      User(
        id: '23',
        username: 'hammock',
        displayName: '吊床悬挂者',
        bio: '吊床露营传道者 | 不需要帐篷',
        avatarUrl: _avatarPaths[22],
        coverUrl: _campingPhotos[22],
        followers: 7400,
        trips: 51,
        plans: 79,
        tags: const ['#吊床', '#树上露营', '#高架'],
        isVerified: true,
      ),
      User(
        id: '24',
        username: 'climber',
        displayName: '攀岩者',
        bio: '攀登岩壁，在星空下露营',
        avatarUrl: _avatarPaths[23],
        coverUrl: _campingPhotos[23],
        followers: 9500,
        trips: 63,
        plans: 97,
        tags: const ['#攀岩', '#高山', '#山脉'],
        isVerified: true,
      ),
      User(
        id: '25',
        username: 'birder',
        displayName: '观鸟者',
        bio: '鸟类学爱好者 | 为鸟类而露营',
        avatarUrl: _avatarPaths[24],
        coverUrl: _campingPhotos[24],
        followers: 4500,
        trips: 39,
        plans: 61,
        tags: const ['#观鸟', '#野生动物', '#自然'],
        isVerified: false,
      ),
      User(
        id: '26',
        username: 'survivor',
        displayName: '生存专家',
        bio: '荒野生存教练 | 技能胜过装备',
        avatarUrl: _avatarPaths[25],
        coverUrl: _campingPhotos[25],
        followers: 11800,
        trips: 87,
        plans: 134,
        tags: const ['#生存', '#丛林技能', '#技能'],
        isVerified: true,
      ),
      User(
        id: '27',
        username: 'yogacamper',
        displayName: '瑜伽露营者',
        bio: '自然中的瑜伽 | 在户外寻找平衡',
        avatarUrl: _avatarPaths[26],
        coverUrl: _campingPhotos[26],
        followers: 6300,
        trips: 33,
        plans: 55,
        tags: const ['#瑜伽', '#健康', '#正念'],
        isVerified: false,
      ),
      User(
        id: '28',
        username: 'dogcamper',
        displayName: '狗狗露营者',
        bio: '与我最好的朋友一起冒险 | 宠物友好贴士',
        avatarUrl: _avatarPaths[27],
        coverUrl: _campingPhotos[27],
        followers: 10200,
        trips: 45,
        plans: 72,
        tags: const ['#狗狗', '#宠物友好', '#最好朋友'],
        isVerified: true,
      ),
      User(
        id: '29',
        username: 'historian',
        displayName: '露营历史学家',
        bio: '历史爱好者 | 在历史遗址露营',
        avatarUrl: _avatarPaths[28],
        coverUrl: _campingPhotos[28],
        followers: 5100,
        trips: 41,
        plans: 66,
        tags: const ['#历史', '#文化', '#遗产'],
        isVerified: false,
      ),
      User(
        id: '30',
        username: 'writer',
        displayName: '荒野作家',
        bio: '从荒野中写故事 | 作家兼露营者',
        avatarUrl: _avatarPaths[29],
        coverUrl: _campingPhotos[29],
        followers: 8700,
        trips: 49,
        plans: 81,
        tags: const ['#写作', '#故事', '#作家'],
        isVerified: true,
      ),
      User(
        id: '31',
        username: 'educator',
        displayName: '户外教育者',
        bio: '教授荒野技能 | 不留痕迹倡导者',
        avatarUrl: _avatarPaths[30],
        coverUrl: _campingPhotos[30],
        followers: 7900,
        trips: 54,
        plans: 88,
        tags: const ['#教育', '#不留痕迹', '#保护'],
        isVerified: true,
      ),
    ];
  }

  User? getUserById(String id) {
    try {
      return getUsers().firstWhere((u) => u.id == id);
    } catch (e) {
      return getUsers().first;
    }
  }

  // Mock wiki articles with teaching images
  List<WikiArticle> getWikiArticles({String? category}) {
    final articles = [
      WikiArticle(
        id: '1',
        title: '隧道帐篷搭建入门',
        category: WikiCategory.setup,
        difficulty: Difficulty.beginner,
        description: '不再困扰。独自露营者的优雅搭建技巧。',
        thumbnailUrl: _teachingImages[0],
        steps: const [
          WikiStep(
            stepNumber: 1,
            title: '穿杆',
            description: '连接所有杆子。按颜色代码将它们穿入套筒。暂时不要将杆尖插入扣眼；保持平整。',
          ),
          WikiStep(
            stepNumber: 2,
            title: '后端固定与拉伸',
            description: '首先固定后角。然后像手风琴一样向前拉伸前端。',
            tip: '顺风拉伸更容易。',
          ),
          WikiStep(
            stepNumber: 3,
            title: '前端固定与调整',
            description: '固定前端。最后，调整所有风绳的张力，确保紧绷、无皱褶的搭建。',
          ),
        ],
        relatedGear: const [
          RelatedGear(
            id: 'g1',
            name: 'MSR旋风地钉',
            description: '最适合软地面',
            emoji: '🔨',
          ),
          RelatedGear(
            id: 'g2',
            name: '风绳张紧器',
            description: '保持帐篷紧绷',
            emoji: '⚙️',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      WikiArticle(
        id: '2',
        title: '铸铁锅牛排',
        category: WikiCategory.cooking,
        difficulty: Difficulty.intermediate,
        description: '露营完美牛排烹饪技巧。',
        thumbnailUrl: _teachingImages[1],
        steps: const [
          WikiStep(
            stepNumber: 1,
            title: '准备火源',
            description: '建立一个热炭床。你需要持续的高温来完美煎制。',
          ),
          WikiStep(
            stepNumber: 2,
            title: '调味与预热',
            description: '用盐和胡椒慷慨地给牛排调味。预热铸铁锅直到冒烟。',
            tip: '先让牛排回到室温。',
          ),
          WikiStep(
            stepNumber: 3,
            title: '煎制与静置',
            description: '每面煎3-4分钟达到五分熟。切之前静置5分钟。',
          ),
        ],
        relatedGear: const [
          RelatedGear(
            id: 'g3',
            name: 'Lodge铸铁锅',
            description: '12英寸，完美的露营烹饪',
            emoji: '🍳',
          ),
          RelatedGear(id: 'g4', name: '皮革手套', description: '耐热处理', emoji: '🧤'),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
      WikiArticle(
        id: '3',
        title: '野外急救',
        category: WikiCategory.firstAid,
        difficulty: Difficulty.advanced,
        description: '户外紧急情况必备急救技能。',
        thumbnailUrl: _teachingImages[2],
        steps: const [
          WikiStep(
            stepNumber: 1,
            title: '评估情况',
            description: '首先检查危险。在接近伤者之前确保现场安全。',
          ),
          WikiStep(
            stepNumber: 2,
            title: '初步检查',
            description: '检查ABC：气道、呼吸、循环。如需要请呼救。',
            tip: '记住：你的安全第一。',
          ),
          WikiStep(
            stepNumber: 3,
            title: '治疗与监护',
            description: '提供适当的治疗。监测生命体征并保持患者温暖。',
          ),
          WikiStep(
            stepNumber: 4,
            title: '撤离计划',
            description: '决定是否可以自行撤离或需要救援。记录所有治疗。',
          ),
        ],
        relatedGear: const [
          RelatedGear(
            id: 'g5',
            name: '野外急救包',
            description: '全面的应急用品',
            emoji: '🚑',
          ),
          RelatedGear(
            id: 'g6',
            name: '应急庇护所',
            description: '防止体温过低',
            emoji: '🏕️',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 21)),
      ),
    ];

    if (category == null || category == 'all') return articles;
    return articles.where((a) => a.category == category).toList();
  }

  // Mock posts with real photos
  List<Post> getFeedPosts({String? category, int limit = 20}) {
    final users = getUsers();
    final posts = <Post>[];

    // Generate posts from different users
    for (int i = 0; i < _campingPhotos.length && i < 31; i++) {
      final user = users[i % users.length];
      posts.add(
        Post(
          id: 'post_$i',
          title: _getPostTitle(i),
          description: _getPostDescription(i),
          imageUrls: [_campingPhotos[i]],
          creatorId: user.id,
          creator: user,
          likes: 100 + (i * 23) % 500,
          hasPlan: i % 3 == 0,
          planId: i % 3 == 0 ? 'plan_$i' : null,
          category: _getPostCategory(i),
          createdAt: DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }

    if (category == null || category == PostCategory.featured) {
      return posts.take(limit).toList();
    }
    return posts.where((p) => p.category == category).take(limit).toList();
  }

  String _getPostTitle(int index) {
    final titles = [
      '武陵山安静周末',
      '野外生存周末装备',
      '湖畔宁静',
      '秋色露营',
      '海岸日落露营',
      '森林晨光',
      '山峰冒险',
      '沙漠夜空',
      '冬日仙境露营',
      '河边静修',
      '松林隐居',
      '海滩篝火夜',
      '高山湖泊发现',
      '峡谷露营体验',
      '草甸晨光',
      '悬崖边景色',
      '林地奇观',
      '冰川小径露营',
      '山谷日落时光',
      '山脊线冒险',
      '隐秘林地露营',
      '瀑布大本营',
      '草原天空露营',
      '海岸悬崖逃离',
      '山脊景观',
      '森林树冠露营',
      '沙漠绿洲夜晚',
      '山顶日出',
      '河湾露营',
      '海岛沙滩露营',
      '高原荒野',
    ];
    return titles[index % titles.length];
  }

  String _getPostDescription(int index) {
    final descriptions = [
      '完美的城市逃离。景色令人叹为观止。',
      '在野外测试我的新装备配置。',
      '在湖边发现了这个绝佳地点。如此宁静。',
      '今年的秋色绝对令人惊艳。',
      '今晚看到了最不可思议的日落。',
      '在森林里喝晨咖啡感觉就是不一样。',
      '攀登很艰难，但每一步都值得。',
      '从未见过如此繁星。',
      '雪地露营充满挑战但很有收获。',
      '没有什么能比得上流水声。',
      '深入松林，找到了内心的平静。',
      '在星空下海滩露营。',
      '清澈的湖水和完美的天气。',
      '从这个峡谷边缘看到的史诗般景色。',
      '到处都是野花，纯粹的魔法。',
      '在冒险的边缘露营。',
      '以最好的方式迷失。',
      '令人屏息的冰川景色。',
      '山谷中的黄金时刻。',
      '在鹰飞翔的高处。',
      '发现了这个秘密露营地。',
      '伴着瀑布声入睡。',
      '无尽的天空和开阔的空间。',
      '戏剧性的悬崖和海浪。',
      '山脊露营360°景观。',
      '树冠露营体验。',
      '沙漠夜晚寒冷但美丽。',
      '海拔3000米的日出。',
      '沿河逆流而上。',
      '私人岛屿露营冒险。',
      '偏远高原探索。',
    ];
    return descriptions[index % descriptions.length];
  }

  String _getPostCategory(int index) {
    if (index % 3 == 0) return PostCategory.featured;
    if (index % 3 == 1) return PostCategory.bushcraft;
    return PostCategory.glamping;
  }

  // Mock camp plan
  CampPlan? getActivePlan() {
    return CampPlan(
      id: 'plan1',
      title: '安吉松林露营',
      location: '浙江安吉',
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 9)),
      temperature: 22,
      weatherCondition: 'sunny',
      status: PlanStatus.goodToGo,
      season: Season.autumn,
      estimatedWeight: 8.5,
      gearList: [
        const GearItem(
          id: 'g1',
          name: 'Snow Peak Tunnel Tent',
          category: GearCategory.sleep,
          emoji: '🏕️',
          description: '主要装备 • 已清洁',
          isPacked: true,
        ),
        const GearItem(
          id: 'g2',
          name: 'Kerosene Lamp',
          category: GearCategory.lighting,
          emoji: '🔦',
          description: '照明 • 易碎',
          isPacked: false,
        ),
        const GearItem(
          id: 'g3',
          name: 'Sleeping Bag',
          category: GearCategory.sleep,
          emoji: '💤',
          description: '睡眠 • -5°C额定',
          isPacked: true,
        ),
        const GearItem(
          id: 'g4',
          name: 'Cast Iron Skillet',
          category: GearCategory.cook,
          emoji: '🍳',
          description: '烹饪 • 重型',
          isPacked: false,
        ),
        const GearItem(
          id: 'g5',
          name: 'Headlamp',
          category: GearCategory.lighting,
          emoji: '💡',
          description: '照明 • USB充电',
          isPacked: true,
        ),
      ],
    );
  }

  // Mock gear plans for creator profile
  List<CampPlan> getCreatorPlans(String userId) {
    return _generateUserPlans(userId);
  }

  List<CampPlan> _generateUserPlans(String userId) {
    switch (userId) {
      case '1': // Wild Hiker - Bushcraft specialist
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '独自野外生存周末',
            location: '偏远松林',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            temperature: 15,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 7.2,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '防水布庇护所',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '3x3m硅胶尼龙防水布',
                weight: 0.4,
              ),
              GearItem(
                id: 'g2',
                name: '睡袋',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '-5°C羽绒睡袋',
                weight: 0.9,
              ),
              GearItem(
                id: 'g3',
                name: '丛林刀',
                category: GearCategory.tools,
                emoji: '🔪',
                description: '全龙骨固定刀片',
                weight: 0.3,
              ),
              GearItem(
                id: 'g4',
                name: '生火套装',
                category: GearCategory.tools,
                emoji: '🔥',
                description: '打火棒 + 引火物',
                weight: 0.2,
              ),
              GearItem(
                id: 'g5',
                name: '钛合金锅',
                category: GearCategory.cook,
                emoji: '🍳',
                description: '900ml锅具套装',
                weight: 0.3,
              ),
              GearItem(
                id: 'g6',
                name: '净水器',
                category: GearCategory.tools,
                emoji: '💧',
                description: 'Sawyer迷你净水器',
                weight: 0.1,
              ),
              GearItem(
                id: 'g7',
                name: '头灯',
                category: GearCategory.lighting,
                emoji: '💡',
                description: 'USB充电式',
                weight: 0.15,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
          CampPlan(
            id: 'plan_${userId}_2',
            title: '摄影探险',
            location: '山脊',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 8,
            weatherCondition: 'partly_cloudy',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 12.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '四季帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: 'Hilleberg Soulo帐篷',
                weight: 1.5,
              ),
              GearItem(
                id: 'g2',
                name: '相机装备',
                category: GearCategory.tools,
                emoji: '📷',
                description: '胶片相机 + 3个镜头',
                weight: 2.8,
              ),
              GearItem(
                id: 'g3',
                name: '三脚架',
                category: GearCategory.tools,
                emoji: '🎬',
                description: '碳纤维旅行三脚架',
                weight: 1.2,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
      case '2': // Alex·Wild Hiker - Gear Addict
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '装备测试周末',
            location: '当地荒野区域',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            temperature: 16,
            weatherCondition: 'partly_cloudy',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 11.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '测试帐篷A',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: 'REI半圆顶2人帐',
                weight: 2.1,
              ),
              GearItem(
                id: 'g2',
                name: '睡袋',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '20°F合成睡袋',
                weight: 1.4,
              ),
              GearItem(
                id: 'g3',
                name: '装备收纳袋',
                category: GearCategory.tools,
                emoji: '🎒',
                description: '模块化收纳立方体',
                weight: 0.3,
              ),
              GearItem(
                id: 'g4',
                name: '多功能工具',
                category: GearCategory.tools,
                emoji: '🔧',
                description: 'Leatherman Wave',
                weight: 0.24,
              ),
              GearItem(
                id: 'g5',
                name: '露营炉',
                category: GearCategory.cook,
                emoji: '🔥',
                description: 'MSR袖珍火箭',
                weight: 0.073,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
          CampPlan(
            id: 'plan_${userId}_2',
            title: '预算入门套装',
            location: '州立公园',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 1)),
            temperature: 18,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 9.2,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '科尔曼帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '经济型2人帐篷',
                weight: 3.5,
              ),
              GearItem(
                id: 'g2',
                name: '基础睡袋',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '40°F额定睡袋',
                weight: 1.8,
              ),
              GearItem(
                id: 'g3',
                name: '预算炊具套装',
                category: GearCategory.cook,
                emoji: '🍳',
                description: '铝制锅具套装',
                weight: 0.6,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
      case '3': // Mountain Soul
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '登顶日出任务',
            location: '高山步道',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 1)),
            temperature: 5,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 9.8,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '超轻帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: 'Big Agnes飞溪帐篷',
                weight: 0.95,
              ),
              GearItem(
                id: 'g2',
                name: '高山睡袋',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '-10°C额定睡袋',
                weight: 1.2,
              ),
              GearItem(
                id: 'g3',
                name: '攀登安全带',
                category: GearCategory.tools,
                emoji: '🧗',
                description: '安全装备',
                weight: 0.5,
              ),
              GearItem(
                id: 'g4',
                name: '登山杖',
                category: GearCategory.tools,
                emoji: '🥾',
                description: '碳纤维登山杖',
                weight: 0.4,
              ),
              GearItem(
                id: 'g5',
                name: 'Jetboil炉具',
                category: GearCategory.cook,
                emoji: '🔥',
                description: '快速沸腾系统',
                weight: 0.45,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '4': // Camp Chef
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '美食露营厨房',
            location: '河边营地',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            temperature: 20,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 18.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: 'Lodge铸铁锅',
                category: GearCategory.cook,
                emoji: '🍳',
                description: '12英寸平底锅',
                weight: 4.0,
              ),
              GearItem(
                id: 'g2',
                name: '荷兰烤箱',
                category: GearCategory.cook,
                emoji: '🥘',
                description: '用于面包和炖菜',
                weight: 5.5,
              ),
              GearItem(
                id: 'g3',
                name: '露营炉',
                category: GearCategory.cook,
                emoji: '🔥',
                description: '双头丙烷炉',
                weight: 2.8,
              ),
              GearItem(
                id: 'g4',
                name: '香料套装',
                category: GearCategory.cook,
                emoji: '🧂',
                description: '15种基本香料',
                weight: 0.5,
              ),
              GearItem(
                id: 'g5',
                name: '烹饪用具套装',
                category: GearCategory.cook,
                emoji: '🥄',
                description: '铲子、夹子、勺子',
                weight: 0.6,
              ),
              GearItem(
                id: 'g6',
                name: '冷藏箱',
                category: GearCategory.tools,
                emoji: '❄️',
                description: '40L保温冷藏箱',
                weight: 3.2,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
      case '5': // Forest Wanderer - Trail Runner
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '快速轻量越野跑露营',
            location: '山地环线',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 1)),
            temperature: 14,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 6.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '露宿袋',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '超轻应急庇护所',
                weight: 0.35,
              ),
              GearItem(
                id: 'g2',
                name: '跑步背心包',
                category: GearCategory.tools,
                emoji: '🎒',
                description: '越野跑背心12L',
                weight: 0.3,
              ),
              GearItem(
                id: 'g3',
                name: '紧凑被子',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '30°F超轻被子',
                weight: 0.48,
              ),
              GearItem(
                id: 'g4',
                name: '越野跑鞋',
                category: GearCategory.clothing,
                emoji: '👟',
                description: 'Altra孤峰跑鞋',
                weight: 0.55,
              ),
              GearItem(
                id: 'g5',
                name: '水瓶',
                category: GearCategory.tools,
                emoji: '💧',
                description: '软质水瓶500ml x2',
                weight: 0.1,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
      case '6': // Glamp Guru
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '奢华周末逃离',
            location: '风景湖景营地',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            temperature: 22,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 25.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '钟形帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '5米直径帆布帐篷',
                weight: 15.0,
              ),
              GearItem(
                id: 'g2',
                name: '大号充气床垫',
                category: GearCategory.sleep,
                emoji: '🛏️',
                description: '记忆泡沫床垫',
                weight: 3.5,
              ),
              GearItem(
                id: 'g3',
                name: '串灯',
                category: GearCategory.lighting,
                emoji: '💡',
                description: '太阳能LED灯串',
                weight: 0.3,
              ),
              GearItem(
                id: 'g4',
                name: '便携式咖啡机',
                category: GearCategory.cook,
                emoji: '☕',
                description: '手动泵压咖啡机',
                weight: 0.8,
              ),
              GearItem(
                id: 'g5',
                name: '露营椅',
                category: GearCategory.tools,
                emoji: '🪑',
                description: '带垫折叠椅 x2',
                weight: 4.0,
              ),
              GearItem(
                id: 'g6',
                name: '便携音响',
                category: GearCategory.tools,
                emoji: '🔊',
                description: '蓝牙防水音响',
                weight: 0.5,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
      case '7': // Star Gazer - Astronomy
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '天体摄影夜间配置',
            location: '暗夜保护区',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 1)),
            temperature: 10,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 14.8,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '相机和望远镜',
                category: GearCategory.tools,
                emoji: '📷',
                description: '单反相机 + 星空追踪器',
                weight: 3.5,
              ),
              GearItem(
                id: 'g2',
                name: '三脚架',
                category: GearCategory.tools,
                emoji: '🎬',
                description: '重型长曝光三脚架',
                weight: 2.8,
              ),
              GearItem(
                id: 'g3',
                name: '保暖睡袋',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '10°F寒夜睡袋',
                weight: 1.6,
              ),
              GearItem(
                id: 'g4',
                name: '红光头灯',
                category: GearCategory.lighting,
                emoji: '💡',
                description: '夜视友好红光',
                weight: 0.08,
              ),
              GearItem(
                id: 'g5',
                name: '星图',
                category: GearCategory.tools,
                emoji: '🗺️',
                description: '星盘 + 应用程序',
                weight: 0.2,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
      case '8': // Gear Head
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '超轻量测试配置',
            location: '后山步道',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 12,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 5.8,
            gearList: const [
              GearItem(
                id: 'g1',
                name: 'Dyneema帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: 'Zpacks双人帐篷',
                weight: 0.54,
              ),
              GearItem(
                id: 'g2',
                name: '被子',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '启蒙装备20°F被子',
                weight: 0.59,
              ),
              GearItem(
                id: 'g3',
                name: '钛合金炊具套装',
                category: GearCategory.cook,
                emoji: '🍳',
                description: 'Toaks 750ml锅',
                weight: 0.095,
              ),
              GearItem(
                id: 'g4',
                name: '酒精炉',
                category: GearCategory.cook,
                emoji: '🔥',
                description: 'DIY猫罐炉',
                weight: 0.015,
              ),
              GearItem(
                id: 'g5',
                name: 'GPS手表',
                category: GearCategory.tools,
                emoji: '⌚',
                description: 'Garmin飞耐时',
                weight: 0.07,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
      case '9': // Lake Shore - Kayaker
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '皮划艇露营冒险',
            location: '岛屿营地',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 22,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 16.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '皮划艇',
                category: GearCategory.tools,
                emoji: '🛶',
                description: '带储物海上皮划艇',
                weight: 0.0,
              ),
              GearItem(
                id: 'g2',
                name: '防水袋',
                category: GearCategory.tools,
                emoji: '💼',
                description: '防水袋套装',
                weight: 0.8,
              ),
              GearItem(
                id: 'g3',
                name: '海滩帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '沙地地钉兼容',
                weight: 2.2,
              ),
              GearItem(
                id: 'g4',
                name: '钓鱼装备',
                category: GearCategory.tools,
                emoji: '🎣',
                description: '可折叠钓竿',
                weight: 0.5,
              ),
              GearItem(
                id: 'g5',
                name: '救生衣',
                category: GearCategory.clothing,
                emoji: '🦺',
                description: 'PFD III型救生衣',
                weight: 0.7,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
      case '10': // Winter Camper
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '极端冬季探险',
            location: '雪山基地',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 4)),
            temperature: -15,
            weatherCondition: 'snowy',
            status: PlanStatus.goodToGo,
            season: Season.winter,
            estimatedWeight: 22.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '四季探险帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: 'Hilleberg Jannu帐篷',
                weight: 3.7,
              ),
              GearItem(
                id: 'g2',
                name: '冬季睡袋',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '-30°C羽绒睡袋',
                weight: 2.5,
              ),
              GearItem(
                id: 'g3',
                name: '保温睡垫',
                category: GearCategory.sleep,
                emoji: '🛏️',
                description: 'R值6.5睡垫',
                weight: 1.2,
              ),
              GearItem(
                id: 'g4',
                name: '热帐篷炉',
                category: GearCategory.cook,
                emoji: '🔥',
                description: '便携式木炉',
                weight: 8.5,
              ),
              GearItem(
                id: 'g5',
                name: '雪铲',
                category: GearCategory.tools,
                emoji: '⛏️',
                description: '铝制雪崩铲',
                weight: 0.9,
              ),
              GearItem(
                id: 'g6',
                name: '保温靴',
                category: GearCategory.clothing,
                emoji: '🥾',
                description: '-40°C额定靴子',
                weight: 2.2,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
      case '11': // Trail Blazer
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '越野探索',
            location: '未知荒野',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 4)),
            temperature: 12,
            weatherCondition: 'variable',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 13.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: 'GPS设备',
                category: GearCategory.tools,
                emoji: '📍',
                description: 'Garmin inReach',
                weight: 0.2,
              ),
              GearItem(
                id: 'g2',
                name: '指南针和地图',
                category: GearCategory.tools,
                emoji: '🧭',
                description: '传统导航工具',
                weight: 0.15,
              ),
              GearItem(
                id: 'g3',
                name: '砍刀',
                category: GearCategory.tools,
                emoji: '🔪',
                description: '用于开路',
                weight: 0.8,
              ),
              GearItem(
                id: 'g4',
                name: '卫星通讯器',
                category: GearCategory.tools,
                emoji: '📡',
                description: '紧急SOS',
                weight: 0.24,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '12': // Camping Family
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '家庭周末冒险',
            location: '家庭营地',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            temperature: 20,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 28.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '家庭帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '6人帐篷',
                weight: 8.5,
              ),
              GearItem(
                id: 'g2',
                name: '儿童睡袋',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '彩色儿童睡袋 x2',
                weight: 2.0,
              ),
              GearItem(
                id: 'g3',
                name: '露营游戏',
                category: GearCategory.tools,
                emoji: '🎲',
                description: '纸牌、飞盘、球',
                weight: 0.6,
              ),
              GearItem(
                id: 'g4',
                name: '急救包',
                category: GearCategory.firstAid,
                emoji: '🚑',
                description: '家庭装急救包',
                weight: 0.9,
              ),
              GearItem(
                id: 'g5',
                name: '零食和点心',
                category: GearCategory.cook,
                emoji: '🍪',
                description: '棉花糖用品',
                weight: 2.0,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '13': // The Minimalist
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '超极简长途徒步',
            location: '长距离步道',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 7)),
            temperature: 16,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 4.8,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '防水布',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: 'Cuben纤维2.4x2.4m',
                weight: 0.18,
              ),
              GearItem(
                id: 'g2',
                name: '被子',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '40°F羽绒被',
                weight: 0.35,
              ),
              GearItem(
                id: 'g3',
                name: '泡沫垫',
                category: GearCategory.sleep,
                emoji: '🛏️',
                description: '1/8英寸CCF垫',
                weight: 0.06,
              ),
              GearItem(
                id: 'g4',
                name: '烹饪系统',
                category: GearCategory.cook,
                emoji: '🔥',
                description: '冷浸罐',
                weight: 0.04,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '14': // Beach Camper
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '海岸沙滩露营',
            location: '沙滩',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 24,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 15.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '海滩遮阳篷',
                category: GearCategory.sleep,
                emoji: '⛱️',
                description: '遮阳庇护所',
                weight: 3.2,
              ),
              GearItem(
                id: 'g2',
                name: '沙地地钉',
                category: GearCategory.tools,
                emoji: '⚓',
                description: '海滩锚定套装',
                weight: 0.8,
              ),
              GearItem(
                id: 'g3',
                name: '冲浪板',
                category: GearCategory.tools,
                emoji: '🏄',
                description: '短板',
                weight: 0.0,
              ),
              GearItem(
                id: 'g4',
                name: '冷藏箱',
                category: GearCategory.tools,
                emoji: '🧊',
                description: '海滩冷藏箱30L',
                weight: 2.5,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '15': // Vintage Camper
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '老式帆布露营',
            location: '历史营地',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 18,
            weatherCondition: 'partly_cloudy',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 22.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '帆布墙式帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '复古1970年代帐篷',
                weight: 12.0,
              ),
              GearItem(
                id: 'g2',
                name: '科尔曼灯笼',
                category: GearCategory.lighting,
                emoji: '🔦',
                description: '经典燃料灯笼',
                weight: 1.8,
              ),
              GearItem(
                id: 'g3',
                name: '搪瓷餐具套装',
                category: GearCategory.cook,
                emoji: '🍳',
                description: '复古炊具',
                weight: 2.5,
              ),
              GearItem(
                id: 'g4',
                name: '羊毛毯',
                category: GearCategory.sleep,
                emoji: '🧶',
                description: '经典军用毯',
                weight: 3.0,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '16': // Adventure Mom
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '独行妈妈背包旅行',
            location: '安全步道网络',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            temperature: 17,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 10.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '轻量帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '易搭建单人帐篷',
                weight: 1.2,
              ),
              GearItem(
                id: 'g2',
                name: '安全哨',
                category: GearCategory.tools,
                emoji: '📢',
                description: '紧急信号',
                weight: 0.02,
              ),
              GearItem(
                id: 'g3',
                name: '个人定位信标',
                category: GearCategory.tools,
                emoji: '🆘',
                description: '个人定位信标',
                weight: 0.15,
              ),
              GearItem(
                id: 'g4',
                name: '紧凑炉具',
                category: GearCategory.cook,
                emoji: '🔥',
                description: '一体化系统',
                weight: 0.4,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '17': // Desert Rat
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '沙漠干露营',
            location: '西南沙漠',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 4)),
            temperature: 28,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 19.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '沙漠帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '通风网眼帐篷',
                weight: 1.8,
              ),
              GearItem(
                id: 'g2',
                name: '储水容器',
                category: GearCategory.tools,
                emoji: '💧',
                description: '20L容量',
                weight: 0.6,
              ),
              GearItem(
                id: 'g3',
                name: '遮阳庇护所',
                category: GearCategory.tools,
                emoji: '☂️',
                description: '遮阴防水布',
                weight: 1.2,
              ),
              GearItem(
                id: 'g4',
                name: '宽檐帽',
                category: GearCategory.clothing,
                emoji: '👒',
                description: '防晒保护',
                weight: 0.15,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '18': // Camp Photographer
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '风景摄影露营',
            location: '风景观景点',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 14,
            weatherCondition: 'variable',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 16.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '相机机身',
                category: GearCategory.tools,
                emoji: '📷',
                description: '尼康D850',
                weight: 1.0,
              ),
              GearItem(
                id: 'g2',
                name: '镜头套装',
                category: GearCategory.tools,
                emoji: '🔭',
                description: '广角 + 长焦',
                weight: 2.8,
              ),
              GearItem(
                id: 'g3',
                name: '相机背包',
                category: GearCategory.tools,
                emoji: '🎒',
                description: '带垫相机包',
                weight: 1.8,
              ),
              GearItem(
                id: 'g4',
                name: '滤镜套装',
                category: GearCategory.tools,
                emoji: '🎨',
                description: 'ND和偏振滤镜',
                weight: 0.3,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '19': // Fishing Camper
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '钓鱼者天堂配置',
            location: '山湖',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 19,
            weatherCondition: 'partly_cloudy',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 17.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '钓鱼竿',
                category: GearCategory.tools,
                emoji: '🎣',
                description: '纺车和飞钓竿',
                weight: 0.8,
              ),
              GearItem(
                id: 'g2',
                name: '钓具箱',
                category: GearCategory.tools,
                emoji: '🧰',
                description: '带饵料完整套装',
                weight: 2.5,
              ),
              GearItem(
                id: 'g3',
                name: '鱼类清理套装',
                category: GearCategory.tools,
                emoji: '🔪',
                description: '鱼片刀和砧板',
                weight: 0.6,
              ),
              GearItem(
                id: 'g4',
                name: '涉水裤',
                category: GearCategory.clothing,
                emoji: '🥾',
                description: '透气胸高涉水裤',
                weight: 1.2,
              ),
              GearItem(
                id: 'g5',
                name: '露营烤架',
                category: GearCategory.cook,
                emoji: '🔥',
                description: '用于新鲜渔获',
                weight: 2.3,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '20': // Van Life
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '房车生活长途旅行',
            location: '太平洋海岸公路',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 30)),
            temperature: 21,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 45.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '房车改装',
                category: GearCategory.sleep,
                emoji: '🚐',
                description: '完整露营配置',
                weight: 0.0,
              ),
              GearItem(
                id: 'g2',
                name: '太阳能板',
                category: GearCategory.tools,
                emoji: '☀️',
                description: '400W系统',
                weight: 15.0,
              ),
              GearItem(
                id: 'g3',
                name: '便携淋浴',
                category: GearCategory.tools,
                emoji: '🚿',
                description: '太阳能加热袋',
                weight: 0.8,
              ),
              GearItem(
                id: 'g4',
                name: '露营厨房',
                category: GearCategory.cook,
                emoji: '🍳',
                description: '内置炉灶配置',
                weight: 8.0,
              ),
              GearItem(
                id: 'g5',
                name: '折叠椅',
                category: GearCategory.tools,
                emoji: '🪑',
                description: '户外生活空间',
                weight: 3.5,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '21': // 自行车露营者
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '自行车包装旅行',
            location: '海岸步道路线',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 7)),
            temperature: 18,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 12.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '自行车包装袋',
                category: GearCategory.tools,
                emoji: '🎒',
                description: '车架+座垫包',
                weight: 0.9,
              ),
              GearItem(
                id: 'g2',
                name: '自行车修理包',
                category: GearCategory.tools,
                emoji: '🔧',
                description: '工具和备用内胎',
                weight: 0.8,
              ),
              GearItem(
                id: 'g3',
                name: '超轻帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '独立式单人帐篷',
                weight: 1.1,
              ),
              GearItem(
                id: 'g4',
                name: '自行车锁',
                category: GearCategory.tools,
                emoji: '🔐',
                description: '城镇用U型锁',
                weight: 1.2,
              ),
              GearItem(
                id: 'g5',
                name: '骑行服',
                category: GearCategory.clothing,
                emoji: '👕',
                description: '快干衣物',
                weight: 0.3,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '22': // 野外厨师
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '觅食与野生食物',
            location: '森林边缘营地',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 16,
            weatherCondition: 'partly_cloudy',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 13.8,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '觅食篮',
                category: GearCategory.tools,
                emoji: '🧺',
                description: '收集篮',
                weight: 0.4,
              ),
              GearItem(
                id: 'g2',
                name: '野外指南',
                category: GearCategory.tools,
                emoji: '📖',
                description: '可食用植物书籍',
                weight: 0.5,
              ),
              GearItem(
                id: 'g3',
                name: '蘑菇刀',
                category: GearCategory.tools,
                emoji: '🔪',
                description: '弯曲觅食刀',
                weight: 0.15,
              ),
              GearItem(
                id: 'g4',
                name: '铸铁锅',
                category: GearCategory.cook,
                emoji: '🍳',
                description: '野外烹饪用',
                weight: 2.5,
              ),
              GearItem(
                id: 'g5',
                name: '储存袋',
                category: GearCategory.tools,
                emoji: '👜',
                description: '收获物网袋',
                weight: 0.2,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '23': // 吊床悬挂者
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '吊床露营系统',
            location: '森林步道',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            temperature: 20,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 6.8,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '吊床',
                category: GearCategory.sleep,
                emoji: '🛏️',
                description: '11英尺聚拢端',
                weight: 0.55,
              ),
              GearItem(
                id: 'g2',
                name: '防虫网',
                category: GearCategory.sleep,
                emoji: '🦟',
                description: '集成防虫保护',
                weight: 0.25,
              ),
              GearItem(
                id: 'g3',
                name: '雨篷',
                category: GearCategory.sleep,
                emoji: '☂️',
                description: '不对称防水布',
                weight: 0.45,
              ),
              GearItem(
                id: 'g4',
                name: '底部保温被',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '20°F保温',
                weight: 0.68,
              ),
              GearItem(
                id: 'g5',
                name: '树带',
                category: GearCategory.tools,
                emoji: '🪢',
                description: '不留痕迹带子',
                weight: 0.3,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '24': // 攀岩者
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '攀岩大本营',
            location: '岩壁营地',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 4)),
            temperature: 15,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 25.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '攀岩绳',
                category: GearCategory.tools,
                emoji: '🪢',
                description: '70米动力绳',
                weight: 4.2,
              ),
              GearItem(
                id: 'g2',
                name: '器械架和快挂',
                category: GearCategory.tools,
                emoji: '🧗',
                description: '完整传统器械架',
                weight: 6.5,
              ),
              GearItem(
                id: 'g3',
                name: '抱石垫',
                category: GearCategory.tools,
                emoji: '🟦',
                description: '抱石保护垫',
                weight: 5.5,
              ),
              GearItem(
                id: 'g4',
                name: '攀岩鞋',
                category: GearCategory.clothing,
                emoji: '👟',
                description: '专业攀岩鞋',
                weight: 0.45,
              ),
              GearItem(
                id: 'g5',
                name: '头盔',
                category: GearCategory.tools,
                emoji: '⛑️',
                description: '安全头盔',
                weight: 0.35,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '25': // 观鸟者
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '观鸟观察营地',
            location: '湿地保护区',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 17,
            weatherCondition: 'partly_cloudy',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 14.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '双筒望远镜',
                category: GearCategory.tools,
                emoji: '🔭',
                description: '10x42观鸟望远镜',
                weight: 0.8,
              ),
              GearItem(
                id: 'g2',
                name: '观测镜',
                category: GearCategory.tools,
                emoji: '📡',
                description: '带三脚架',
                weight: 2.2,
              ),
              GearItem(
                id: 'g3',
                name: '野外指南',
                category: GearCategory.tools,
                emoji: '📚',
                description: '鸟类识别书',
                weight: 0.6,
              ),
              GearItem(
                id: 'g4',
                name: '露营椅',
                category: GearCategory.tools,
                emoji: '🪑',
                description: '长时间观察用',
                weight: 1.8,
              ),
              GearItem(
                id: 'g5',
                name: '录音设备',
                category: GearCategory.tools,
                emoji: '🎤',
                description: '鸟鸣录音器',
                weight: 0.3,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '26': // 生存专家
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '野外生存训练',
            location: '偏远后山区',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 5)),
            temperature: 14,
            weatherCondition: 'variable',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 11.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '生存包',
                category: GearCategory.tools,
                emoji: '🧰',
                description: '完整生存工具',
                weight: 1.2,
              ),
              GearItem(
                id: 'g2',
                name: '丛林刀',
                category: GearCategory.tools,
                emoji: '🔪',
                description: '全龙骨生存刀',
                weight: 0.4,
              ),
              GearItem(
                id: 'g3',
                name: '生火包',
                category: GearCategory.tools,
                emoji: '🔥',
                description: '多种生火方法',
                weight: 0.3,
              ),
              GearItem(
                id: 'g4',
                name: '伞绳',
                category: GearCategory.tools,
                emoji: '🪢',
                description: '100英尺550伞绳',
                weight: 0.5,
              ),
              GearItem(
                id: 'g5',
                name: '应急庇护所',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '防水布和应急睡袋',
                weight: 0.8,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '27': // 瑜伽露营者
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '瑜伽与健康静修',
            location: '宁静草甸',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 22,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 13.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '瑜伽垫',
                category: GearCategory.tools,
                emoji: '🧘',
                description: '旅行瑜伽垫',
                weight: 1.2,
              ),
              GearItem(
                id: 'g2',
                name: '冥想坐垫',
                category: GearCategory.tools,
                emoji: '💺',
                description: '便携坐垫',
                weight: 0.6,
              ),
              GearItem(
                id: 'g3',
                name: '精油',
                category: GearCategory.tools,
                emoji: '🌿',
                description: '芳疗套装',
                weight: 0.2,
              ),
              GearItem(
                id: 'g4',
                name: '日记本',
                category: GearCategory.tools,
                emoji: '📓',
                description: '反思日记',
                weight: 0.3,
              ),
              GearItem(
                id: 'g5',
                name: '草药茶包',
                category: GearCategory.cook,
                emoji: '🍵',
                description: '舒缓茶叶选择',
                weight: 0.4,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '28': // 狗狗露营者
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '狗狗友好冒险',
            location: '宠物友好步道',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            temperature: 19,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 16.5,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '狗狗背包',
                category: GearCategory.tools,
                emoji: '🎒',
                description: '狗狗自带装备',
                weight: 0.8,
              ),
              GearItem(
                id: 'g2',
                name: '便携狗碗',
                category: GearCategory.tools,
                emoji: '🥣',
                description: '可折叠碗',
                weight: 0.2,
              ),
              GearItem(
                id: 'g3',
                name: '狗狗睡垫',
                category: GearCategory.sleep,
                emoji: '🛏️',
                description: '保温宠物垫',
                weight: 0.6,
              ),
              GearItem(
                id: 'g4',
                name: '急救包',
                category: GearCategory.firstAid,
                emoji: '🚑',
                description: '宠物和人类用品',
                weight: 0.8,
              ),
              GearItem(
                id: 'g5',
                name: '长牵引绳',
                category: GearCategory.tools,
                emoji: '🐕',
                description: '30英尺露营牵引绳',
                weight: 0.3,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '29': // 露营历史学家
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '历史遗址露营',
            location: '遗产步道',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 18,
            weatherCondition: 'clear',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 14.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '历史书籍',
                category: GearCategory.tools,
                emoji: '📚',
                description: '地区历史指南',
                weight: 1.5,
              ),
              GearItem(
                id: 'g2',
                name: '相机',
                category: GearCategory.tools,
                emoji: '📷',
                description: '记录历史遗址',
                weight: 0.8,
              ),
              GearItem(
                id: 'g3',
                name: '笔记本',
                category: GearCategory.tools,
                emoji: '📝',
                description: '研究笔记',
                weight: 0.3,
              ),
              GearItem(
                id: 'g4',
                name: '头灯',
                category: GearCategory.lighting,
                emoji: '💡',
                description: '晚间阅读用',
                weight: 0.12,
              ),
              GearItem(
                id: 'g5',
                name: '露营椅',
                category: GearCategory.tools,
                emoji: '🪑',
                description: '舒适学习座椅',
                weight: 2.0,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '30': // 荒野作家
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '写作静修营地',
            location: '独居小屋区域',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 7)),
            temperature: 17,
            weatherCondition: 'partly_cloudy',
            status: PlanStatus.goodToGo,
            season: Season.autumn,
            estimatedWeight: 12.8,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '笔记本电脑',
                category: GearCategory.tools,
                emoji: '💻',
                description: '轻量笔记本',
                weight: 1.2,
              ),
              GearItem(
                id: 'g2',
                name: '太阳能充电器',
                category: GearCategory.tools,
                emoji: '☀️',
                description: '保持设备供电',
                weight: 0.5,
              ),
              GearItem(
                id: 'g3',
                name: '日记本',
                category: GearCategory.tools,
                emoji: '📓',
                description: '多本笔记本',
                weight: 0.8,
              ),
              GearItem(
                id: 'g4',
                name: '露营桌椅配置',
                category: GearCategory.tools,
                emoji: '🪑',
                description: '便携桌椅',
                weight: 3.5,
              ),
              GearItem(
                id: 'g5',
                name: '咖啡压壶',
                category: GearCategory.cook,
                emoji: '☕',
                description: '写作必需品',
                weight: 0.4,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      case '31': // 户外教育者
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '教育团体营地',
            location: '自然教育中心',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            temperature: 20,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.spring,
            estimatedWeight: 35.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '团体帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '8人教学帐篷',
                weight: 12.0,
              ),
              GearItem(
                id: 'g2',
                name: '急救包',
                category: GearCategory.firstAid,
                emoji: '🚑',
                description: '专业级团体急救包',
                weight: 3.5,
              ),
              GearItem(
                id: 'g3',
                name: '教学材料',
                category: GearCategory.tools,
                emoji: '📚',
                description: '野外技能指南和活动',
                weight: 2.8,
              ),
              GearItem(
                id: 'g4',
                name: '团体炊具套装',
                category: GearCategory.cook,
                emoji: '🍳',
                description: '大容量烹饪设备',
                weight: 8.5,
              ),
              GearItem(
                id: 'g5',
                name: '安全设备',
                category: GearCategory.tools,
                emoji: '⚠️',
                description: '哨子、反光镜、绳索',
                weight: 1.2,
              ),
              GearItem(
                id: 'g6',
                name: '环保垃圾袋',
                category: GearCategory.tools,
                emoji: '♻️',
                description: '不留痕迹教育用品',
                weight: 0.5,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];

      default:
        // 其他用户的通用计划
        return [
          CampPlan(
            id: 'plan_${userId}_1',
            title: '周末露营配置',
            location: '当地营地',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            temperature: 18,
            weatherCondition: 'sunny',
            status: PlanStatus.goodToGo,
            season: Season.summer,
            estimatedWeight: 12.0,
            gearList: const [
              GearItem(
                id: 'g1',
                name: '帐篷',
                category: GearCategory.sleep,
                emoji: '⛺',
                description: '家庭帐篷',
                weight: 4.0,
              ),
              GearItem(
                id: 'g2',
                name: '睡袋',
                category: GearCategory.sleep,
                emoji: '💤',
                description: '舒适睡袋',
                weight: 3.0,
              ),
              GearItem(
                id: 'g3',
                name: '露营炉',
                category: GearCategory.cook,
                emoji: '🔥',
                description: '丙烷炉',
                weight: 2.5,
              ),
            ],
            creatorId: userId,
            isPublic: true,
          ),
        ];
    }
  }

  // Get plan description
  String? getPlanDescription(String planId) {
    final descriptions = {
      'plan_1_1': '专注于技能而非装备的极简野外生存配置。适合那些想要使用传统技术和轻量装备与自然连接的人。',
      'plan_1_2': '专为高山环境的风景和野生动物摄影设计。在相机装备重量和舒适露营必需品之间取得平衡，适合多日拍摄。',
      'plan_2_1': '真实世界装备测试配置，用于比较不同产品。完美适用于在实际野外条件下评测露营装备。',
      'plan_2_2': '经济实惠的入门套装，证明你不需要昂贵装备就能开始露营。每件物品都是为了在预算内获得价值和可靠性而选择。',
      'plan_3_1': '高海拔登顶露营装备。在严酷山地条件下测试的轻量但可靠的设备。每件装备都在海拔3000米以上证明了其价值。',
      'plan_4_1': '将任何营地转变为五星级户外厨房。这套配置将美食烹饪带入荒野，不妥协风味或技术。',
      'plan_5_1': '快速轻量越野跑露营系统。设计用于快速覆盖距离，同时在夜晚舒适露营。',
      'plan_6_1':
          '正确的豪华露营 - 舒适与风格遇见户外冒险。创造一个舒适、值得发朋友圈的大本营，拥有所有现代便利设施，同时与自然保持连接。',
      'plan_7_1': '为天体摄影和观星优化。用于在暗夜地点捕捉夜空的重型设备。',
      'plan_8_1': '为严肃背包客测试和完善的超轻系统。每克都计算在内，每件装备都有多重用途。包括庇护所在内基础重量不到6公斤。',
      'plan_9_1': '防水皮划艇露营系统，用于岛屿跳跃。即使在恶劣水况下，所有装备都能保持干燥。',
      'plan_10_1': '经过验证的极寒冬季露营系统。设计用于-30°C低温，内置安全冗余。在44次冬季探险中使用。',
      'plan_11_1': '配备先进导航工具的越野探索套装。专注安全的配置，用于进入未知领域。',
      'plan_12_1': '面向家庭的露营配置，专为孩子和父母设计。强调安全、舒适，以及共同创造持久的回忆。',
      'plan_13_1': '超极简徒步系统。精简到长距离步道的绝对必需品。实现了不到5公斤的基础重量。',
      'plan_14_1': '海滩和海岸露营专用装备。防沙、防水，为海边冒险优化。',
      'plan_15_1': '使用传统帆布和过去几十年经过时间考验的装备的经典复古露营体验。',
      'plan_16_1': '具有增强安全功能的独行女性背包配置。轻量但包含所有必要的应急设备。',
      'plan_17_1': '干旱环境的沙漠干露营系统。大容量储水和防晒保护，适用于炎热无水条件。',
      'plan_18_1': '专业风景摄影露营配置。保护性相机存储，配备多日拍摄所需的所有舒适设施。',
      'plan_19_1': '钓鱼者天堂露营套装，结合钓鱼装备和舒适大本营。新鲜渔获到餐桌的配置。',
      'plan_20_1': '用于长途公路旅行的完整房车生活系统。配备太阳能和完整设施的自给自足移动家园。',
      'plan_21_1': '为脚踏动力冒险设计的自行车包装旅行套装。平衡的重量分配，适合舒适的骑行和露营。',
      'plan_22_1': '专注觅食的露营配置，配备识别和采集野生食材的工具。野外生存遇见烹饪冒险。',
      'plan_23_1': '完整的吊床露营系统，证明帐篷是可选的。在任何林地区域舒适的高架睡眠。',
      'plan_24_1': '配备所有必需技术装备的攀岩大本营。重型但全面的多段攀岩旅行配置。',
      'plan_25_1': '为耐心观察野生动物优化的观鸟营地。长时间自然观察的舒适配置。',
      'plan_26_1': '专注技能和冗余的野外生存训练套装。为每项基本生存任务提供多种方法。',
      'plan_27_1': '瑜伽和健康静修露营配置。用正念工具创造宁静的户外练习空间。',
      'plan_28_1': '狗狗友好的露营套装，你的最好朋友也能一起来。宠物专用装备确保人类和犬类都舒适。',
      'plan_29_1': '具有教育重点的历史遗址露营。在探索遗产地点时学习的书籍和研究材料。',
      'plan_30_1': '用于在自然中创作的作家静修露营配置。高效工作空间结合荒野灵感。',
      'plan_31_1': '用于教授户外技能的团体教育营地。包含专业级安全设备和教学材料。',
    };
    return descriptions[planId];
  }

  // Get plan details (highlights and tips)
  Map<String, dynamic> getPlanDetails(String planId) {
    // Return empty map for planIds without specific details
    // Default highlights and tips
    final Map<String, dynamic> defaultDetails = {
      'highlights': ['精心挑选的装备', '实地测试的设备', '平衡的重量分配', '适合天气的配置'],
      'tips': ['出发前务必检查天气', '先装必需品，奢侈品最后', '出行前在家测试所有装备', '不留痕迹 - 尊重自然'],
    };

    final details = {
      'plan_1_1': {
        'highlights': [
          '包括食物和水在内总重量不到8公斤',
          '所有装备都能装进40L背包',
          '完美适用于三季（春季到秋季）',
          '防水布提供多样化庇护选择',
          '最小环境影响',
        ],
        'tips': [
          '出行前练习防水布搭建 - 这需要技巧',
          '携带备用点火器（火柴+打火机）',
          '选择已建立的营地以减少影响',
          '先在家测试你的净水器',
        ],
      },
      'plan_1_2': {
        'highlights': ['专用相机保护系统', '装备防风雨庇护所', '寒冷天气额外电池容量', '长时间拍摄的舒适大本营'],
        'tips': ['夜晚将电池放在睡袋中保温', '携带硅胶包防潮', '围绕黄金时刻规划拍摄'],
      },
      'plan_3_1': {
        'highlights': [
          '登顶就绪的轻量化配置',
          '低至-10°C的寒冷天气测试',
          '快速搭建帐篷便于快速建营',
          '高海拔综合营养系统',
        ],
        'tips': ['适当适应高度 - 不要急于攀升', '每日检查天气预报并制定撤离计划', '日出前开始登顶以获得最佳条件'],
      },
      'plan_4_1': {
        'highlights': [
          '铸铁烹饪带来正宗风味',
          '完整香料架制作美食餐点',
          '汽车露营优化 - 开车到营地',
          '优质冷藏箱保存新鲜食物',
        ],
        'tips': ['出行前给铸铁调味', '在家准备食材节省时间', '为荷兰烤箱烹饪带额外木炭', '将冷藏箱放在阴凉处并每日加冰'],
      },
      'plan_6_1': {
        'highlights': ['宽敞钟形帐篷可直立', '舒适睡眠系统', '环境照明营造氛围', '优质咖啡设备享受晨光'],
        'tips': ['早到以便正确搭建', '为营地电源带延长线', '添加地毯和纺织品营造舒适内饰', '定时灯串自动营造氛围'],
      },
      'plan_8_1': {
        'highlights': [
          '实现低于6公斤基础重量',
          '经过65次旅行实地测试',
          '每件物品都有多重用途',
          'Dyneema面料节省重量',
        ],
        'tips': ['出行前称重所有物品', '学习在不同配置下搭建帐篷', '被子需要正确的睡眠技巧', '酒精炉在无风条件下效果最佳'],
      },
      'plan_10_1': {
        'highlights': [
          '极寒天气能力可达-30°C',
          '带木炉的热帐篷系统',
          '包含雪崩安全设备',
          '在44次冬季探险中得到验证',
        ],
        'tips': [
          '极端冬季条件下绝不独自露营',
          '携带备用内袜 - 脚部必须保持干燥',
          '即使在寒冷中通风也很关键',
          '离家前测试炉子操作',
          '打包应急双层睡袋作为备用',
        ],
      },
      'plan_2_1': {
        'highlights': ['真实世界测试条件', '装备并排比较', '客观性能数据收集', '所有物品都有记录和评级'],
        'tips': ['带笔记本做详细记录', '在各种天气条件下测试装备', '客观记录优缺点', '与社区分享发现'],
      },
      'plan_5_1': {
        'highlights': ['超轻量低于7公斤总重量', '跑步友好的最小背包', '5分钟内快速建营', '每日可覆盖40公里以上'],
        'tips': ['长跑前磨合鞋子', '在路上持续补水', '早起避开正午高温', '打包电解质补充剂'],
      },
      'plan_7_1': {
        'highlights': ['Bortle 1-2级最佳位置', '完整天体摄影设备', '长曝光能力', '整夜拍摄的保暖睡眠系统'],
        'tips': ['规划前检查月相', '日落前到达进行设置', '天黑后只使用红光', '在睡袋中保存额外电池'],
      },
      'plan_9_1': {
        'highlights': ['完全防水打包系统', '海滩登陆优化', '轻量皮划艇装备', '具备岛屿跳跃能力'],
        'tips': ['关键电子设备双重打包', '出发前检查潮汐表', '将最重物品放在皮划艇底部', '携带备用桨浮'],
      },
      'plan_11_1': {
        'highlights': ['先进GPS和卫星通信', '传统和数字导航', '包含应急定位信标', '专为越野探索设计'],
        'tips': ['始终告知他人你的路线', '携带实体地图作为备用', '出行前测试所有电子设备', '为GPS携带额外电池'],
      },
      'plan_12_1': {
        'highlights': ['包含儿童友好活动', '额外安全设备', '宽敞家庭帐篷', '教育与乐趣的平衡'],
        'tips': ['让孩子参与营地搭建', '带充足的零食', '为小腿规划短途徒步', '制作棉花糖是必做活动'],
      },
      'plan_13_1': {
        'highlights': ['实现低于5公斤基础重量', '零奢侈品 - 纯必需品', '数千英里步道验证', '最大效率设计'],
        'tips': ['冷浸餐食节省炉子重量', '修剪每个标签和多余带子', '多用途物品是关键', '舒适是心理的，不是物理的'],
      },
      'plan_14_1': {
        'highlights': ['防沙防水', '海滩专用锚定系统', '包含冲浪设备', '海岸天气就绪'],
        'tips': ['在沙中深埋地钉', '保持帐篷通风防潮', '将食物存放在远离海鸥的地方', '每日两次检查潮汐水位'],
      },
      'plan_15_1': {
        'highlights': ['正宗复古体验', '帆布比尼龙透气性更好', '经典美学和耐用性', '传统露营方法'],
        'tips': ['出行前给帆布防水', '接受更重的重量', '学习正确的帆布护理', '享受怀旧体验'],
      },
      'plan_16_1': {
        'highlights': ['增强个人安全功能', '轻量但完整的系统', '应急通信设备', '独行优化装备选择'],
        'tips': ['尽可能在其他团体附近露营', '始终相信你的直觉', '保持手机充电以备紧急情况', '告知朋友行程安排'],
      },
      'plan_17_1': {
        'highlights': ['20升储水容量', '优先考虑防晒保护', '耐热设备', '沙漠专用通风'],
        'tips': ['感到口渴前就要喝水', '正午时分搭建遮阳', '注意山洪预警', '保护电子设备免受沙尘'],
      },
      'plan_18_1': {
        'highlights': ['专业相机保护', '多镜头携带能力', '防风雨密封存储', '舒适的多日设置'],
        'tips': ['携带超细纤维布', '提前侦察地点', '在黄金时刻拍摄', '每晚备份照片'],
      },
      'plan_19_1': {
        'highlights': ['完整钓鱼者工具包', '新鲜鱼类烹饪设置', '多种钓鱼方法', '包含鱼类清理站'],
        'tips': ['检查当地钓鱼规定', '携带钓鱼许可证', '立即清理鱼类', '有序存放钓具'],
      },
      'plan_20_1': {
        'highlights': ['自给自足的移动生活', '400W太阳能发电系统', '内置厨房和床铺', '30天容量补给'],
        'tips': ['寻找平整的停车位', '尊重房车生活社区', '保持淡水供应', '定期清空废水箱'],
      },
      'plan_21_1': {
        'highlights': ['空气动力学自行车包', '骑行重量平衡', '完整的自行车修理工具', '7天食物容量'],
        'tips': ['先用负重自行车训练', '轮胎充气至最大PSI', '每2小时休息一次', '骑行前固定所有绑带'],
      },
      'plan_22_1': {
        'highlights': ['包含觅食工具和指南', '野生食物准备装备', '蘑菇识别资源', '专注可持续采集'],
        'tips': ['绝不食用未知植物', '只取所需', '向有经验的觅食者学习', '尊重私人财产'],
      },
      'plan_23_1': {
        'highlights': ['无帐篷高架睡眠', '适用于任何森林环境', '比帐篷系统更轻', '舒适的吊床人体工学'],
        'tips': ['在家练习搭建', '寻找相距12-15英尺的树木', '正确调节张力', '斜躺睡觉更平坦'],
      },
      'plan_24_1': {
        'highlights': ['完整传统攀岩装备', '多段攀登能力', '包含抱石垫', '所有安全设备齐全'],
        'tips': ['攀登前检查所有装备', '与有经验的伙伴攀登', '了解自己的极限', '检查绳索磨损情况'],
      },
      'plan_25_1': {
        'highlights': ['观鸟高质量光学设备', '舒适的观察装备', '包含野外指南图书馆', '鸟鸣录音设备'],
        'tips': ['在迁徙季节参观', '保持安静和耐心', '清晨活动最佳', '记录野外笔记'],
      },
      'plan_26_1': {
        'highlights': ['多种生存方法', '注重技能而非装备依赖', '完整的应急准备', '整合87次旅行经验'],
        'tips': ['在需要之前练习技能', '冗余备份拯救生命', '心理准备至关重要', '分享生存知识'],
      },
      'plan_27_1': {
        'highlights': ['瑜伽和冥想优化', '包含正念工具', '宁静地点选择', '专注健康的日程安排'],
        'tips': ['在日出和日落时练习', '带上额外的坐垫', '手机保持飞行模式', '每日反思日记'],
      },
      'plan_28_1': {
        'highlights': ['包含狗狗装备和用品', '宠物安全优先', '对两个物种都舒适', '与狗狗一起的步道测试'],
        'tips': ['携带狗狗急救包', '检查步道宠物政策', '带上额外的狗粮', '在营地保持狗狗牵引'],
      },
      'plan_29_1': {
        'highlights': ['包含教育材料', '历史遗址访问', '研究导向设置', '舒适的阅读环境'],
        'tips': ['事先研究地点', '尊重历史地点', '拍照记录', '与他人分享知识'],
      },
      'plan_30_1': {
        'highlights': ['高效工作空间设置', '设备太阳能供电', '无干扰环境', '7天写作静修容量'],
        'tips': ['设定每日字数目标', '将作品备份到云端', '平衡写作与自然漫步', '拥抱创意独处'],
      },
      'plan_31_1': {
        'highlights': ['专业教学材料', '团体安全设备', '专注不留痕迹教育', '54次教育旅行经验'],
        'tips': ['规划适合年龄的活动', '持续强调安全', '让学习变得有趣', '以身作则'],
      },
    };
    return details[planId] ?? defaultDetails;
  }

  // User log entries - persisted storage
  final List<LogEntry> _userLogs = [];
  static const String _logsKey = 'user_camp_logs';
  bool _logsLoaded = false;

  // Load logs from persistent storage
  Future<void> _loadLogs() async {
    if (_logsLoaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final logsJson = prefs.getString(_logsKey);

      if (logsJson != null) {
        final List<dynamic> logsList = json.decode(logsJson);
        _userLogs.clear();
        _userLogs.addAll(
          logsList.map((logJson) => LogEntry.fromJson(logJson)).toList(),
        );
        // Sort by date (newest first)
        _userLogs.sort((a, b) => b.date.compareTo(a.date));
      }
    } catch (e) {
      print('Error loading logs: $e');
    } finally {
      _logsLoaded = true;
    }
  }

  // Save logs to persistent storage
  Future<void> _saveLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsJson = json.encode(
        _userLogs.map((log) => log.toJson()).toList(),
      );
      await prefs.setString(_logsKey, logsJson);
    } catch (e) {
      print('Error saving logs: $e');
    }
  }

  Future<List<LogEntry>> getLogEntries() async {
    await _loadLogs();
    return List.from(_userLogs);
  }

  Future<void> addLogEntry(LogEntry log) async {
    await _loadLogs();
    _userLogs.insert(0, log); // Add to beginning for chronological order
    await _saveLogs();
  }

  Future<void> removeLogEntry(String logId) async {
    await _loadLogs();
    _userLogs.removeWhere((log) => log.id == logId);
    await _saveLogs();
  }

  Future<void> updateLogEntry(LogEntry updatedLog) async {
    await _loadLogs();
    final index = _userLogs.indexWhere((log) => log.id == updatedLog.id);
    if (index != -1) {
      _userLogs[index] = updatedLog;
      await _saveLogs();
    }
  }

  // Mock circles for community
  List<Circle> getCircles() {
    return const [
      Circle(
        id: 'c1',
        name: '同城露营',
        emoji: '📍',
        description: '本地露营爱好者交流',
        memberCount: 1248,
        category: CircleCategory.location,
        isJoined: true,
      ),
      Circle(
        id: 'c2',
        name: '复古灯炉',
        emoji: '🔥',
        description: '复古装备收藏与分享',
        memberCount: 856,
        category: CircleCategory.interest,
        isJoined: false,
      ),
      Circle(
        id: 'c3',
        name: '自驾露营',
        emoji: '🚗',
        description: '房车与自驾露营',
        memberCount: 2134,
        category: CircleCategory.interest,
        isJoined: true,
      ),
      Circle(
        id: 'c4',
        name: '野外生存',
        emoji: '🏕️',
        description: 'Bushcraft技能交流',
        memberCount: 1567,
        category: CircleCategory.skillLevel,
        isJoined: false,
      ),
      Circle(
        id: 'c5',
        name: '亲子露营',
        emoji: '👨‍👩‍👧‍👦',
        description: '家庭露营经验分享',
        memberCount: 3421,
        category: CircleCategory.interest,
        isJoined: true,
      ),
      Circle(
        id: 'c6',
        name: '摄影爱好',
        emoji: '📷',
        description: '露营摄影技巧',
        memberCount: 987,
        category: CircleCategory.interest,
        isJoined: false,
      ),
    ];
  }

  // Follow state management
  final Set<String> _followedUsers = {};

  bool isFollowing(String userId) {
    return _followedUsers.contains(userId);
  }

  void toggleFollow(String userId) {
    if (_followedUsers.contains(userId)) {
      _followedUsers.remove(userId);
    } else {
      _followedUsers.add(userId);
    }
  }

  // Get user-specific posts
  List<Post> getUserPosts(String userId) {
    final user = getUserById(userId);
    if (user == null) return [];

    // Generate unique posts for each user based on their profile
    final posts = _generateUserSpecificPosts(user);
    return posts;
  }

  List<Post> _generateUserSpecificPosts(User user) {
    // Different post content based on user's tags and bio
    final postData = _getUserPostData(user.id);
    final posts = <Post>[];

    for (int i = 0; i < postData.length; i++) {
      posts.add(
        Post(
          id: 'user_${user.id}_post_$i',
          title: postData[i]['title']!,
          description: postData[i]['description'],
          imageUrls: const [],
          creatorId: user.id,
          creator: user,
          likes: (i * 13 + 50) % 300 + 20,
          hasPlan: i % 4 == 0,
          planId: i % 4 == 0 ? 'plan_${user.id}_$i' : null,
          category: postData[i]['category']!,
          createdAt: DateTime.now().subtract(Duration(days: i * 3 + 1)),
        ),
      );
    }

    return posts;
  }

  List<Map<String, String>> _getUserPostData(String userId) {
    // Each user gets unique content based on their ID
    switch (userId) {
      case '1': // Wild Hiker - Photographer, Bushcraft
        return [
          {
            'title': '静默露营的艺术',
            'description':
                '经过48次荒野之旅，我学会了最好的营地是那些只能听到松林间风声的地方。这就是为什么我总是选择偏远地点而不是热门营地。',
            'category': 'Bushcraft',
          },
          {
            'title': '野外胶片摄影',
            'description': '在露营时用35mm胶片拍摄迫使你放慢脚步，真正观察周围环境。当你只有36张照片时，每一帧都变得珍贵。',
            'category': 'Featured',
          },
          {
            'title': '我的极简装备哲学',
            'description':
                '装备不在于价格标签。我最可靠的装备？一把15美元的钛合金勺子，我已经携带了5年。质量胜过数量，永远如此。',
            'category': 'Bushcraft',
          },
          {
            'title': '独自露营安全贴士',
            'description': '独自出行不意味着毫无准备。这里是我在偏远地区独自露营时绝不妥协的5件事。',
            'category': 'Bushcraft',
          },
          {
            'title': '自然中的晨间仪式',
            'description': '醒来时帐篷上结着霜，一边煮咖啡一边看日出透过树林 - 这些时刻提醒我为什么要这样做。',
            'category': 'Featured',
          },
        ];

      case '2': // Alex·Wild Hiker - Gear Addict
        return [
          {
            'title': '装备测试：冬季版',
            'description': '刚刚完成了在零下温度测试5种不同睡袋。结果可能会让你惊讶 - 最昂贵的那个最先失效。',
            'category': 'Featured',
          },
          {
            'title': '我的装备箱进化史',
            'description': '从45公斤的"以防万一"物品到精简的12公斤配置。这是我在12次旅行中学到的装备选择经验。',
            'category': 'Bushcraft',
          },
          {
            'title': '预算露营配置',
            'description': '你不需要花费数千元就能开始露营。我第一年的配置花费不到300美元，却带我去了令人惊叹的地方。',
            'category': 'Featured',
          },
        ];

      case '3': // Mountain Soul
        return [
          {
            'title': '追逐山间日出',
            'description': '凌晨4点醒来从山脊观看日出。黄金时刻照射在山峰上，让每个寒冷的早晨都值得。',
            'category': 'Featured',
          },
          {
            'title': '高海拔露营课程',
            'description':
                '在海拔3000米以上露营会快速教会你对自然的敬畏。稀薄的空气、不可预测的天气，以及最令人难以置信的繁星天空。',
            'category': 'Bushcraft',
          },
          {
            'title': '步道故事：漫长的上山路',
            'description': '有时最艰难的步道通向最好的营地。到达这个山脊花了8小时，但360°的景观值得每一步。',
            'category': 'Featured',
          },
          {
            'title': '山地天气智慧',
            'description': '经过32次山地旅行，我学会了读懂云朵。这些是告诉你要快速收拾营地的警告信号。',
            'category': 'Bushcraft',
          },
        ];

      case '4': // Camp Chef
        return [
          {
            'title': '铸铁牛排完美制作',
            'description': '人们问我为什么要带4公斤铸铁锅进入荒野。这就是原因：在星空下完美煎制的牛排值得每一克重量。',
            'category': 'Glamping',
          },
          {
            'title': '一锅露营餐',
            'description': '更少清洁，更多风味。这5个一锅食谱支撑我度过了无数次露营旅行，从未让人失望。',
            'category': 'Featured',
          },
          {
            'title': '露营厨房配置',
            'description': '户外烹饪时组织是关键。这是我的模块化厨房系统，装在一个箱子里但能处理美食餐点。',
            'category': 'Glamping',
          },
          {
            'title': '篝火烘焙冒险',
            'description': '是的，你可以在露营时烘焙新鲜面包。荷兰烤箱面包烘焙是我多日旅行的冥想仪式。',
            'category': 'Featured',
          },
        ];

      case '5': // Forest Wanderer
        return [
          {
            'title': '跑步到营地',
            'description': '既然可以跑步，为什么要徒步？超轻量越野跑进入深林营地将两种激情合并为一次冒险。',
            'category': 'Bushcraft',
          },
          {
            'title': '故意迷路',
            'description': '有时最好的营地是在你离开步道时发现的。这是我如何安全地探索越野路线同时不迷失的方法。',
            'category': 'Featured',
          },
          {
            'title': '森林浴与露营',
            'description': '将日本森林浴与露营结合创造了冥想体验。森林以我们才开始理解的方式治愈着我们。',
            'category': 'Bushcraft',
          },
        ];

      case '6': // Glamp Guru
        return [
          {
            'title': '奢华遇见荒野',
            'description': '谁说露营不能舒适？我最新的配置包括埃及棉床单、记忆泡沫床垫和仙女灯。是的，真的。',
            'category': 'Glamping',
          },
          {
            'title': '营地室内设计',
            'description': '作为室内设计师，我将美学感觉带入帐篷。温暖的照明、天然纺织品和周到的组织改造任何营地。',
            'category': 'Glamping',
          },
          {
            'title': '豪华露营装备指南',
            'description': '舒适不意味着牺牲真实性。这些是真正增强户外体验的奢侈品。',
            'category': 'Featured',
          },
          {
            'title': '营造营地氛围',
            'description': '蜡烛灯笼、播放自然声音的便携音响和合适的营地家具将基本营地变成户外客厅。',
            'category': 'Glamping',
          },
        ];

      case '7': // Star Gazer
        return [
          {
            'title': '暗夜观星营地',
            'description': '上周发现了一个Bortle 1级地点 - 完全没有光污染。银河如此明亮，甚至投下了阴影。',
            'category': 'Featured',
          },
          {
            'title': '营地天体摄影',
            'description': '露营给你数小时时间捕捉长曝光。昨晚我拍了200张星轨照片 - 每张都是4分钟曝光。',
            'category': 'Bushcraft',
          },
          {
            'title': '流星雨观测指南',
            'description': '围绕天文事件规划露营将体验提升到另一个层次。在海拔2500米观看英仙座流星雨令人难忘。',
            'category': 'Featured',
          },
        ];

      case '8': // Gear Head
        return [
          {
            'title': '帐篷对比：测试10款型号',
            'description': '在雨、风、雪中测试帐篷后，这是我基于数据的分析，哪些设计真正有效，哪些只是营销炒作。',
            'category': 'Featured',
          },
          {
            'title': '超轻量vs耐用：权衡取舍',
            'description': '每节省一克都是一种妥协。经过65次旅行，这是我认为超轻量有意义和没意义的地方。',
            'category': 'Bushcraft',
          },
          {
            'title': '野外科技装备',
            'description': '太阳能板、充电宝和GPS手表 - 现代科技可以增强露营体验而不破坏它。这是我的电子设备配置。',
            'category': 'Featured',
          },
          {
            'title': '装备维护经验',
            'description': '那个500美元的帐篷能用5年还是50年取决于你如何保养。维护比初始质量更重要。',
            'category': 'Bushcraft',
          },
        ];

      case '9': // Lake Shore
        return [
          {
            'title': '湖边晨间划桨',
            'description': '日出前划桨出去，从皮划艇上观看薄雾从平静水面升起，有种神奇的感觉。',
            'category': 'Featured',
          },
          {
            'title': '皮划艇露营必需品',
            'description': '防水不等于抗水。这是我的皮划艇露营打包系统，即使在恶劣水况下也能保持装备干燥。',
            'category': 'Bushcraft',
          },
          {
            'title': '最佳湖泊营地',
            'description': '划桨进入的营地提供汽车露营永远无法提供的宁静。这些隐秘的湖泊地点值得额外努力到达。',
            'category': 'Featured',
          },
        ];

      case '10': // Winter Camper
        return [
          {
            'title': '-20°C雪地露营',
            'description': '大多数人认为我疯了。但冬季露营有独特的宁静 - 寂静、雪覆盖的景观、挑战。',
            'category': 'Bushcraft',
          },
          {
            'title': '寒冷天气生存技能',
            'description': '如果你知道自己在做什么，冬季露营并不危险。这些是让我在极寒中保持温暖和安全的关键技能。',
            'category': 'Bushcraft',
          },
          {
            'title': '冬季营地快速搭建',
            'description': '当温度是-15°C时，每分钟都很重要。我的营地搭建程序从到达到温暖帐篷只需12分钟。方法如下。',
            'category': 'Featured',
          },
          {
            'title': '热帐篷炉子系统',
            'description': '便携式木炉改变了冬季露营。在雪花飘落时在温暖帐篷中醒来是纯粹的奢华。',
            'category': 'Glamping',
          },
        ];

      default:
        // Generic posts for other users
        return [
          {
            'title': '周末露营冒险',
            'description': '又一次成功的野外之旅。有时你只需要48小时远离一切来重置你的心灵。',
            'category': 'Featured',
          },
          {
            'title': '步道上的教训',
            'description': '每次露营旅行都会教给你新东西。这次我学到了带额外袜子的重要性。永远。额外的。袜子。',
            'category': 'Bushcraft',
          },
          {
            'title': '自然的疗法',
            'description': '森林里没有WiFi，但我保证你会找到更好的连接。露营让我们重新连接到重要的事物。',
            'category': 'Featured',
          },
        ];
    }
  }

  // Mock topics for community
  List<Topic> getTopics() {
    return [
      Topic(
        id: 't1',
        title: '雨天露营装备推荐',
        emoji: '🔥',
        description: '最近雨季来了，大家都用什么装备应对雨天露营？分享一下你的经验吧！',
        replyCount: 156,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        authorId: '1',
        replies: [
          TopicReply(
            id: 'r1',
            content: '防水天幕是必备的！我用的是3x3米的银胶天幕，下大雨也不怕。',
            authorId: '2',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            likes: 23,
          ),
          TopicReply(
            id: 'r2',
            content: '推荐准备防水袋，把睡袋和衣服都装进去，这样就算帐篷漏水也不怕。',
            authorId: '3',
            createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
            likes: 18,
          ),
          TopicReply(
            id: 'r3',
            content: '雨天地钉很重要！普通地钉容易松，建议用螺旋地钉或者Y型地钉。',
            authorId: '4',
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
            likes: 15,
          ),
        ],
      ),
      Topic(
        id: 't2',
        title: '新手第一次露营注意事项',
        emoji: '⛺',
        description: '准备第一次去露营，有点紧张，大家有什么建议吗？',
        replyCount: 89,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
        authorId: '5',
        replies: [
          TopicReply(
            id: 'r4',
            content: '第一次建议去设施完善的营地，不要去太偏远的地方。',
            authorId: '1',
            createdAt: DateTime.now().subtract(const Duration(hours: 4)),
            likes: 32,
          ),
          TopicReply(
            id: 'r5',
            content: '装备不用买太贵的，先租或者买入门级的试试，确定喜欢再升级。',
            authorId: '6',
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
            likes: 28,
          ),
        ],
      ),
      Topic(
        id: 't3',
        title: '露营美食分享',
        emoji: '🍳',
        description: '分享你在露营时做过的美食，附上做法更好！',
        replyCount: 234,
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
        authorId: '7',
        replies: [
          TopicReply(
            id: 'r6',
            content: '铸铁锅煎牛排真的绝了！带上黄油和迷迭香，野外也能吃大餐。',
            authorId: '4',
            createdAt: DateTime.now().subtract(const Duration(hours: 20)),
            likes: 45,
          ),
          TopicReply(
            id: 'r7',
            content: '推荐烤棉花糖！小朋友超喜欢，准备很简单。',
            authorId: '12',
            createdAt: DateTime.now().subtract(const Duration(hours: 18)),
            likes: 38,
          ),
        ],
      ),
    ];
  }

  Topic? getTopicById(String id) {
    try {
      return getTopics().firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // Mock camping tips - hot questions for AI
  List<CampingTip> getCampingTips() {
    return const [
      // 装备相关
      CampingTip(
        id: 'tip1',
        question: '如何选择适合自己的帐篷？',
        emoji: '⛺',
        category: TipCategory.gear,
        difficulty: TipDifficulty.beginner,
        viewCount: 2340,
      ),
      CampingTip(
        id: 'tip2',
        question: '睡袋温标怎么看？如何选择？',
        emoji: '💤',
        category: TipCategory.gear,
        difficulty: TipDifficulty.beginner,
        viewCount: 1890,
      ),
      CampingTip(
        id: 'tip3',
        question: '露营灯具有哪些选择？各有什么优缺点？',
        emoji: '💡',
        category: TipCategory.gear,
        difficulty: TipDifficulty.intermediate,
        viewCount: 1560,
      ),

      // 搭建技巧
      CampingTip(
        id: 'tip4',
        question: '下雨天如何收帐篷？',
        emoji: '🌧️',
        category: TipCategory.setup,
        difficulty: TipDifficulty.intermediate,
        viewCount: 3120,
      ),
      CampingTip(
        id: 'tip5',
        question: '天幕的搭建方法和技巧',
        emoji: '🏕️',
        category: TipCategory.setup,
        difficulty: TipDifficulty.intermediate,
        viewCount: 2780,
      ),
      CampingTip(
        id: 'tip6',
        question: '如何选择合适的营地位置？',
        emoji: '📍',
        category: TipCategory.setup,
        difficulty: TipDifficulty.beginner,
        viewCount: 2450,
      ),

      // 烹饪相关
      CampingTip(
        id: 'tip7',
        question: '露营时如何做出美味的早餐？',
        emoji: '🍳',
        category: TipCategory.cooking,
        difficulty: TipDifficulty.beginner,
        viewCount: 1980,
      ),
      CampingTip(
        id: 'tip8',
        question: '铸铁锅的使用和保养技巧',
        emoji: '🔥',
        category: TipCategory.cooking,
        difficulty: TipDifficulty.intermediate,
        viewCount: 1670,
      ),
      CampingTip(
        id: 'tip9',
        question: '野外生火的安全方法',
        emoji: '🔥',
        category: TipCategory.cooking,
        difficulty: TipDifficulty.advanced,
        viewCount: 2890,
      ),

      // 天气应对
      CampingTip(
        id: 'tip10',
        question: '冬季露营需要准备什么？',
        emoji: '❄️',
        category: TipCategory.weather,
        difficulty: TipDifficulty.advanced,
        viewCount: 3450,
      ),
      CampingTip(
        id: 'tip11',
        question: '夏季露营如何防暑降温？',
        emoji: '☀️',
        category: TipCategory.weather,
        difficulty: TipDifficulty.beginner,
        viewCount: 2120,
      ),
      CampingTip(
        id: 'tip12',
        question: '大风天气露营注意事项',
        emoji: '💨',
        category: TipCategory.weather,
        difficulty: TipDifficulty.intermediate,
        viewCount: 1890,
      ),

      // 安全相关
      CampingTip(
        id: 'tip13',
        question: '野外急救包应该准备什么？',
        emoji: '🚑',
        category: TipCategory.safety,
        difficulty: TipDifficulty.beginner,
        viewCount: 2670,
      ),
      CampingTip(
        id: 'tip14',
        question: '如何防止野生动物进入营地？',
        emoji: '🐻',
        category: TipCategory.safety,
        difficulty: TipDifficulty.intermediate,
        viewCount: 2340,
      ),
      CampingTip(
        id: 'tip15',
        question: '迷路了怎么办？野外定向技巧',
        emoji: '🧭',
        category: TipCategory.safety,
        difficulty: TipDifficulty.advanced,
        viewCount: 1780,
      ),

      // 营地推荐
      CampingTip(
        id: 'tip16',
        question: '推荐适合亲子的营地',
        emoji: '👨‍👩‍👧‍👦',
        category: TipCategory.location,
        difficulty: TipDifficulty.beginner,
        viewCount: 3890,
      ),
      CampingTip(
        id: 'tip17',
        question: '江浙沪有哪些好的露营地？',
        emoji: '🗺️',
        category: TipCategory.location,
        difficulty: TipDifficulty.beginner,
        viewCount: 4120,
      ),
      CampingTip(
        id: 'tip18',
        question: '如何找到人少景美的野营地？',
        emoji: '🏞️',
        category: TipCategory.location,
        difficulty: TipDifficulty.intermediate,
        viewCount: 3560,
      ),
    ];
  }

  // Get camping tips by category
  List<CampingTip> getCampingTipsByCategory(String category) {
    return getCampingTips().where((tip) => tip.category == category).toList();
  }

  // Get popular camping tips (sorted by view count)
  List<CampingTip> getPopularCampingTips({int limit = 6}) {
    final tips = List<CampingTip>.from(getCampingTips());
    tips.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return tips.take(limit).toList();
  }

  // ============================================================================
  // Content Moderation & User Safety Features (App Store Compliance)
  // ============================================================================

  // Blocked users storage
  final Set<String> _blockedUserIds = {};

  /// Block a user - removes their content from feed instantly
  Future<void> blockUser(String userId) async {
    _blockedUserIds.add(userId);

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blocked_users', _blockedUserIds.toList());

    // TODO: In production, also send to backend API
    // await _apiService.blockUser(userId);
  }

  /// Unblock a user
  Future<void> unblockUser(String userId) async {
    _blockedUserIds.remove(userId);

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blocked_users', _blockedUserIds.toList());

    // TODO: In production, also send to backend API
    // await _apiService.unblockUser(userId);
  }

  /// Check if a user is blocked
  bool isUserBlocked(String userId) {
    return _blockedUserIds.contains(userId);
  }

  /// Get list of blocked users
  Future<List<String>> getBlockedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final blocked = prefs.getStringList('blocked_users') ?? [];
    _blockedUserIds.addAll(blocked);
    return blocked;
  }

  /// Notify developer when a user is blocked
  /// This helps identify problematic users and content
  Future<void> notifyDeveloperOfBlock({
    required String blockedUserId,
    required String blockedUsername,
    required String reason,
  }) async {
    final reportData = {
      'type': 'user_block',
      'blocked_user_id': blockedUserId,
      'blocked_username': blockedUsername,
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
      'reporter_action': 'block',
    };

    // TODO: In production, send to backend API or analytics service
    // This allows developers to track patterns and take action
    // await _apiService.sendModerationAlert(reportData);

    // For now, log locally
    print(
      '🚫 User Blocked - Developer Notification: ${jsonEncode(reportData)}',
    );
  }

  /// Report a user for inappropriate behavior
  Future<void> reportUser({
    required String reportedUserId,
    required String reportedUsername,
    required String reason,
    Map<String, dynamic>? reporterContext,
  }) async {
    final reportData = {
      'type': 'user_report',
      'reported_user_id': reportedUserId,
      'reported_username': reportedUsername,
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
      'context': reporterContext,
    };

    // Save report locally
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList('user_reports') ?? [];
    reports.add(jsonEncode(reportData));
    await prefs.setStringList('user_reports', reports);

    // TODO: In production, send to backend API for review
    // await _apiService.submitUserReport(reportData);
  }

  /// Notify developer of a new report
  /// This ensures immediate visibility of inappropriate content
  Future<void> notifyDeveloperOfReport({
    required String reportedUserId,
    required String reportedUsername,
    required String reason,
    required String contentType,
  }) async {
    final notificationData = {
      'type': 'content_report',
      'reported_user_id': reportedUserId,
      'reported_username': reportedUsername,
      'reason': reason,
      'content_type': contentType,
      'timestamp': DateTime.now().toIso8601String(),
      'priority': _getReportPriority(reason),
    };

    // TODO: In production, send immediate notification to moderation team
    // This could be via:
    // - Push notification to admin dashboard
    // - Email alert to moderation team
    // - Slack/Discord webhook
    // - Backend API endpoint
    // await _apiService.sendUrgentModerationAlert(notificationData);

    // For now, log with high visibility
    print(
      '⚠️ URGENT - Content Report - Developer Notification: ${jsonEncode(notificationData)}',
    );
  }

  /// Report a post for inappropriate content
  Future<void> reportPost({
    required String postId,
    required String postTitle,
    required String authorId,
    required String reason,
  }) async {
    final reportData = {
      'type': 'post_report',
      'post_id': postId,
      'post_title': postTitle,
      'author_id': authorId,
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Save report locally
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList('post_reports') ?? [];
    reports.add(jsonEncode(reportData));
    await prefs.setStringList('post_reports', reports);

    // Notify developer
    await notifyDeveloperOfReport(
      reportedUserId: authorId,
      reportedUsername: 'Post Author',
      reason: reason,
      contentType: '动态内容',
    );

    // TODO: In production, send to backend API
    // await _apiService.submitPostReport(reportData);
  }

  /// Report a message/comment for inappropriate content
  Future<void> reportMessage({
    required String messageId,
    required String messageContent,
    required String reason,
  }) async {
    final reportData = {
      'type': 'message_report',
      'message_id': messageId,
      'message_preview': messageContent.substring(
        0,
        messageContent.length > 100 ? 100 : messageContent.length,
      ),
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Save report locally
    final prefs = await SharedPreferences.getInstance();
    final reports = prefs.getStringList('message_reports') ?? [];
    reports.add(jsonEncode(reportData));
    await prefs.setStringList('message_reports', reports);

    // Notify developer
    print('⚠️ Message Reported: ${jsonEncode(reportData)}');

    // TODO: In production, send to backend API
    // await _apiService.submitMessageReport(reportData);
  }

  /// Determine report priority based on reason
  String _getReportPriority(String reason) {
    final highPriorityKeywords = ['不当内容', '骚扰', '暴力', '色情'];
    for (final keyword in highPriorityKeywords) {
      if (reason.contains(keyword)) {
        return 'HIGH';
      }
    }
    return 'MEDIUM';
  }

  /// Filter posts to exclude blocked users
  List<Post> filterBlockedUserPosts(List<Post> posts) {
    return posts.where((post) => !isUserBlocked(post.creatorId)).toList();
  }

  /// Get all reports for admin review (for testing/development)
  Future<Map<String, List<String>>> getAllReports() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_reports': prefs.getStringList('user_reports') ?? [],
      'post_reports': prefs.getStringList('post_reports') ?? [],
      'message_reports': prefs.getStringList('message_reports') ?? [],
    };
  }
}
