#!/bin/bash
# 持续监控The Super Puff库存
# 每30分钟检测一次

# 切换到脚本所在目录
cd "$(dirname "$0")"

# 检查虚拟环境
if [ ! -d "venv" ]; then
    echo "⚠️  虚拟环境不存在，请先运行 install_linux.sh"
    exit 1
fi

# 激活虚拟环境
source venv/bin/activate

# 运行持续监控
python3 check_stock.py --loop
