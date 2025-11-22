import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/api/posts_api.dart';
import 'package:zhenyu_flutter/api/index_api.dart';
import 'package:zhenyu_flutter/models/posts_api_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zhenyu_flutter/screens/common/post_card.dart';
import 'package:zhenyu_flutter/screens/common/publish_post_fab.dart';
import 'package:zhenyu_flutter/screens/common/gradient_tab_indicator.dart';
import 'package:zhenyu_flutter/screens/common/new_user_discount_dialog.dart';
import 'package:zhenyu_flutter/screens/explore/explore_message_screen.dart';
import 'package:zhenyu_flutter/shared/location_permission_helper.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['同城', '推荐'];

  // State for "Same City" list
  final List<PostInfo> _cityPosts = [];
  final ScrollController _cityScrollController = ScrollController();
  int _cityPageNum = 1;
  bool _isCityLoading = true;
  bool _isCityLoadingMore = false;

  // State for "Recommended" list
  final List<PostInfo> _recommendedPosts = [];
  final ScrollController _recommendedScrollController = ScrollController();
  int _recommendedPageNum = 1;
  bool _isRecommendedLoading = true;
  bool _isRecommendedLoadingMore = false;

  String? _cityCode;
  late TapGestureRecognizer _locationTipRecognizer;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _locationTipRecognizer = TapGestureRecognizer()
      ..onTap = _onLocationTipTapped;

    _cityScrollController.addListener(() {
      if (_cityScrollController.position.pixels ==
          _cityScrollController.position.maxScrollExtent) {
        _fetchCityPosts();
      }
    });

    _recommendedScrollController.addListener(() {
      if (_recommendedScrollController.position.pixels ==
          _recommendedScrollController.position.maxScrollExtent) {
        _fetchRecommendedPosts();
      }
    });

    // Initial data fetch
    _fetchRecommendedPosts();
    _fetchCityPosts();
    _getUnreadCount();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cityScrollController.dispose();
    _recommendedScrollController.dispose();
    _locationTipRecognizer.dispose();
    super.dispose();
  }

  Future<void> _fetchRecommendedPosts({bool isRefresh = false}) async {
    if (isRefresh) {
      _recommendedPageNum = 1;
    }
    if (_isRecommendedLoadingMore) return;

    setState(() {
      if (isRefresh) {
        _isRecommendedLoading = true;
      } else {
        _isRecommendedLoadingMore = true;
      }
    });

    try {
      final req = PostsListReq(
        pageNum: _recommendedPageNum,
        pageSize: 10,
        type: 2, // 2 for recommended
      );
      final resp = await PostsApi.postsList(req);
      if (resp.code == 0 && resp.data?.list != null) {
        setState(() {
          if (isRefresh) {
            _recommendedPosts.clear();
          }
          _recommendedPosts.addAll(resp.data!.list!);
          _recommendedPageNum++;
        });
      }
    } catch (e) {
      print('Failed to load recommended posts: $e');
    } finally {
      setState(() {
        _isRecommendedLoading = false;
        _isRecommendedLoadingMore = false;
      });
    }
  }

  Future<void> _fetchCityPosts({bool isRefresh = false}) async {
    if (isRefresh) {
      _cityPageNum = 1;
    }
    if (_isCityLoadingMore) return;

    setState(() {
      if (isRefresh) {
        _isCityLoading = true;
      } else {
        _isCityLoadingMore = true;
      }
    });

    try {
      // 1. Get location
      if (_cityCode == null) {
        final position = await _determinePosition();
        if (position != null) {
          final cityResp = await IndexApi.getLocationCity(
            position.longitude,
            position.latitude,
          );
          if (cityResp.code == 0 && cityResp.data?.cityCode != null) {
            _cityCode = cityResp.data!.cityCode;
          }
        }
      }

      if (_cityCode == null) {
        // Don't throw an exception, just return. The UI will show an empty state.
        // The error is already printed by the getLocationCity call if it fails.
        setState(() {
          _isCityLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('无法获取位置信息，请检查定位权限或网络')));
        }
        return;
      }

      // 2. Fetch posts
      final req = PostsListReq(
        pageNum: _cityPageNum,
        pageSize: 10,
        type: 1, // 1 for same city
        cityCode: _cityCode,
      );
      final resp = await PostsApi.postsList(req);
      if (resp.code == 0 && resp.data?.list != null) {
        setState(() {
          if (isRefresh) {
            _cityPosts.clear();
          }
          _cityPosts.addAll(resp.data!.list!);
          _cityPageNum++;
        });
      }
    } catch (e) {
      print('Failed to load city posts: $e');
      final errorMessage = e.toString();
      if (mounted) {
        showLocationPermissionSnackBar(context, errorMessage);
      }
      // Optionally show an error message to the user
    } finally {
      setState(() {
        _isCityLoading = false;
        _isCityLoadingMore = false;
      });
    }
  }

  /// Determine the current position of the device.
  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getUnreadCount() async {
    try {
      final resp = await PostsApi.getUnreadCount({});
      if (resp.code == 0 && resp.data != null) {
        setState(() {
          _unreadCount = resp.data!;
        });
      }
    } catch (e) {
      print('Failed to get unread count: $e');
    }
  }

  void _handlePostDeleted(int postId) {
    setState(() {
      _cityPosts.removeWhere((post) => post.id == postId);
      _recommendedPosts.removeWhere((post) => post.id == postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            leadingWidth: 0,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildTabBar()),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/post_hint.png',
                        width: 48.w,
                        height: 48.h,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ExploreMessageScreen(),
                          ),
                        );
                      },
                    ),
                    if (_unreadCount > 0)
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16.w,
                            minHeight: 16.h,
                          ),
                          child: Text(
                            '$_unreadCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildPostsList(
                posts: _cityPosts,
                isLoading: _isCityLoading,
                controller: _cityScrollController,
                onRefresh: () => _fetchCityPosts(isRefresh: true),
                isCityTab: true,
              ),
              _buildPostsList(
                posts: _recommendedPosts,
                isLoading: _isRecommendedLoading,
                controller: _recommendedScrollController,
                onRefresh: () => _fetchRecommendedPosts(isRefresh: true),
              ),
            ],
          ),
        ),
        const PublishPostFab(),
        NewUserDiscountWidget(bottom: 140.h, right: 30.w),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: _tabs.map((String name) => Tab(text: name)).toList(),
      isScrollable: true, // Allows the TabBar to be left-aligned
      tabAlignment: TabAlignment.start,
      labelStyle: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 26.sp),
      labelColor: AppColors.textPrimary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorSize: TabBarIndicatorSize.label, // Makes indicator tight to text
      dividerColor: Colors.transparent, // Removes the bottom line
      indicator: GradientTabIndicator(
        gradient: AppGradients.primaryGradient,
        height: 10.h,
        width: 40.w,
        radius: 20.r,
        bottomMargin: 20.h,
        left: 20.w,
      ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPostsList({
    required List<PostInfo> posts,
    required bool isLoading,
    required ScrollController controller,
    required Future<void> Function() onRefresh,
    bool isCityTab = false,
  }) {
    if (isLoading && posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (posts.isEmpty) {
      if (isCityTab && _cityCode == null) {
        return Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: AppColors.textSecondary, fontSize: 28.sp),
              children: [
                const TextSpan(text: '无法获取位置信息，'),
                TextSpan(
                  text: '点击尝试重新定位',
                  style: const TextStyle(color: AppColors.goldGradientStart),
                  recognizer: _locationTipRecognizer,
                ),
                const TextSpan(text: '\n定位优先推荐附近内容~'),
              ],
            ),
          ),
        );
      }
      return const Center(child: StyledText('暂无数据~'));
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: controller,
        itemCount: posts.length + 1, // +1 for loading indicator
        itemBuilder: (context, index) {
          if (index == posts.length) {
            return _buildLoader();
          }
          final post = posts[index];
          return PostCard(post: post, onPostDeleted: _handlePostDeleted);
        },
      ),
    );
  }

  void _onLocationTipTapped() {
    _fetchCityPosts(isRefresh: true);
  }
}
