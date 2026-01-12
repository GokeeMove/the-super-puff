#!/bin/bash
# 修复ChromeDriver缺少依赖库的问题

echo "========================================"
echo "  修复ChromeDriver依赖问题"
echo "========================================"
echo ""

# 检查是否为root或有sudo权限
if [ "$EUID" -eq 0 ]; then 
    SUDO_CMD=""
    echo "当前用户: root"
else
    SUDO_CMD="sudo"
    echo "当前用户: $(whoami)"
fi

echo ""
echo "步骤1: 更新包列表..."
$SUDO_CMD apt update

echo ""
echo "步骤2: 安装Chrome/ChromeDriver所需的所有依赖库..."
echo "这可能需要几分钟时间..."

# 安装所有可能需要的依赖
$SUDO_CMD apt install -y \
    libnss3 \
    libnss3-dev \
    libgconf-2-4 \
    libfontconfig1 \
    libxss1 \
    libappindicator1 \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
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
    libglib2.0-0 \
    libnss3 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    ca-certificates \
    2>&1 | grep -v "already the newest version"

echo ""
echo "步骤3: 检查Chrome是否安装..."
if command -v google-chrome &> /dev/null; then
    CHROME_VERSION=$(google-chrome --version)
    echo "✓ $CHROME_VERSION"
else
    echo "⚠️  Chrome未安装，正在安装..."
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    $SUDO_CMD apt install -y /tmp/chrome.deb
    rm /tmp/chrome.deb
fi

echo ""
echo "步骤4: 清理Selenium缓存的ChromeDriver..."
if [ -d "/root/.cache/selenium/chromedriver" ]; then
    echo "清理root用户的Selenium缓存..."
    rm -rf /root/.cache/selenium/chromedriver
    echo "✓ 已清理"
fi

if [ -d "$HOME/.cache/selenium/chromedriver" ]; then
    echo "清理当前用户的Selenium缓存..."
    rm -rf $HOME/.cache/selenium/chromedriver
    echo "✓ 已清理"
fi

echo ""
echo "步骤5: 测试ChromeDriver..."
if command -v chromedriver &> /dev/null; then
    echo "系统ChromeDriver版本:"
    chromedriver --version
fi

echo ""
echo "步骤6: 检查ldd依赖..."
# 查找chromedriver位置
CHROMEDRIVER_PATH=$(which chromedriver 2>/dev/null)
if [ -n "$CHROMEDRIVER_PATH" ]; then
    echo "ChromeDriver路径: $CHROMEDRIVER_PATH"
    echo "检查依赖库..."
    if ldd $CHROMEDRIVER_PATH | grep "not found"; then
        echo "❌ 发现缺少的依赖库"
        echo "请手动检查并安装缺少的库"
    else
        echo "✓ 所有依赖库都已满足"
    fi
fi

echo ""
echo "========================================"
echo "  修复完成"
echo "========================================"
echo ""
echo "Selenium会在首次运行时自动下载匹配的ChromeDriver"
echo "现在可以尝试运行: ./run.sh"
echo ""
