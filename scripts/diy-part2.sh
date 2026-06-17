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
# The rolling sbwml/luci-app-mosdns feed currently includes a v2dat mmap
# performance patch that changes go.mod to Go 1.25, while openwrt-24.10
# provides golang/host 1.23.x. Drop only that optional perf patch; the
# remaining v2dat patches build successfully with Go 1.23.
V2DAT_INCOMPAT_PATCH="feeds/mosdns/v2dat/patches/102-perf-unpack-Use-memory-mapping-to-reduce-memory-usag.patch"
if [ -f "$V2DAT_INCOMPAT_PATCH" ]; then
    echo "Removing v2dat Go 1.25-only patch for Go 1.23 compatibility"
    rm -f "$V2DAT_INCOMPAT_PATCH"
fi

# 替换opkg源为清华源
sed -i 's|http://downloads.openwrt.org|https://mirrors.tuna.tsinghua.edu.cn/openwrt|g' package/base-files/files/etc/opkg/distfeeds.conf

echo "DIY-part2.sh 脚本执行完成" 