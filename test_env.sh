#!/bin/bash
# 环境测试脚本 - 检查所有依赖是否正确安装

echo "========================================"
echo "  环境检测工具"
echo "========================================"
echo ""

# 检测用户
if [ "$EUID" -eq 0 ]; then 
    echo "✓ 当前用户: root"
else
    echo "✓ 当前用户: 普通用户 ($(whoami))"
fi
echo ""

# 检测系统
echo "检测操作系统..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "✓ 系统: $PRETTY_NAME"
else
    echo "⚠️  无法检测系统版本"
fi
echo ""

# 检测Python
echo "检测Python..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✓ $PYTHON_VERSION"
else
    echo "❌ Python3 未安装"
    echo "   运行: apt install python3"
fi
echo ""

# 检测pip
echo "检测pip..."
if command -v pip3 &> /dev/null || command -v pip &> /dev/null; then
    if command -v pip3 &> /dev/null; then
        PIP_VERSION=$(pip3 --version)
    else
        PIP_VERSION=$(pip --version)
    fi
    echo "✓ $PIP_VERSION"
else
    echo "❌ pip 未安装"
    echo "   运行: apt install python3-pip"
fi
echo ""

# 检测Chrome
echo "检测Chrome浏览器..."
if command -v google-chrome &> /dev/null; then
    CHROME_VERSION=$(google-chrome --version)
    echo "✓ $CHROME_VERSION"
else
    echo "❌ Chrome 未安装"
    echo "   运行: wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    echo "   然后: apt install ./google-chrome-stable_current_amd64.deb"
fi
echo ""

# 检测ChromeDriver
echo "检测ChromeDriver..."
if command -v chromedriver &> /dev/null; then
    DRIVER_VERSION=$(chromedriver --version)
    echo "✓ $DRIVER_VERSION"
else
    echo "❌ ChromeDriver 未安装"
    echo "   运行: apt install chromium-chromedriver"
fi
echo ""

# 检测虚拟环境
echo "检测Python虚拟环境..."
if [ -d "venv" ]; then
    echo "✓ 虚拟环境已创建: venv/"
    if [ -f "venv/bin/activate" ]; then
        echo "✓ 激活脚本存在"
    fi
else
    echo "⚠️  虚拟环境未创建"
    echo "   运行: python3 -m venv venv"
fi
echo ""

# 检测requirements
echo "检测依赖安装..."
if [ -f "requirements.txt" ]; then
    echo "✓ requirements.txt 存在"
    if [ -d "venv" ]; then
        source venv/bin/activate 2>/dev/null
        if python3 -c "import selenium" 2>/dev/null; then
            echo "✓ selenium 已安装"
        else
            echo "⚠️  selenium 未安装"
            echo "   激活虚拟环境后运行: pip install -r requirements.txt"
        fi
    fi
else
    echo "❌ requirements.txt 不存在"
fi
echo ""

# 总结
echo "========================================"
echo "  检测完成"
echo "========================================"
echo ""
echo "如果所有项都显示 ✓，说明环境配置正确"
echo "如果有 ❌ 或 ⚠️，请按提示操作"
echo ""
echo "快速安装: bash install_linux.sh"
echo "运行程序: ./run.sh"
echo ""
