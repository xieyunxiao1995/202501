import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:zhenyu_flutter/api/vip_api.dart';
import 'package:zhenyu_flutter/models/vip_api_model.dart';
import 'package:zhenyu_flutter/screens/common/gradient_tab_indicator.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';

class BillScreen extends StatefulWidget {
  final int? type;
  const BillScreen({super.key, this.type});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  List<BillListItem> _billList = [];
  bool _hasNext = true;
  int _page = 1;
  final int _pageSize = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.type == 2 ? 1 : 0,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _getBillList(isRefresh: true);
      }
    });
    _getBillList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getBillList({bool isRefresh = false}) async {
    if (_isLoading) return;
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    if (isRefresh) {
      _page = 1;
      _billList.clear();
    }
    try {
      final req = BillListRequest(
        monthOfYear: intl.DateFormat('yyyy-MM').format(_selectedDate),
        pageNum: _page,
        pageSize: _pageSize,
        type: _tabController.index == 0 ? 'EXPENSE' : 'INCOME',
      );
      final res = await VipApi.getBillList(req);
      if (mounted) {
        setState(() {
          _billList.addAll(res.data?.list ?? []);
          _hasNext = res.data?.hasNext ?? false;
          _page++;
        });
      }
    } catch (e) {
      // handle error
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDatePicker(BuildContext context) {
    int selectedYear = _selectedDate.year;
    int selectedMonth = _selectedDate.month;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('完成'),
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _selectedDate = DateTime(selectedYear, selectedMonth);
                        });
                      }
                      _getBillList(isRefresh: true);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedYear - 2020,
                        ),
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          selectedYear = 2020 + index;
                        },
                        children: List<Widget>.generate(11, (int index) {
                          return Center(child: Text('${2020 + index}年'));
                        }),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedMonth - 1,
                        ),
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          selectedMonth = index + 1;
                        },
                        children: List<Widget>.generate(12, (int index) {
                          return Center(child: Text('${index + 1}月'));
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('账单'),
        bottom: TabBar(
          controller: _tabController,
          indicator: const GradientTabIndicator(
            gradient: AppGradients.primaryGradient,
            height: 6,
            width: 24,
            radius: 2,
            bottomMargin: 6,
            left: 5,
          ),
          tabs: const [
            Tab(text: '支出'),
            Tab(text: '收入'),
          ],
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  StyledText('${_selectedDate.year}年${_selectedDate.month}月'),
                  const Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildBillList(), _buildBillList()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillList() {
    if (_billList.isEmpty && !_isLoading) {
      return const Center(child: Text('~ 暂无数据 ~'));
    }
    return RefreshIndicator(
      onRefresh: () => _getBillList(isRefresh: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              _hasNext) {
            _getBillList();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _billList.length + (_hasNext && _isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _billList.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final bill = _billList[index];
            return ListTile(
              title: StyledText(bill.title ?? ''),
              subtitle: StyledText(bill.info ?? ''),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${bill.changeValue ?? 0} ${bill.company == "COIN" ? '金币' : '钻石'}',
                    style: TextStyle(
                      color: AppColors.goldGradientEnd,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bill.createTime ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
