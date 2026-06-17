#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改默认IP
sed -i 's/192.168.1.1/192.168.2.3/g' package/base-files/files/bin/config_generate

# 修改主机名字
if grep -q "CONFIG_TARGET_x86=y" .config; then
    sed -i 's/OpenWrt/ImmortalWrt/g' package/base-files/files/bin/config_generate
elif grep -q "CONFIG_TARGET_armvirt=y" .config; then
    sed -i 's/OpenWrt/N1-OpenWrt/g' package/base-files/files/bin/config_generate
else
    sed -i 's/OpenWrt/ImmortalWrt/g' package/base-files/files/bin/config_generate
fi

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i 's/root:::0:99999:7:::/root::0:0:99999:7:::/g' package/base-files/files/etc/shadow

# 修改时区
sed -i "s/timezone='UTC'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/timezone='CST-8'/a\\\t\t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 修改默认主题（如果存在）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile


# Keep mosdns v2dat Go 1.23 compatibility for ImmortalWrt/OpenWrt 24.10.
# The rolling sbwml/luci-app-mosdns feed currently patches v2dat to require
# Go 1.25, while openwrt-24.10 provides golang/host 1.23.x. Patch the feed
# patch back to Go 1.23-compatible module metadata after feeds are installed.
V2DAT_COMPAT_PATCH="feeds/mosdns/v2dat/patches/102-perf-unpack-Use-memory-mapping-to-reduce-memory-usag.patch"
if [ -f "$V2DAT_COMPAT_PATCH" ]; then
    echo "Applying v2dat Go 1.23 compatibility patch"
    python3 - "$V2DAT_COMPAT_PATCH" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()
text = text.replace('+go 1.25.0', '+go 1.23')
text = text.replace(
    'golang.org/x/sys v0.42.0 h1:omrd2nAlyT5ESRdCLYdm3+fMfNFE/+Rf4bDIQImRJeo=',
    'golang.org/x/sys v0.35.0 h1:vz1N37gP5bs89s7He8XuIYXpyY0+QlsKmzipCbUtyxI=',
)
text = text.replace(
    'golang.org/x/sys v0.42.0/go.mod h1:4GL1E5IUh+htKOUEOaiffhrAeqysfVGipDYzABqnCmw=',
    'golang.org/x/sys v0.35.0/go.mod h1:BJP2sWEmIv4KK5OTEluFJCKSidICx8ciO85XgH3Ak8k=',
)
text = text.replace('golang.org/x/sys v0.42.0', 'golang.org/x/sys v0.35.0')
path.write_text(text)
PY
fi

# 替换opkg源为清华源
sed -i 's|http://downloads.openwrt.org|https://mirrors.tuna.tsinghua.edu.cn/openwrt|g' package/base-files/files/etc/opkg/distfeeds.conf

echo "DIY-part2.sh 脚本执行完成" 