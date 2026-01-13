# 微信推送配置指南

## 📱 功能说明

当检测到 Size M 有货时，自动发送微信推送通知！

支持三种推送方式：
1. **Server酱** (推荐，最简单)
2. **企业微信机器人**
3. **PushPlus**

---

## 🎯 方式1: Server酱 (推荐)

### 优点
- ✅ 完全免费
- ✅ 配置超简单
- ✅ 直接推送到微信
- ✅ 无需企业认证

### 配置步骤

#### 1. 获取 Server酱 密钥

访问: https://sct.ftqq.com/

1. 用GitHub账号登录
2. 微信扫码绑定
3. 复制你的 `SendKey`（类似：`SCT123456ABCDxxx`）

#### 2. 配置密钥

编辑 `notify_config.json`:

```json
{
  "method": "serverchan",
  "server_chan_key": "SCT123456ABCDxxx",
  "wecom_webhook": "",
  "pushplus_token": ""
}
```

将 `SCT123456ABCDxxx` 替换为你的实际密钥。

#### 3. 测试推送

```bash
cd /path/to/the-super-puff
source venv/bin/activate
python3 wechat_notify.py
```

成功会显示：
```
正在测试微信推送...
✅ 微信推送成功 (Server酱)
```

同时你的微信会收到测试消息！

---

## 🎯 方式2: 企业微信机器人

### 适用场景
- 有企业微信群
- 需要推送到多人

### 配置步骤

#### 1. 创建企业微信群机器人

1. 在企业微信中创建一个群聊
2. 群设置 → 群机器人 → 添加机器人
3. 复制 Webhook 地址（类似：`https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxx`）

#### 2. 配置 Webhook

编辑 `notify_config.json`:

```json
{
  "method": "wecom",
  "server_chan_key": "",
  "wecom_webhook": "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxx",
  "pushplus_token": ""
}
```

#### 3. 测试推送

```bash
python3 wechat_notify.py
```

群聊会收到机器人消息。

---

## 🎯 方式3: PushPlus

### 配置步骤

#### 1. 获取 Token

访问: http://www.pushplus.plus/

1. 微信扫码登录
2. 复制你的 Token

#### 2. 配置 Token

编辑 `notify_config.json`:

```json
{
  "method": "pushplus",
  "server_chan_key": "",
  "wecom_webhook": "",
  "pushplus_token": "YOUR_TOKEN_HERE"
}
```

#### 3. 测试推送

```bash
python3 wechat_notify.py
```

---

## 📝 完整使用流程

### 1. 配置推送

```bash
cd /path/to/the-super-puff
vi notify_config.json
# 填入你的密钥
```

### 2. 测试推送

```bash
source venv/bin/activate
python3 wechat_notify.py
```

看到 `✅ 微信推送成功` 即表示配置成功。

### 3. 开始监控

```bash
# 前台监控
./monitor.sh

# 或后台监控
bash monitor_background.sh
```

### 4. 等待通知

当检测到有货时，你会收到微信推送！

**推送内容示例：**
```
🎉 The Super Puff Size M 仅剩1件！

商品: The Super Puff Size M
状态: 仅剩1件
时间: 2026-01-13 14:30:00
链接: https://www.aritzia.com/intl/en/product/...

⚡ 请尽快购买！
```

---

## 🔧 禁用推送

如果暂时不需要推送，修改 `notify_config.json`:

```json
{
  "method": "none",
  "server_chan_key": "",
  "wecom_webhook": "",
  "pushplus_token": ""
}
```

或者删除/重命名 `notify_config.json` 文件。

---

## ❓ 常见问题

### Q1: 推送失败怎么办？

**检查步骤：**
```bash
# 1. 测试推送
python3 wechat_notify.py

# 2. 查看错误信息
# 常见错误：
# - 密钥错误: 检查 notify_config.json 是否正确
# - 网络错误: 检查服务器能否访问互联网
# - Token过期: 重新获取密钥
```

### Q2: 如何推送到多个微信号？

**Server酱：** 在 Server酱 网站上绑定多个接收人

**企业微信：** 将多人拉入同一个企业微信群

**PushPlus：** 购买高级版支持多人推送

### Q3: 推送频率太高怎么办？

修改监控间隔：

编辑 `check_stock.py`，找到：
```python
time.sleep(1800)  # 30分钟
```

改为：
```python
time.sleep(3600)  # 60分钟
```

### Q4: 只推送一次，不要重复推送？

在主程序中添加一个标志，检测到有货后就停止监控：

编辑 `check_stock.py`，在主循环部分添加：
```python
if stock_status == "有货":
    print("已发送通知，停止监控")
    break
```

### Q5: 收不到推送？

**Server酱：**
1. 检查微信是否已绑定
2. 检查 SendKey 是否正确
3. 查看 Server酱 网站的发送记录

**企业微信：**
1. 检查 Webhook 地址是否正确
2. 确认机器人没有被移除
3. 检查网络连接

---

## 🎨 推送消息示例

### 有货推送

```
标题: 🎉 The Super Puff Size M 仅剩1件！

内容:
**商品**: The Super Puff Size M
**状态**: 仅剩1件
**时间**: 2026-01-13 14:30:00
**链接**: https://www.aritzia.com/intl/en/product/...

⚡ 请尽快购买！
```

---

## 📊 推送方式对比

| 方式 | 难度 | 费用 | 推荐度 |
|------|------|------|--------|
| Server酱 | ⭐ | 免费 | ⭐⭐⭐⭐⭐ |
| 企业微信 | ⭐⭐ | 免费 | ⭐⭐⭐⭐ |
| PushPlus | ⭐ | 免费/付费 | ⭐⭐⭐ |

**推荐使用 Server酱**，配置最简单，完全免费！

---

## 🚀 快速开始（3步搞定）

```bash
# 1. 获取 Server酱 SendKey
# 访问 https://sct.ftqq.com/

# 2. 配置密钥
echo '{
  "method": "serverchan",
  "server_chan_key": "你的SendKey"
}' > notify_config.json

# 3. 测试推送
python3 wechat_notify.py
```

搞定！现在就可以开始监控了：
```bash
bash monitor_background.sh
```

有货时会自动推送到你的微信！🎉
