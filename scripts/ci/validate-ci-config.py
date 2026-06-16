#!/usr/bin/env python3
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
errors = []

part1 = ROOT / "scripts" / "diy-part1.sh"
text = part1.read_text()
required_feeds = [
    "https://github.com/Openwrt-Passwall/openwrt-passwall2",
    "https://github.com/Openwrt-Passwall/openwrt-passwall-packages",
]
for url in required_feeds:
    if url not in text:
        errors.append(f"{part1.relative_to(ROOT)} must use current feed URL: {url}")
for stale in [
    "https://github.com/xiaorouji/openwrt-passwall2",
    "https://github.com/xiaorouji/openwrt-passwall-packages",
]:
    if stale in text:
        errors.append(f"{part1.relative_to(ROOT)} still contains stale feed URL: {stale}")

workflow_expectations = {
    ".github/workflows/x86_64_immortalwrt.yml": ["CONFIG_FILE_PC"],
    ".github/workflows/build-n1-openwrt.yml": ["CONFIG_FILE_MINIMAL", "CONFIG_FILE_BYPASS"],
}
for wf, config_vars in workflow_expectations.items():
    wf_text = (ROOT / wf).read_text()
    for var in config_vars:
        if f'"$GITHUB_WORKSPACE/${var}"' not in wf_text:
            errors.append(f"{wf} must copy ${var} from $GITHUB_WORKSPACE, not /workdir")
    if '"$GITHUB_WORKSPACE/$DIY_P2_SH"' not in wf_text:
        errors.append(f"{wf} must execute DIY_P2_SH from $GITHUB_WORKSPACE")
    bad_patterns = [
        r"\[ -e \$CONFIG_FILE_(?:PC|MINIMAL|BYPASS) \] && mv \$CONFIG_FILE_",
        r"\[ -e \$DIY_P2_SH \] && chmod \+x \$DIY_P2_SH",
    ]
    for pattern in bad_patterns:
        if re.search(pattern, wf_text):
            errors.append(f"{wf} still checks config/script relative to /workdir")

if errors:
    print("CI config validation failed:")
    for e in errors:
        print(f"- {e}")
    sys.exit(1)
print("CI config validation passed")
