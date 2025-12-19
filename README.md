# 斐讯N1/x86 OpenWRT自用固件自动编译

本项目使用GitHub Actions自动编译斐讯N1（Amlogic S905）/x86的OpenWRT固件。

## 📋 功能特性

### 精简版固件
- ✅ 基础immortalwrt系统
- ✅ 晶晨宝盒
- ✅ 中文界面支持
- ✅ SSH支持
- ✅ 基础网络功能

### x86_64版本 (软路由)
- ✅ 基础immortalwrt系统
- ✅ IPv6完整支持
- ✅ iStore - 应用商店
- ✅ MosDNS - 高性能DNS解析
- ✅ PassWall 2 - 科学上网工具
- ✅ ZeroTier - 内网穿透
- ✅ msd_lite - IPTV组播
- ✅ Argon 主题 - 现代美观界面

## ⚙️ 自定义配置

### 修改默认设置
编辑`scripts/diy-part2.sh`可以修改：
- 默认IP地址: 192.168.2.3
- 主机名: ImmortalWrt
- 时区设置: Asia/Shanghai (CST-8)
- 默认密码: 无 (首次登录后请设置密码)

### 添加/删除软件包
编辑对应的配置文件：
- `configs/n1-minimal.config` - N1精简版
- `configs/n1-bypass.config` - N1旁路由版本
- `configs/x86_64.config` - x86_64软路由版本

### 添加新的feeds源
编辑`scripts/diy-part1.sh`添加新的软件源。

### 💾 默认分区大小
- **x86_64**: 1024MB (1GB)
- **N1 旁路由版**: 512MB
- **N1 精简版**: 300MB

## 🔧 编译说明

本项目基于 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 源码仓库 (openwrt-24.10 分支)。

## 📖 安装说明

1. 下载编译好的固件（.img文件）
2. 使用balenaEtcher、Rufus等工具将固件写入U盘
3. 软路由从U盘启动
4. 默认登录信息：
   - 默认IP地址：192.168.2.3
   - 默认用户名：root
   - 默认密码：无

## ⚠️ 注意事项

1. x86_64 版本固件已移除晶晨宝盒（Amlogic）相关应用，仅保留在 N1 版本中。
2. 推荐使用 Argon 主题获得更好的视觉体验。

## 🔄 更新说明

固件支持在线升级：
1. 系统 → 晶晨宝盒 → 在线下载更新
2. 系统 → 晶晨宝盒 → 手动上传更新


## 📄 许可证

本项目遵循MIT许可证，详见LICENSE文件。

---

**免责声明**：本固件仅供学习交流使用，使用者需自行承担使用风险。 
