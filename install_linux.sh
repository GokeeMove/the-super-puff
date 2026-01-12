#!/bin/bash
# The Super Puff 库存检测工具 - Linux安装脚本
# 适用于 Debian/Ubuntu 系统

set -e

echo "========================================"
echo "  The Super Puff 库存检测工具"
echo "  Linux 安装脚本"
echo "========================================"
echo ""

# 检查是否为root用户
if [ "$EUID" -eq 0 ]; then 
    echo "⚠️  检测到root用户运行"
    echo "   将以root权限安装（跳过sudo）"
    SUDO_CMD=""
else
    SUDO_CMD="sudo"
fi

# 检查系统
if [ -f /etc/debian_version ]; then
    echo "✓ 检测到 Debian/Ubuntu 系统"
else
    echo "⚠️  此脚本仅支持 Debian/Ubuntu 系统"
    exit 1
fi

# 1. 更新系统包
echo ""
echo "步骤 1/5: 更新系统包列表..."
$SUDO_CMD apt update

# 2. 安装Python和必要工具
echo ""
echo "步骤 2/5: 安装Python和依赖..."
$SUDO_CMD apt install -y python3 python3-pip python3-venv wget unzip curl

# 2.1 安装Chrome/ChromeDriver所需的系统库
echo "安装Chrome运行所需的系统库..."
$SUDO_CMD apt install -y \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libxss1 \
    libappindicator1 \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libu2f-udev \
    libvulkan1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    fonts-liberation \
    2>/dev/null || echo "部分依赖包可能不可用，继续..."

# 3. 安装Chrome浏览器
echo ""
echo "步骤 3/5: 安装Chrome浏览器..."
if ! command -v google-chrome &> /dev/null; then
    echo "下载Chrome浏览器..."
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    $SUDO_CMD apt install -y /tmp/chrome.deb
    rm /tmp/chrome.deb
    echo "✓ Chrome安装完成"
else
    echo "✓ Chrome已安装"
fi

# 检查Chrome版本
CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+' | head -1)
echo "Chrome版本: $CHROME_VERSION"

# 4. 安装ChromeDriver
echo ""
echo "步骤 4/5: 安装ChromeDriver..."
if ! command -v chromedriver &> /dev/null; then
    # 先尝试apt安装
    if $SUDO_CMD apt install -y chromium-chromedriver 2>/dev/null; then
        echo "✓ ChromeDriver (通过apt安装)"
    else
        # 手动下载安装
        echo "通过官方源下载ChromeDriver..."
        DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE")
        echo "下载ChromeDriver版本: $DRIVER_VERSION"
        wget -q "https://chromedriver.storage.googleapis.com/${DRIVER_VERSION}/chromedriver_linux64.zip" -O /tmp/chromedriver.zip
        unzip -q /tmp/chromedriver.zip -d /tmp/
        $SUDO_CMD mv /tmp/chromedriver /usr/local/bin/
        $SUDO_CMD chmod +x /usr/local/bin/chromedriver
        rm /tmp/chromedriver.zip
        echo "✓ ChromeDriver安装完成"
    fi
else
    echo "✓ ChromeDriver已安装"
fi

# 5. 安装Python依赖
echo ""
echo "步骤 5/5: 设置Python环境..."
if [ ! -d "venv" ]; then
    echo "创建Python虚拟环境..."
    python3 -m venv venv
fi

echo "激活虚拟环境并安装依赖..."
source venv/bin/activate
pip install --upgrade pip -q
pip install -r requirements.txt -q

echo ""
echo "========================================"
echo "  ✅ 安装完成!"
echo "========================================"
echo ""
echo "运行方法:"
echo "  source venv/bin/activate"
echo "  python3 check_stock.py"
echo ""
echo "或者直接运行:"
echo "  ./run.sh"
echo ""
