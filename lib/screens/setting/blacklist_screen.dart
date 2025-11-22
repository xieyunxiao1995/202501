import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class BlacklistScreen extends StatefulWidget {
  const BlacklistScreen({super.key});

  @override
  State<BlacklistScreen> createState() => _BlacklistScreenState();
}

class _BlacklistScreenState extends State<BlacklistScreen> {
  final List<BlacklistUserInfo> _users = [];
  final ScrollController _scrollController = ScrollController();
  final Set<int> _removingUids = <int>{};

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasNext = true;
  int _pageNum = 1;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _fetchBlacklist();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent <= 0) {
      return;
    }
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _fetchBlacklist(loadMore: true);
    }
  }

  Future<void> _fetchBlacklist({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore || !_hasNext) {
        return;
      }
    } else if (_isLoading) {
      return;
    }

    final nextPage = loadMore ? _pageNum + 1 : 1;

    setState(() {
      if (loadMore) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
      }
    });

    try {
      final resp = await UserApi.getBlacklist(
        BlacklistRequest(pageNum: nextPage, pageSize: _pageSize),
      );
      if (!mounted) return;

      final items = resp.data?.list ?? <BlacklistUserInfo>[];

      setState(() {
        if (loadMore) {
          _users.addAll(items);
        } else {
          _users
            ..clear()
            ..addAll(items);
        }
        _pageNum = nextPage;
        _hasNext = resp.data?.hasNext ?? false;
      });
    } catch (e) {
      if (!mounted) return;
      showMsg(context, '获取黑名单失败');
    } finally {
      if (!mounted) return;
      setState(() {
        if (loadMore) {
          _isLoadingMore = false;
        } else {
          _isLoading = false;
        }
      });
    }
  }

  Future<void> _removeFromBlacklist(int uid) async {
    if (_removingUids.contains(uid)) {
      return;
    }

    setState(() {
      _removingUids.add(uid);
    });

    try {
      final resp = await UserApi.removeBlacklistUser(
        BlacklistModifyRequest(toUid: uid),
      );
      if (!mounted) return;

      if (resp.code == 0) {
        showMsg(context, '已取消拉黑');
        await _fetchBlacklist();
      } else {
        showMsg(context, resp.message ?? '操作失败');
      }
    } catch (e) {
      if (mounted) {
        showMsg(context, '操作失败');
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _removingUids.remove(uid);
      });
    }
  }

  Future<void> _onRefresh() {
    return _fetchBlacklist();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledText('黑名单', fontSize: 18),
        centerTitle: false,
      ),
      body: RefreshIndicator(onRefresh: _onRefresh, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 120),
        children: const [
          Center(
            child: Text(
              '暂无数据~',
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.5),
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _users.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _users.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final item = _users[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  _buildAvatar(item.avatar),
                  const SizedBox(width: 16),
                  Expanded(child: _buildUserInfo(item)),
                  const SizedBox(width: 12),
                  _buildRemoveButton(item),
                ],
              ),
            ),
            if (index != _users.length - 1)
              Container(
                margin: const EdgeInsets.only(left: 88, right: 16),
                height: 1,
                color: AppColors.primaryColor,
              ),
          ],
        );
      },
    );
  }

  Widget _buildUserInfo(BlacklistUserInfo item) {
    return Row(
      children: [
        Flexible(
          child: Text(
            (item.userName == null || item.userName!.isEmpty)
                ? '未命名用户'
                : item.userName!,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _buildGenderBadge(item.sex),
      ],
    );
  }

  Widget _buildGenderBadge(int? sex) {
    if (sex == null) {
      return const SizedBox.shrink();
    }

    final bool isFemale = sex == 0;
    final Color background = isFemale
        ? const Color(0x80F4497D)
        : const Color(0x8031B1DB);
    final String asset = isFemale
        ? 'assets/images/gender_girl.png'
        : 'assets/images/gender_boy.png';

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Image.asset(asset, width: 14, height: 14),
    );
  }

  Widget _buildRemoveButton(BlacklistUserInfo item) {
    final uid = item.uid;
    final bool isBusy = uid != null && _removingUids.contains(uid);
    final bool enabled = uid != null && !isBusy;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => _removeFromBlacklist(uid!) : null,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          width: 90,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: AppColors.secondaryGradientEnd),
          ),
          child: isBusy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  '移除',
                  style: TextStyle(
                    color: enabled
                        ? AppColors.secondaryGradientEnd
                        : const Color.fromRGBO(242, 219, 168, 0.5),
                    fontSize: 12,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String? avatarUrl) {
    const double size = 42;

    if (avatarUrl == null || avatarUrl.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF2B2A30),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.person, color: Colors.white54, size: 24),
      );
    }

    return ClipOval(
      child: Image.network(
        avatarUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Color(0xFF2B2A30),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Colors.white54, size: 24),
          );
        },
      ),
    );
  }
}
