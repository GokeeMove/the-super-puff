#!/bin/bash
# 在后台持续监控The Super Puff库存
# 日志保存到 monitor.log

# 切换到脚本所在目录
cd "$(dirname "$0")"

# 检查是否已在运行
if [ -f monitor.pid ]; then
    PID=$(cat monitor.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo "⚠️  监控程序已在运行 (PID: $PID)"
        echo "   查看日志: tail -f monitor.log"
        echo "   停止监控: bash stop_monitor.sh"
        exit 1
    fi
fi

# 检查虚拟环境
if [ ! -d "venv" ]; then
    echo "⚠️  虚拟环境不存在，请先运行 install_linux.sh"
    exit 1
fi

echo "启动后台监控..."
echo "日志文件: monitor.log"
echo ""

# 激活虚拟环境并在后台运行
nohup bash -c "source venv/bin/activate && python3 check_stock.py --loop" > monitor.log 2>&1 &

# 保存进程ID
echo $! > monitor.pid

echo "✓ 监控已启动 (PID: $!)"
echo ""
echo "查看实时日志: tail -f monitor.log"
echo "停止监控: bash stop_monitor.sh"
echo "查看状态: bash status_monitor.sh"
echo ""
