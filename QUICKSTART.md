# 快速开始指南

## 🚀 一键安装和运行（Linux）

```bash
# 1. 进入项目目录
cd the-super-puff

# 2. 安装（首次运行）
bash install_linux.sh

# 3. 运行检测
./run.sh
```

**就这么简单！** ⏱️ 整个过程约2-3分钟

---

## ⚠️ 遇到错误？

### dpkg依赖错误（最常见）
```bash
# 方案1: 常规修复
bash fix_dpkg.sh

# 方案2: 绕过dpkg问题（推荐！）
bash install_chrome_only.sh

# 方案3: 强制修复
bash force_fix_dpkg.sh
```

### ChromeDriver错误（状态码127）
```bash
bash fix_chromedriver.sh
```

### 检查环境
```bash
bash test_env.sh
```

---

## 📋 预期输出

成功运行后，你会看到：

**无货时：**
```
============================================================
  The Super Puff 库存检测工具 - Size M
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
```

**有货时：**
```
找到Size M，完整文本: 'M
1 Left'

✅✅✅ Size M 有货! ✅✅✅
    (仅剩1件！)
```

⏱️ 整个检测过程约10-15秒

---

## 🔧 系统要求

- ✅ Debian/Ubuntu/Debian sid
- ✅ Python 3.9+
- ✅ 网络连接
- ✅ Root或普通用户（都支持）

---

## 📚 详细文档

- [完整README](README.md) - 详细说明
- [Linux安装指南](INSTALL_LINUX.md) - 深入安装步骤
- [故障排除](TROUBLESHOOTING.md) - 问题解决方案
- [使用说明](使用说明.md) - 中文使用指南

---

## 🎯 常用命令

### 单次检测
```bash
./run.sh
```

### 持续监控（每30分钟）
```bash
# 前台运行（可看输出）
./monitor.sh

# 后台运行（推荐）
bash monitor_background.sh    # 启动
bash status_monitor.sh        # 查看状态
tail -f monitor.log           # 查看日志
bash stop_monitor.sh          # 停止
```

### 📱 微信推送
```bash
# 一键配置（推荐）
bash setup_wechat.sh

# 手动配置
vi notify_config.json         # 编辑配置
python3 wechat_notify.py      # 测试推送
```

详细说明: [WECHAT_NOTIFY_SETUP.md](WECHAT_NOTIFY_SETUP.md)

### 维护命令
```bash
bash test_env.sh              # 检查环境
bash fix_chromedriver.sh      # 修复ChromeDriver
bash fix_dpkg.sh              # 修复dpkg
bash install_linux.sh         # 重新安装
```

---

## 💡 小贴士

1. **首次运行**可能需要下载ChromeDriver，需要等待
2. **后台运行**不显示浏览器窗口
3. **约15秒**完成一次检测
4. **Root用户**无需sudo，自动适配
5. **截图保存**在当前目录，可供调试

---

## ❓ 获取帮助

遇到问题？按以下顺序操作：

1️⃣ 运行 `bash test_env.sh` 检查环境  
2️⃣ 查看 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)  
3️⃣ 运行对应的修复脚本  

---

**祝你使用愉快！** 🎉
