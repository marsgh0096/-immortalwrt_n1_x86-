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

# 替换opkg源为清华源
sed -i 's|http://downloads.openwrt.org|https://mirrors.tuna.tsinghua.edu.cn/openwrt|g' package/base-files/files/etc/opkg/distfeeds.conf

echo "DIY-part2.sh 脚本执行完成" 