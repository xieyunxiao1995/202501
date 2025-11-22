import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zhenyu_flutter/api/index_api.dart';
import 'package:zhenyu_flutter/models/index_api_model.dart';
import 'package:zhenyu_flutter/screens/people/people_list_item.dart';
import 'package:zhenyu_flutter/screens/common/vip_dialog.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:zhenyu_flutter/utils/common.dart';

class SearchPeopleScreen extends StatefulWidget {
  const SearchPeopleScreen({super.key});

  @override
  State<SearchPeopleScreen> createState() => _SearchPeopleScreenState();
}

class _SearchPeopleScreenState extends State<SearchPeopleScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<IndexUserInfo> _searchResults = [];
  bool _isLoading = false;
  bool _noResults = false;
  bool _isVip = false;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadLocationData() async {
    final prefs = await SharedPreferences.getInstance();
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
      });
    } else {
      try {
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      } catch (e) {
        debugPrint("Failed to get location: $e");
      }
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search();
    });
  }

  Future<void> _search() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
        _noResults = false;
      });
      return;
    }

    if (_latitude == null || _longitude == null) {
      // Handle case where location is not available
      return;
    }

    setState(() {
      _isLoading = true;
      _noResults = false;
    });

    try {
      final req = SearchUserReq(
        keyword: _searchController.text,
        latitude: _latitude!,
        longitude: _longitude!,
        pageNum: 1,
        pageSize: 20,
      );
      final resp = await IndexApi.searchUser(req);
      if (resp.code == 0) {
        setState(() {
          _searchResults = resp.data?.page?.list ?? [];
          _noResults = _searchResults.isEmpty;
        });
      } else if (resp.code == 2006) {
        if (mounted) {
          showDialog(context: context, builder: (context) => const VipDialog());
        }
      } else {
        setState(() {
          _noResults = true;
        });
      }
    } catch (e) {
      debugPrint('Search failed: $e');
      setState(() {
        _noResults = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('搜索用户')),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 62.5.r,
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite8,
                borderRadius: BorderRadius.circular(42.r),
              ),
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(fontSize: 25.sp, color: Colors.white),
                decoration: InputDecoration(
                  hintText: '请输入对方的昵称或ID',
                  hintStyle: TextStyle(
                    fontSize: 25.sp,
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.r, vertical: 15.h),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchResults = [];
                              _noResults = false;
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            height: 62.5.r,
            child: ElevatedButton(
              onPressed: _search,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldGradientStart,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(83.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32.w),
              ),
              child: Text(
                '搜索',
                style: TextStyle(fontSize: 25.sp, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_noResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nolist.png', // Make sure you have this asset
              width: 312.5.r,
              height: 312.5.r,
            ),
            SizedBox(height: 16.h),
            Text(
              '没有搜索到该用户~',
              style: TextStyle(fontSize: 31.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return PeopleListItem(
          user: _searchResults[index],
          selectValue: 0, // This might need adjustment based on your logic
          isVip: _isVip,
          onUpdate: _search,
        );
      },
    );
  }
}
