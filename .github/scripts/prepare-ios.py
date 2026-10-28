#!/usr/bin/env python3
"""Discover a root-level Xcode container and apply signing to the app target in CI."""
import datetime
import json
import os
from pathlib import Path
import plistlib
import subprocess
import sys


def fail(message):
    raise SystemExit(f'::error::{message}')


def xcode_json(arguments):
    result = subprocess.run(
        ['xcodebuild', *arguments, '-json'], text=True, capture_output=True
    )
    if result.returncode:
        sys.stderr.write(result.stdout + result.stderr)
        fail('Xcode 工程读取失败，请检查工程和共享 Scheme。')
    return json.loads(result.stdout)


def main():
    root = Path.cwd().resolve()
    configuration = os.environ.get('IOS_CONFIGURATION', 'Release')
    requested = os.environ.get('IOS_CONTAINER', '').strip()
    if requested:
        container = Path(requested)
        if not container.is_dir() or container.suffix not in {'.xcworkspace', '.xcodeproj'}:
            fail('IOS_CONTAINER 必须指向存在的 .xcworkspace 或 .xcodeproj 目录。')
    else:
        candidates = sorted(root.glob('*.xcworkspace')) or sorted(root.glob('*.xcodeproj'))
        if len(candidates) != 1:
            fail('请将 Xcode 工程放在仓库根目录；有多个工程时设置 IOS_CONTAINER。')
        container = candidates[0]
    container = container.resolve()
    if not container.is_relative_to(root):
        fail('IOS_CONTAINER 必须位于仓库内。')
    container_type = 'workspace' if container.suffix == '.xcworkspace' else 'project'
    arguments = [f'-{container_type}', str(container)]
    info = xcode_json([*arguments, '-list'])
    schemes = info.get(container_type, {}).get('schemes', [])
    scheme = os.environ.get('IOS_SCHEME', '').strip()
    if not scheme:
        # 避免把 CocoaPods 自动生成的 Scheme 当作主应用。
        projects = [container] if container_type == 'project' else sorted(root.glob('*.xcodeproj'))
        shared = {p.stem for project in [container, *projects]
                  for p in project.glob('xcshareddata/xcschemes/*.xcscheme')}
        choices = sorted(set(schemes) & shared) if shared else schemes
        if len(choices) != 1:
            fail('无法唯一识别 Scheme，请设置 IOS_SCHEME。可用值：' + ', '.join(schemes))
        scheme = choices[0]
    if scheme not in schemes:
        fail(f'Scheme {scheme!r} 不存在；请勾选 Shared 并提交 xcscheme 文件。')

    with open(os.environ['PROFILE_PLIST'], 'rb') as source:
        profile = plistlib.load(source)
    with open('ExportOptions.plist', 'rb') as source:
        export = plistlib.load(source)
    expires = profile['ExpirationDate']
    if expires.replace(tzinfo=datetime.timezone.utc) <= datetime.datetime.now(datetime.timezone.utc):
        fail('硬编码的 provisioning profile 已过期，请更新。')
    team = profile['TeamIdentifier'][0]
    identifier = profile['Entitlements']['application-identifier']
    prefix = profile['ApplicationIdentifierPrefix'][0] + '.'
    if not identifier.startswith(prefix):
        fail('Provisioning profile 的 App ID 前缀无效。')
    bundle_id = identifier[len(prefix):]
    if '*' in bundle_id or profile['Entitlements'].get('get-task-allow') or profile.get('ProvisionedDevices') or profile.get('ProvisionsAllDevices'):
        fail('需要显式 App ID 的 App Store 分发描述文件。')
    if export.get('teamID') != team or export.get('provisioningProfiles', {}).get(bundle_id) not in {profile['Name'], profile['UUID']}:
        fail('ExportOptions.plist 与硬编码描述文件的 Team、Bundle ID 或 Profile 不一致。')

    build_arguments = [*arguments, '-scheme', scheme, '-configuration', configuration,
                       '-destination', 'generic/platform=iOS',
                       '-derivedDataPath', str(Path(os.environ['RUNNER_TEMP']) / 'swift-derived-data')]
    # Swift Package Manager 会在此解析依赖，和归档使用同一个 DerivedData 目录。
    settings = xcode_json([*build_arguments, '-showBuildSettings'])
    apps = []
    for item in settings:
        build = item['buildSettings']
        product_type = build.get('PRODUCT_TYPE', '')
        if 'extension' in product_type or product_type.startswith('com.apple.product-type.application.watch'):
            fail('当前只提供一个主 App 的描述文件；扩展或 Watch App 需要额外签名配置。')
        if product_type == 'com.apple.product-type.application':
            apps.append(build)
    if len(apps) != 1:
        fail('所选 Scheme 必须只归档一个 iOS 主 App。')
    app = apps[0]
    if app.get('PRODUCT_BUNDLE_IDENTIFIER') != bundle_id:
        fail(f'App Bundle ID 必须为 {bundle_id}，请在 Xcode 中修改或更新签名材料。')
    if app.get('PLATFORM_NAME') != 'iphoneos':
        fail('所选 Scheme 必须支持 iOS 真机归档。')

    project_file = Path(app['PROJECT_FILE_PATH']) / 'project.pbxproj'
    project_file = project_file.resolve()
    if not project_file.is_relative_to(root):
        fail('签名目标工程必须位于仓库内。')
    # plutil 可读取 Xcode 的 OpenStep 格式；只在 CI checkout 中改写为等价 XML plist。
    project = json.loads(subprocess.check_output(
        ['plutil', '-convert', 'json', '-o', '-', str(project_file)], text=True
    ))
    objects = project['objects']
    targets = [obj for obj in objects.values()
               if obj.get('isa') == 'PBXNativeTarget' and obj.get('name') == app['TARGET_NAME']]
    if len(targets) != 1:
        fail('无法定位 App 的 PBXNativeTarget。')
    configurations = objects[targets[0]['buildConfigurationList']]['buildConfigurations']
    matched = False
    for config_id in configurations:
        config = objects[config_id]
        if config['name'] != configuration:
            continue
        matched = True
        build = config.setdefault('buildSettings', {})
        keys = ('CODE_SIGN_STYLE', 'DEVELOPMENT_TEAM', 'CODE_SIGN_IDENTITY',
                'PROVISIONING_PROFILE_SPECIFIER', 'PROVISIONING_PROFILE',
                'CODE_SIGNING_ALLOWED', 'CODE_SIGNING_REQUIRED')
        for key in list(build):
            if key.split('[')[0] in keys:
                del build[key]
        build.update(CODE_SIGN_STYLE='Manual', DEVELOPMENT_TEAM=team,
                     CODE_SIGN_IDENTITY='Apple Distribution',
                     PROVISIONING_PROFILE_SPECIFIER=profile['Name'],
                     CODE_SIGNING_ALLOWED='YES', CODE_SIGNING_REQUIRED='YES')
    if not matched:
        fail(f'App 没有 {configuration} 构建配置。')
    project_file.write_bytes(plistlib.dumps(project, sort_keys=False))

    outputs = {'container': str(container.relative_to(root)),
               'container_type': container_type, 'scheme': scheme}
    with open(os.environ['GITHUB_OUTPUT'], 'a') as output:
        for key, value in outputs.items():
            if '\n' in value or '\r' in value:
                fail('工程路径和 Scheme 不允许换行符。')
            output.write(f'{key}={value}\n')
    print(f'准备完成：{outputs["container"]} / {scheme} / {configuration}')
    print(f'App Bundle ID: {bundle_id}; profile 有效期: {expires.date()}')


if __name__ == '__main__':
    main()
