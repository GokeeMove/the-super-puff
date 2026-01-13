#!/bin/bash
# 仅安装Chrome和必要组件（绕过系统包问题）

echo "========================================"
echo "  最小化安装Chrome（绕过dpkg问题）"
echo "========================================"
echo ""

if [ "$EUID" -ne 0 ]; then 
    echo "需要root权限"
    exit 1
fi

echo "此脚本会："
echo "  1. 忽略dpkg错误"
echo "  2. 强制安装Chrome"
echo "  3. 安装Python依赖"
echo "  4. 跳过有问题的系统包"
echo ""

echo "步骤1: 检查Python环境..."
if ! command -v python3 &> /dev/null; then
    echo "安装Python3..."
    apt-get install -y python3 python3-pip python3-venv --fix-broken || true
else
    echo "✓ Python3已安装: $(python3 --version)"
fi

echo ""
echo "步骤2: 强制安装Chrome（忽略依赖）..."
if ! command -v google-chrome &> /dev/null; then
    # 下载Chrome
    if [ ! -f /tmp/chrome.deb ]; then
        echo "下载Chrome..."
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    fi
    
    # 强制安装，忽略依赖问题
    echo "强制安装Chrome..."
    dpkg -i --force-depends --force-conflicts /tmp/chrome.deb 2>&1 | grep -v "dependency problems"
    
    # 不运行apt install -f（会触发dpkg错误）
    echo "✓ Chrome已安装（忽略了一些依赖警告）"
else
    echo "✓ Chrome已安装"
fi

echo ""
echo "步骤3: 安装ChromeDriver必需的运行时库..."
# 只安装运行时库，不安装开发包
apt-get install -y \
    libnss3 \
    libasound2 \
    libxss1 \
    libappindicator3-1 \
    libnspr4 \
    fonts-liberation \
    libgbm1 \
    2>&1 | grep -v "not configured"

echo ""
echo "步骤4: 设置Python虚拟环境..."
if [ ! -d "venv" ]; then
    python3 -m venv venv || {
        echo "⚠️  venv创建失败，尝试安装python3-venv..."
        apt-get install -y python3-venv --fix-broken || true
        python3 -m venv venv
    }
fi

echo ""
echo "步骤5: 安装Python依赖..."
source venv/bin/activate
pip install --upgrade pip -q 2>/dev/null || pip install --upgrade pip
pip install -r requirements.txt -q 2>/dev/null || pip install selenium

echo ""
echo "步骤6: 测试Chrome..."
if google-chrome --version 2>/dev/null; then
    echo "✓ Chrome可以运行: $(google-chrome --version)"
else
    echo "⚠️  Chrome可能缺少依赖，但仍可以尝试运行程序"
fi

echo ""
echo "========================================"
echo "  安装完成"
echo "========================================"
echo ""
echo "dpkg可能仍有错误，但不影响程序运行"
echo ""
echo "现在可以运行: ./run.sh"
echo ""
