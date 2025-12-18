#!/bin/bash
#
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 添加额外的feeds源
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall2' >>feeds.conf.default
echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages' >>feeds.conf.default
echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns' >>feeds.conf.default
echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
echo 'src-git msd_lite https://github.com/ximiTech/luci-app-msd_lite' >>feeds.conf.default

# 添加晶晨宝盒
echo 'src-git amlogic https://github.com/ophub/luci-app-amlogic' >>feeds.conf.default

# 注意：feeds的更新和安装将在主工作流中处理 
