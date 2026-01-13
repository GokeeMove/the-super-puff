#!/bin/bash
# 停止后台监控

if [ ! -f monitor.pid ]; then
    echo "⚠️  没有找到运行中的监控进程"
    exit 1
fi

PID=$(cat monitor.pid)

if ps -p $PID > /dev/null 2>&1; then
    echo "正在停止监控进程 (PID: $PID)..."
    kill $PID
    sleep 2
    
    # 如果还在运行，强制停止
    if ps -p $PID > /dev/null 2>&1; then
        echo "强制停止..."
        kill -9 $PID
    fi
    
    rm -f monitor.pid
    echo "✓ 监控已停止"
else
    echo "⚠️  进程已不存在"
    rm -f monitor.pid
fi
