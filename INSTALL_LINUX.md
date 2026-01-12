# Linux安装指南

适用于 Debian、Ubuntu、Debian sid (forky) 等系统

## 方法一：自动安装（推荐）

```bash
# 1. 下载或克隆项目
cd the-super-puff

# 2. 运行自动安装脚本
bash install_linux.sh

# 3. 运行程序
./run.sh
```

就这么简单！安装脚本会自动完成所有配置。

## 方法二：手动安装

### 1. 安装系统依赖

```bash
# 更新包列表
sudo apt update

# 安装Python和工具
sudo apt install -y python3 python3-pip python3-venv wget unzip

# 安装Chrome浏览器
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```

### 2. 安装ChromeDriver

```bash
# 方法A: 使用apt（简单但版本可能较旧）
sudo apt install chromium-chromedriver

# 方法B: 手动下载最新版本（推荐）
DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE")
wget "https://chromedriver.storage.googleapis.com/${DRIVER_VERSION}/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip
mv chromedriver /usr/local/bin/
chmod +x /usr/local/bin/chromedriver
rm chromedriver_linux64.zip
```

### 3. 设置Python环境

```bash
# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境
source venv/bin/activate

# 安装Python依赖
pip install -r requirements.txt
```

### 4. 运行程序

```bash
# 方法A: 使用快捷脚本
./run.sh

# 方法B: 手动运行
source venv/bin/activate
python3 check_stock.py
```

## 无GUI服务器环境

如果在完全无图形界面的服务器上运行，需要安装额外依赖：

```bash
# 安装必要的库
sudo apt install -y \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libxss1 \
    libappindicator1 \
    libasound2 \
    xvfb

# 使用xvfb运行（如果需要）
xvfb-run python3 check_stock.py
```

## 常见问题

### Chrome启动失败

```bash
# 确保安装了所有依赖
sudo apt install -y \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libwayland-client0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils
```

### ChromeDriver版本不匹配

```bash
# 检查Chrome版本
google-chrome --version

# 检查ChromeDriver版本
chromedriver --version

# 如果不匹配，重新下载对应版本的ChromeDriver
# 访问: https://chromedriver.chromium.org/downloads
```

### 权限问题

```bash
# 确保脚本有执行权限
chmod +x run.sh install_linux.sh

# 确保虚拟环境可访问
chmod -R u+w venv/
```

## Debian sid (forky) 特别说明

Debian sid是Debian的不稳定版本，代码已针对该系统进行优化：

- ✅ 自动检测Linux系统
- ✅ 使用适合Linux的Chrome选项
- ✅ 包含所有必要的沙箱和GPU设置
- ✅ 无需任何额外配置

## 测试安装

运行以下命令测试安装是否成功：

```bash
# 检查Python
python3 --version

# 检查Chrome
google-chrome --version

# 检查ChromeDriver
chromedriver --version

# 运行检测程序
./run.sh
```

如果所有命令都正常执行，说明安装成功！
