# 完整使用示例

## 场景1: 快速开始（不配置微信推送）

```bash
# 1. 安装
bash install_linux.sh

# 2. 运行单次检测
./run.sh

# 3. 启动持续监控
bash monitor_background.sh

# 4. 查看状态
bash status_monitor.sh
```

---

## 场景2: 配置微信推送后使用（推荐）

### 第一步：安装程序

```bash
cd /path/to/the-super-puff
bash install_linux.sh
```

等待安装完成...

### 第二步：配置微信推送

**使用一键配置脚本：**

```bash
bash setup_wechat.sh
```

按照提示操作：
```
支持的推送方式：
1. Server酱 (推荐，最简单)
2. 企业微信机器人
3. PushPlus
4. 不使用推送

请选择推送方式 (1-4): 1

📱 配置 Server酱
----------------------------------------
1. 访问: https://sct.ftqq.com/
2. 用GitHub账号登录
3. 微信扫码绑定
4. 复制你的 SendKey

请输入你的 SendKey: SCT123456ABCxxx

✅ Server酱 配置成功！

正在测试推送...
✅ 微信推送成功 (Server酱)
```

此时你的微信会收到测试消息！

**或手动配置：**

```bash
# 编辑配置文件
vi notify_config.json

# 填入：
{
  "method": "serverchan",
  "server_chan_key": "你的SendKey"
}

# 测试推送
python3 wechat_notify.py
```

### 第三步：启动监控

```bash
# 后台启动
bash monitor_background.sh
```

输出：
```
启动后台监控...
日志文件: monitor.log

✓ 监控已启动 (PID: 12345)

查看实时日志: tail -f monitor.log
停止监控: bash stop_monitor.sh
查看状态: bash status_monitor.sh
```

### 第四步：查看状态

```bash
bash status_monitor.sh
```

输出：
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
  ❌ Size M 无货 (Sold Out Online)
----------------------------------------
```

### 第五步：等待有货通知

当检测到有货时，你会收到微信推送：

**微信消息：**
```
🎉 The Super Puff Size M 仅剩1件！

商品: The Super Puff Size M
状态: 仅剩1件
时间: 2026-01-13 14:30:00
链接: https://www.aritzia.com/intl/en/product/...

⚡ 请尽快购买！
```

**同时终端日志：**
```
============================================================
  第 15 次检测 - 2026-01-13 21:30:00
============================================================
检测到操作系统: Linux
使用无界面模式运行...
正在启动浏览器（后台模式）...
正在加载页面...
正在检测尺码...

找到Size M，完整文本: 'M
1 Left'

✅✅✅ Size M 有货! ✅✅✅
    (仅剩1件！)
正在发送微信推送...
✅ 微信推送成功 (Server酱)

检测完成!
============================================================
```

### 第六步：停止监控

```bash
bash stop_monitor.sh
```

---

## 场景3: 前台运行查看详细输出

适合测试或调试：

```bash
./monitor.sh
```

实时输出：
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

[等待中...]
```

按 `Ctrl+C` 停止：
```
已停止监控
总共检测了 1 次
```

---

## 场景4: 查看实时日志

后台运行时查看日志：

```bash
tail -f monitor.log
```

输出：
```
============================================================
  第 10 次检测 - 2026-01-13 19:30:00
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
============================================================
```

按 `Ctrl+C` 退出日志查看（监控继续运行）。

---

## 场景5: 禁用微信推送

如果暂时不需要推送：

```bash
# 方法1: 修改配置
vi notify_config.json
# 将 "method" 改为 "none"

# 方法2: 删除配置文件
rm notify_config.json

# 方法3: 使用配置脚本
bash setup_wechat.sh
# 选择 "4. 不使用推送"
```

---

## 场景6: 更换推送方式

从Server酱切换到企业微信：

```bash
# 使用配置脚本
bash setup_wechat.sh

# 选择 "2. 企业微信机器人"
# 输入 Webhook 地址

# 测试推送
python3 wechat_notify.py
```

---

## 场景7: 修改监控间隔

默认30分钟，改为10分钟：

```bash
# 编辑主程序
vi check_stock.py

# 找到这一行（约第308行）：
time.sleep(1800)  # 30分钟

# 改为：
time.sleep(600)   # 10分钟

# 重启监控
bash stop_monitor.sh
bash monitor_background.sh
```

---

## 场景8: 故障排除

### 问题1: ChromeDriver启动失败

```bash
bash fix_chromedriver.sh
```

### 问题2: dpkg错误

```bash
bash fix_dpkg.sh
```

### 问题3: 微信推送失败

```bash
# 测试推送
python3 wechat_notify.py

# 查看错误信息
# 常见问题：
# - SendKey错误：重新配置
# - 网络错误：检查网络连接
```

### 问题4: 查看完整错误日志

```bash
# 前台运行查看详细错误
./monitor.sh

# 或查看日志
tail -100 monitor.log
```

---

## 常用命令速查

```bash
# 安装
bash install_linux.sh

# 单次检测
./run.sh

# 配置微信
bash setup_wechat.sh

# 测试推送
python3 wechat_notify.py

# 启动监控
bash monitor_background.sh     # 后台
./monitor.sh                   # 前台

# 管理监控
bash status_monitor.sh         # 查看状态
bash stop_monitor.sh           # 停止
tail -f monitor.log            # 查看日志

# 故障修复
bash test_env.sh               # 检查环境
bash fix_chromedriver.sh       # 修复ChromeDriver
bash fix_dpkg.sh               # 修复dpkg

# 测试
python3 test_detection.py      # 测试检测逻辑
```

---

## 最佳实践

1. **首次使用**：先单次检测测试 (`./run.sh`)
2. **配置推送**：使用一键配置脚本 (`bash setup_wechat.sh`)
3. **测试推送**：确认能收到微信消息
4. **前台测试**：先前台运行几次 (`./monitor.sh`)
5. **后台监控**：确认无误后后台运行 (`bash monitor_background.sh`)
6. **定期查看**：定期查看状态 (`bash status_monitor.sh`)
7. **收到通知**：立即打开网页购买！

---

## 提示

- 💡 建议监控间隔不要少于10分钟
- 💡 后台运行可以关闭终端
- 💡 日志文件会持续增长，定期清理
- 💡 Server酱推送最简单，推荐使用
- 💡 有货时库存可能很快售罄，收到通知立即购买
