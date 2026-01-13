# 持续监控使用指南

## 功能说明

程序支持持续监控模式，每30分钟自动检测一次Size M的库存状态。

## 使用方式

### 方式1: 前台监控（推荐用于测试）

```bash
./monitor.sh
```

或

```bash
python3 check_stock.py --loop
```

**特点：**
- ✅ 实时显示检测结果
- ✅ 可以看到详细输出
- ✅ 按 Ctrl+C 随时停止
- ❌ 关闭终端会停止监控

**输出示例：**
```
============================================================
  The Super Puff 持续监控模式
  每30分钟检测一次
  按 Ctrl+C 停止
============================================================

============================================================
  第 1 次检测 - 2026-01-13 14:30:00
============================================================
检测到操作系统: Linux
使用无界面模式运行...
正在启动浏览器（后台模式）...
正在加载页面...
正在检测尺码...

找到Size M，完整文本: 'M
Sold Out Online'

❌ Size M 无货 (Sold Out Online)

检测完成!

============================================================
  等待30分钟后进行下次检测...
  (按 Ctrl+C 可随时停止)
============================================================
```

---

### 方式2: 后台监控（推荐用于长期运行）

#### 启动后台监控

```bash
bash monitor_background.sh
```

**输出：**
```
启动后台监控...
日志文件: monitor.log

✓ 监控已启动 (PID: 12345)

查看实时日志: tail -f monitor.log
停止监控: bash stop_monitor.sh
查看状态: bash status_monitor.sh
```

#### 查看监控状态

```bash
bash status_monitor.sh
```

**输出示例：**
```
========================================
  监控状态
========================================

✅ 监控正在运行
   进程ID: 12345
   启动时间: Mon Jan 13 14:30:00 2026

   日志文件: monitor.log
   日志大小: 24K
   日志行数: 156

最近5次检测结果:
----------------------------------------
  第 5 次检测 - 2026-01-13 16:30:00
  找到Size M，完整文本: 'M
  Sold Out Online'
  ❌ Size M 无货 (Sold Out Online)
----------------------------------------

查看实时日志: tail -f monitor.log
停止监控: bash stop_monitor.sh

========================================
```

#### 查看实时日志

```bash
tail -f monitor.log
```

按 Ctrl+C 退出日志查看（不会停止监控）

#### 停止后台监控

```bash
bash stop_monitor.sh
```

**输出：**
```
正在停止监控进程 (PID: 12345)...
✓ 监控已停止
```

---

## 监控间隔

默认每30分钟检测一次。如需修改间隔：

### 临时修改（单次运行）

编辑 `check_stock.py` 第308行左右：

```python
# 等待30分钟 (1800秒)
time.sleep(1800)
```

修改为其他值：
- 10分钟：`time.sleep(600)`
- 15分钟：`time.sleep(900)`
- 1小时：`time.sleep(3600)`

### 创建自定义间隔脚本

```bash
#!/bin/bash
# monitor_10min.sh - 每10分钟检测一次

cd "$(dirname "$0")"
source venv/bin/activate

while true; do
    python3 check_stock.py
    echo "等待10分钟..."
    sleep 600
done
```

---

## 最佳实践

### 1. 测试阶段

使用前台模式，确保一切正常：

```bash
# 前台运行，观察几次检测
./monitor.sh

# 看到正常运行后按 Ctrl+C 停止
```

### 2. 长期监控

确认无误后，使用后台模式：

```bash
# 启动后台监控
bash monitor_background.sh

# 定期查看状态
bash status_monitor.sh
```

### 3. 日志管理

日志文件会持续增长，建议定期清理：

```bash
# 查看日志大小
du -h monitor.log

# 保存旧日志
mv monitor.log monitor.log.old

# 或清空日志
> monitor.log
```

### 4. 系统重启后自动运行

如需开机自动运行，可以使用 cron 或 systemd：

**使用 cron:**
```bash
# 编辑 crontab
crontab -e

# 添加这一行（开机后启动）
@reboot cd /path/to/the-super-puff && bash monitor_background.sh
```

---

## 注意事项

### ⚠️ 不要过于频繁

- 建议最短间隔：10分钟
- 推荐间隔：30分钟
- 过于频繁可能导致IP被封

### ⚠️ 后台运行占用资源

每次检测会：
- 启动Chrome浏览器
- 占用约200-300MB内存
- 运行10-15秒

确保服务器有足够资源。

### ⚠️ 网络稳定性

如果网络不稳定，可能导致检测失败。程序会自动处理错误并继续下次检测。

---

## 故障排除

### 问题1: 后台监控启动失败

```bash
# 检查是否已在运行
bash status_monitor.sh

# 如果卡住，强制停止
ps aux | grep check_stock
kill -9 <PID>
rm -f monitor.pid
```

### 问题2: 日志不更新

```bash
# 检查进程是否还在
bash status_monitor.sh

# 重启监控
bash stop_monitor.sh
bash monitor_background.sh
```

### 问题3: 内存不足

```bash
# 查看内存使用
free -h

# 如果内存不足，增加检测间隔或使用单次检测
```

---

## 快速命令参考

```bash
# 单次检测
./run.sh

# 前台监控
./monitor.sh

# 后台监控
bash monitor_background.sh      # 启动
bash status_monitor.sh          # 查看状态
tail -f monitor.log             # 查看日志
bash stop_monitor.sh            # 停止

# 检查进程
ps aux | grep check_stock
```

---

## 监控输出说明

### 有货提醒

```
✅✅✅ Size M 有货! ✅✅✅
    (仅剩1件！)
```

### 无货提示

```
❌ Size M 无货 (Sold Out Online)
```

当看到有货提醒时，需要尽快前往购买！

---

## 高级用法

### 发送通知（可选）

如果想在有货时收到通知，可以修改代码添加通知功能：

```python
# 在 check_stock.py 中添加
if stock_status == "有货":
    # 发送邮件、短信或其他通知
    print("🔔 发送通知: Size M 有货!")
```

具体通知方式可以使用：
- Email（使用Python的smtplib）
- Telegram Bot
- 微信通知
- 系统通知等
