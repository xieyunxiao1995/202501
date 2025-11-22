import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';

import 'package:zhenyu_flutter/api/posts_api.dart';
import 'package:zhenyu_flutter/models/posts_api_model.dart';
import 'package:zhenyu_flutter/screens/common/post_card.dart';
import 'package:zhenyu_flutter/screens/common/publish_post_fab.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  final List<PostInfo> _posts = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasNext = false;

  int _pageNum = 1;
  final int _pageSize = 10;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _loadUserId();
    if (!mounted) return;
    await _fetchPosts(isRefresh: true);
  }

  Future<void> _loadUserId() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    if (currentUser != null) {
      setState(() {
        _userId = currentUser.id;
      });
    }
  }

  void _onScroll() {
    if (!_hasNext || _isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchPosts();
    }
  }

  Future<void> _fetchPosts({bool isRefresh = false}) async {
    if (_isLoadingMore && !isRefresh) return;

    if (isRefresh) {
      _pageNum = 1;
      _hasNext = false;
    }

    setState(() {
      if (isRefresh) {
        _isLoading = true;
      } else {
        _isLoadingMore = true;
      }
    });

    try {
      final req = PostsMyListReq(
        pageNum: _pageNum,
        pageSize: _pageSize,
        uid: _userId,
      );
      final resp = await PostsApi.postsMyList(req);
      if (!mounted) return;
      if (resp.code == 0) {
        final list = resp.data?.list ?? [];
        setState(() {
          if (isRefresh) {
            _posts
              ..clear()
              ..addAll(list);
          } else {
            _posts.addAll(list);
          }
          _hasNext = resp.data?.hasNext ?? false;
          if (_hasNext) {
            _pageNum++;
          }
        });
      } else {
        _showMessage(resp.message ?? '加载失败');
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('加载失败: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refresh() => _fetchPosts(isRefresh: true);

  void _handlePostDeleted(int postId) {
    setState(() {
      _posts.removeWhere((post) => post.id == postId);
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, title: const Text('我的动态')),
          body: _buildBody(),
        ),
        PublishPostFab(
          onReturn: () async {
            await _refresh();
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading && _posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_posts.isEmpty) {
      return const Center(
        child: StyledText('暂无数据~', color: AppColors.textSecondary),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        itemCount: _posts.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _posts.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final post = _posts[index];
          return PostCard(post: post, onPostDeleted: _handlePostDeleted);
        },
      ),
    );
  }
}
