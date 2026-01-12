#!/bin/bash
# 运行 The Super Puff 库存检测工具

# 切换到脚本所在目录
cd "$(dirname "$0")"

# 检查虚拟环境
if [ ! -d "venv" ]; then
    echo "⚠️  虚拟环境不存在，请先运行安装脚本"
    echo ""
    if [ -f "install_linux.sh" ]; then
        echo "Linux系统运行: bash install_linux.sh"
    fi
    echo "或手动创建: python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

# 激活虚拟环境
source venv/bin/activate

# 运行程序
python3 check_stock.py
