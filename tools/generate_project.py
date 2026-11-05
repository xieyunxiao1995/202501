#!/usr/bin/env python3
"""Regenerates traditional PBXGroup .xcodeproj from the checked-in Swift sources.
No third-party package manager, XcodeGen install or Internet connectivity required.
"""
from __future__ import annotations
import hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / 'SunShadowPad'
TESTS = ROOT / 'SunShadowPadTests'
UITESTS = ROOT / 'SunShadowPadUITests'
OUT = ROOT / 'SunShadowPad.xcodeproj' / 'project.pbxproj'
OUT.parent.mkdir(exist_ok=True)


def uid(key: str) -> str:
    return hashlib.sha1(key.encode('utf8')).hexdigest().upper()[:24]


def q(s: str) -> str:
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'


def object_code(key: str, comment: str = '') -> str:
    return uid(key) + (f' /* {comment} */' if comment else '')


objects: dict[str, str] = {}

def add(key: str, fields: str) -> None:
    objects[key] = '\t\t' + uid(key) + ' = {\n' + fields + '\t\t};\n'


def fref(file_key: str, filename: str, type_name: str = 'sourcecode.swift', source='"<group>"'):
    add(file_key, f'\t\t\tisa = PBXFileReference;\n\t\t\tlastKnownFileType = {type_name};\n'
                  f'\t\t\tpath = {q(filename)};\n\t\t\tsourceTree = {source};\n')


app_files = sorted(APP.rglob('*.swift'), key=lambda x: x.as_posix())
test_files = sorted(TESTS.rglob('*.swift'), key=lambda x: x.as_posix())
ui_test_files = sorted(UITESTS.rglob('*.swift'), key=lambda x: x.as_posix())
for source in app_files + test_files + ui_test_files:
    rel = source.relative_to(ROOT).as_posix()
    fref('f_' + rel, source.name)
    add('b_' + rel,
        f'\t\t\tisa = PBXBuildFile;\n\t\t\tfileRef = {object_code("f_" + rel, source.name)};\n')

asset_rel = 'SunShadowPad/Resources/Assets.xcassets'
fref('f_' + asset_rel, 'Assets.xcassets', 'folder.assetcatalog')
add('b_' + asset_rel,
    f'\t\t\tisa = PBXBuildFile;\n\t\t\tfileRef = {object_code("f_" + asset_rel,"Assets.xcassets")};\n')
plist_rel = 'SunShadowPad/Resources/Info.plist'
fref('f_' + plist_rel, 'Info.plist', 'text.plist.xml')
privacy_rel = 'SunShadowPad/Resources/PrivacyInfo.xcprivacy'
fref('f_' + privacy_rel, 'PrivacyInfo.xcprivacy', 'text.xml')
add('b_' + privacy_rel,
    f'\t\t\tisa = PBXBuildFile;\n\t\t\tfileRef = {object_code("f_" + privacy_rel,"PrivacyInfo.xcprivacy")};\n')

add('product_app', '\t\t\tisa = PBXFileReference;\n\t\t\texplicitFileType = wrapper.application;\n'
                   '\t\t\tincludeInIndex = 0;\n\t\t\tpath = SunShadowPad.app;\n'
                   '\t\t\tsourceTree = BUILT_PRODUCTS_DIR;\n')
add('product_tests', '\t\t\tisa = PBXFileReference;\n\t\t\texplicitFileType = wrapper.cfbundle;\n'
                     '\t\t\tincludeInIndex = 0;\n\t\t\tpath = SunShadowPadTests.xctest;\n'
                     '\t\t\tsourceTree = BUILT_PRODUCTS_DIR;\n')
add('product_uitests', '\t\t\tisa = PBXFileReference;\n\t\t\texplicitFileType = wrapper.cfbundle;\n'
                       '\t\t\tincludeInIndex = 0;\n\t\t\tpath = SunShadowPadUITests.xctest;\n'
                       '\t\t\tsourceTree = BUILT_PRODUCTS_DIR;\n')

# Build traditional visible groups, so this works beyond one specific Xcode release.
def source_dirs(base: Path) -> set[Path]:
    dirs = {base}
    for child in base.rglob('*'):
        if child.is_dir() and child.suffix not in {'.xcassets', '.xcdatamodeld'}:
            dirs.add(child)
    return dirs

folders = sorted(source_dirs(APP) | source_dirs(TESTS) | source_dirs(UITESTS),
                 key=lambda p: (len(p.parts), p.as_posix()))
for folder in folders:
    children = []
    nested = sorted([d for d in folders if d.parent == folder], key=lambda x: x.name)
    children += [object_code('g_' + d.relative_to(ROOT).as_posix(), d.name) for d in nested]
    children += [object_code('f_' + f.relative_to(ROOT).as_posix(), f.name)
                 for f in sorted([x for x in (app_files + test_files + ui_test_files) if x.parent == folder], key=lambda x: x.name)]
    if folder == APP / 'Resources':
        children += [object_code('f_' + asset_rel, 'Assets.xcassets'),
                     object_code('f_' + plist_rel, 'Info.plist'),
                     object_code('f_' + privacy_rel, 'PrivacyInfo.xcprivacy')]
    key = 'g_' + folder.relative_to(ROOT).as_posix()
    add(key, '\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n' + ''.join(
        '\t\t\t\t' + c + ',\n' for c in children) +
        '\t\t\t);\n\t\t\tpath = ' + q(folder.name) + ';\n\t\t\tsourceTree = "<group>";\n')

add('g_products', '\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n'
    f'\t\t\t\t{object_code("product_app","SunShadowPad.app")},\n'
    f'\t\t\t\t{object_code("product_tests","SunShadowPadTests.xctest")},\n'
    f'\t\t\t\t{object_code("product_uitests","SunShadowPadUITests.xctest")},\n'
    '\t\t\t);\n\t\t\tname = Products;\n\t\t\tsourceTree = "<group>";\n')
add('g_main', '\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n'
    f'\t\t\t\t{object_code("g_SunShadowPad","SunShadowPad")},\n'
    f'\t\t\t\t{object_code("g_SunShadowPadTests","SunShadowPadTests")},\n'
    f'\t\t\t\t{object_code("g_SunShadowPadUITests","SunShadowPadUITests")},\n'
    f'\t\t\t\t{object_code("g_products","Products")},\n'
    '\t\t\t);\n\t\t\tsourceTree = "<group>";\n')

for target, files in (('app', app_files), ('tests', test_files), ('uitests', ui_test_files)):
    add('phase_sources_' + target, '\t\t\tisa = PBXSourcesBuildPhase;\n'
        '\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n' + ''.join(
            '\t\t\t\t' + object_code('b_' + f.relative_to(ROOT).as_posix(), f.name + ' in Sources') + ',\n'
            for f in files) + '\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n')
    add('phase_frameworks_' + target, '\t\t\tisa = PBXFrameworksBuildPhase;\n'
        '\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = ();\n'
        '\t\t\trunOnlyForDeploymentPostprocessing = 0;\n')
add('phase_resources_app', '\t\t\tisa = PBXResourcesBuildPhase;\n'
    '\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n'
    f'\t\t\t\t{object_code("b_"+asset_rel,"Assets.xcassets in Resources")},\n'
    f'\t\t\t\t{object_code("b_"+privacy_rel,"PrivacyInfo.xcprivacy in Resources")},\n'
    '\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n')
add('phase_resources_tests', '\t\t\tisa = PBXResourcesBuildPhase;\n'
    '\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = ();\n'
    '\t\t\trunOnlyForDeploymentPostprocessing = 0;\n')

app_id = object_code('target_app', 'SunShadowPad')
test_id = object_code('target_tests', 'SunShadowPadTests')
ui_test_id = object_code('target_uitests', 'SunShadowPadUITests')
for name, display, product, filetype in (
        ('app', 'SunShadowPad', 'product_app', 'com.apple.product-type.application'),
        ('tests', 'SunShadowPadTests', 'product_tests', 'com.apple.product-type.bundle.unit-test'),
        ('uitests', 'SunShadowPadUITests', 'product_uitests', 'com.apple.product-type.bundle.ui-testing')):
    phases = ['phase_sources_'+name, 'phase_frameworks_'+name, 'phase_resources_'+name]
    deps = [] if name == 'app' else [object_code('dependency_'+name, 'PBXTargetDependency')]
    add('target_'+name, '\t\t\tisa = PBXNativeTarget;\n'
        f'\t\t\tbuildConfigurationList = {object_code("configlist_"+name,"Build configuration list")};\n'
        '\t\t\tbuildPhases = (\n' + ''.join('\t\t\t\t'+object_code(p)+',\n' for p in phases)
        + '\t\t\t);\n\t\t\tbuildRules = ();\n\t\t\tdependencies = (\n' + ''.join(
        '\t\t\t\t' + dep + ',\n' for dep in deps) + '\t\t\t);\n'
        f'\t\t\tname = {q(display)};\n'
        f'\t\t\tproductName = {q(display)};\n'
        f'\t\t\tproductReference = {object_code(product,"Product")};\n'
        f'\t\t\tproductType = {q(filetype)};\n')

for target in ('tests', 'uitests'):
    add('proxy_'+target, '\t\t\tisa = PBXContainerItemProxy;\n'
        f'\t\t\tcontainerPortal = {object_code("project")};\n'
        '\t\t\tproxyType = 1;\n'
        f'\t\t\tremoteGlobalIDString = {uid("target_app")};\n'
        '\t\t\tremoteInfo = SunShadowPad;\n')
    add('dependency_'+target, '\t\t\tisa = PBXTargetDependency;\n'
        f'\t\t\ttarget = {app_id};\n'
        f'\t\t\ttargetProxy = {object_code("proxy_"+target)};\n')

project_debug = {
    'ALWAYS_SEARCH_USER_PATHS': 'NO', 'CLANG_ENABLE_MODULES': 'YES',
    'COPY_PHASE_STRIP': 'NO', 'DEBUG_INFORMATION_FORMAT': 'dwarf',
    'ENABLE_TESTABILITY': 'YES', 'GCC_OPTIMIZATION_LEVEL': '0',
    'IPHONEOS_DEPLOYMENT_TARGET': '17.0', 'SDKROOT': 'iphoneos',
    'SWIFT_ACTIVE_COMPILATION_CONDITIONS': 'DEBUG', 'SWIFT_OPTIMIZATION_LEVEL': '-Onone',
}
project_release = {
    'ALWAYS_SEARCH_USER_PATHS': 'NO', 'CLANG_ENABLE_MODULES': 'YES',
    'COPY_PHASE_STRIP': 'YES', 'DEBUG_INFORMATION_FORMAT': 'dwarf-with-dsym',
    'IPHONEOS_DEPLOYMENT_TARGET': '17.0', 'SDKROOT': 'iphoneos',
    'SWIFT_COMPILATION_MODE': 'wholemodule', 'SWIFT_OPTIMIZATION_LEVEL': '-O',
}
app_config = {
    'ASSETCATALOG_COMPILER_APPICON_NAME': 'AppIcon',
    'CODE_SIGN_STYLE': 'Automatic',
    'CURRENT_PROJECT_VERSION': '1',
    'GENERATE_INFOPLIST_FILE': 'NO',
    'INFOPLIST_FILE': 'SunShadowPad/Resources/Info.plist',
    'IPHONEOS_DEPLOYMENT_TARGET': '17.0',
    'LD_RUNPATH_SEARCH_PATHS': '$(inherited) @executable_path/Frameworks',
    'MARKETING_VERSION': '1.0',
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.sunshadowpad.local',
    'PRODUCT_NAME': '$(TARGET_NAME)',
    'SDKROOT': 'iphoneos',
    'SUPPORTED_PLATFORMS': 'iphoneos iphonesimulator',
    'SWIFT_VERSION': '5.0',
    'TARGETED_DEVICE_FAMILY': '1',
}
test_config = {
    'BUNDLE_LOADER': '$(TEST_HOST)',
    'CODE_SIGN_STYLE': 'Automatic',
    'CURRENT_PROJECT_VERSION': '1',
    'GENERATE_INFOPLIST_FILE': 'YES',
    'IPHONEOS_DEPLOYMENT_TARGET': '17.0',
    'LD_RUNPATH_SEARCH_PATHS': '$(inherited) @loader_path/Frameworks @executable_path/Frameworks',
    'MARKETING_VERSION': '1.0',
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.sunshadowpad.local.tests',
    'PRODUCT_NAME': '$(TARGET_NAME)',
    'SDKROOT': 'iphoneos',
    'SUPPORTED_PLATFORMS': 'iphoneos iphonesimulator',
    'SWIFT_VERSION': '5.0',
    'TARGETED_DEVICE_FAMILY': '1',
    'TEST_HOST': '$(BUILT_PRODUCTS_DIR)/SunShadowPad.app/SunShadowPad',
}

ui_test_config = {
    'CODE_SIGN_STYLE': 'Automatic',
    'CURRENT_PROJECT_VERSION': '1',
    'GENERATE_INFOPLIST_FILE': 'YES',
    'IPHONEOS_DEPLOYMENT_TARGET': '17.0',
    'LD_RUNPATH_SEARCH_PATHS': '$(inherited) @executable_path/Frameworks @loader_path/Frameworks',
    'MARKETING_VERSION': '1.0',
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.sunshadowpad.local.uitests',
    'PRODUCT_NAME': '$(TARGET_NAME)',
    'SDKROOT': 'iphoneos',
    'SUPPORTED_PLATFORMS': 'iphoneos iphonesimulator',
    'SWIFT_VERSION': '5.0',
    'TARGETED_DEVICE_FAMILY': '1',
    'TEST_TARGET_NAME': 'SunShadowPad',
}

for name, shared in [('project', project_debug), ('app', app_config),
                     ('tests', test_config), ('uitests', ui_test_config)]:
    for variant in ['Debug', 'Release']:
        settings = dict(shared)
        if name == 'project' and variant == 'Release':
            settings = dict(project_release)
        if name == 'app' and variant == 'Debug': settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'DEBUG'
        txt = '\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {\n'
        for setting, value in sorted(settings.items()):
            txt += f'\t\t\t\t{setting} = {q(value)};\n'
        txt += f'\t\t\t}};\n\t\t\tname = {variant};\n'
        add('configuration_'+name+'_'+variant, txt)
    add('configlist_'+name, '\t\t\tisa = XCConfigurationList;\n\t\t\tbuildConfigurations = (\n'
        f'\t\t\t\t{object_code("configuration_"+name+"_Debug", "Debug")},\n'
        f'\t\t\t\t{object_code("configuration_"+name+"_Release", "Release")},\n'
        '\t\t\t);\n\t\t\tdefaultConfigurationIsVisible = 0;\n'
        '\t\t\tdefaultConfigurationName = Release;\n')

add('project', '\t\t\tisa = PBXProject;\n\t\t\tattributes = {\n'
    '\t\t\t\tBuildIndependentTargetsInParallel = YES;\n'
    '\t\t\t\tLastSwiftUpdateCheck = 1600;\n'
    '\t\t\t\tLastUpgradeCheck = 1600;\n'
    '\t\t\t\tTargetAttributes = {\n'
    f'\t\t\t\t\t{uid("target_app")} = {{ CreatedOnToolsVersion = 16.0; }};\n'
    f'\t\t\t\t\t{uid("target_tests")} = {{ CreatedOnToolsVersion = 16.0; TestTargetID = {uid("target_app")}; }};\n'
    f'\t\t\t\t\t{uid("target_uitests")} = {{ CreatedOnToolsVersion = 16.0; TestTargetID = {uid("target_app")}; }};\n'
    '\t\t\t\t};\n\t\t\t};\n'
    f'\t\t\tbuildConfigurationList = {object_code("configlist_project")};\n'
    '\t\t\tcompatibilityVersion = "Xcode 15.0";\n'
    '\t\t\tdevelopmentRegion = en;\n'
    '\t\t\thasScannedForEncodings = 0;\n'
    '\t\t\tknownRegions = (en, Base);\n'
    f'\t\t\tmainGroup = {object_code("g_main")};\n'
    f'\t\t\tproductRefGroup = {object_code("g_products")};\n'
    '\t\t\tprojectDirPath = "";\n'
    '\t\t\tprojectRoot = "";\n'
    '\t\t\ttargets = (\n'
    f'\t\t\t\t{app_id},\n\t\t\t\t{test_id},\n\t\t\t\t{ui_test_id},\n'
    '\t\t\t);\n')

out = '// !$*UTF8*$!\n{\n\tarchiveVersion = 1;\n\tclasses = {};\n\tobjectVersion = 60;\n\tobjects = {\n'
out += ''.join(objects[key] for key in sorted(objects))
out += f'\t}};\n\trootObject = {object_code("project","Project object")};\n}}\n'
OUT.write_text(out, encoding='utf-8')
print(f'Wrote {OUT} ({len(app_files)} app sources; {len(test_files)} unit test sources; '
      f'{len(ui_test_files)} UI test sources)')
