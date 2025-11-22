import 'dart:async';

import 'package:flutter/material.dart';

import 'package:zhenyu_flutter/api/diamond_api.dart';
import 'package:zhenyu_flutter/models/diamond_api_model.dart';
import 'package:zhenyu_flutter/screens/invate/invate_screen.dart';
import 'package:zhenyu_flutter/screens/wallet/bill_screen.dart';
import 'package:zhenyu_flutter/screens/wallet/diamond_withdraw_screen.dart';
import 'package:zhenyu_flutter/theme.dart';

class DiamondScreen extends StatefulWidget {
  const DiamondScreen({super.key});

  @override
  State<DiamondScreen> createState() => _DiamondScreenState();
}

class _DiamondScreenState extends State<DiamondScreen> {
  DiamondExchangeConfigData? _config;
  int? _activeId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final resp = await DiamondApi.getWithdrawExchangeConfig();
      if (!mounted) return;
      if (resp.code == 0) {
        setState(() {
          _config = resp.data;
          final list = resp.data?.list;
          _activeId = (list != null && list.isNotEmpty) ? list.first.id : null;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(resp.message ?? '加载失败')));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('加载失败: $e')));
    }
  }

  void _handleConfirmExchange() {
    if (_activeId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择兑换选项')));
      return;
    }

    final list = _config?.list ?? [];
    DiamondExchangeConfigItem? selectedItem;
    for (final item in list) {
      if (item.id == _activeId) {
        selectedItem = item;
        break;
      }
    }
    if (selectedItem == null) return;

    final targetItem = selectedItem!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondaryGradientStart,
                  AppColors.secondaryGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: const Center(
              child: Text(
                '兑换金币',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          titlePadding: EdgeInsets.zero,
          content: Text(
            '是否消耗${targetItem.incomeAmount ?? 0}钻石兑换${targetItem.exchangeAmount ?? 0}金币',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.btnText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 2,
                      ),
                    ),
                    child: const Text(
                      '取消',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.secondaryGradientStart,
                          AppColors.secondaryGradientEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 2,
                        ),
                      ),
                      child: const Text(
                        '确定',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close dialog first
                        _performExchange();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performExchange() async {
    if (_activeId == null) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('正在兑换...')));
    try {
      final res = await DiamondApi.withdrawExchangeApply(_activeId!);
      if (!mounted) return;
      messenger.hideCurrentSnackBar();
      final code = res['code'] as int? ?? -1;
      final message = res['message'] as String? ?? '兑换失败';
      if (code == 0) {
        messenger.showSnackBar(const SnackBar(content: Text('兑换成功')));
        _fetchData();
      } else {
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (!mounted) return;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text('兑换出错: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('我的钻石'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BillScreen()),
              );
            },
            child: const Text('账单', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _config == null
          ? Center(
              child: TextButton(
                onPressed: _fetchData,
                child: const Text('加载失败，点击重试'),
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBalanceCard(),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          '充值',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      _buildExchangeGrid(),
                      _buildRules(),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
                _buildConfirmButton(),
              ],
            ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      height: 125,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/wallet/diamond_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '当前钻石余额：',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/wallet/diamond.png',
                    width: 26,
                    height: 26,
                  ), // Placeholder
                  const SizedBox(width: 5),
                  Text(
                    '${_config?.balanceAmount ?? 0}',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          Positioned(
            // top: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DiamondWithdrawScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    '钻石提现',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            // top: 0,
            left: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const InvateScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    '获取钻石',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeGrid() {
    final list = _config?.list ?? [];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.95, // 调整为稍微高一点，避免溢出
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final bool isSelected = _activeId != null && _activeId == item.id;
        return GestureDetector(
          onTap: () {
            final itemId = item.id;
            if (itemId == null) return;
            setState(() {
              _activeId = itemId;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.containerBlackColor,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: AppColors.diamondSelectBorder, width: 2.5)
                  : Border.all(color: Colors.transparent, width: 2.5),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/wallet/coin.png',
                      width: 31,
                      height: 31,
                    ),
                    const SizedBox(height: 8), // 减小间距
                    Text(
                      '${item.exchangeAmount ?? 0}金币',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                      ),
                    ),
                    if ((item.giveAmount ?? 0) > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 2), // 减小间距
                        child: Text(
                          '赠送${item.giveAmount ?? 0}金币',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4), // 减小间距
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/wallet/diamond.png',
                          width: 12.5,
                          height: 12.5,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${item.incomeAmount ?? 0}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if ((item.tag ?? 0) == 1)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/wallet/recommend.png',
                      width: 52,
                      height: 15.5,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRules() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        '1、兑换比率：每100钻石换1金币\n2、每次最少兑换500钻石\n3、兑换成功不支持退换',
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 12.5,
          height: 1.8,
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: AppGradients.paleGoldGradient,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: _handleConfirmExchange,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            '确定兑换',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
