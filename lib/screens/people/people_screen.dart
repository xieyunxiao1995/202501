import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhenyu_flutter/api/index_api.dart';
import 'package:zhenyu_flutter/api/user_api.dart';
import 'package:zhenyu_flutter/models/index_api_model.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/common/gradient_tab_indicator.dart';
import 'package:zhenyu_flutter/screens/common/new_user_discount_dialog.dart';
import 'package:zhenyu_flutter/screens/common/vip_dialog.dart';
import 'package:zhenyu_flutter/screens/people/people_list_item.dart';
import 'package:zhenyu_flutter/screens/people/widgets/filter_dialog.dart';
import 'package:zhenyu_flutter/screens/people/widgets/tips_dialog.dart';
import 'package:zhenyu_flutter/screens/people/banner_handler.dart';
import 'package:zhenyu_flutter/shared/location_permission_helper.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/screens/people/search_people_screen.dart';
import 'package:zhenyu_flutter/utils/common.dart';

// Helper class to manage state for each tab's content
class _TabContentState {
  List<IndexUserInfo> users = [];
  int pageNum = 1;
  bool hasNextPage = true;
  bool isLoading = false; // For initial load of a tab
  bool isLoadingMore = false; // For loading more items
  ScrollController scrollController = ScrollController();
}

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<TabInfo> _tabList = [];
  List<BannerInfo> _bannerList = [];
  bool _isLoadingTabs = true;
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  late TapGestureRecognizer _gpsTipRecognizer;

  // State management for each tab's list, using the helper class
  final Map<int, _TabContentState> _tabStates = {};

  // Unified filter state
  FilterOptions _filterOptions = FilterOptions(
    ageRange: const RangeValues(18, 100),
    onlyCertified: false,
    hideFromNearby: false,
    priorityOnline: false,
    priorityDistance: false,
  );
  late FilterOptions _baseFilterOptions = _filterOptions;
  bool _filterApplied = false;

  double? _latitude;
  double? _longitude;
  String? _cityCode; // From automatic location
  bool _hasLocationPermission = false;
  List<CityInfo>? _cityData;
  GetUserProfileData? _userProfileData;
  bool _isVip = false; // VIP状态

  @override
  void initState() {
    super.initState();
    _gpsTipRecognizer = TapGestureRecognizer()..onTap = _onGpsTipTapped;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadLocationData();
    await _fetchTabsAndInitialUsers();
    // Show tips dialog after a short delay once the screen is loaded
    Future.delayed(const Duration(seconds: 1), () async {
      if (mounted &&
          await shouldShowDialogToday(StorageKeys.tipsDialogLastShownDate)) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => const TipsDialog(),
          );
          await markDialogShownToday(StorageKeys.tipsDialogLastShownDate);
        }
      }
    });
  }

  Future<void> _fetchCityData() async {
    try {
      final resp = await IndexApi.getCityList();
      if (mounted && resp.code == 0 && resp.data != null) {
        print('City data pre-fetched successfully.');
        setState(() {
          _cityData = resp.data;
        });
      }
    } catch (e) {
      // Handle error silently, filter will just not have location option
      print('Failed to pre-fetch city data: $e');
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final resp = await UserApi.getUserProfile();
      if (mounted && resp.code == 0 && resp.data != null) {
        print('User profile pre-fetched successfully.');
        setState(() {
          _userProfileData = resp.data;
        });
      }
    } catch (e) {
      print('Failed to pre-fetch user profile: $e');
    }
  }

  Future<void> _loadLocationData() async {
    final prefs = await SharedPreferences.getInstance();
    // 读取 VIP 状态
    var vip = getUserVipInfo(prefs);
    setState(() {
      _isVip = vip;
    });

    final locationString = prefs.getString('longitudeData');
    if (locationString != null) {
      final locationData = jsonDecode(locationString);
      setState(() {
        _latitude = locationData['latitude'];
        _longitude = locationData['longitude'];
        _hasLocationPermission = true;
      });
      debugPrint('设置 latitude: $_latitude, longitude: $_longitude');
    } else {
      debugPrint('longitudeData 为 null，未设置位置信息');
    }
  }

  Future<void> _fetchTabsAndInitialUsers() async {
    try {
      final resp = await IndexApi.getTabAll();
      if (resp.code == 0 && resp.data != null) {
        final data = resp.data!;
        _tabList = data.tabList ?? [];
        _bannerList = data.adBanner?.bannerList ?? [];
        _startBannerAutoScroll();
        _filterOptions = FilterOptions(
          ageRange: _filterOptions.ageRange,
          onlyCertified: _filterOptions.onlyCertified,
          hideFromNearby: data.hideFromNearby ?? _filterOptions.hideFromNearby,
          priorityOnline: _filterOptions.priorityOnline,
          priorityDistance: _filterOptions.priorityDistance,
          selectedTag: _filterOptions.selectedTag,
          selectedLocation: _filterOptions.selectedLocation,
          cityCode: _filterOptions.cityCode,
        );
        _baseFilterOptions = _filterOptions;
        _filterApplied = false;

        _tabController = TabController(
          length: _tabList.length,
          vsync: this,
          initialIndex: _getInitialTabIndex(data.defaultTab),
        );

        _tabController!.addListener(() {
          if (_tabController!.index.toDouble() ==
              _tabController!.animation!.value) {
            final currentType = _tabList[_tabController!.index].type ?? 0;
            if (_tabStates[currentType]?.users.isEmpty ?? true) {
              if (currentType == 1) {
                _getLocationAndFetchList(currentType);
              } else {
                _fetchUserList(currentType);
              }
            }
          }
          setState(() {});
        });

        for (var tab in _tabList) {
          final type = tab.type!;
          _tabStates[type] = _TabContentState();
          _tabStates[type]!.scrollController.addListener(() {
            if (_tabStates[type]!.scrollController.position.pixels ==
                _tabStates[type]!.scrollController.position.maxScrollExtent) {
              _fetchUserList(type, isLoadMore: true);
            }
          });
        }

        if (_tabList.isNotEmpty) {
          final initialType = _tabList[_tabController!.index].type ?? 0;
          if (initialType == 1) {
            await _getLocationAndFetchList(initialType);
          } else {
            await _fetchUserList(initialType);
          }
        }
      } else {
        throw Exception(resp.message ?? 'Failed to load tabs');
      }
    } catch (e) {
      print('Error fetching tabs: $e');
    } finally {
      setState(() {
        _isLoadingTabs = false;
      });
    }
  }

  Future<void> _getLocationAndFetchList(int type) async {
    try {
      final position = await determinePosition();
      final resp = await IndexApi.getLocationCity(
        position.longitude,
        position.latitude,
      );
      if (mounted && resp.code == 0 && resp.data != null) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _cityCode = resp.data!.cityCode;
          _hasLocationPermission = true;
        });
        await _fetchUserList(type);
      }
    } catch (e) {
      print('Failed to get location and fetch list: $e');
      final errorMessage = e.toString();
      if (mounted) {
        showLocationPermissionSnackBar(context, errorMessage);
        setState(() {
          _tabStates[type]?.users.clear();
          _hasLocationPermission = false;
        });
      }
    }
  }

  Future<void> _fetchUserList(
    int type, {
    bool isLoadMore = false,
    bool isRefresh = false,
  }) async {
    final state = _tabStates[type];
    if (state == null ||
        state.isLoadingMore ||
        (!state.hasNextPage && isLoadMore)) {
      return;
    }

    final previousUsers = !isLoadMore
        ? List<IndexUserInfo>.from(state.users)
        : null;
    final previousPageNum = state.pageNum;
    final previousHasNextPage = state.hasNextPage;

    setState(() {
      if (isLoadMore) {
        state.isLoadingMore = true;
      } else {
        state.isLoading = true;
        state.pageNum = 1;
        state.hasNextPage = true;
      }
    });

    try {
      final req = IndexUserListReq(
        latitude: _latitude ?? 0.0,
        longitude: _longitude ?? 0.0,
        cityCode: _cityCode,
        pageNum: state.pageNum,
        pageSize: 20,
        type: type,
        filterStatus: _filterApplied,
        onlyCertified: _filterOptions.onlyCertified,
        priorityDistance: _filterOptions.priorityDistance,
        priorityOnline: _filterOptions.priorityOnline,
        hideFromNearby: _filterOptions.hideFromNearby,
        minAge: _filterOptions.ageRange.start.round(),
        maxAge: _filterOptions.ageRange.end.round() == 100
            ? null
            : _filterOptions.ageRange.end.round(),
        selectedTag: _filterOptions.selectedTag,
        modifiedCityCode: _filterOptions.cityCode,
      );
      final resp = await IndexApi.indexUserList(req);
      if (resp.code == 2006) {
        if (mounted) {
          showDialog(context: context, builder: (_) => const VipDialog());
        }
        if (!isLoadMore && previousUsers != null) {
          setState(() {
            state.users = previousUsers;
            state.pageNum = previousPageNum;
            state.hasNextPage = previousHasNextPage;
            _filterOptions = _baseFilterOptions;
            _filterApplied = false;
          });
        }
        return;
      }
      if (resp.code == 0 && resp.data?.page != null) {
        final pageData = resp.data!.page!;
        setState(() {
          if (isLoadMore) {
            state.users.addAll(pageData.list ?? []);
          } else {
            state.users = pageData.list ?? [];
          }
          state.pageNum++;
          state.hasNextPage = pageData.hasNext ?? false;
        });
      } else {
        if (resp.message != null && mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(resp.message!)));
        }
        if (!isLoadMore && previousUsers != null) {
          setState(() {
            state.users = previousUsers;
            state.pageNum = previousPageNum;
            state.hasNextPage = previousHasNextPage;
            _filterOptions = _baseFilterOptions;
            _filterApplied = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching user list for type $type: $e');
      if (!isLoadMore && previousUsers != null && mounted) {
        setState(() {
          state.users = previousUsers;
          state.pageNum = previousPageNum;
          state.hasNextPage = previousHasNextPage;
          _filterOptions = _baseFilterOptions;
          _filterApplied = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          state.isLoading = false;
          state.isLoadingMore = false;
        });
      }
    }
  }

  void _startBannerAutoScroll() {
    _stopBannerAutoScroll();
    _currentBannerIndex = 0;

    if (_bannerList.isEmpty) {
      return;
    }

    void jumpToStart() {
      if (_bannerController.hasClients) {
        _bannerController.jumpToPage(0);
      }
    }

    if (_bannerController.hasClients) {
      jumpToStart();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => jumpToStart());
    }

    if (_bannerList.length == 1) {
      return;
    }

    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_bannerController.hasClients || _bannerList.isEmpty) return;
      _currentBannerIndex = (_currentBannerIndex + 1) % _bannerList.length;
      _bannerController.animateToPage(
        _currentBannerIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopBannerAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = null;
  }

  int _getInitialTabIndex(int? defaultTabType) {
    if (defaultTabType == null) return 0;
    final index = _tabList.indexWhere((tab) => tab.type == defaultTabType);
    return index != -1 ? index : 0;
  }

  @override
  void dispose() {
    _stopBannerAutoScroll();
    _bannerController.dispose();
    _tabController?.dispose();
    _gpsTipRecognizer.dispose();
    _tabStates.forEach((_, state) => state.scrollController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingTabs) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_tabController == null) {
      return const Center(child: Text('Failed to load content'));
    }

    return Stack(
      children: [
        Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      toolbarHeight: 0,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(_topSectionHeight()),
                        child: SizedBox(
                          height: _topSectionHeight(),
                          child: _buildTopSection(),
                        ),
                      ),
                    ),
                  ];
                },
            body: TabBarView(
              controller: _tabController!,
              children: _tabList.map((tab) {
                return _buildUserList(tab.type ?? 0);
              }).toList(),
            ),
          ),
        ),
        NewUserDiscountWidget(),
      ],
    );
  }

  Widget _buildTopSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBanner(),
        _buildTabBar(),
        if (_shouldShowGpsTip) _buildGpsAuthTip(),
      ],
    );
  }

  Widget _buildBanner() {
    if (_bannerList.isEmpty) {
      return const SizedBox.shrink();
    }

    // 打印所有 banner 信息
    print('========== Banner List (共${_bannerList.length}个) ==========');
    for (int i = 0; i < _bannerList.length; i++) {
      final banner = _bannerList[i];
      print('Banner[$i]: ${banner.toJson()}');
    }
    print('==========================================');

    return Container(
      height: 170.r,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: PageView.builder(
          controller: _bannerController,
          itemCount: _bannerList.length,
          onPageChanged: (index) {
            _currentBannerIndex = index;
          },
          itemBuilder: (context, index) {
            final banner = _bannerList[index];
            return GestureDetector(
              onTap: () => BannerHandler.handleBannerTap(context, banner),
              child: Image.network(banner.bannerUrl ?? '', fit: BoxFit.cover),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController!,
              tabs: _tabList.map((tab) => Tab(text: tab.name)).toList(),
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(fontSize: 26.sp),
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              dividerColor: Colors.transparent,
              // indicatorSize: TabBarIndicatorSize.label,
              // indicatorColor: AppColors.textPrimary,
              indicator: GradientTabIndicator(
                gradient: AppGradients.primaryGradient,
                height: 10.h,
                width: 50.w,
                radius: 20.r,
                bottomMargin: 10.h,
                left: 10.w,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPeopleScreen(),
                    ),
                  );
                },
                padding: EdgeInsets.all(8.w),
                constraints: const BoxConstraints(),
                icon: Image.asset(
                  'assets/images/icons_search.png',
                  width: 18,
                  height: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 4.w),
              IconButton(
                onPressed: () async {
                  await Future.wait([_fetchCityData(), _fetchUserProfile()]);
                  if (mounted) {
                    final newFilters =
                        await showModalBottomSheet<Map<String, Object?>>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => FilterDialog(
                            cityData: _cityData,
                            userProfileData: _userProfileData,
                            initialFilters: _filterOptions,
                          ),
                        );
                    if (newFilters != null) {
                      final selectedFilters =
                          newFilters['filters'] as FilterOptions;
                      bool applied = newFilters['applied'] as bool? ?? false;
                      applied =
                          applied &&
                          !_filtersEqual(selectedFilters, _baseFilterOptions);
                      setState(() {
                        _filterOptions = selectedFilters;
                        _filterApplied = applied;
                        if (!applied) {
                          _baseFilterOptions = selectedFilters;
                        }
                      });
                      final currentType =
                          _tabList[_tabController!.index].type ?? 0;
                      _fetchUserList(currentType, isRefresh: true);
                    }
                  }
                },
                padding: EdgeInsets.all(8.w),
                constraints: const BoxConstraints(),
                icon: Image.asset(
                  'assets/images/icons_filter.png',
                  width: 18,
                  height: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool get _shouldShowGpsTip =>
      !_hasLocationPermission &&
      _tabController != null &&
      _tabController!.index == 0;

  double _topSectionHeight() {
    final bannerHeight = _bannerList.isEmpty ? 0.0 : 170.r + 16.h;
    final tabBarHeight = kTextTabBarHeight + 24.h;
    final gpsTipHeight = _shouldShowGpsTip ? 48.h : 0.0;
    // Add a small constant buffer to avoid rounding issues that could
    // otherwise trigger a 1px overflow on high-density screens.
    return bannerHeight + tabBarHeight + gpsTipHeight + 4.h;
  }

  void _onGpsTipTapped() {
    if (_tabController == null || _tabList.isEmpty) {
      return;
    }

    if (_tabController!.index != 0) {
      _tabController!.animateTo(0);
    }

    final nearbyType = _tabList.first.type ?? 0;
    _getLocationAndFetchList(nearbyType);
  }

  bool _filtersEqual(FilterOptions a, FilterOptions b) {
    return a.onlyCertified == b.onlyCertified &&
        a.hideFromNearby == b.hideFromNearby &&
        a.priorityOnline == b.priorityOnline &&
        a.priorityDistance == b.priorityDistance &&
        a.selectedTag == b.selectedTag &&
        a.selectedLocation == b.selectedLocation &&
        a.cityCode == b.cityCode &&
        (a.ageRange.start == b.ageRange.start &&
            a.ageRange.end == b.ageRange.end);
  }

  Widget _buildGpsAuthTip() {
    return Container(
      color: AppColors.backgroundWhite8,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: RichText(
        text: TextSpan(
          style: textStyleSecondary,
          children: [
            const TextSpan(text: '当前未开启定位，'),
            TextSpan(
              text: '点击开启',
              style: const TextStyle(color: AppColors.goldGradientStart),
              recognizer: _gpsTipRecognizer,
            ),
            const TextSpan(text: '定位优先推荐附近的人~'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(int tabType) {
    final state = _tabStates[tabType];
    if (state == null) return const SizedBox.shrink();

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.users.isEmpty) {
      return const Center(child: StyledText('暂无数据~'));
    }

    return RefreshIndicator(
      onRefresh: () => _fetchUserList(tabType),
      child: ListView.builder(
        key: PageStorageKey<int>(tabType),
        controller: state.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        itemCount: state.users.length + (state.hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.users.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return PeopleListItem(
            user: state.users[index],
            selectValue: tabType,
            isVip: _isVip,
            onUpdate: () {
              _fetchUserList(tabType);
            },
          );
        },
      ),
    );
  }

  Future<Position> determinePosition() async {
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
}
