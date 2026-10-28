#!/usr/bin/env python3
"""Regenerates the checked-in Xcode project after adding Swift sources."""
from pathlib import Path
import hashlib

root = Path(__file__).resolve().parent.parent
files = sorted(str(p.relative_to(root / 'HomeMeasure')) for p in (root / 'HomeMeasure').rglob('*.swift'))
tests = sorted(str(p.relative_to(root / 'HomeMeasureTests')) for p in (root / 'HomeMeasureTests').rglob('*.swift'))

def ID(name):
    return hashlib.sha1(name.encode()).hexdigest().upper()[:24]

def block(kind, parts):
    return f'/* Begin {kind} section */\n' + '\n'.join(parts) + f'\n/* End {kind} section */\n'

objects=[]
def entry(name, typ, fields):
    objects.append((typ, f'\t\t{ID(name)} /* {name} */ = {{isa = {typ}; ' + ' '.join(fields) + ' };'))

def refs(seq):
    return '( ' + ', '.join(f'{ID(n)} /* {n} */' for n in seq) + ', )' if seq else '()'

app_sources=[f'App:{s}' for s in files]
test_sources=[f'Tests:{s}' for s in tests]
for s in files:
    entry(f'App:{s}', 'PBXFileReference', [f'lastKnownFileType = sourcecode.swift; path = "{s}"; sourceTree = "<group>";'])
    entry(f'Build:App:{s}', 'PBXBuildFile', [f'fileRef = {ID(f"App:{s}")} /* {s} */;'])
for s in tests:
    entry(f'Tests:{s}', 'PBXFileReference', [f'lastKnownFileType = sourcecode.swift; path = "{s}"; sourceTree = "<group>";'])
    entry(f'Build:Tests:{s}', 'PBXBuildFile', [f'fileRef = {ID(f"Tests:{s}")} /* {s} */;'])
entry('PrivacyInfo.xcprivacy', 'PBXFileReference', ['lastKnownFileType = text.xml; path = Resources/PrivacyInfo.xcprivacy; sourceTree = "<group>";'])
entry('Build:PrivacyInfo', 'PBXBuildFile', [f'fileRef = {ID("PrivacyInfo.xcprivacy")} /* PrivacyInfo.xcprivacy */;'])
entry('Assets.xcassets', 'PBXFileReference', ['lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>";'])
entry('Build:Assets', 'PBXBuildFile', [f'fileRef = {ID("Assets.xcassets")} /* Assets.xcassets */;'])
entry('HomeMeasure.app', 'PBXFileReference', ['explicitFileType = wrapper.application; includeInIndex = 0; path = HomeMeasure.app; sourceTree = BUILT_PRODUCTS_DIR;'])
entry('HomeMeasureTests.xctest', 'PBXFileReference', ['explicitFileType = wrapper.cfbundle; includeInIndex = 0; path = HomeMeasureTests.xctest; sourceTree = BUILT_PRODUCTS_DIR;'])
entry('Main Group', 'PBXGroup', [f'children = {refs(["App Group", "Test Group", "Products Group"])}; sourceTree = "<group>";'])
entry('App Group', 'PBXGroup', [f'children = {refs(app_sources+["Assets.xcassets","PrivacyInfo.xcprivacy"])}; path = HomeMeasure; sourceTree = "<group>";'])
entry('Test Group', 'PBXGroup', [f'children = {refs(test_sources)}; path = HomeMeasureTests; sourceTree = "<group>";'])
entry('Products Group', 'PBXGroup', [f'children = {refs(["HomeMeasure.app","HomeMeasureTests.xctest"])}; name = Products; sourceTree = "<group>";'])
entry('App Sources', 'PBXSourcesBuildPhase', [f'buildActionMask = 2147483647; files = {refs([f"Build:{s}" for s in app_sources])}; runOnlyForDeploymentPostprocessing = 0;'])
entry('Test Sources', 'PBXSourcesBuildPhase', [f'buildActionMask = 2147483647; files = {refs([f"Build:{s}" for s in test_sources])}; runOnlyForDeploymentPostprocessing = 0;'])
entry('App Resources', 'PBXResourcesBuildPhase', [f'buildActionMask = 2147483647; files = {refs(["Build:Assets","Build:PrivacyInfo"])}; runOnlyForDeploymentPostprocessing = 0;'])
entry('App Frameworks', 'PBXFrameworksBuildPhase', ['buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0;'])
entry('Test Frameworks', 'PBXFrameworksBuildPhase', ['buildActionMask = 2147483647; files = (); runOnlyForDeploymentPostprocessing = 0;'])
entry('App Target', 'PBXNativeTarget', [
    f'buildConfigurationList = {ID("App Config List")}; buildPhases = {refs(["App Sources", "App Frameworks", "App Resources"])};',
    'buildRules = (); dependencies = (); name = HomeMeasure;',
    f'productName = HomeMeasure; productReference = {ID("HomeMeasure.app")}; productType = "com.apple.product-type.application";'])
entry('Test Target', 'PBXNativeTarget', [
    f'buildConfigurationList = {ID("Test Config List")}; buildPhases = {refs(["Test Sources", "Test Frameworks"])};',
    f'buildRules = (); dependencies = {refs(["Test Dependency"])}; name = HomeMeasureTests;',
    f'productName = HomeMeasureTests; productReference = {ID("HomeMeasureTests.xctest")}; productType = "com.apple.product-type.bundle.unit-test";'])
entry('App Proxy', 'PBXContainerItemProxy', [f'containerPortal = {ID("Root Project")}; proxyType = 1; remoteGlobalIDString = {ID("App Target")}; remoteInfo = HomeMeasure;'])
entry('Test Dependency', 'PBXTargetDependency', [f'target = {ID("App Target")}; targetProxy = {ID("App Proxy")};'])
entry('Root Project', 'PBXProject', [
    f'attributes = {{ BuildIndependentTargetsInParallel = YES; LastUpgradeCheck = 1600; TargetAttributes = {{ {ID("App Target")} = {{ CreatedOnToolsVersion = 16.0; }}; {ID("Test Target")} = {{ CreatedOnToolsVersion = 16.0; TestTargetID = {ID("App Target")}; }}; }}; }};',
    f'buildConfigurationList = {ID("Project Config List")}; compatibilityVersion = "Xcode 14.0";',
    'developmentRegion = en; hasScannedForEncodings = 0; knownRegions = ( en, Base, );',
    f'mainGroup = {ID("Main Group")}; productRefGroup = {ID("Products Group")}; projectDirPath = "";',
    'projectRoot = ""; targets = '+refs(['App Target','Test Target'])+';'])

common='''ALWAYS_SEARCH_USER_PATHS = NO; CLANG_ENABLE_MODULES = YES; CLANG_ENABLE_OBJC_ARC = YES; COPY_PHASE_STRIP = NO; DEBUG_INFORMATION_FORMAT = dwarf; ENABLE_STRICT_OBJC_MSGSEND = YES; GCC_C_LANGUAGE_STANDARD = gnu17; SDKROOT = iphoneos; IPHONEOS_DEPLOYMENT_TARGET = 17.0; TARGETED_DEVICE_FAMILY = 1; SWIFT_VERSION = 5.0; '''
for config in ['Debug','Release']:
    isdebug = config == 'Debug'
    entry(f'Project {config}', 'XCBuildConfiguration', [
        f'buildSettings = {{ {common} SWIFT_OPTIMIZATION_LEVEL = {"\"-Onone\"" if isdebug else "\"-O\""}; '
        + ('GCC_OPTIMIZATION_LEVEL = 0; ENABLE_TESTABILITY = YES; SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG; ' if isdebug else 'ENABLE_NS_ASSERTIONS = NO; ') +
        f'}}; name = {config};'])
    app_settings='''ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon; CODE_SIGN_STYLE = Automatic; CURRENT_PROJECT_VERSION = 1; GENERATE_INFOPLIST_FILE = YES; INFOPLIST_KEY_CFBundleDisplayName = HomeMeasure; INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.lifestyle"; INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES; INFOPLIST_KEY_UILaunchScreen_Generation = YES; INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = UIInterfaceOrientationPortrait; MARKETING_VERSION = 1.0.0; PRODUCT_BUNDLE_IDENTIFIER = com.homemeasure.studio; PRODUCT_NAME = "$(TARGET_NAME)"; SUPPORTS_MACCATALYST = NO; SWIFT_EMIT_LOC_STRINGS = YES; SWIFT_STRICT_CONCURRENCY = minimal; TARGETED_DEVICE_FAMILY = 1; '''
    entry(f'App {config}', 'XCBuildConfiguration', [f'buildSettings = {{ {app_settings} }}; name = {config};'])
    test_settings='''BUNDLE_LOADER = "$(TEST_HOST)"; CODE_SIGN_STYLE = Automatic; GENERATE_INFOPLIST_FILE = YES; IPHONEOS_DEPLOYMENT_TARGET = 17.0; PRODUCT_BUNDLE_IDENTIFIER = com.homemeasure.studio.tests; PRODUCT_NAME = "$(TARGET_NAME)"; SWIFT_VERSION = 5.0; TARGETED_DEVICE_FAMILY = 1; TEST_HOST = "$(BUILT_PRODUCTS_DIR)/HomeMeasure.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/HomeMeasure"; '''
    entry(f'Test {config}', 'XCBuildConfiguration', [f'buildSettings = {{ {test_settings} }}; name = {config};'])
for name, prefix in [('Project Config List','Project'),('App Config List','App'),('Test Config List','Test')]:
    entry(name, 'XCConfigurationList', [f'buildConfigurations = {refs([prefix+" Debug", prefix+" Release"])}; defaultConfigurationIsVisible = 0; defaultConfigurationName = Release;'])

order=['PBXBuildFile','PBXContainerItemProxy','PBXFileReference','PBXFrameworksBuildPhase','PBXGroup','PBXNativeTarget','PBXProject','PBXResourcesBuildPhase','PBXSourcesBuildPhase','PBXTargetDependency','XCBuildConfiguration','XCConfigurationList']
sections='\n'.join(block(kind,[s for typ,s in objects if typ == kind]) for kind in order)
out=f'''// !$*UTF8*$!\n{{\n\tarchiveVersion = 1;\n\tclasses = {{}};\n\tobjectVersion = 56;\n\tobjects = {{\n{sections}\n\t}};\n\trootObject = {ID("Root Project")} /* Project object */;\n}}\n'''
proj = root / 'HomeMeasure.xcodeproj'
proj.mkdir(exist_ok=True)
(proj/'project.pbxproj').write_text(out)
schemes=proj/'xcshareddata/xcschemes'
schemes.mkdir(parents=True,exist_ok=True)
(schemes/'HomeMeasure.xcscheme').write_text(f'''<?xml version="1.0" encoding="UTF-8"?>
<Scheme LastUpgradeVersion="1600" version="1.3">
 <BuildAction parallelizeBuildables="YES" buildImplicitDependencies="YES">
  <BuildActionEntries>
   <BuildActionEntry buildForTesting="YES" buildForRunning="YES" buildForProfiling="YES" buildForArchiving="YES" buildForAnalyzing="YES">
    <BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{ID('App Target')}" BuildableName="HomeMeasure.app" BlueprintName="HomeMeasure" ReferencedContainer="container:HomeMeasure.xcodeproj"/>
   </BuildActionEntry>
  </BuildActionEntries>
 </BuildAction>
 <TestAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv="YES">
  <Testables><TestableReference skipped="NO"><BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{ID('Test Target')}" BuildableName="HomeMeasureTests.xctest" BlueprintName="HomeMeasureTests" ReferencedContainer="container:HomeMeasure.xcodeproj"/></TestableReference></Testables>
 </TestAction>
 <LaunchAction buildConfiguration="Debug" selectedDebuggerIdentifier="Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier="Xcode.IDEFoundation.Launcher.LLDB" launchStyle="0" useCustomWorkingDirectory="NO" ignoresPersistentStateOnLaunch="NO" debugDocumentVersioning="YES" debugServiceExtension="internal" allowLocationSimulation="NO">
  <BuildableProductRunnable runnableDebuggingMode="0"><BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{ID('App Target')}" BuildableName="HomeMeasure.app" BlueprintName="HomeMeasure" ReferencedContainer="container:HomeMeasure.xcodeproj"/></BuildableProductRunnable>
 </LaunchAction>
 <ProfileAction buildConfiguration="Release" shouldUseLaunchSchemeArgsEnv="YES" savedToolIdentifier="" useCustomWorkingDirectory="NO" debugDocumentVersioning="YES"><BuildableProductRunnable runnableDebuggingMode="0"><BuildableReference BuildableIdentifier="primary" BlueprintIdentifier="{ID('App Target')}" BuildableName="HomeMeasure.app" BlueprintName="HomeMeasure" ReferencedContainer="container:HomeMeasure.xcodeproj"/></BuildableProductRunnable></ProfileAction>
 <AnalyzeAction buildConfiguration="Debug"/>
 <ArchiveAction buildConfiguration="Release" revealArchiveInOrganizer="YES"/>
</Scheme>
''')
print('Written', proj, 'with',len(files),'Swift source files and',len(tests),'unit test files')
