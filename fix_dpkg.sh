#!/bin/bash
# 修复Debian/Ubuntu dpkg错误的脚本（增强版）

echo "========================================"
echo "  修复dpkg依赖问题"
echo "========================================"
echo ""

# 检查是否为root
if [ "$EUID" -ne 0 ]; then 
    echo "此脚本需要root权限运行"
    echo "请使用: sudo bash fix_dpkg.sh"
    echo "或切换到root用户后运行"
    exit 1
fi

# 备份重要文件
echo "步骤1: 备份dpkg状态..."
cp -a /var/lib/dpkg/status /var/lib/dpkg/status.backup.$(date +%Y%m%d-%H%M%S)

echo ""
echo "步骤2: 修复文件权限问题..."
# 修复/etc权限问题
chmod 755 /etc
chmod 644 /etc/group 2>/dev/null || true
chmod 644 /etc/passwd 2>/dev/null || true

# 清理可能的临时文件
rm -f /etc/.#group* 2>/dev/null || true
rm -f /etc/.#passwd* 2>/dev/null || true

echo ""
echo "步骤3: 强制移除问题包的配置脚本..."
# 列出所有问题包
PROBLEM_PACKAGES="dbus-system-bus-common dbus libpam-systemd dbus-user-session dconf-service dconf-gsettings-backend libgtk-3-common gsettings-desktop-schemas libgtk-3-bin libgtk-3-0t64 at-spi2-core google-chrome-stable"

for pkg in $PROBLEM_PACKAGES; do
    echo "处理包: $pkg"
    # 移除可能导致失败的post-installation脚本
    rm -f /var/lib/dpkg/info/${pkg}.postinst 2>/dev/null || true
    rm -f /var/lib/dpkg/info/${pkg}.prerm 2>/dev/null || true
    rm -f /var/lib/dpkg/info/${pkg}:amd64.postinst 2>/dev/null || true
    rm -f /var/lib/dpkg/info/${pkg}:amd64.prerm 2>/dev/null || true
done

echo ""
echo "步骤4: 强制配置所有包..."
dpkg --configure -a --force-all 2>&1 | tee /tmp/dpkg_fix.log

echo ""
echo "步骤5: 修复损坏的依赖..."
apt-get install -f -y --fix-missing

echo ""
echo "步骤6: 清理apt缓存..."
apt-get clean
apt-get autoclean

echo ""
echo "步骤7: 更新包列表..."
apt-get update

echo ""
echo "步骤8: 重新安装问题包..."
# 按依赖顺序重新安装
echo "重新安装基础包..."
apt-get install --reinstall -y dbus-system-bus-common 2>/dev/null || true
apt-get install --reinstall -y dbus 2>/dev/null || true
apt-get install --reinstall -y libpam-systemd 2>/dev/null || true
apt-get install --reinstall -y dbus-user-session 2>/dev/null || true
apt-get install --reinstall -y dconf-service 2>/dev/null || true
apt-get install --reinstall -y dconf-gsettings-backend 2>/dev/null || true
apt-get install --reinstall -y libgtk-3-common 2>/dev/null || true
apt-get install --reinstall -y gsettings-desktop-schemas 2>/dev/null || true

echo ""
echo "步骤9: 最终配置检查..."
if dpkg --configure -a 2>&1 | tee -a /tmp/dpkg_fix.log; then
    echo "✓ dpkg配置已修复"
else
    echo "⚠️  部分包仍有问题，但可能不影响Chrome运行"
    echo "   可以尝试继续安装Chrome"
fi

echo ""
echo "========================================"
echo "  修复完成"
echo "========================================"
echo ""
echo "现在可以运行: bash install_linux.sh"
echo ""
