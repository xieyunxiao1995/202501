#!/usr/bin/env python3
"""Verify that the two App Store profiles match the Release targets and certificate."""

from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import plistlib
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]


def check(condition, message):
    if not condition:
        raise ValueError(message)


def read_plist(path):
    return plistlib.loads(path.read_bytes())


def main(keychain, app_profile, tunnel_profile):
    target_profiles = {"GeckConnent": Path(app_profile), "PacketTunnel": Path(tunnel_profile)}
    export = read_plist(ROOT / "ExportOptions.plist")
    team = export["teamID"]
    profiles = export["provisioningProfiles"]
    settings = json.loads(subprocess.check_output([
        "xcodebuild", "-project", "GeckoHop.xcodeproj", "-alltargets",
        "-configuration", "Release", "-sdk", "iphoneos", "-showBuildSettings", "-json",
    ], cwd=ROOT))
    release_targets = {item["target"]: item["buildSettings"] for item in settings}
    check({release_targets[target]["PRODUCT_BUNDLE_IDENTIFIER"] for target in target_profiles}
          == set(profiles), "ExportOptions.plist 必须分别映射主 App 和 Packet Tunnel。")

    identity_list = subprocess.check_output(
        ["security", "find-identity", "-v", "-p", "codesigning", keychain], text=True
    )
    identities = set(re.findall(r"\b[A-F0-9]{40}\b", identity_list))
    validated = []
    for target, source in target_profiles.items():
        build = release_targets[target]
        profile = plistlib.loads(subprocess.check_output(["security", "cms", "-D", "-i", str(source)]))
        bundle = build["PRODUCT_BUNDLE_IDENTIFIER"]
        entitlements = profile["Entitlements"]
        expires = profile["ExpirationDate"].replace(tzinfo=timezone.utc)
        check(expires > datetime.now(timezone.utc), f"{target} 的描述文件已过期。")
        check(profile["TeamIdentifier"] == [team] and build["DEVELOPMENT_TEAM"] == team,
              f"{target} 的开发团队与导出配置不一致。")
        check(entitlements.get("application-identifier") == f"{team}.{bundle}",
              f"{target} 的描述文件不匹配 {bundle}。")
        check(not (profile.get("ProvisionedDevices") or profile.get("ProvisionsAllDevices")
                   or entitlements.get("get-task-allow")),
              f"{target} 需要 App Store 分发描述文件。")
        check("packet-tunnel-provider" in entitlements.get("com.apple.developer.networking.networkextension", []),
              f"{target} 的描述文件缺少 Packet Tunnel 能力。")
        check(build["CODE_SIGN_STYLE"] == "Manual"
              and build["PROVISIONING_PROFILE_SPECIFIER"] == profile["Name"]
              and profiles[bundle] == profile["Name"],
              f"{target} 的 Release 签名和 ExportOptions.plist 必须使用 {profile['Name']}。")
        certs = {hashlib.sha1(c).hexdigest().upper() for c in profile["DeveloperCertificates"]}
        check(identities & certs, f"{target} 的描述文件与 P12 中的可用签名身份不匹配。")
        validated.append((source, profile["UUID"]))
        print(f"{target} · {bundle} · profile 有效至 {expires.date()}")

    installed = Path.home() / "Library/Developer/Xcode/UserData/Provisioning Profiles"
    installed.mkdir(parents=True, exist_ok=True)
    for source, uuid in validated:
        shutil.copyfile(source, installed / f"{uuid}.mobileprovision")


if __name__ == "__main__":
    try:
        main(*sys.argv[1:])
    except (KeyError, ValueError, OSError, subprocess.CalledProcessError) as error:
        sys.exit(f"::error::{error}")
