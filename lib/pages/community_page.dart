import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/data.dart';
import '../theme/theme.dart';
import 'post_detail_page.dart';
import '../components/post_card.dart';
import '../utils/responsive_helper.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  List<CommunityPost> _filteredPosts = [];
  String _selectedFilter = '全部';

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String _sortBy = 'hot';
  List<String> _selectedTypes = [];

  late AnimationController _staggeredController;
  int _lastPostCount = 0;

  @override
  void initState() {
    super.initState();
    _filterPosts('全部');
    _staggeredController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _staggeredController.forward(from: 0);
    });

    AppState.instance.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _applyFilters();
      }
    });
  }

  @override
  void didUpdateWidget(CommunityPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_filteredPosts.length != _lastPostCount) {
        _lastPostCount = _filteredPosts.length;
        _staggeredController.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _staggeredController.dispose();
    AppState.instance.removeListener(_onAppStateChanged);
    super.dispose();
  }

  Future<void> _toggleLike(int index) async {
    final post = _filteredPosts[index];
    await AppState.instance.togglePostLike(post.id);
  }

  List<CommunityPost> _searchPosts(List<CommunityPost> posts, String query) {
    if (query.isEmpty) return posts;
    final lowerQuery = query.toLowerCase();
    return posts.where((post) {
      if ((post.userName ?? '').toLowerCase().contains(lowerQuery)) return true;
      if ((post.tag ?? '').toLowerCase().contains(lowerQuery)) return true;
      if ((post.content ?? '').toLowerCase().contains(lowerQuery)) return true;
      return false;
    }).toList();
  }

  List<CommunityPost> _sortPosts(List<CommunityPost> posts) {
    final sorted = List<CommunityPost>.from(posts);
    switch (_sortBy) {
      case 'hot':
        sorted.sort((a, b) => b.likes.compareTo(a.likes));
        break;
      case 'time':
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'comments':
        sorted.sort((a, b) => b.comments.compareTo(a.comments));
        break;
    }
    return sorted;
  }

  List<CommunityPost> _filterByTypes(List<CommunityPost> posts) {
    if (_selectedTypes.isEmpty) return posts;
    return posts.where((post) => _selectedTypes.contains(post.type)).toList();
  }

  void _filterPosts(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilters();
    });
  }

  void _applyFilters() {
    var posts = AppState.instance.getPostsByType(_selectedFilter.toLowerCase());

    final seenContents = <String>{};
    final uniquePosts = <CommunityPost>[];

    for (var post in posts) {
      final contentKey = '${post.content}_${post.imageUrl}';
      if (seenContents.add(contentKey)) {
        uniquePosts.add(post);
      }
    }
    posts = uniquePosts;

    posts = _filterByTypes(posts);
    posts = _searchPosts(posts, _searchQuery);
    posts = _sortPosts(posts);

    setState(() {
      _filteredPosts = posts;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Text(
                      '筛选与排序',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setModalState(() {
                          _sortBy = 'hot';
                          _selectedTypes = [];
                        });
                      },
                      child: const Text(
                        '重置',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '排序方式',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildSortChip('🔥 热门', 'hot', setModalState),
                        const SizedBox(width: 8),
                        _buildSortChip('🕐 时间', 'time', setModalState),
                        const SizedBox(width: 8),
                        _buildSortChip('💬 评论', 'comments', setModalState),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '帖子类型（可多选）',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTypeFilterChip('今日穿搭', 'ootd', setModalState),
                        const SizedBox(width: 8),
                        _buildTypeFilterChip('心情', 'mood', setModalState),
                        const SizedBox(width: 8),
                        _buildTypeFilterChip('平铺展示', 'flatlay', setModalState),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_alt, color: AppColors.textMain),
                        SizedBox(width: 8),
                        Text(
                          '应用筛选',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String value, Function setModalState) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _sortBy = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.textMain : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeFilterChip(
    String label,
    String value,
    Function setModalState,
  ) {
    final isSelected = _selectedTypes.contains(value);
    return GestureDetector(
      onTap: () {
        setModalState(() {
          if (isSelected) {
            _selectedTypes.remove(value);
          } else {
            _selectedTypes.add(value);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.3)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: 14,
                color: AppColors.primaryDark,
              )
            else
              const Icon(Icons.circle_outlined, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.textMain : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _CreatePostSheet(
          onPostCreated: (post) async {
            await AppState.instance.addCommunityPost(post);
            _applyFilters();
            if (context.mounted) {
              Navigator.pop(context);
            }
            _showSnackBar('帖子创建成功！✨');
          },
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showPostDetail(CommunityPost post, String heroTag) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostDetailPage(post: post, heroTag: heroTag),
      ),
    );
  }

  void _showMoreOptions(BuildContext context, CommunityPost post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
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
              ListTile(
                leading: const Icon(Icons.report_outlined, color: Colors.red),
                title: const Text('举报帖子', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('举报已收到，我们将在48小时内处理。');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.block_outlined,
                  color: Colors.grey.shade700,
                ),
                title: const Text(
                  '屏蔽用户',
                  style: TextStyle(color: AppColors.textMain),
                ),
                onTap: () {
                  Navigator.pop(context);
                  final author = post.userName ?? '匿名用户';
                  AppState.instance.blockUser(author);
                  _showSnackBar('用户已屏蔽，其帖子将不再显示。');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
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
          if (_isSearching) _buildSearchBar(),
          _buildFilterChips(),
          if (_searchQuery.isNotEmpty) _buildSearchResultsCount(),
          Expanded(
            child: _filteredPosts.isEmpty
                ? _buildEmptyState()
                : _buildMasonryFeed(),
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                    '发现',
                    style: TextStyle(
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                _buildIconButton(Icons.tune, () {
                  _showFilterBottomSheet();
                }),
                SizedBox(width: 10 * scale),
                _buildIconButton(_isSearching ? Icons.close : Icons.search, () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchQuery = '';
                      _searchController.clear();
                      _applyFilters();
                    } else {
                      _isSearching = true;
                    }
                  });
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback? onTap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = ResponsiveHelper.getScaleFactor(context);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40 * scale,
            height: 40 * scale,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8D5F5), Color(0xFFD5E8F5)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC4B5E0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF6B5B95), size: 20 * scale),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC4B5E0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.gradientPurpleStart,
                    AppColors.gradientPurpleEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 15),
                decoration: InputDecoration(
                  hintText: '搜索用户名、标签或内容...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _applyFilters();
                  });
                },
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                    _applyFilters();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey.shade500,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.gradientTealStart,
                  AppColors.gradientTealEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gradientTealStart.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${_filteredPosts.length} 条结果',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['全部', '今日穿搭', '心情', '平铺展示'];

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
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _filterPosts(filter);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
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
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.gradientPurpleStart
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.gradientPurpleStart.withOpacity(
                                0.25,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
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

  Widget _buildMasonryFeed() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = (constraints.maxWidth - 12) / 2;
        final leftItems = <CommunityPost>[];
        final rightItems = <CommunityPost>[];

        for (int i = 0; i < _filteredPosts.length; i++) {
          if (i % 2 == 0) {
            leftItems.add(_filteredPosts[i]);
          } else {
            rightItems.add(_filteredPosts[i]);
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: leftItems.asMap().entries.map((entry) {
                    final index = entry.key * 2;
                    final post = entry.value;
                    return _buildAnimatedPostCard(post, index);
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: rightItems.asMap().entries.map((entry) {
                    final index = entry.key * 2 + 1;
                    final post = entry.value;
                    return _buildAnimatedPostCard(post, index);
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedPostCard(CommunityPost post, int index) {
    final heroTag = 'post_${post.id}';

    return AnimatedBuilder(
      animation: _staggeredController,
      builder: (context, child) {
        final animationValue = CurvedAnimation(
          parent: _staggeredController,
          curve: Interval(
            ((index % 6) * 0.1).clamp(0.0, 0.9),
            (((index % 6) * 0.1) + 0.5).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ).value;

        return Transform.translate(
          offset: Offset(0, 50 * (1 - animationValue)),
          child: Opacity(opacity: animationValue, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: PostCard(
          post: post,
          heroTag: heroTag,
          onTap: () => _showPostDetail(post, heroTag),
          onLike: () =>
              _toggleLike(_filteredPosts.indexWhere((p) => p.id == post.id)),
          onMoreTap: () => _showMoreOptions(context, post),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isNotEmpty ? '未找到结果' : '暂无帖子',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty ? '尝试其他关键词或清除搜索' : '来做第一个分享的人吧！',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                  _applyFilters();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '清除搜索',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFab() {
    return Container(
      margin: const EdgeInsets.only(bottom: 80, right: 8),
      child: FloatingActionButton(
        heroTag: 'community_add_fab',
        onPressed: _showCreatePostDialog,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.gradientPinkStart, AppColors.gradientPinkEnd],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradientPinkStart.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
    );
  }
}

class _CreatePostSheet extends StatefulWidget {
  final Function(CommunityPost) onPostCreated;

  const _CreatePostSheet({required this.onPostCreated});

  @override
  State<_CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<_CreatePostSheet> {
  final TextEditingController _contentController = TextEditingController();
  String _selectedType = 'mood';
  String _selectedTag = '';
  bool _isPosting = false;

  final List<String> _quickTags = [
    '#开心',
    '#放松',
    '#兴奋',
    '#舒适',
    '#今日穿搭',
    '#心情',
    '#悠闲',
    '#高效',
  ];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _createPost() {
    if (_contentController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isPosting = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final avatars = ['🦊', '🐼', '🐱', '🦁', '🦋', '🦄', '🐨', '🐯'];
      final randomAvatar = avatars[DateTime.now().millisecond % avatars.length];

      final post = CommunityPost(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedType,
        tag: _selectedTag.isNotEmpty ? _selectedTag : '#NewPost',
        content: _contentController.text.trim(),
        timeAgo: '刚刚',
        userName: '你',
        userAvatar: randomAvatar,
        likes: 0,
        isLiked: false,
        comments: 0,
        createdAt: DateTime.now(),
      );

      widget.onPostCreated(post);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              const Text(
                '创建帖子',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _isPosting ? null : _createPost,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _isPosting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textMain,
                            ),
                          ),
                        )
                      : const Text(
                          '发布',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _buildTypeChip('心情', 'mood'),
              const SizedBox(width: 8),
              _buildTypeChip('今日穿搭', 'ootd'),
              const SizedBox(width: 8),
              _buildTypeChip('平铺展示', 'flatlay'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _contentController,
              maxLines: 6,
              style: const TextStyle(fontSize: 16, color: AppColors.textMain),
              decoration: InputDecoration(
                hintText: '分享你的想法...',
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '快捷标签',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickTags.map((tag) {
                  final isSelected = _selectedTag == tag;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTag = isSelected ? '' : tag;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.3)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.textMain
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(String label, String type) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.textMain : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
