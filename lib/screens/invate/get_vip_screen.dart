import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/api/invite_api.dart';
import 'package:zhenyu_flutter/models/invite_api_model.dart';
import 'package:zhenyu_flutter/screens/vip/vip_screen.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/common.dart';

class GetVipScreen extends StatefulWidget {
  const GetVipScreen({super.key});

  @override
  State<GetVipScreen> createState() => _GetVipScreenState();
}

class _GetVipScreenState extends State<GetVipScreen> {
  VipGiftBenefitConfigData? _configData;
  List<VipGiftRecordItem> _giveList = [];
  List<String> _ruleList = [];

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasNext = false;

  int _pageNum = 1;
  final int _pageSize = 20;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _giveIdController = TextEditingController();

  int _popupType = 1; // 1=周会员, 2=月会员
  ToUserInfoData? _giveUserData;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _giveIdController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_hasNext && !_isLoadingMore) {
        _loadMoreRecords();
      }
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _getVipGiftBenefitConfig(),
      _getVipGiftBenefitRecords(isRefresh: true),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _getVipGiftBenefitConfig() async {
    try {
      final resp = await InviteApi.getVipGiftBenefitConfig();
      if (resp.code == 0 && resp.data != null) {
        setState(() {
          _configData = resp.data;
          _ruleList = resp.data!.ruleList?.take(1).toList() ?? [];
        });
      }
    } catch (e) {
      debugPrint('获取权益配置失败: $e'); // Log for debugging
      if (mounted) {
        _showToast('获取权益配置失败，请稍后重试');
      }
    }
  }

  Future<void> _getVipGiftBenefitRecords({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _pageNum = 1;
        _giveList.clear();
      });
    }

    try {
      setState(() => _isLoadingMore = !isRefresh);
      final req = VipGiftBenefitRecordsReq(
        pageNum: _pageNum,
        pageSize: _pageSize,
      );
      final resp = await InviteApi.getVipGiftBenefitRecords(req);

      if (resp.code == 0 && resp.data != null) {
        setState(() {
          if (isRefresh) {
            _giveList = resp.data!.list ?? [];
          } else {
            _giveList.addAll(resp.data!.list ?? []);
          }
          _hasNext = resp.data!.hasNext ?? false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      debugPrint('获取赠送记录失败: $e'); // Log for debugging
      setState(() => _isLoadingMore = false);
      if (mounted) {
        _showToast('获取赠送记录失败，请稍后重试');
      }
    }
  }

  Future<void> _loadMoreRecords() async {
    if (_hasNext && !_isLoadingMore) {
      setState(() => _pageNum++);
      await _getVipGiftBenefitRecords();
    }
  }

  void _showGiveDialog(int type) {
    final count = type == 1
        ? (_configData?.weekGiftCount ?? 0)
        : (_configData?.monthGiftCount ?? 0);

    if (count <= 0) {
      _showToast('没有赠送次数~');
      return;
    }

    setState(() => _popupType = type);
    _giveIdController.clear();

    showDialog(context: context, builder: (context) => _buildGiveDialog());
  }

  Future<void> _getUserInfo() async {
    if (_giveIdController.text.isEmpty) {
      _showToast('请输入对方的ID');
      return;
    }

    try {
      final req = VipGiftBenefitGetToUserInfoReq(
        userNumber: _giveIdController.text,
      );
      final resp = await InviteApi.vipGiftBenefitGetToUserInfo(req);

      if (resp.code == 0 && resp.data != null) {
        setState(() => _giveUserData = resp.data);
        if (mounted) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => _buildConfirmDialog(),
          );
        }
      } else {
        _showToast(resp.message ?? '获取用户信息失败');
      }
    } catch (e) {
      _showToast('获取用户信息失败');
    }
  }

  Future<void> _confirmGive() async {
    try {
      final req = VipGiftBenefitGiveReq(
        giftType: _popupType == 1 ? 'WEEK_VIP' : 'MONTH_VIP',
        toUserNumber: _giveIdController.text,
      );
      final resp = await InviteApi.vipGiftBenefitGive(req);

      if (resp.code == 0) {
        _showToast('赠送成功~');
        if (mounted) {
          Navigator.of(context).pop();
        }
        _giveIdController.clear();
        await _loadData();
      } else {
        _showToast(resp.message ?? '赠送失败');
      }
    } catch (e) {
      _showToast('赠送失败');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '邀请有奖',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 20),
                    _buildMiddleBox(),
                    const SizedBox(height: 20),
                    _buildGiftCountBox(1),
                    const SizedBox(height: 20),
                    _buildGiftCountBox(2),
                    const SizedBox(height: 40),
                    _buildShoppingVipButton(),
                    const SizedBox(height: 40),
                    _buildRecordsTable(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderSection() {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Image.asset(
        'assets/images/invate/giveVipBj.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF252525),
            child: const Center(
              child: Icon(Icons.image, color: Colors.white54, size: 50),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiddleBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF5E5E5E), width: 5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final rule in _ruleList)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  rule,
                  style: const TextStyle(
                    color: AppColors.invateScreenColor,
                    fontSize: 12,
                  ),
                ),
              ),
            if (_configData?.benefitList != null &&
                _configData!.benefitList!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildVipTable(),
            ],
            const SizedBox(height: 16),
            if (_configData?.ruleList != null)
              for (int i = 1; i < (_configData!.ruleList?.length ?? 0); i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _configData!.ruleList![i],
                    style: const TextStyle(
                      color: AppColors.invateScreenColor,
                      fontSize: 12,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildVipTable() {
    final benefits = _configData?.benefitList ?? [];
    if (benefits.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondaryGradientEnd),
      ),
      child: Column(
        children: [
          // 表头行
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3E2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: AppColors.secondaryGradientEnd,
                          width: 0.5,
                        ),
                        bottom: BorderSide(
                          color: AppColors.secondaryGradientEnd,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '充值时长',
                        style: TextStyle(
                          color: AppColors.invateScreenColor,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
                for (int i = 0; i < benefits.length; i++)
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                          right: i < benefits.length - 1
                              ? const BorderSide(
                                  color: AppColors.secondaryGradientEnd,
                                  width: 0.5,
                                )
                              : BorderSide.none,
                          bottom: const BorderSide(
                            color: AppColors.secondaryGradientEnd,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${benefits[i].level ?? ''}会员',
                          style: const TextStyle(
                            color: AppColors.invateScreenColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // 数据行
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: AppColors.secondaryGradientEnd,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '奖励天数',
                      style: TextStyle(
                        color: AppColors.invateScreenColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
              for (int i = 0; i < benefits.length; i++)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        right: i < benefits.length - 1
                            ? const BorderSide(
                                color: AppColors.secondaryGradientEnd,
                                width: 0.5,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        benefits[i].benefit ?? '',
                        style: const TextStyle(
                          color: AppColors.invateScreenColor,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCountBox(int type) {
    final count = type == 1
        ? (_configData?.weekGiftCount ?? 0)
        : (_configData?.monthGiftCount ?? 0);
    final title = type == 1 ? '周会员' : '月会员';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF5E5E5E), width: 5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '当前可赠送$title次数:$count',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () => _showGiveDialog(type),
              child: Container(
                width: 50,
                height: 25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      count > 0
                          ? 'assets/images/invate/yqbt.png'
                          : 'assets/images/invate/yqbt2.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '赠送',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShoppingVipButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VipScreen()),
          );
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.secondaryGradientStart,
                AppColors.secondaryGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(83),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.5),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '购买会员',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordsTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF5E5E5E), width: 5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                '我的赠送',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // 表头
            Container(
              color: const Color(0xFFFFF3E2),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      '头像用户',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.invateScreenColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '赠送会员类型',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.invateScreenColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '赠送时间',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.invateScreenColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 数据行
            if (_giveList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        '还没有赠送记录',
                        style: TextStyle(
                          color: Color(0xFF949494),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '快去赠送好友会员吧',
                        style: TextStyle(
                          color: Color(0xFF949494),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              for (final item in _giveList) _buildRecordRow(item),
            if (_isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordRow(VipGiftRecordItem item) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.secondaryGradientEnd, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFF2F2F2),
                  backgroundImage:
                      item.toAvatar != null && item.toAvatar!.isNotEmpty
                      ? NetworkImage(item.toAvatar!)
                      : null,
                  child: item.toAvatar == null || item.toAvatar!.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.toUserName ?? '--',
                        style: const TextStyle(
                          color: AppColors.invateScreenColor,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'ID:${item.toUserNumber ?? '--'}',
                        style: const TextStyle(
                          color: Color(0xFF949494),
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              item.giftVipName ?? '--',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.invateScreenColor,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              item.createTime != null ? formatDate(item.createTime!) : '--',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.invateScreenColor,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiveDialog() {
    return Dialog(
      backgroundColor: const Color(0xFF252429),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '赠送${_popupType == 1 ? '周' : '月'}会员',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF151419),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _giveIdController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: '(请输入对方的ID)',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _getUserInfo,
              child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.secondaryGradientStart,
                      AppColors.secondaryGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(83),
                ),
                child: const Center(
                  child: Text(
                    '赠送',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmDialog() {
    // 打印用户数据
    debugPrint('========== 赠送确认对话框 ==========');
    debugPrint('用户头像: ${_giveUserData?.avatar}');
    debugPrint('用户昵称: ${_giveUserData?.userName}');
    debugPrint('用户ID: ${_giveUserData?.userNumber}');
    debugPrint('赠送类型: ${_popupType == 1 ? '周会员' : '月会员'}');
    debugPrint('=====================================');

    const double avatarRadius = 40.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(top: avatarRadius),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 对话框内容
            Container(
              width: 290,
              padding: const EdgeInsets.only(
                top: avatarRadius + 40, // 为头像和用户名预留空间
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF252429),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '是否确认给以下用户赠送${_popupType == 1 ? '周' : '月'}会员',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(83),
                          ),
                          child: const Center(
                            child: Text(
                              '取消',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _confirmGive,
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.secondaryGradientStart,
                                AppColors.secondaryGradientEnd,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(83),
                          ),
                          child: const Center(
                            child: Text(
                              '确认',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 头像和用户名，定位在对话框顶部中央
            Positioned(
              top: -avatarRadius, // 让圆心正好在 Container 顶部线上
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: const Color(0xFFF2F2F2),
                    backgroundImage:
                        _giveUserData?.avatar != null &&
                            _giveUserData!.avatar!.isNotEmpty
                        ? NetworkImage(_giveUserData!.avatar!)
                        : null,
                    child:
                        _giveUserData?.avatar == null ||
                            _giveUserData!.avatar!.isEmpty
                        ? const Icon(Icons.person, color: Colors.grey, size: 40)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _giveUserData?.userName ?? '--',
                    style: const TextStyle(
                      color: AppColors.goldGradientEnd,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
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
