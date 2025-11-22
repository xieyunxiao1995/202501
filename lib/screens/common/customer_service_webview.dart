import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// 客服WebView - 支持自动跳转到微信
class CustomerServiceWebView extends StatefulWidget {
  final String url;

  const CustomerServiceWebView({super.key, required this.url});

  @override
  State<CustomerServiceWebView> createState() => _CustomerServiceWebViewState();
}

class _CustomerServiceWebViewState extends State<CustomerServiceWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          // 关键：处理导航请求，允许自动跳转到微信
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('[CustomerServiceWebView] Navigation request: ${request.url}');

            // 检测是否是微信相关的URL Scheme或Universal Link
            if (_shouldOpenExternally(request.url)) {
              debugPrint('[CustomerServiceWebView] Opening externally: ${request.url}');
              _openExternalUrl(request.url);
              // 阻止WebView加载，我们手动用外部应用打开
              return NavigationDecision.prevent;
            }

            // 允许WebView加载其他URL
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// 判断是否应该用外部应用打开
  bool _shouldOpenExternally(String url) {
    // 微信URL Scheme
    if (url.startsWith('weixin://') ||
        url.startsWith('weixinwork://') ||
        url.startsWith('wework://')) {
      return true;
    }

    // 企业微信的Universal Links重定向
    // 当企业微信页面要跳转到微信时，可能是这些URL
    if (url.contains('wxwork') ||
        url.contains('wework.qq.com') ||
        url.contains('weixin://')) {
      return true;
    }

    return false;
  }

  /// 用外部应用打开URL
  Future<void> _openExternalUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        final result = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (result && mounted) {
          // 成功打开微信后，延迟一下再关闭WebView
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      }
    } catch (e) {
      debugPrint('[CustomerServiceWebView] Error opening external URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('客服'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
