#!/bin/bash
# 查看监控状态

echo "========================================"
echo "  监控状态"
echo "========================================"
echo ""

if [ ! -f monitor.pid ]; then
    echo "❌ 监控未运行"
    echo ""
    echo "启动监控:"
    echo "  前台: bash monitor.sh"
    echo "  后台: bash monitor_background.sh"
    exit 0
fi

PID=$(cat monitor.pid)

if ps -p $PID > /dev/null 2>&1; then
    echo "✅ 监控正在运行"
    echo "   进程ID: $PID"
    echo "   启动时间: $(ps -p $PID -o lstart= 2>/dev/null || echo '未知')"
    echo ""
    
    if [ -f monitor.log ]; then
        LOG_SIZE=$(du -h monitor.log | cut -f1)
        LOG_LINES=$(wc -l < monitor.log)
        echo "   日志文件: monitor.log"
        echo "   日志大小: $LOG_SIZE"
        echo "   日志行数: $LOG_LINES"
        echo ""
        echo "最近5次检测结果:"
        echo "----------------------------------------"
        grep -E "第 [0-9]+ 次检测|Size M|✅|❌" monitor.log | tail -20
    fi
    
    echo ""
    echo "查看实时日志: tail -f monitor.log"
    echo "停止监控: bash stop_monitor.sh"
else
    echo "❌ 进程已停止 (PID: $PID 不存在)"
    rm -f monitor.pid
fi

echo ""
echo "========================================"
