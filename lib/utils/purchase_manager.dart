import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:zhenyu_flutter/api/vip_api.dart';
import 'package:zhenyu_flutter/models/vip_api_model.dart';

/// 购买状态回调
class PurchaseCallbacks {
  /// 购买等待中（用户正在输入密码等）
  final VoidCallback? onPending;

  /// 购买被取消
  final VoidCallback? onCanceled;

  /// 购买失败
  final void Function(String errorMessage)? onError;

  /// 购买成功
  final void Function(bool wasActivelyProcessing)? onSuccess;

  /// 购买验证失败
  final void Function(String errorMessage)? onVerificationFailed;

  const PurchaseCallbacks({
    this.onPending,
    this.onCanceled,
    this.onError,
    this.onSuccess,
    this.onVerificationFailed,
  });
}

/// 苹果内购管理器
///
/// 使用示例：
/// ```dart
/// final purchaseManager = PurchaseManager();
///
/// // 初始化监听
/// purchaseManager.initialize(
///   callbacks: PurchaseCallbacks(
///     onSuccess: (wasActivelyProcessing) {
///       // 购买成功，刷新VIP状态
///     },
///     onError: (message) {
///       // 显示错误提示
///     },
///   ),
/// );
///
/// // 发起购买
/// await purchaseManager.startPurchase(
///   productId: 'com.yourapp.vip.30days',
///   planId: 1,
///   orderTradeType: 'VIP', // 或 'COIN'、'ORDER'
/// );
///
/// // 记得在 dispose 时取消监听
/// purchaseManager.dispose();
/// ```
class PurchaseManager {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  PurchaseCallbacks? _callbacks;

  /// 标记是否是用户主动发起的购买（区分主动购买和自动恢复）
  bool _isProcessingPurchase = false;

  /// 当前购买的套餐ID（用于后端验证）
  int? _currentPlanId;

  /// 当前购买的订单类型（COIN, ORDER, VIP）
  String? _currentOrderTradeType;

  /// 是否正在处理购买
  bool get isProcessingPurchase => _isProcessingPurchase;

  /// 初始化购买流程监听
  ///
  /// [callbacks] 购买状态回调
  void initialize({required PurchaseCallbacks callbacks}) {
    _callbacks = callbacks;

    // 订阅购买状态流，监听所有购买状态变化
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      _handlePurchaseUpdate,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        debugPrint('Purchase stream error: $error');
        _callbacks?.onError?.call('购买流程出错: $error');
      },
    );
  }

  /// 处理购买状态更新
  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      debugPrint('Purchase status: ${purchaseDetails.status}');

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // 等待用户操作（如输入密码）
          _callbacks?.onPending?.call();
          break;

        case PurchaseStatus.canceled:
          // 用户取消支付
          _isProcessingPurchase = false;
          _callbacks?.onCanceled?.call();
          break;

        case PurchaseStatus.error:
          // 支付失败
          _isProcessingPurchase = false;
          final errorMessage = purchaseDetails.error?.message ?? '未知错误';
          final errorCode = purchaseDetails.error?.code;
          final errorDetails = purchaseDetails.error?.details;

          debugPrint('❌ Purchase Error Details:');
          debugPrint('   - Error Code: $errorCode');
          debugPrint('   - Error Message: $errorMessage');
          debugPrint('   - Error Details: $errorDetails');
          debugPrint('   - Product ID: ${purchaseDetails.productID}');
          debugPrint(
            '   - Current Environment: ${kReleaseMode ? "Production" : "Sandbox"}',
          );

          _callbacks?.onError?.call(errorMessage);
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // 支付成功或恢复购买
          _verifyPurchase(purchaseDetails);
          break;
      }

      // ⚠️ 重要：必须调用 completePurchase，否则会一直重复推送
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  /// 验证购买（后端验证收据）
  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (_currentPlanId == null) {
      debugPrint('Warning: _currentPlanId is null, cannot verify purchase');
      _callbacks?.onVerificationFailed?.call('套餐信息丢失，请重试');
      _isProcessingPurchase = false;
      return;
    }

    if (_currentOrderTradeType == null) {
      debugPrint(
        'Warning: _currentOrderTradeType is null, cannot verify purchase',
      );
      _callbacks?.onVerificationFailed?.call('订单类型丢失，请重试');
      _isProcessingPurchase = false;
      return;
    }

    // 保存标志，因为后面会重置
    final wasActivelyProcessing = _isProcessingPurchase;

    try {
      // 获取收据数据
      String receiptData;
      if (Platform.isIOS) {
        try {
          // 使用 StoreKit 1 完整收据（App Receipt）
          final appReceipt = await SKReceiptManager.retrieveReceiptData();
          receiptData = appReceipt;
          debugPrint('Using StoreKit 1 App Receipt');
        } catch (e) {
          debugPrint(
            'Failed to get App Receipt, using transaction receipt: $e',
          );
          receiptData = purchaseDetails.verificationData.serverVerificationData;
        }
      } else {
        receiptData = purchaseDetails.verificationData.serverVerificationData;
      }
      debugPrint('kReleaseMode------------->$kReleaseMode');
      // 构建验证请求
      final request = ApplePayRequest(
        chooseEnv: kReleaseMode, // false = 沙盒环境，true = 生产环境
        id: _currentPlanId!,
        orderTradeType: _currentOrderTradeType!, // 使用保存的订单类型（COIN, ORDER, VIP）
        receipt: receiptData,
      );

      debugPrint(
        'Verifying purchase with backend... (type: $_currentOrderTradeType)',
      );
      final response = await VipApi.iosPay(request);

      // 检查后端返回
      final responseData = response.data ?? response;
      final code = responseData['code'];
      final message = responseData['message'];

      if (code != 0) {
        throw Exception(message ?? '苹果支付验证失败');
      }

      debugPrint('Purchase verified successfully');
      _isProcessingPurchase = false;
      _callbacks?.onSuccess?.call(wasActivelyProcessing);
    } catch (e) {
      debugPrint('Purchase verification failed: $e');
      _isProcessingPurchase = false;
      _callbacks?.onVerificationFailed?.call('支付验证失败: $e');
    }
  }

  /// 发起购买
  ///
  /// [productId] App Store 产品ID（如 "com.yourapp.vip.30days"）
  /// [planId] 套餐ID（用于后端验证）
  /// [orderTradeType] 订单类型（COIN, ORDER, VIP）
  /// [userId] 用户ID（可选，用于关联购买记录）
  ///
  /// 返回错误信息，如果为 null 表示成功发起购买
  Future<String?> startPurchase({
    required String productId,
    required int planId,
    required String orderTradeType,
    String? userId,
  }) async {
    if (productId.isEmpty) {
      return '产品ID不能为空';
    }

    // 验证订单类型
    if (!['COIN', 'ORDER', 'VIP'].contains(orderTradeType)) {
      return '未知订单类型';
    }

    // 检查平台
    if (!Platform.isIOS) {
      return '当前平台不支持 Apple 内购';
    }

    // 检查 App Store 是否可用
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      return '无法连接到 App Store';
    }

    // 查询产品详情
    debugPrint('Querying product details for: $productId');
    final productDetailResponse = await _inAppPurchase.queryProductDetails({
      productId,
    });

    if (productDetailResponse.error != null) {
      final error = productDetailResponse.error!;
      final message = StringBuffer('获取商品信息失败: ${error.message}');
      if (error.details != null) {
        message.write('\n详情: ${error.details}');
      }
      if (productDetailResponse.notFoundIDs.isNotEmpty) {
        message.write(
          '\n未找到的商品ID: ${productDetailResponse.notFoundIDs.join(', ')}',
        );
      }
      return message.toString();
    }

    if (productDetailResponse.productDetails.isEmpty) {
      final notFoundMsg = productDetailResponse.notFoundIDs.isNotEmpty
          ? '未在 App Store 中找到以下商品ID: ${productDetailResponse.notFoundIDs.join(', ')}'
          : '在 App Store 中找不到该商品';
      return notFoundMsg;
    }

    // 获取产品详情
    final ProductDetails productDetails =
        productDetailResponse.productDetails.first;

    debugPrint(
      'Product found: ${productDetails.title}, price: ${productDetails.price}',
    );

    // 创建购买参数
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: userId, // 可选的用户ID
    );

    // 保存套餐ID、订单类型和标记
    _currentPlanId = planId;
    _currentOrderTradeType = orderTradeType;
    _isProcessingPurchase = true;

    // 发起购买（消耗型商品）
    debugPrint('Starting purchase... (planId: $planId, type: $orderTradeType)');
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);

    return null; // 成功发起购买
  }

  /// 取消订阅并释放资源
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _callbacks = null;
    _isProcessingPurchase = false;
    _currentPlanId = null;
    _currentOrderTradeType = null;
  }
}
