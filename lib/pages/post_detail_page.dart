import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/data.dart';
import '../theme/theme.dart';

class PostDetailPage extends StatefulWidget {
  final CommunityPost post;
  final String heroTag;

  const PostDetailPage({super.key, required this.post, required this.heroTag});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _likeController;
  late AnimationController _saveController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _saveScaleAnimation;

  @override
  void initState() {
    super.initState();

    _likeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _saveController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _likeScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_likeController);

    _saveScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_saveController);
  }

  @override
  void dispose() {
    _likeController.dispose();
    _saveController.dispose();
    super.dispose();
  }

  Future<void> _handleLike() async {
    HapticFeedback.lightImpact();
    _likeController.forward().then((_) => _likeController.reverse());
    final post = widget.post;
    await AppState.instance.togglePostLike(post.id);
  }

  void _handleSave() {
    HapticFeedback.lightImpact();
    _saveController.forward().then((_) => _saveController.reverse());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('帖子已保存！⭐'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF1A3A34),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_horiz_rounded,
                    size: 20,
                    color: Color(0xFF1A3A34),
                  ),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showMoreOptions(context, post);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: '${widget.heroTag}_avatar',
                        child: Material(
                          color: Colors.transparent,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade200,
                            child:
                                post.userAvatar != null &&
                                    post.userAvatar!.startsWith('http')
                                ? ClipOval(
                                    child: Image.network(
                                      post.userAvatar!,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Text(
                                              post.userAvatar!.substring(0, 1),
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            );
                                          },
                                    ),
                                  )
                                : Text(
                                    post.userAvatar ?? '?',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.userName ?? '匿名用户',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            ),
                            if (post.timeAgo != null)
                              Text(
                                post.timeAgo!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (post.tag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            post.tag!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (post.imageUrl != null) ...[
                    Hero(
                      tag: widget.heroTag,
                      flightShuttleBuilder:
                          (
                            BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext,
                          ) {
                            return Material(
                              color: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  post.imageUrl!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.error,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                      placeholderBuilder:
                          (BuildContext context, Size size, Widget child) {
                            return Material(
                              color: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                      child: Material(
                        color: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              post.imageUrl!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (post.content != null)
                    Text(
                      post.content!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        height: 1.6,
                      ),
                    ),

                  const SizedBox(height: 32),

                  Container(height: 1, color: Colors.grey.shade200),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      _buildStatItem(
                        Icons.volunteer_activism,
                        '${post.likes}',
                        '点赞',
                      ),
                      const SizedBox(width: 24),
                      _buildStatItem(Icons.comment_outlined, '0', '评论'),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AnimatedActionButton(
                        icon: Icons.volunteer_activism_rounded,
                        label: '点赞',
                        isActive: post.isLiked,
                        activeColor: AppColors.primaryDark,
                        controller: _likeController,
                        scaleAnimation: _likeScaleAnimation,
                        onTap: _handleLike,
                      ),
                      _AnimatedActionButton(
                        icon: Icons.bookmark_border_rounded,
                        label: '收藏',
                        isActive: false,
                        activeColor: AppColors.primaryDark,
                        controller: _saveController,
                        scaleAnimation: _saveScaleAnimation,
                        onTap: _handleSave,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      ],
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
              _buildOptionItem(Icons.report_outlined, '举报帖子', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('举报已收到，我们将在48小时内处理。')),
                );
              }),
              _buildOptionItem(Icons.block_outlined, '屏蔽用户', () {
                Navigator.pop(context); // pop modal
                final author = post.userName ?? '匿名用户';
                AppState.instance.blockUser(author);
                Navigator.pop(context); // pop detail page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('用户已屏蔽，其帖子将不再显示。')),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(label, style: const TextStyle(color: AppColors.textMain)),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final AnimationController? controller;
  final Animation<double>? scaleAnimation;
  final VoidCallback onTap;

  const _AnimatedActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    this.controller,
    this.scaleAnimation,
    required this.onTap,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressScaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _pressScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _pressController.forward().then((_) {
      _pressController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _pressScaleAnimation,
        child: AnimatedBuilder(
          animation: widget.controller ?? AlwaysStoppedAnimation(0),
          builder: (context, child) {
            final scaleAnim =
                widget.scaleAnimation ?? const AlwaysStoppedAnimation(1.0);
            return ScaleTransition(scale: scaleAnim, child: child);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? widget.activeColor.withOpacity(0.15)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isActive
                    ? widget.activeColor.withOpacity(0.5)
                    : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  widget.icon,
                  size: 26,
                  color: widget.isActive
                      ? widget.activeColor
                      : Colors.grey.shade500,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.isActive
                        ? widget.activeColor
                        : Colors.grey.shade600,
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
