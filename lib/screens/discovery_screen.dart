import 'package:flutter/material.dart';
import '../models/wiki_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/data_service.dart';
import '../utils/constants.dart';

import 'wiki_detail_screen.dart';
import 'creator_profile_screen.dart';

/// Discovery screen - Tab 1
class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final _dataService = DataService();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _selectedCategory = '精选'; // 默认选择精选
  late List<WikiArticle> _wikiArticles;
  late List<Post> _posts;
  late List<Post> _allPosts;
  final String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    _wikiArticles = _dataService.getWikiArticles();
    _allPosts = _dataService.getFeedPosts(category: null, limit: 100);
    _filterPosts();

    setState(() {
      _isLoading = false;
    });
  }

  void _filterPosts() {
    if (_searchQuery.isEmpty) {
      // 根据选择的类别过滤达人
      String? categoryFilter;
      switch (_selectedCategory) {
        case '精选':
          categoryFilter = 'Featured';
          break;
        case '野外生存':
          categoryFilter = 'Bushcraft';
          break;
        case '豪华露营':
          categoryFilter = 'Glamping';
          break;
      }
      _posts = _dataService.getFeedPosts(category: categoryFilter);
    } else {
      final query = _searchQuery.toLowerCase();
      _posts = _allPosts.where((post) {
        final titleMatch = post.title.toLowerCase().contains(query);
        final descriptionMatch =
            post.description?.toLowerCase().contains(query) ?? false;
        final creatorMatch =
            post.creator?.displayName?.toLowerCase().contains(query) ?? false;
        final usernameMatch =
            post.creator?.username.toLowerCase().contains(query) ?? false;

        return titleMatch || descriptionMatch || creatorMatch || usernameMatch;
      }).toList();
    }

    // 过滤掉被屏蔽用户的内容 - 立即从 feed 中移除
    _posts = _dataService.filterBlockedUserPosts(_posts);
  }

  void _onCategoryChanged(String category) {
    if (_selectedCategory != category) {
      setState(() {
        _selectedCategory = category;
        _isLoading = true;
      });

      // 添加轻微延迟以显示加载状态
      Future.delayed(const Duration(milliseconds: 300), () {
        _filterPosts();
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
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
              slivers: [_buildModernHeader(), _buildFeedSection()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部标题区域
          _buildTopSection(),
          const SizedBox(height: 24),
          // 露营百科功能卡片（3个）
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildModernFeatureCards(),
          ),
          const SizedBox(height: 32),
          // 分类标签（精选、野外生存、豪华露营）
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildModernCategoryTabs(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                    '发现达人',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1D29),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '与露营专家连接，开启精彩旅程',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _showIntroductionDialog,
                  child: Container(
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
                      Icons.help_outline_rounded,
                      color: Colors.grey[700],
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernFeatureCards() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _wikiArticles.length,
        itemBuilder: (context, index) {
          final article = _wikiArticles[index];
          final gradients = [
            [const Color(0xFF6366F1), const Color(0xFF8B5CF6)], // 现代紫色
            [const Color(0xFF06B6D4), const Color(0xFF3B82F6)], // 现代蓝色
            [const Color(0xFFEF4444), const Color(0xFFF97316)], // 现代橙红色
          ];

          return Container(
            width: 170,
            margin: EdgeInsets.only(
              right: index < _wikiArticles.length - 1 ? 16 : 0,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WikiDetailScreen(article: article),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradients[index % gradients.length],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: gradients[index % gradients.length][0]
                            .withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getArticleIcon(article.category),
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  article.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '查看详情',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getArticleIcon(String category) {
    switch (category.toLowerCase()) {
      case 'setup':
        return Icons.home_work;
      case 'cooking':
        return Icons.restaurant;
      case 'firstaid':
        return Icons.medical_services;
      default:
        return Icons.school;
    }
  }

  Widget _buildModernCategoryTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '探索类别',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1D29),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: AppConstants.feedCategories.map((category) {
                    final isSelected = _selectedCategory == category;
                    final categoryColor = _getCategoryColorForTab(category);

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => _onCategoryChanged(category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        categoryColor,
                                        categoryColor.withValues(alpha: 0.8),
                                      ],
                                    )
                                  : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: Colors.grey[300]!,
                                      width: 1.5,
                                    ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: categoryColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(category),
                                  size: 18,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getCategoryColorForTab(String category) {
    switch (category) {
      case '精选':
        return const Color(0xFFFF6B6B);
      case '野外生存':
        return const Color(0xFF4ECDC4);
      case '豪华露营':
        return const Color(0xFF9B59B6);
      default:
        return const Color(0xFF3498DB);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '精选':
        return Icons.star_rounded;
      case '野外生存':
        return Icons.nature_people_rounded;
      case '豪华露营':
        return Icons.hotel_rounded;
      default:
        return Icons.explore_rounded;
    }
  }

  Widget _buildFeedSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // 类别标题和统计
            _buildCategoryHeader(),
            const SizedBox(height: 16),
            // 用户卡片列表
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isLoading
                  ? _buildLoadingIndicator()
                  : _posts.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      key: ValueKey(_selectedCategory),
                      children: _posts.map((post) {
                        return _buildUserCard(post);
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader() {
    String categoryDescription;
    IconData categoryIcon;
    Color categoryColor;

    switch (_selectedCategory) {
      case '精选':
        categoryDescription = '为你推荐的优质达人';
        categoryIcon = Icons.star_rounded;
        categoryColor = const Color(0xFFFF6B6B);
        break;
      case '野外生存':
        categoryDescription = '野外生存技能专家';
        categoryIcon = Icons.nature_people_rounded;
        categoryColor = const Color(0xFF4ECDC4);
        break;
      case '豪华露营':
        categoryDescription = '豪华露营体验达人';
        categoryIcon = Icons.hotel_rounded;
        categoryColor = const Color(0xFF9B59B6);
        break;
      default:
        categoryDescription = '发现更多达人';
        categoryIcon = Icons.explore_rounded;
        categoryColor = const Color(0xFF3498DB);
    }

    return Container(
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
              gradient: LinearGradient(
                colors: [categoryColor, categoryColor.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: categoryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(categoryIcon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCategory,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1D29),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  categoryDescription,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: categoryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              '${_posts.length}位',
              style: TextStyle(
                fontSize: 13,
                color: categoryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getCategoryColorForTab(_selectedCategory),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '正在加载达人信息...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '为您寻找最优质的$_selectedCategory达人',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            if (post.creator != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreatorProfileScreen(user: post.creator!),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // 现代化头像设计
                    _buildModernAvatar(post),
                    const SizedBox(width: 16),
                    // 用户信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  post.creator?.displayName ??
                                      post.creator?.username ??
                                      '未知用户',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1D29),
                                  ),
                                ),
                              ),
                              if (post.creator?.isVerified == true)
                                _buildVerificationBadge(),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _getUserLocationInfo(post),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 描述文本
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    post.description ?? post.title,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
                // 底部操作区域
                Row(
                  children: [
                    _buildStatsChip(Icons.visibility_outlined, '${post.likes}'),
                    const SizedBox(width: 12),
                    _buildStatsChip(
                      Icons.chat_bubble_outline,
                      '${post.likes ~/ 10}',
                    ),
                    const Spacer(),
                    _buildModernActionButton(post.creator),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernAvatar(Post post) {
    return Stack(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                _getCategoryColorForTab(_selectedCategory),
                _getCategoryColorForTab(
                  _selectedCategory,
                ).withValues(alpha: 0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _getCategoryColorForTab(
                  _selectedCategory,
                ).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: post.creator?.avatarUrl != null
                    ? Image.asset(
                        post.creator!.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.grey[400],
                              size: 32,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                      ),
              ),
            ),
          ),
        ),
        // 在线状态指示器
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCategoryColorForTab(_selectedCategory),
            _getCategoryColorForTab(_selectedCategory).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getCategoryColorForTab(
              _selectedCategory,
            ).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            _getCategoryLabel(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsChip(IconData icon, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Text(
            count,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernActionButton(User? user) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatorProfileScreen(user: user),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getCategoryColorForTab(_selectedCategory),
                _getCategoryColorForTab(
                  _selectedCategory,
                ).withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: _getCategoryColorForTab(
                  _selectedCategory,
                ).withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getActionButtonIcon(), color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                _getActionButtonText(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActionButtonIcon() {
    switch (_selectedCategory) {
      case '精选':
        return Icons.home_rounded;
      case '野外生存':
        return Icons.home_rounded;
      case '豪华露营':
        return Icons.home_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  String _calculateDistance() {
    // 模拟距离计算
    return (5 + (DateTime.now().millisecondsSinceEpoch % 50)).toString();
  }

  String _getCategoryLabel() {
    switch (_selectedCategory) {
      case '精选':
        return '精选达人';
      case '野外生存':
        return '生存专家';
      case '豪华露营':
        return '豪华达人';
      default:
        return '达人';
    }
  }

  String _getUserLocationInfo(Post post) {
    final trips = post.creator?.trips ?? 0;
    final distance = _calculateDistance();

    switch (_selectedCategory) {
      case '精选':
        return '推荐达人 | $trips次旅行 | ${distance}km';
      case '野外生存':
        return '野外专家 | $trips次探险 | ${distance}km';
      case '豪华露营':
        return '豪华体验 | $trips次旅行 | ${distance}km';
      default:
        return '未知地点 | $trips次旅行 | ${distance}km';
    }
  }

  String _getActionButtonText() {
    switch (_selectedCategory) {
      case '精选':
        return '进入主页';
      case '野外生存':
        return '进入主页';
      case '豪华露营':
        return '进入主页';
      default:
        return '进入主页';
    }
  }

  Widget _buildEmptyState() {
    String emptyMessage;
    String emptySubtitle;
    IconData emptyIcon;

    switch (_selectedCategory) {
      case '精选':
        emptyMessage = '暂无精选达人';
        emptySubtitle = '我们正在为您寻找最优质的达人';
        emptyIcon = Icons.star_outline_rounded;
        break;
      case '野外生存':
        emptyMessage = '暂无野外生存专家';
        emptySubtitle = '敬请期待更多专业达人加入';
        emptyIcon = Icons.nature_people_outlined;
        break;
      case '豪华露营':
        emptyMessage = '暂无豪华露营达人';
        emptySubtitle = '正在寻找更多优质体验师';
        emptyIcon = Icons.hotel_outlined;
        break;
      default:
        emptyMessage = '暂无相关达人';
        emptySubtitle = '请尝试其他类别';
        emptyIcon = Icons.person_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(60),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColorForTab(
                      _selectedCategory,
                    ).withValues(alpha: 0.1),
                    _getCategoryColorForTab(
                      _selectedCategory,
                    ).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: _getCategoryColorForTab(
                    _selectedCategory,
                  ).withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                emptyIcon,
                size: 60,
                color: _getCategoryColorForTab(
                  _selectedCategory,
                ).withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D29),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColorForTab('精选'),
                    _getCategoryColorForTab('精选').withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: _getCategoryColorForTab('精选').withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = '精选';
                  });
                  _filterPosts();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '查看精选达人',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showIntroductionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 头部区域
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.explore_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '发现达人',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '界面功能介绍',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                // 内容区域
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroItem(
                        Icons.auto_awesome_rounded,
                        '露营百科',
                        '浏览精选的露营技能教程，学习搭帐篷、野外烹饪和急救知识',
                        const Color(0xFF6366F1),
                      ),
                      const SizedBox(height: 20),
                      _buildIntroItem(
                        Icons.category_rounded,
                        '类别筛选',
                        '通过精选、野外生存、豪华露营等类别，找到符合你兴趣的达人',
                        const Color(0xFF10B981),
                      ),
                      const SizedBox(height: 20),
                      _buildIntroItem(
                        Icons.people_rounded,
                        '达人推荐',
                        '发现经验丰富的露营达人，查看他们的经历和专业技能',
                        const Color(0xFFFF6B6B),
                      ),
                      const SizedBox(height: 20),
                      _buildIntroItem(
                        Icons.chat_bubble_rounded,
                        '互动交流',
                        '与达人直接交流，学习技能或了解更多露营体验',
                        const Color(0xFF9B59B6),
                      ),
                      const SizedBox(height: 24),
                      // 底部按钮
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            '开始探索',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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
      },
    );
  }

  Widget _buildIntroItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1D29),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
