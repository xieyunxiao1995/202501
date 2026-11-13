#!/usr/bin/env python3
"""Portable source-content and project-structure checks for Tideverse.

Works without third-party packages or Apple SDKs. Does NOT replace xcodebuild.
Run from any directory: python3 Tools/verify_package.py
"""
from pathlib import Path
from collections import Counter
import json
import plistlib
import re
import sys
from urllib.parse import urlparse

root = Path(__file__).resolve().parents[1]
res = root / 'Tideverse' / 'Resources'
assets = res / 'Assets.xcassets'
characters = json.loads((res / 'Stories' / 'characters.json').read_text(encoding='utf-8'))
stories = json.loads((res / 'Stories' / 'stories.json').read_text(encoding='utf-8'))
errors = []

def check(condition, message):
    if not condition:
        errors.append(message)

check(len(characters) == 40, f'expected 40 characters, got {len(characters)}')
check(len(stories) == 40, f'expected 40 stories, got {len(stories)}')
check(all(isinstance(c.get('age'), int) and c['age'] >= 25 for c in characters), 'all character ages must be explicitly 25+')
check(len({c['id'] for c in characters}) == len(characters), 'duplicate character IDs')
check(len({s['id'] for s in stories}) == len(stories), 'duplicate story IDs')
check(len({s['characterID'] for s in stories}) == len(stories), 'story/character mapping is not 1:1')
checks = 0
for char in characters:
    for label in ('portraitAsset', 'avatarAsset', 'sceneAsset'):
        name = char[label]
        folder = assets / f'{name}.imageset'
        manifest = folder / 'Contents.json'
        check(manifest.is_file(), f'{name} imageset manifest missing')
        if manifest.is_file():
            entries = json.loads(manifest.read_text(encoding='utf-8')).get('images', [])
            check(bool(entries), f'{name} imageset is empty')
            for item in entries:
                if 'filename' in item:
                    image = folder / item['filename']
                    check(image.is_file() and image.stat().st_size > 3000, f'asset missing or too small: {image}')
                    checks += 1
    check(any(s['id'] == char['storyID'] and s['characterID'] == char['id'] for s in stories), f'missing story for {char["id"]}')

chapter_ids, choice_ids = [], []
for story in stories:
    earlier_choices = set()
    check(len(story['chapters']) >= 4, f'{story["id"]} needs at least four authored chapters')
    for i, chapter in enumerate(story['chapters']):
        chapter_ids.append(chapter['id'])
        check(chapter['number'] == i+1, f'{chapter["id"]} number incorrect')
        check(len(chapter['choices']) >= 2, f'{chapter["id"]} must have at least two choices')
        check(len(chapter['intro']) > 40 and len(chapter['objective']) > 12, f'{chapter["id"]} needs chapter content')
        options = chapter['choices']
        for opt in options:
            choice_ids.append(opt['id'])
            check(len(opt['outcome']) > 50, f'{opt["id"]} outcome too short')
            check(isinstance(opt.get('memoryHint'), str) and len(opt['memoryHint'].strip()) > 8, f'{opt["id"]} needs a memory hint')
        check(len({o['outcome'] for o in options}) == len(options), f'{chapter["id"]} has identical outcomes')
        echoes = chapter.get('echoes', {})
        check(isinstance(echoes, dict) and all(key in earlier_choices and isinstance(value, str) and len(value) > 20 for key, value in echoes.items()), f'{chapter["id"]} has invalid earlier-choice acknowledgments')
        earlier_choices.update(o['id'] for o in options)
check(len(chapter_ids) == len(set(chapter_ids)), 'duplicate chapter IDs')
check(len(choice_ids) == len(set(choice_ids)), 'duplicate choice IDs')

pbx = (root / 'Tideverse.xcodeproj' / 'project.pbxproj').read_text(encoding='utf-8')
for source in (root / 'Tideverse').rglob('*.swift'):
    check(source.name in pbx, f'Swift source not referenced by project: {source.name}')
for file_name in ('characters.json', 'stories.json', 'Assets.xcassets', 'TideverseTests.swift'):
    check(file_name in pbx, f'Xcode target resource missing: {file_name}')
with (res / 'Info.plist').open('rb') as handle:
    info = plistlib.load(handle)
gateway = info.get('TIDEVERSE_GATEWAY_URL', '').strip()
if gateway:
    parsed = urlparse(gateway)
    check(parsed.scheme == 'https' and bool(parsed.hostname) and not parsed.username and not parsed.password, 'gateway must be HTTPS without embedded credentials')
    host = (parsed.hostname or '').lower()
    check(not any(host == domain or host.endswith('.' + domain) for domain in ('volces.com', 'volcengine.com')), 'configure the private gateway, not a direct provider endpoint')
check(info.get('UIUserInterfaceStyle') == 'Dark', 'Info.plist must enforce dark UI')
check('Assets.xcassets' in pbx and '/* Resources */' in pbx, 'Asset catalog must be added to app Resources build phase')

for file in root.rglob('*.json'):
    if any(part in {'build', '.build', '.git', 'node_modules', '__pycache__'} for part in file.relative_to(root).parts):
        continue
    try:
        json.loads(file.read_text(encoding='utf-8'))
    except (OSError, ValueError) as exc:
        errors.append(f'invalid JSON {file}: {exc}')

# Do not paste/store tokens into the repo or this checker. Check for patterns
# associated with accidentally committing a live Ark key in app source.
scan_files = list((root / 'Tideverse').rglob('*.swift')) + list((root / 'Tideverse').rglob('*.plist')) + [root / 'Backend' / 'worker.js']
for source in scan_files:
    content = source.read_text(encoding='utf-8')
    if re.search(r'(?i)(?:ark_api_key|authorization)\s*[:=]\s*["\'](?:Bearer\s+)?[0-9a-f]{8}-[0-9a-f-]{26,}', content):
        errors.append(f'possible embedded API key in {source}')

# Required-reason API declaration for the app's own preferences/consent.
privacy_path = root / 'Tideverse/Resources/PrivacyInfo.xcprivacy'
try:
    with privacy_path.open('rb') as handle:
        privacy = plistlib.load(handle)
    api_entries = privacy.get('NSPrivacyAccessedAPITypes', [])
    assert any(entry.get('NSPrivacyAccessedAPIType') == 'NSPrivacyAccessedAPICategoryUserDefaults'
               and 'CA92.1' in entry.get('NSPrivacyAccessedAPITypeReasons', []) for entry in api_entries)
    assert 'PrivacyInfo.xcprivacy' in (root / 'Tideverse.xcodeproj/project.pbxproj').read_text()
except (OSError, ValueError, AssertionError):
    errors.append('missing/invalid own-app UserDefaults required-reason privacy declaration')

if errors:
    print('FAIL:')
    for issue in errors:
        print(' -', issue)
    sys.exit(1)
print(f'PASS: {len(characters)} characters; {len(stories)} stories; {len(chapter_ids)} chapters; {len(choice_ids)} choices')
print(f'PASS: {checks} character images, Xcode source/resource references, Info.plist, JSON, key pattern check')
print('Note: open the .xcodeproj and run Xcode Build / XCTest on macOS to verify iOS compilation.')
