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

### ChromeDriver错误（状态码127）
```bash
bash fix_chromedriver.sh
```

### dpkg/systemd错误
```bash
bash fix_dpkg.sh
```

### 检查环境
```bash
bash test_env.sh
```

---

## 📋 预期输出

成功运行后，你会看到：

```
============================================================
  The Super Puff 库存检测工具 - Size M
============================================================
检测到操作系统: Linux
使用无界面模式运行...
正在启动浏览器（后台模式）...
正在加载页面...
正在检测尺码...

❌ Size M 无货 (Sold Out Online)

检测完成!
============================================================
```

⏱️ 整个检测过程约15秒

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

```bash
# 运行程序
./run.sh

# 检查环境
bash test_env.sh

# 修复ChromeDriver
bash fix_chromedriver.sh

# 修复dpkg
bash fix_dpkg.sh

# 重新安装
bash install_linux.sh
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
