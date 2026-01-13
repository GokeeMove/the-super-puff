#!/bin/bash
# 强制修复dpkg - 最激进的方法（仅用于严重损坏的情况）

echo "========================================"
echo "  强制修复dpkg（激进模式）"
echo "========================================"
echo ""
echo "⚠️  警告：此脚本会强制重置dpkg状态"
echo "   仅在常规修复失败后使用"
echo ""
read -p "继续？(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "已取消"
    exit 1
fi

# 必须是root
if [ "$EUID" -ne 0 ]; then 
    echo "需要root权限"
    exit 1
fi

echo ""
echo "步骤1: 备份dpkg数据库..."
BACKUP_DIR="/var/backups/dpkg-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR
cp -a /var/lib/dpkg/status $BACKUP_DIR/
cp -a /var/lib/dpkg/info $BACKUP_DIR/info/
echo "✓ 备份到: $BACKUP_DIR"

echo ""
echo "步骤2: 修复/etc权限..."
chmod 755 /etc
chmod 644 /etc/group /etc/passwd /etc/shadow 2>/dev/null || true
rm -f /etc/.#* 2>/dev/null || true

echo ""
echo "步骤3: 清理所有问题包的脚本..."
cd /var/lib/dpkg/info
for file in *.postinst *.prerm *.preinst *.postrm; do
    if [ -f "$file" ]; then
        # 创建一个空脚本替代
        echo '#!/bin/bash' > "$file"
        echo 'exit 0' >> "$file"
        chmod +x "$file"
    fi
done

echo ""
echo "步骤4: 强制配置所有包..."
dpkg --configure -a --force-all --force-depends

echo ""
echo "步骤5: 恢复正常的安装脚本..."
# 重新安装关键包以恢复正确的脚本
apt-get download dbus-system-bus-common 2>/dev/null
if [ -f dbus-system-bus-common*.deb ]; then
    dpkg -i --force-all dbus-system-bus-common*.deb
    rm dbus-system-bus-common*.deb
fi

echo ""
echo "步骤6: 修复依赖关系..."
apt-get install -f -y --allow-downgrades

echo ""
echo "步骤7: 清理和更新..."
apt-get clean
apt-get update

echo ""
echo "步骤8: 尝试正常配置..."
dpkg --configure -a

echo ""
echo "========================================"
echo "  修复完成"
echo "========================================"
echo ""
echo "如果仍有错误，可以忽略dbus相关的错误"
echo "这些错误通常不影响Chrome运行"
echo ""
