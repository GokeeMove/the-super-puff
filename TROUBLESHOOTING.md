# 故障排除指南

## 快速诊断

遇到问题？按照以下步骤操作：

### 1️⃣ 运行环境检测
```bash
bash test_env.sh
```
这会检查所有依赖是否正确安装。

### 2️⃣ 根据错误类型选择修复脚本

| 错误类型 | 修复命令 |
|---------|---------|
| ChromeDriver错误(127) | `bash fix_chromedriver.sh` |
| dpkg/systemd错误 | `bash fix_dpkg.sh` |
| 依赖缺失 | `bash install_linux.sh` |

---

## 常见错误及解决方案

### ❌ 错误1: ChromeDriver状态码127

**完整错误信息：**
```
Service /root/.cache/selenium/chromedriver/linux64/143.0.7499.192/chromedriver 
unexpectedly exited. Status code was: 127
```

**原因：** ChromeDriver缺少系统依赖库

**解决方案：**
```bash
# 方法1: 自动修复（推荐）
bash fix_chromedriver.sh

# 方法2: 手动安装依赖
apt install -y \
    libnss3 libgconf-2-4 libfontconfig1 libxss1 \
    libappindicator1 libasound2 libatk-bridge2.0-0 \
    libatk1.0-0 libcups2 libdbus-1-3 libdrm2 \
    libgbm1 libgtk-3-0 libnspr4 libxcomposite1 \
    libxdamage1 libxfixes3 libxkbcommon0 libxrandr2

# 清理Selenium缓存
rm -rf ~/.cache/selenium/chromedriver
rm -rf /root/.cache/selenium/chromedriver
```

---

### ❌ 错误2: dpkg依赖链错误

**错误信息：**
```
Failed to copy permissions from /etc/group to /etc/.#group...
dpkg: error processing package dbus-system-bus-common (--configure)
dpkg: dependency problems prevent configuration of dbus...
Error: Sub-process /usr/bin/dpkg returned an error code (1)
```

**原因：** Debian包管理系统依赖链断裂（常见于Debian sid/unstable）

**解决方案（按顺序尝试）：**

**方案1: 常规修复**
```bash
bash fix_dpkg.sh
```

**方案2: 强制修复（如果方案1失败）**
```bash
bash force_fix_dpkg.sh
```

**方案3: 绕过dpkg问题，直接安装Chrome（推荐）**
```bash
# 这个方法会忽略dpkg错误，直接安装必要组件
bash install_chrome_only.sh
```

**方案4: 手动修复**
```bash
# 修复权限
chmod 755 /etc
chmod 644 /etc/group /etc/passwd
rm -f /etc/.#*

# 强制配置
dpkg --configure -a --force-all

# 修复依赖
apt-get install -f -y
```

**重要提示：**
- dpkg的dbus错误通常不影响Chrome运行
- 可以忽略这些错误，直接运行程序
- 使用 `install_chrome_only.sh` 可以绕过所有dpkg问题

---

### ❌ 错误3: Chrome无法启动

**错误信息：**
```
Chrome failed to start
```

**解决方案：**
```bash
# 检查Chrome是否安装
google-chrome --version

# 如果未安装
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb

# 检查依赖
bash fix_chromedriver.sh
```

---

### ❌ 错误4: 403 Forbidden

**错误信息：**
```
403 Client Error: Forbidden
```

**原因：** 网站反爬虫机制

**解决方案：**
- 这是正常现象，程序使用Selenium来绕过
- 确保使用headless模式（代码中已配置）
- 等待几分钟后重试
- 检查网络连接

---

### ❌ 错误5: 虚拟环境问题

**错误信息：**
```
No module named 'selenium'
```

**解决方案：**
```bash
# 确保激活虚拟环境
source venv/bin/activate

# 重新安装依赖
pip install -r requirements.txt

# 如果虚拟环境损坏，重建
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

### ❌ 错误6: Root用户Chrome错误

**错误信息：**
```
Running as root without --no-sandbox is not supported
```

**解决方案：**
程序已经自动添加`--no-sandbox`参数，如果仍有问题：

```bash
# 检查代码是否最新
grep "no-sandbox" check_stock.py

# 应该看到：
# chrome_options.add_argument('--no-sandbox')
```

---

### ❌ 错误7: 端口占用

**错误信息：**
```
Address already in use
```

**解决方案：**
```bash
# 查找并杀死僵尸Chrome进程
ps aux | grep chrome
kill -9 <进程ID>

# 或批量清理
pkill -f chrome
pkill -f chromedriver
```

---

## 系统特定问题

### Debian sid (forky/trixie)

Debian sid是滚动更新的不稳定版本，可能遇到：

**问题：** 包依赖冲突
```bash
# 解决方案
apt --fix-broken install
apt update && apt upgrade
```

**问题：** Python版本过新
```bash
# 检查Python版本
python3 --version

# 如果是3.13+，某些包可能不兼容
# 使用虚拟环境隔离
python3 -m venv venv
```

---

## 调试技巧

### 1. 查看详细错误
```bash
# 运行程序时显示完整错误
python3 check_stock.py 2>&1 | tee error.log
```

### 2. 测试Chrome
```bash
# 测试Chrome是否能启动
google-chrome --headless --disable-gpu --dump-dom https://www.google.com
```

### 3. 测试ChromeDriver
```bash
# 检查ChromeDriver版本
chromedriver --version

# 检查依赖
ldd $(which chromedriver) | grep "not found"
```

### 4. 检查网络
```bash
# 测试能否访问目标网站
curl -I https://www.aritzia.com
```

---

## 获取帮助

如果以上方法都无法解决问题：

1. **收集信息：**
```bash
# 运行环境检测
bash test_env.sh > system_info.txt

# 收集错误日志
python3 check_stock.py 2>&1 | tee error.log

# 系统信息
cat /etc/os-release >> system_info.txt
python3 --version >> system_info.txt
google-chrome --version >> system_info.txt
```

2. **尝试完全重装：**
```bash
# 清理所有缓存
rm -rf venv
rm -rf ~/.cache/selenium
rm -rf /root/.cache/selenium

# 重新安装
bash install_linux.sh
```

3. **使用Docker（终极方案）：**
如果在宿主机上持续出现问题，考虑使用Docker容器：
```bash
# TODO: 后续可以提供Dockerfile
```

---

## 预防措施

### 定期维护
```bash
# 每周更新系统
apt update && apt upgrade

# 清理不需要的包
apt autoremove
apt autoclean
```

### 备份工作环境
```bash
# 如果环境配置成功，可以导出依赖
pip freeze > requirements_working.txt
```

---

## 快速命令参考

```bash
# 完整重装流程
bash fix_dpkg.sh           # 修复dpkg
bash fix_chromedriver.sh   # 修复依赖
bash install_linux.sh      # 安装程序
./run.sh                   # 运行程序

# 诊断命令
bash test_env.sh           # 环境检测
google-chrome --version    # Chrome版本
chromedriver --version     # Driver版本
python3 --version          # Python版本

# 清理命令
rm -rf venv                # 删除虚拟环境
rm -rf ~/.cache/selenium   # 清理缓存
pkill -f chrome            # 杀死Chrome进程
```
