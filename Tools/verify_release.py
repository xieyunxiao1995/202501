#!/usr/bin/env python3
"""Fail release builds until publisher metadata is explicitly configured.

This validates configuration, not legal accuracy or App Store acceptance.
Run with --check-urls for an additional public policy/support reachability check.
"""
from pathlib import Path
from urllib.parse import urlparse
import argparse
import datetime
import plistlib
import sys

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--check-urls', action='store_true')
args = parser.parse_args()
with (root/'Tideverse/Resources/Info.plist').open('rb') as handle:
    info = plistlib.load(handle)
errors = []
for key in ['TIDEVERSE_PUBLISHER_NAME', 'TIDEVERSE_SUPPORT_EMAIL', 'TIDEVERSE_LEGAL_EFFECTIVE_DATE']:
    if not isinstance(info.get(key), str) or not info[key].strip(): errors.append(f'{key} must be configured with verified real information')
email = info.get('TIDEVERSE_SUPPORT_EMAIL', '')
if email and ('@' not in email or any(c.isspace() for c in email)):
    errors.append('TIDEVERSE_SUPPORT_EMAIL is invalid')
for key in ['TIDEVERSE_PRIVACY_URL', 'TIDEVERSE_SUPPORT_URL']:
    raw = info.get(key, '')
    url = urlparse(raw)
    if url.scheme != 'https' or not url.hostname or url.username or url.password:
        errors.append(f'{key} must be a real HTTPS URL without embedded credentials')
    elif url.hostname.endswith(('.invalid', '.example', '.test', '.localhost')) or url.hostname in ['example.com', 'example.org', 'example.net', 'localhost']:
        errors.append(f'{key} must not use a placeholder host')
    elif args.check_urls:
        from urllib.request import Request, urlopen
        try:
            with urlopen(Request(raw, headers={'User-Agent': 'Tideverse-Release-Validation'}), timeout=15) as response:
                if response.status != 200: errors.append(f'{key} is not publicly reachable (HTTP {response.status})')
        except Exception as error:
            errors.append(f'{key} could not be reached: {error}')
try:
    datetime.date.fromisoformat(info.get('TIDEVERSE_LEGAL_EFFECTIVE_DATE', ''))
except ValueError:
    errors.append('TIDEVERSE_LEGAL_EFFECTIVE_DATE must use YYYY-MM-DD')
if info.get('TIDEVERSE_PUBLISHER_REVIEWED') is not True:
    errors.append('TIDEVERSE_PUBLISHER_REVIEWED must be true after the real publisher reviews identity, legal copy, support and data-processing details')
if errors:
    for issue in errors: print('error: Release configuration: '+issue)
    sys.exit(1)
print('Release metadata configured. This does not verify identity, service operation, moderation, device QA or App Store acceptance.')
