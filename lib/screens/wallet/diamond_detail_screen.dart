import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zhenyu_flutter/api/diamond_api.dart';
import 'package:zhenyu_flutter/models/diamond_api_model.dart';
import 'package:zhenyu_flutter/theme.dart';

class DiamondDetailScreen extends StatefulWidget {
  const DiamondDetailScreen({
    super.key,
    required this.incomeBalance,
    required this.inviteDiamondAmount,
  });

  final num incomeBalance;
  final num inviteDiamondAmount;

  @override
  State<DiamondDetailScreen> createState() => _DiamondDetailScreenState();
}

class _DiamondDetailScreenState extends State<DiamondDetailScreen> {
  final List<InviteIncomeItem> _records = <InviteIncomeItem>[];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasNext = false;
  int _pageNum = 1;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        !_isLoadingMore &&
        !_isLoading &&
        _hasNext) {
      _fetchData(loadMore: true);
    }
  }

  Future<void> _fetchData({bool loadMore = false}) async {
    if (loadMore) {
      setState(() => _isLoadingMore = true);
    } else {
      setState(() {
        _isLoading = true;
        if (_records.isEmpty) {
          _pageNum = 1;
        }
      });
    }

    try {
      final resp = await DiamondApi.getInviteIncomeList(
        InviteIncomeListReq(pageNum: _pageNum, pageSize: _pageSize),
      );
      if (!mounted) return;

      if (resp.code == 0) {
        final data = resp.data;
        final newList = data?.list ?? <InviteIncomeItem>[];
        setState(() {
          if (loadMore) {
            _records.addAll(newList);
          } else {
            _records
              ..clear()
              ..addAll(newList);
          }
          _hasNext = data?.hasNext ?? false;
          if (_hasNext) {
            _pageNum += 1;
          }
        });
      } else {
        final message = resp.message ?? '加载失败';
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('加载失败: $e')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    _pageNum = 1;
    await _fetchData();
  }

  String _formatNumber(num value) {
    if (value is int || value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textFieldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('我的奖励', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              '明细',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _isLoading && _records.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    color: AppColors.secondaryGradientStart,
                    onRefresh: _onRefresh,
                    child: _records.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 120.h),
                              Center(
                                child: Text(
                                  '暂无数据~',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            itemCount:
                                _records.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _records.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final item = _records[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.incomeDesc ?? '--',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${item.income ?? 0}钻石',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item.incomeTime ?? '--',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SizedBox(
        height: 200.h,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  'assets/images/wallet/diamond_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 20.w,
              top: 24.h,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '总获得钻石 :',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/wallet/diamond.png',
                        width: 20.w,
                        height: 20.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formatNumber(widget.inviteDiamondAmount),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 26.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '钻石余额 :',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/wallet/diamond.png',
                        width: 20.w,
                        height: 20.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formatNumber(widget.incomeBalance),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 26.sp,
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
    );
  }
}
