#!/bin/bash
# 修复Debian/Ubuntu dpkg错误的脚本

echo "========================================"
echo "  修复dpkg/systemd错误"
echo "========================================"
echo ""

# 检查是否为root
if [ "$EUID" -ne 0 ]; then 
    echo "此脚本需要root权限运行"
    echo "请使用: sudo bash fix_dpkg.sh"
    echo "或切换到root用户后运行"
    exit 1
fi

echo "步骤1: 修复dpkg中断的配置..."
dpkg --configure -a 2>&1 | tee /tmp/dpkg_fix.log

echo ""
echo "步骤2: 修复损坏的包..."
apt-get install -f -y

echo ""
echo "步骤3: 清理apt缓存..."
apt-get clean
apt-get autoclean

echo ""
echo "步骤4: 更新包列表..."
apt-get update

echo ""
echo "步骤5: 尝试修复systemd..."
# 如果systemd有问题，尝试重新配置
if dpkg -l | grep -q "^iF.*systemd"; then
    echo "检测到systemd配置问题，尝试修复..."
    apt-get install --reinstall systemd -y
fi

echo ""
echo "步骤6: 再次检查dpkg状态..."
if dpkg --configure -a; then
    echo "✓ dpkg配置已修复"
else
    echo "⚠️  dpkg仍有问题，尝试高级修复..."
    
    # 高级修复：移除problem状态的包
    echo "步骤7: 移除问题包状态..."
    rm -f /var/lib/dpkg/info/systemd.postinst
    rm -f /var/lib/dpkg/info/systemd.prerm
    
    # 重新安装
    apt-get install --reinstall systemd -y
fi

echo ""
echo "========================================"
echo "  修复完成"
echo "========================================"
echo ""
echo "现在可以运行: bash install_linux.sh"
echo ""
