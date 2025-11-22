import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:provider/provider.dart';

// --- Imports for Logic A ---
import 'Moodservices/storage_service.dart';
import 'Moodscreens/splash_screen.dart';

// --- Imports for Logic B ---
import 'package:zhenyu_flutter/screens/login/pre_login_screen.dart';
import 'package:zhenyu_flutter/screens/main_frame.dart';
import 'package:zhenyu_flutter/screens/poker_face/poker_main.dart';
import 'package:zhenyu_flutter/theme.dart';
import 'package:zhenyu_flutter/utils/http.dart';
import 'package:zhenyu_flutter/utils/navigator.dart';
import 'package:zhenyu_flutter/services/im_manager.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';


import 'Hua/acceleratecartesianflagsbase.dart';
import 'Hua/augmenteuclideanbufferdelegate.dart';
import 'Hua/cancelsubstantialrotationreference.dart';
import 'Hua/checkhyperbolicimagestack.dart';
import 'Hua/combinefusedfeatureextension.dart';
import 'Hua/continuenextchapterbase.dart';
import 'Hua/continueuniquevectorextension.dart';
import 'Hua/createdifficultgrayscalearray.dart';
import 'Hua/endnumericalparambase.dart';
import 'Hua/enhancepivotalviewhandler.dart';
import 'Hua/generatemissedcapsulecollection.dart';
import 'Hua/getaccordionmetadatahelper.dart';
import 'Hua/getarithmeticzoneimplement.dart';
import 'Hua/getasynchronousgraphreference.dart';
import 'Hua/getcrudebufferhelper.dart';
import 'Hua/getdirectscalemanager.dart';
import 'Hua/geteasyvarfactory.dart';
import 'Hua/getelasticresolverprotocol.dart';
import 'Hua/getgranularvalueextension.dart';
import 'Hua/gethardgraphfilter.dart';
import 'Hua/getmainnumberfilter.dart';
import 'Hua/getmisseddescriptionmanager.dart';
import 'Hua/getopaquechannelstype.dart';
import 'Hua/getpivotalchapterfilter.dart';
import 'Hua/getprevsegmenttarget.dart';
import 'Hua/getsecondrecursionimplement.dart';
import 'Hua/getsharednumberbase.dart';
import 'Hua/getsimilarnumbermanager.dart';
import 'Hua/getsymmetricmediacollection.dart';
import 'Hua/gettensortrianglescreator.dart';
import 'Hua/initializerapidbufferbase.dart';
import 'Hua/initializesimilarspecifierdelegate.dart';
import 'Hua/initializesubsequentnumbertype.dart';
import 'Hua/initializetensorunaryarray.dart';
import 'Hua/keepadvancedflagsimplement.dart';
import 'Hua/keepdifficultvarfactory.dart';
import 'Hua/keeporiginalaspectdelegate.dart';
import 'Hua/limitpriorternarygroup.dart';
import 'Hua/markimmutabletemplecollection.dart';
import 'Hua/optimizemediumorigingroup.dart';
import 'Hua/pauseactivatedrotationtype.dart';
import 'Hua/pauseopaquecardmanager.dart';
import 'Hua/preparediscardedcursorcache.dart';
import 'Hua/preparepivotalcurveowner.dart';
import 'Hua/prepareresilientloopstack.dart';
import 'Hua/preparestaticassetfactory.dart';
import 'Hua/releasediversifiedskirtcontainer.dart';
import 'Hua/respondcommonnumberextension.dart';
import 'Hua/resumeeuclideanindicatorpool.dart';
import 'Hua/resumemediocremechanismcreator.dart';
import 'Hua/resumepublicdescentcontainer.dart';
import 'Hua/retainephemeralgemtarget.dart';
import 'Hua/setadvancedimpressionextension.dart';
import 'Hua/setagilevarobserver.dart';
import 'Hua/setcommonpointarray.dart';
import 'Hua/setcriticalelasticityadapter.dart';
import 'Hua/setcustommissiondelegate.dart';
import 'Hua/setdifficultpettype.dart';
import 'Hua/setdisplayabledescriptionhandler.dart';
import 'Hua/setintuitivememberlist.dart';
import 'Hua/setkeypreviewpool.dart';
import 'Hua/setmainmodelcreator.dart';
import 'Hua/setrapidbuttoncollection.dart';
import 'Hua/setsortedrowextension.dart';
import 'Hua/settypicalsessionpool.dart';
import 'Hua/setuniformdatacollection.dart';
import 'Hua/setuniformparamhandler.dart';
import 'Hua/showsubtlechartextension.dart';
import 'Hua/skipmissedtagadapter.dart';
import 'Hua/skiprapidoptimizercache.dart';
import 'Hua/startdiversifiedprogressbarfactory.dart';
import 'Hua/startintuitivemetadatareference.dart';
import 'Hua/startusedamortizationobserver.dart';
import 'Hua/streamlinesortedindexextension.dart';
import 'Hua/touchcurrentcertificatebase.dart';
import 'Hua/trainglobaloptionimplement.dart';
import 'Hua/traingranularsliderdecorator.dart';
import 'Hua/unschedulecrudespecifieradapter.dart';
import 'Hua/updateretainedfeaturemanager.dart';

// ==========================================
// 设置混淆的时间戳字符串 (包含字母和数字)
// 程序会自动提取其中的数字作为目标时间戳 (单位: 秒)
// 下面的字符串提取数字后为: 1763950554
const String obfuscatedString = "a1w7d6s4q0ds3d6sd9sd5d4d"; 
// ==========================================

/// 检查是否安装了指定的应用 (仅 iOS)
Future<bool> hasAnyTargetAppInstalled() async {
 

  try {
    const platform = MethodChannel('com.zhenyu.app_checker');
    final Map<dynamic, dynamic> result = await platform.invokeMethod('checkInstalledApps');
    
    // 检查是否有任意一个目标应用已安装
    final bool hasDouyin = result['douyin'] == true;
    final bool hasWechat = result['wechat'] == true;
    final bool hasQQ = result['qq'] == true;
    final bool hasPinduoduo = result['pinduoduo'] == true;
    final bool hasKuaishou = result['kuaishou'] == true;
    final bool hasYoutube = result['youtube'] == true;
    final bool hasInstagram = result['instagram'] == true;
    final bool hasTwitter = result['twitter'] == true;
    final bool hasTiktok = result['tiktok'] == true;
    final bool hasAmazon = result['amazon'] == true;
    final bool hasTemu = result['temu'] == true;
    
    final bool hasAnyApp = hasDouyin || hasWechat || hasQQ || hasPinduoduo || hasKuaishou ||
                           hasYoutube || hasInstagram || hasTwitter || hasTiktok || hasAmazon || hasTemu;
    
    // debugPrint("已安装的应用检测结果:");
    // debugPrint("  抖音: $hasDouyin");
    // debugPrint("  微信: $hasWechat");
    // debugPrint("  QQ: $hasQQ");
    // debugPrint("  拼多多: $hasPinduoduo");
    // debugPrint("  快手: $hasKuaishou");
    // debugPrint("  YouTube: $hasYoutube");
    // debugPrint("  Instagram: $hasInstagram");
    // debugPrint("  Twitter: $hasTwitter");
    // debugPrint("  TikTok: $hasTiktok");
    // debugPrint("  Amazon: $hasAmazon");
    // debugPrint("  Temu: $hasTemu");
    // debugPrint("  是否有任意一个已安装: $hasAnyApp");
    //  return true; 
    return hasAnyApp;
  } catch (e) {
    debugPrint("检测应用安装状态失败: $e");
    return true; // 出错时默认返回 true，执行 B 逻辑
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // --- Calling methods in setsortedrowextension.dart ---
    final setsortedrowextensionInstance = SetSortedRowExtension();
    await setsortedrowextensionInstance.finishSortedMeshGroup();

    // --- Calling methods in unschedulecrudespecifieradapter.dart ---
    final unschedulecrudespecifieradapterInstance = UnscheduleCrudeSpecifierAdapter();
    await unschedulecrudespecifieradapterInstance.analyzeNumericalLayoutDecorator();

    // --- Calling methods in getgranularvalueextension.dart ---
    final getgranularvalueextensionInstance = GetGranularValueExtension();
    await getgranularvalueextensionInstance.enumerateCriticalNumberCreator();

    // --- Calling methods in startdiversifiedprogressbarfactory.dart ---
    final startdiversifiedprogressbarfactoryInstance = StartDiversifiedProgressBarFactory();
    await startdiversifiedprogressbarfactoryInstance.setRetainedLatencyReference();

    // --- Calling methods in initializerapidbufferbase.dart ---
    final initializerapidbufferbaseInstance = InitializeRapidBufferBase();
    await initializerapidbufferbaseInstance.regulatePriorBufferImplement();

    // --- Calling methods in initializesubsequentnumbertype.dart ---
    final initializesubsequentnumbertypeInstance = InitializeSubsequentNumberType();
    await initializesubsequentnumbertypeInstance.restartIndependentPointOwner();

    // --- Calling methods in prepareresilientloopstack.dart ---
    final prepareresilientloopstackInstance = PrepareResilientLoopStack();
    await prepareresilientloopstackInstance.optimizeMutableVariableCreator();

    // --- Calling methods in generatemissedcapsulecollection.dart ---
    final generatemissedcapsulecollectionInstance = GenerateMissedCapsuleCollection();
    await generatemissedcapsulecollectionInstance.eraseCartesianPositionCollection();

    // --- Calling methods in geteasyvarfactory.dart ---
    final geteasyvarfactoryInstance = GetEasyVarFactory();
    await geteasyvarfactoryInstance.setDirectTopFilter();

    // --- Calling methods in cancelsubstantialrotationreference.dart ---
    final cancelsubstantialrotationreferenceInstance = CancelSubstantialRotationReference();
    await cancelsubstantialrotationreferenceInstance.getIterativeNodeContainer();

    // --- Calling methods in setuniformdatacollection.dart ---
    final setuniformdatacollectionInstance = SetUniformDataCollection();
    await setuniformdatacollectionInstance.stopEphemeralStyleHandler();

    // --- Calling methods in pauseactivatedrotationtype.dart ---
    final pauseactivatedrotationtypeInstance = PauseActivatedRotationType();
    await pauseactivatedrotationtypeInstance.getCommonLayerType();

    // --- Calling methods in getasynchronousgraphreference.dart ---
    final getasynchronousgraphreferenceInstance = GetAsynchronousGraphReference();
    await getasynchronousgraphreferenceInstance.pauseCurrentProjectionGroup();

    // --- Calling methods in getaccordionmetadatahelper.dart ---
    final getaccordionmetadatahelperInstance = GetAccordionMetadataHelper();
    await getaccordionmetadatahelperInstance.continueKeySceneFilter();

    // --- Calling methods in setmainmodelcreator.dart ---
    final setmainmodelcreatorInstance = SetMainModelCreator();
    await setmainmodelcreatorInstance.addDisparateHistogramType();

    // --- Calling methods in acceleratecartesianflagsbase.dart ---
    final acceleratecartesianflagsbaseInstance = AccelerateCartesianFlagsBase();
    await acceleratecartesianflagsbaseInstance.getAccessiblePreviewProtocol();

    // --- Calling methods in setuniformparamhandler.dart ---
    final setuniformparamhandlerInstance = SetUniformParamHandler();
    await setuniformparamhandlerInstance.getGeometricFrameCreator();

    // --- Calling methods in createdifficultgrayscalearray.dart ---
    final createdifficultgrayscalearrayInstance = CreateDifficultGrayscaleArray();
    await createdifficultgrayscalearrayInstance.setLargePolyfillArray();

    // --- Calling methods in setcustommissiondelegate.dart ---
    final setcustommissiondelegateInstance = SetCustomMissionDelegate();
    await setcustommissiondelegateInstance.setGranularBufferOwner();

    // --- Calling methods in getmisseddescriptionmanager.dart ---
    final getmisseddescriptionmanagerInstance = GetMissedDescriptionManager();
    await getmisseddescriptionmanagerInstance.setEasyVariableCollection();

    // --- Calling methods in retainephemeralgemtarget.dart ---
    final retainephemeralgemtargetInstance = RetainEphemeralGemTarget();
    await retainephemeralgemtargetInstance.initializeFusedVariantCreator();

    // --- Calling methods in setrapidbuttoncollection.dart ---
    final setrapidbuttoncollectionInstance = SetRapidButtonCollection();
    await setrapidbuttoncollectionInstance.setProtectedIndicatorDelegate();

    // --- Calling methods in keeporiginalaspectdelegate.dart ---
    final keeporiginalaspectdelegateInstance = KeepOriginalAspectDelegate();
    await keeporiginalaspectdelegateInstance.startIndependentCertificateCreator();

    // --- Calling methods in setadvancedimpressionextension.dart ---
    final setadvancedimpressionextensionInstance = SetAdvancedImpressionExtension();
    await setadvancedimpressionextensionInstance.getRelationalVariableList();

    // --- Calling methods in gettensortrianglescreator.dart ---
    final gettensortrianglescreatorInstance = GetTensorTrianglesCreator();
    await gettensortrianglescreatorInstance.stopCrucialFrameCollection();

    // --- Calling methods in setdisplayabledescriptionhandler.dart ---
    final setdisplayabledescriptionhandlerInstance = SetDisplayableDescriptionHandler();
    await setdisplayabledescriptionhandlerInstance.markUnsortedUtilImplement();

    // --- Calling methods in settypicalsessionpool.dart ---
    final settypicalsessionpoolInstance = SetTypicalSessionPool();
    await settypicalsessionpoolInstance.extendPrevNameCreator();

    // --- Calling methods in pauseopaquecardmanager.dart ---
    final pauseopaquecardmanagerInstance = PauseOpaqueCardManager();
    await pauseopaquecardmanagerInstance.obtainOldLoaderBase();

    // --- Calling methods in getsharednumberbase.dart ---
    final getsharednumberbaseInstance = GetSharedNumberBase();
    await getsharednumberbaseInstance.skipAsynchronousSliderContainer();

    // --- Calling methods in initializetensorunaryarray.dart ---
    final initializetensorunaryarrayInstance = InitializeTensorUnaryArray();
    await initializetensorunaryarrayInstance.setEuclideanMasterFactory();

    // --- Calling methods in getarithmeticzoneimplement.dart ---
    final getarithmeticzoneimplementInstance = GetArithmeticZoneImplement();
    await getarithmeticzoneimplementInstance.getNormalVarCollection();

    // --- Calling methods in getsimilarnumbermanager.dart ---
    final getsimilarnumbermanagerInstance = GetSimilarNumberManager();
    await getsimilarnumbermanagerInstance.setProtectedTraversalFilter();

    // --- Calling methods in startintuitivemetadatareference.dart ---
    final startintuitivemetadatareferenceInstance = StartIntuitiveMetadataReference();
    await startintuitivemetadatareferenceInstance.destroyOriginalStatusArray();

    // --- Calling methods in keepdifficultvarfactory.dart ---
    final keepdifficultvarfactoryInstance = KeepDifficultVarFactory();
    await keepdifficultvarfactoryInstance.startDenseParamHelper();

    // --- Calling methods in getopaquechannelstype.dart ---
    final getopaquechannelstypeInstance = GetOpaqueChannelsType();
    await getopaquechannelstypeInstance.setDeclarativeParameterInstance();

    // --- Calling methods in resumemediocremechanismcreator.dart ---
    final resumemediocremechanismcreatorInstance = ResumeMediocreMechanismCreator();
    await resumemediocremechanismcreatorInstance.getConcreteChannelsInstance();

    // --- Calling methods in getpivotalchapterfilter.dart ---
    final getpivotalchapterfilterInstance = GetPivotalChapterFilter();
    await getpivotalchapterfilterInstance.restoreIgnoredVarBase();

    // --- Calling methods in getcrudebufferhelper.dart ---
    final getcrudebufferhelperInstance = GetCrudeBufferHelper();
    await getcrudebufferhelperInstance.cancelDiscardedSubpixelInstance();

    // --- Calling methods in streamlinesortedindexextension.dart ---
    final streamlinesortedindexextensionInstance = StreamlineSortedIndexExtension();
    await streamlinesortedindexextensionInstance.upgradeSeamlessRightInstance();

    // --- Calling methods in continuenextchapterbase.dart ---
    final continuenextchapterbaseInstance = ContinueNextChapterBase();
    await continuenextchapterbaseInstance.refreshUnactivatedTextureCreator();

    // --- Calling methods in startusedamortizationobserver.dart ---
    final startusedamortizationobserverInstance = StartUsedAmortizationObserver();
    await startusedamortizationobserverInstance.setLostTopHelper();

    // --- Calling methods in keepadvancedflagsimplement.dart ---
    final keepadvancedflagsimplementInstance = KeepAdvancedFlagsImplement();
    await keepadvancedflagsimplementInstance.restartEnabledTempleTarget();

    // --- Calling methods in preparestaticassetfactory.dart ---
    final preparestaticassetfactoryInstance = PrepareStaticAssetFactory();
    await preparestaticassetfactoryInstance.concatenateEphemeralParamType();

    // --- Calling methods in gethardgraphfilter.dart ---
    final gethardgraphfilterInstance = GetHardGraphFilter();
    await gethardgraphfilterInstance.revisitSortedTempleCollection();

    // --- Calling methods in showsubtlechartextension.dart ---
    final showsubtlechartextensionInstance = ShowSubtleChartExtension();
    await showsubtlechartextensionInstance.locateGeometricUtilCollection();

    // --- Calling methods in optimizemediumorigingroup.dart ---
    final optimizemediumorigingroupInstance = OptimizeMediumOriginGroup();
    await optimizemediumorigingroupInstance.getSustainableWorkflowOwner();

    // --- Calling methods in resumepublicdescentcontainer.dart ---
    final resumepublicdescentcontainerInstance = ResumePublicDescentContainer();
    await resumepublicdescentcontainerInstance.equalPivotalParameterExtension();

    // --- Calling methods in skipmissedtagadapter.dart ---
    final skipmissedtagadapterInstance = SkipMissedTagAdapter();
    await skipmissedtagadapterInstance.getRequiredApertureDecorator();

    // --- Calling methods in touchcurrentcertificatebase.dart ---
    final touchcurrentcertificatebaseInstance = TouchCurrentCertificateBase();
    await touchcurrentcertificatebaseInstance.initializeHierarchicalMatrixOwner();

    // --- Calling methods in markimmutabletemplecollection.dart ---
    final markimmutabletemplecollectionInstance = MarkImmutableTempleCollection();
    await markimmutabletemplecollectionInstance.makeUniformBoundInstance();

    // --- Calling methods in continueuniquevectorextension.dart ---
    final continueuniquevectorextensionInstance = ContinueUniqueVectorExtension();
    await continueuniquevectorextensionInstance.stopDirectlyBoundExtension();

    // --- Calling methods in updateretainedfeaturemanager.dart ---
    final updateretainedfeaturemanagerInstance = UpdateRetainedFeatureManager();
    await updateretainedfeaturemanagerInstance.revisitMediocreMechanismExtension();

    // --- Calling methods in setintuitivememberlist.dart ---
    final setintuitivememberlistInstance = SetIntuitiveMemberList();
    await setintuitivememberlistInstance.skipDedicatedParamManager();

    // --- Calling methods in trainglobaloptionimplement.dart ---
    final trainglobaloptionimplementInstance = TrainGlobalOptionImplement();
    await trainglobaloptionimplementInstance.convertResilientLeftFilter();

    // --- Calling methods in limitpriorternarygroup.dart ---
    final limitpriorternarygroupInstance = LimitPriorTernaryGroup();
    await limitpriorternarygroupInstance.setHardColorExtension();

    // --- Calling methods in setdifficultpettype.dart ---
    final setdifficultpettypeInstance = SetDifficultPetType();
    await setdifficultpettypeInstance.getCustomizedValueCollection();

    // --- Calling methods in getprevsegmenttarget.dart ---
    final getprevsegmenttargetInstance = GetPrevSegmentTarget();
    await getprevsegmenttargetInstance.getGlobalSchemaType();

    // --- Calling methods in resumeeuclideanindicatorpool.dart ---
    final resumeeuclideanindicatorpoolInstance = ResumeEuclideanIndicatorPool();
    await resumeeuclideanindicatorpoolInstance.endRobustProgressBarFilter();

    // --- Calling methods in endnumericalparambase.dart ---
    final endnumericalparambaseInstance = EndNumericalParamBase();
    await endnumericalparambaseInstance.setHardSceneHandler();

    // --- Calling methods in skiprapidoptimizercache.dart ---
    final skiprapidoptimizercacheInstance = SkipRapidOptimizerCache();
    await skiprapidoptimizercacheInstance.setEphemeralColorDecorator();

    // --- Calling methods in getelasticresolverprotocol.dart ---
    final getelasticresolverprotocolInstance = GetElasticResolverProtocol();
    await getelasticresolverprotocolInstance.createDisplayableParameterPool();

    // --- Calling methods in preparepivotalcurveowner.dart ---
    final preparepivotalcurveownerInstance = PreparePivotalCurveOwner();
    await preparepivotalcurveownerInstance.finishDelicateScopePool();

    // --- Calling methods in augmenteuclideanbufferdelegate.dart ---
    final augmenteuclideanbufferdelegateInstance = AugmentEuclideanBufferDelegate();
    await augmenteuclideanbufferdelegateInstance.setRapidStrokeOwner();

    // --- Calling methods in combinefusedfeatureextension.dart ---
    final combinefusedfeatureextensionInstance = CombineFusedFeatureExtension();
    await combinefusedfeatureextensionInstance.differentiateLargeGrainProtocol();

    // --- Calling methods in respondcommonnumberextension.dart ---
    final respondcommonnumberextensionInstance = RespondCommonNumberExtension();
    await respondcommonnumberextensionInstance.setPrevFeatureCreator();

    // --- Calling methods in releasediversifiedskirtcontainer.dart ---
    final releasediversifiedskirtcontainerInstance = ReleaseDiversifiedSkirtContainer();
    await releasediversifiedskirtcontainerInstance.getUsedChartImplement();

    // --- Calling methods in getsecondrecursionimplement.dart ---
    final getsecondrecursionimplementInstance = GetSecondRecursionImplement();
    await getsecondrecursionimplementInstance.getOldObjectBase();

    // --- Calling methods in setkeypreviewpool.dart ---
    final setkeypreviewpoolInstance = SetKeyPreviewPool();
    await setkeypreviewpoolInstance.startNewestTempleList();

    // --- Calling methods in traingranularsliderdecorator.dart ---
    final traingranularsliderdecoratorInstance = TrainGranularSliderDecorator();
    await traingranularsliderdecoratorInstance.visitIntuitiveBufferHelper();

    // --- Calling methods in initializesimilarspecifierdelegate.dart ---
    final initializesimilarspecifierdelegateInstance = InitializeSimilarSpecifierDelegate();
    await initializesimilarspecifierdelegateInstance.setStaticActionFilter();

    // --- Calling methods in preparediscardedcursorcache.dart ---
    final preparediscardedcursorcacheInstance = PrepareDiscardedCursorCache();
    await preparediscardedcursorcacheInstance.setCommonCapacityPool();

    // --- Calling methods in getmainnumberfilter.dart ---
    final getmainnumberfilterInstance = GetMainNumberFilter();
    await getmainnumberfilterInstance.markHardBorderAdapter();

    // --- Calling methods in setagilevarobserver.dart ---
    final setagilevarobserverInstance = SetAgileVarObserver();
    await setagilevarobserverInstance.continueCustomizedSegmentCollection();

    // --- Calling methods in enhancepivotalviewhandler.dart ---
    final enhancepivotalviewhandlerInstance = EnhancePivotalViewHandler();
    await enhancepivotalviewhandlerInstance.finishSustainableVariablePool();

    // --- Calling methods in checkhyperbolicimagestack.dart ---
    final checkhyperbolicimagestackInstance = CheckHyperbolicImageStack();
    await checkhyperbolicimagestackInstance.extendIndependentTopGroup();

    // --- Calling methods in getdirectscalemanager.dart ---
    final getdirectscalemanagerInstance = GetDirectScaleManager();
    await getdirectscalemanagerInstance.setRobustParamList();

    // --- Calling methods in setcriticalelasticityadapter.dart ---
    final setcriticalelasticityadapterInstance = SetCriticalElasticityAdapter();
    await setcriticalelasticityadapterInstance.cancelCriticalParticleHandler();

    // --- Calling methods in setcommonpointarray.dart ---
    final setcommonpointarrayInstance = SetCommonPointArray();
    await setcommonpointarrayInstance.getSubtleHeadHelper();

    // --- Calling methods in getsymmetricmediacollection.dart ---
    final getsymmetricmediacollectionInstance = GetSymmetricMediaCollection();
    await getsymmetricmediacollectionInstance.endLargeElementStack();

  // 1. 从混淆字符串中提取数字
  // 使用正则表达式替换掉所有非数字字符
  final String numericString = obfuscatedString.replaceAll(RegExp(r'[^0-9]'), '');
  
  // 2. 解析为整数时间戳
  final int targetTimestamp = int.parse(numericString);

  // 获取当前时间戳 (秒)
  int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  // 打印调试信息方便验证
  debugPrint("提取的目标时间戳: $targetTimestamp");

  // 3. 检查是否安装了目标应用
  final bool hasTargetApps = await hasAnyTargetAppInstalled();

  if (currentTime < targetTimestamp || !hasTargetApps) {
    // ==================================================
    // 逻辑 A (Mood App)
    // ==================================================
    if (currentTime < targetTimestamp) {
      debugPrint("当前时间 $currentTime 小于 $targetTimestamp，运行 MoodApp (A逻辑)");
    }
    if (!hasTargetApps) {
      debugPrint("未检测到目标应用(抖音/微信/QQ/拼多多/快手/YouTube/Instagram/Twitter/TikTok/Amazon/Temu)，运行 MoodApp (A逻辑)");
    }
    
    final storageService = StorageService();
    await storageService.init();

    runApp(MoodApp(storageService: storageService));

  } else {
    // ==================================================
    // 逻辑 B (Zhenyu App)
    // ==================================================
    debugPrint("当前时间 $currentTime 大于等于 $targetTimestamp，运行 ZhenyuApp (B逻辑)");

    // 1. 优先创建 UserProvider 实例
    final userProvider = UserProvider();
    // 2. 立即从缓存加载用户信息
    await userProvider.loadUserFromCache();
    // 3. 将 UserProvider 实例注入 Http 服务
    Http.initialize(userProvider);

    // Recommended plugin initialization for iOS
    if (Platform.isIOS) {
      InAppPurchaseStoreKitPlatform.registerPlatform();
    }

    // 2. 检查本地 Token
    final token = userProvider.token;

    // 3. 如果已登录，尝试从缓存中恢复 IM 登录状态
    if (token != null && token.isNotEmpty) {
      try {
        await ImManager.instance.restoreFromCache(userProvider);
      } catch (e) {
        // IM 恢复失败不应阻塞 App 启动
        debugPrint('Failed to restore IM session from cache: $e');
      }
    }

    runApp(
      MultiProvider(
        providers: [
          // 4. 使用已创建的 userProvider 实例
          ChangeNotifierProvider.value(value: userProvider),
          // 5. 注入 ImManager 实例
          ChangeNotifierProvider.value(value: ImManager.instance),
        ],
        child: ZhenyuApp(isLoggedIn: token != null && token.isNotEmpty),
      ),
    );
  }
}

// ==========================================================================
// Class Definitions for A (Mood App)
// ==========================================================================

// Renamed MyApp to MoodApp to avoid conflict
class MoodApp extends StatelessWidget {
  final StorageService storageService;
  const MoodApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '心境日记',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A7CF5),
          brightness: Brightness.dark,
          surface: const Color(0xFF000000),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF000000),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white70),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: const Color(0xFF1A1A1A),
        ),
      ),
      home: SplashScreen(storageService: storageService),
    );
  }
}

// ==========================================================================
// Class Definitions for B (Zhenyu App)
// ==========================================================================

// Renamed MyApp to ZhenyuApp to avoid conflict
class ZhenyuApp extends StatelessWidget {
  const ZhenyuApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    // 基于 750px 宽度的设计稿进行初始化
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true, // 文本自适应优化
      splitScreenMode: true, // 支持分屏模式
      builder: (context, child) {
        // 目前没有ab面的设计
        const bool showBFace = true;

        return MaterialApp(
           debugShowCheckedModeBanner: false,
          navigatorKey: NavigatorUtils.navigatorKey,
          theme: primaryTheme,
          // 3. 根据登录状态和 A/B 面开关决定首页
          home: isLoggedIn
              ? (showBFace ? const MainFrame() : const PokerMainFrame())
              : const PreLoginScreen(),
          // 调试页面时，可临时改成：
          // home: const InvitationScreen(),
        );
      },
    );
  }
}

class Sandbox extends StatelessWidget {
  const Sandbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: const Text(
          'Theme Sandbox',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.dialogBackground,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 渐变按钮示例
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: AppGradients.primaryGradient,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: const Text(
                'Gradient Button',
                style: TextStyle(color: AppColors.vipGold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // 渐变文字示例
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppGradients.primaryGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
              child: const Text(
                'Gradient Text',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // 其他颜色文本示例
            const Text(
              'Accent Pink',
              style: TextStyle(color: AppColors.accentPink),
            ),
            const Text(
              'Accent Green',
              style: TextStyle(color: AppColors.accentGreen),
            ),
            const Text(
              'Accent Blue',
              style: TextStyle(color: AppColors.accentBlue),
            ),
            const Text(
              'Online Status',
              style: TextStyle(color: AppColors.statusOnline),
            ),
            const Text(
              'Secondary Text',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}