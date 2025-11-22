import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';

import 'package:zhenyu_flutter/api/real_api.dart';
import 'package:zhenyu_flutter/models/real_api_model.dart';
import 'package:zhenyu_flutter/theme.dart';

import 'real_person_auth_screen.dart';

class AuthCenterScreen extends StatefulWidget {
  const AuthCenterScreen({super.key});

  @override
  State<AuthCenterScreen> createState() => _AuthCenterScreenState();
}

class _AuthCenterScreenState extends State<AuthCenterScreen> {
  RealStatusData? _status;
  bool _isLoading = true;
  bool _isSubmitting = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserId();
    await _fetchStatus();
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

  Future<void> _fetchStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final resp = await RealApi.getRealStatus();
      if (!mounted) return;
      if (resp.code == 0) {
        setState(() {
          _status = resp.data;
        });
      } else {
        _showMessage(resp.message ?? '获取认证状态失败');
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('获取认证状态失败: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _statusText() {
    final status = _status?.realNameStatus;
    if (status == 1) return '已认证';
    if (status == 2) return '审核中';
    return '去认证';
  }

  Future<void> _handleTap() async {
    final status = _status?.realNameStatus;
    if (status == 1) {
      _showMessage('已认证~');
      return;
    }
    if (status == 2) {
      _showMessage('审核中~');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RealPersonAuthScreen()),
    );

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
    });
    await _fetchStatus();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('认证中心')),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Container(
                  width: double.infinity,
                  height: 146.h,
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '真人认证',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 31.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '通过真人认证获得更多曝光机会',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 21.sp,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _isSubmitting ? null : _handleTap,
                        child: Container(
                          width: 138.w,
                          height: 52.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            borderRadius: BorderRadius.circular(75.r),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : Text(
                                  _statusText(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
