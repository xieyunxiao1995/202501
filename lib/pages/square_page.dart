import 'package:flutter/material.dart';
import '../models/square_post.dart';
import '../models/diary_entry.dart';
import '../constants/app_colors.dart';
import '../constants/sample_data.dart';
import '../widgets/dual_glow_background.dart';
import 'diary_detail_page.dart';

class SquarePage extends StatefulWidget {
  const SquarePage({super.key});

  @override
  State<SquarePage> createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage> {
  List<SquarePost> _posts = SampleData.getSamplePosts();
  String _filter = 'all'; // all, liked
  bool _isGridView = true; // true: 网格, false: 列表
  final Set<String> _blockedUsers = {};

  void _toggleLike(String id) {
    setState(() {
      _posts = _posts.map((post) {
        if (post.id == id) {
          return post.copyWith(
            isLiked: !post.isLiked,
            likes: post.isLiked ? post.likes - 1 : post.likes + 1,
          );
        }
        return post;
      }).toList();
    });
  }

  void _handleReport(String postId) {
    // 这里可以添加实际的举报逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('举报已提交，我们会在24小时内核实和处理'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleBlock(String postId) {
    final post = _posts.firstWhere((p) => p.id == postId);
    setState(() {
      _blockedUsers.add(post.author);
    });
  }

  void _showPostDetail(SquarePost post) {
    // 将 SquarePost 转换为 DiaryEntry
    final entry = DiaryEntry(
      id: post.id,
      content: post.content,
      date: DateTime.now(),
      mood: Mood.joy, // 默认心情
      image: post.image,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryDetailPage(
          entry: entry,
          isOwn: false,
          onReport: _handleReport,
          onBlock: _handleBlock,
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
  }

  void _refreshPosts() {
    setState(() {
      _posts = SampleData.getSamplePosts();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('已刷新'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.ink,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 过滤掉被拉黑用户的帖子
    var filteredPosts = _posts.where((p) => !_blockedUsers.contains(p.author)).toList();
    
    final displayPosts = _filter == 'liked'
        ? filteredPosts.where((p) => p.isLiked).toList()
        : filteredPosts;

    return DualGlowBackground(
      child: CustomScrollView(
        slivers: [
          // 头部
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.tableBackground,
                    AppColors.tableBackground.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '记忆广场',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${displayPosts.length} 条记忆',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.ink.withValues(alpha: 0.5),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // 视图切换按钮
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isGridView = !_isGridView;
                                });
                              },
                              icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
                              color: AppColors.ink,
                              tooltip: _isGridView ? '列表视图' : '网格视图',
                            ),
                          ),
                          const SizedBox(width: 8),
                          // 筛选按钮
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: PopupMenuButton<String>(
                              icon: const Icon(Icons.filter_list_rounded, color: AppColors.ink),
                              onSelected: (value) {
                                setState(() {
                                  _filter = value;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'all',
                                  child: Row(
                                    children: [
                                      Icon(Icons.public, size: 18),
                                      SizedBox(width: 12),
                                      Text('全部'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'liked',
                                  child: Row(
                                    children: [
                                      Icon(Icons.favorite, size: 18, color: Colors.red),
                                      SizedBox(width: 12),
                                      Text('我喜欢的'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // 刷新按钮
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: _refreshPosts,
                              icon: const Icon(Icons.refresh_rounded),
                              color: AppColors.ink,
                              tooltip: '刷新',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _isGridView
              ? SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = displayPosts[index];
                        return _buildPostCard(post);
                      },
                      childCount: displayPosts.length,
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = displayPosts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildListCard(post),
                        );
                      },
                      childCount: displayPosts.length,
                    ),
                  ),
                ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(SquarePost post) {
    return Transform.rotate(
      angle: post.angle * 0.0174533, // 转换为弧度
      child: GestureDetector(
        onTap: () => _showPostDetail(post),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片/颜色区域
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: post.image == null
                        ? _parseColor(post.color)
                        : Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: post.image != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                          child: Image.network(
                            post.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: _parseColor(post.color),
                              );
                            },
                          ),
                        )
                      : Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: NoisePainter(),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // 文字区域
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.ink,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          post.author,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.ink.withValues(alpha: 0.5),
                            letterSpacing: 1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleLike(post.id),
                          child: Row(
                            children: [
                              Icon(
                                post.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 14,
                                color: post.isLiked
                                    ? Colors.red
                                    : AppColors.inkLight,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${post.likes}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.ink.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(SquarePost post) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _showPostDetail(post),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.06),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                // 图片/颜色区域
                Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                    color: post.image == null
                        ? _parseColor(post.color)
                        : Colors.grey[200],
                  ),
                  child: post.image != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              post.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: _parseColor(post.color),
                                  child: CustomPaint(
                                    painter: NoisePainter(),
                                  ),
                                );
                              },
                            ),
                            // 渐变遮罩
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.1),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            CustomPaint(
                              painter: NoisePainter(),
                            ),
                            // 装饰性图标
                            Center(
                              child: Icon(
                                Icons.auto_stories_rounded,
                                size: 40,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                ),

                // 文字区域
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 内容文本
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.content,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.ink,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            // 作者信息
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _parseColor(post.color).withValues(alpha: 0.6),
                                        _parseColor(post.color).withValues(alpha: 0.4),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      post.author[0],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    post.author,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.ink.withValues(alpha: 0.7),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // 底部操作栏
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 点赞按钮
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: post.isLiked
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : AppColors.ink.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: post.isLiked
                                      ? Colors.red.withValues(alpha: 0.2)
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    post.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16,
                                    color: post.isLiked
                                        ? Colors.red
                                        : AppColors.inkLight,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${post.likes}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: post.isLiked
                                          ? Colors.red
                                          : AppColors.ink.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // 更多操作按钮
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.ink.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.more_horiz,
                                size: 18,
                                color: AppColors.ink.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.05);
    
    for (var i = 0; i < 200; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 17) % size.height;
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
