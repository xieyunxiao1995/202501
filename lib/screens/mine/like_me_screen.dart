import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/api/attention_api.dart';
import 'package:zhenyu_flutter/models/attention_api_model.dart';
import 'package:zhenyu_flutter/screens/message/im_screen.dart';
import 'package:zhenyu_flutter/screens/profile/profile_screen.dart';
import 'package:zhenyu_flutter/theme.dart';

class LikeMeScreen extends StatefulWidget {
  final String type; // ATTENTION: 我喜欢, FANS: 喜欢我

  const LikeMeScreen({super.key, required this.type});

  @override
  State<LikeMeScreen> createState() => _LikeMeScreenState();
}

class _LikeMeScreenState extends State<LikeMeScreen> {
  String _title = '';
  final List<AttentionUserInfo> _list = [];
  final ScrollController _scrollController = ScrollController();

  int _pageNum = 1;
  final int _pageSize = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'ATTENTION') {
      _title = '我喜欢';
    } else if (widget.type == 'FANS') {
      _title = '喜欢我';
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchData();
      }
    });

    _fetchData(isRefresh: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData({bool isRefresh = false}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _isFirstLoad = true;
      }
    });

    if (isRefresh) {
      _pageNum = 1;
      _list.clear();
      _hasMore = true;
    }

    try {
      final res = await AttentionApi.likeList(
        LikeListReq(pageNum: _pageNum, pageSize: _pageSize, type: widget.type),
      );

      if (res.code == 0 && res.data != null) {
        setState(() {
          _list.addAll(res.data!.list);
          _hasMore = res.data!.hasNext;
          if (_hasMore) {
            _pageNum++;
          }
        });
      } else {
        _showSnack(res.message);
      }
    } catch (e) {
      _showSnack('加载失败，请稍后重试');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isFirstLoad = false;
        });
      }
    }
  }

  void _goToChat(int uid, String userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ImScreen(userId: uid.toString(), displayName: userName),
      ),
    );
  }

  void _goToProfile(int uid) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(userId: uid)),
    );
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(title: Text(_title)),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(isRefresh: true),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isFirstLoad && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_list.isEmpty) {
      return const Center(
        child: Text('暂无数据~', style: TextStyle(color: Colors.white54)),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: _list.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _list.length) {
          return _buildLoader();
        }
        final item = _list[index];
        return _buildListItem(item);
      },
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildListItem(AttentionUserInfo item) {
    return InkWell(
      onTap: () => _goToProfile(item.uid),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 45.r,
              backgroundImage: NetworkImage(item.avatar),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 15.h),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white12, width: 0.5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.userName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item.realType == 1)
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Image.asset(
                                    'assets/images/user_tag_real.png',
                                    height: 20.h,
                                  ),
                                ),
                              if (item.vip == 1)
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Image.asset(
                                    'assets/images/user_tag_vip.png',
                                    height: 20.h,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          if (item.age > 0 || item.city.isNotEmpty)
                            Text(
                              '${item.age > 0 ? '${item.age}岁' : ''} ${item.city.isNotEmpty ? '| ${item.city}' : ''}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 24.sp,
                              ),
                            ),
                          SizedBox(height: 8.h),
                          if (item.lookTimeFormat.isNotEmpty)
                            Text(
                              item.lookTimeFormat,
                              style: TextStyle(
                                color: AppColors.goldGradientStart,
                                fontSize: 22.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => _goToChat(item.uid, item.userName),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppGradients.primaryGradient,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Text(
                          '去聊天',
                          style: TextStyle(
                            color: AppColors.btnText,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
}
