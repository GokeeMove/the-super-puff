# The Super Puff 库存检测工具

这是一个用于检测Aritzia网站上The Super Puff羽绒服库存的Python程序。

## 功能

- 检测指定商品的Size M库存状态
- 支持自动解析网页内容
- 提供详细的调试信息

## 系统要求

- Python 3.9+
- Google Chrome 浏览器
- ChromeDriver
- 支持系统：macOS、Linux (Debian/Ubuntu)

## 快速安装（推荐）

### Linux (Debian/Ubuntu/Debian sid)

```bash
# 下载项目后，运行自动安装脚本（root和普通用户都支持）
bash install_linux.sh

# 安装完成后运行
./run.sh
```

安装脚本会自动完成：
- ✅ 自动检测用户权限（root/普通用户）
- ✅ 安装Python和必要工具
- ✅ 安装Chrome浏览器
- ✅ 安装ChromeDriver
- ✅ 创建虚拟环境
- ✅ 安装Python依赖

**Root用户说明：** 脚本会自动检测root用户并跳过sudo命令，直接使用root权限安装。程序运行时也会自动添加root用户所需的Chrome安全配置。

## 手动安装

### 1. 创建Python虚拟环境

建议使用虚拟环境：

```bash
# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境 (macOS/Linux)
source venv/bin/activate
```

### 2. 安装Python依赖包

```bash
pip install -r requirements.txt
```

### 3. 安装Chrome和ChromeDriver

#### macOS (使用Homebrew)

```bash
# 安装ChromeDriver
brew install chromedriver
```

#### Linux (Debian/Ubuntu)

```bash
# 更新包列表
sudo apt update

# 安装Chrome浏览器
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# 安装ChromeDriver
sudo apt install chromium-chromedriver

# 或者手动安装最新版本
CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`
wget -N https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/local/bin/chromedriver
sudo chmod +x /usr/local/bin/chromedriver
```

#### 手动下载（所有系统）

1. 访问 https://chromedriver.chromium.org/downloads
2. 下载与你的Chrome版本匹配的ChromeDriver
3. 将chromedriver添加到系统PATH

## 使用方法

### 单次检测

```bash
# 确保虚拟环境已激活
source venv/bin/activate

# 运行单次检测
python3 check_stock.py

# 或使用快捷脚本
./run.sh
```

### 持续监控（每30分钟检测一次）

**方式1: 前台运行（推荐用于测试）**
```bash
# 前台运行，可以看到实时输出
./monitor.sh

# 或
python3 check_stock.py --loop

# 按 Ctrl+C 停止
```

**方式2: 后台运行（推荐用于长期监控）**
```bash
# 启动后台监控
bash monitor_background.sh

# 查看状态
bash status_monitor.sh

# 查看实时日志
tail -f monitor.log

# 停止监控
bash stop_monitor.sh
```

### 📱 微信推送（可选）

**有货时自动推送微信通知！**

1. **配置推送（推荐 Server酱，完全免费）**
   ```bash
   # 1. 访问 https://sct.ftqq.com/ 获取 SendKey
   # 2. 编辑配置文件
   vi notify_config.json
   
   # 填入你的密钥：
   {
     "method": "serverchan",
     "server_chan_key": "你的SendKey"
   }
   ```

2. **测试推送**
   ```bash
   python3 wechat_notify.py
   ```

3. **开始监控**
   ```bash
   bash monitor_background.sh
   ```

详细配置请查看: [微信推送配置指南](WECHAT_NOTIFY_SETUP.md)

程序会：
1. 启动Chrome浏览器（**无界面模式，后台运行**）
2. 访问The Super Puff商品页面
3. 等待页面加载完成
4. 自动点击"Select a Size"下拉框
5. 查找Size M的库存状态
6. 实时显示检测结果（有货/无货）

**示例输出：**
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
1 Left'

✅✅✅ Size M 有货! ✅✅✅
    (仅剩1件！)

检测完成!
============================================================
```

## 特点

- ✅ **无界面运行** - 后台模式，不显示浏览器窗口
- ✅ **快速检测** - 约10-15秒完成检测
- ✅ **自动化** - 全程无需人工干预
- ✅ **准确识别** - 精确定位Size M并判断库存（支持"1 Left"等状态）
- ✅ **简洁输出** - 清晰显示有货/无货状态
- ✅ **实时调试** - 显示读取到的完整库存文本

## 注意事项

- 程序使用Selenium模拟真实浏览器访问，可以绕过基本的反爬虫机制
- 无界面模式（headless）后台运行，不会显示浏览器窗口
- 建议不要频繁请求以避免IP被封禁
- 需要保持网络连接稳定

## 依赖

- selenium: 浏览器自动化工具
- ChromeDriver: Chrome浏览器驱动（需单独安装）

## 项目结构

```
the-super-puff/
├── check_stock.py          # 主程序（支持--loop参数，集成微信推送）
├── wechat_notify.py        # 微信推送模块
├── notify_config.json      # 微信推送配置文件
├── requirements.txt        # Python依赖
├── README.md              # 项目说明
├── 使用说明.md             # 使用说明（中文）
├── QUICKSTART.md          # 快速开始指南
├── WECHAT_NOTIFY_SETUP.md # 微信推送配置指南 📱
├── MONITOR_GUIDE.md       # 持续监控使用指南
├── INSTALL_LINUX.md       # Linux安装指南
├── TROUBLESHOOTING.md     # 故障排除指南
├── STOCK_STATUS_GUIDE.md  # 库存状态检测说明
├── CHANGELOG.md           # 更新日志
├── run.sh                 # 快速运行（单次检测）
├── monitor.sh             # 持续监控（前台）
├── monitor_background.sh  # 后台监控启动脚本
├── stop_monitor.sh        # 停止后台监控
├── status_monitor.sh      # 查看监控状态
├── install_linux.sh       # Linux自动安装脚本
├── install_chrome_only.sh # 绕过dpkg问题的安装
├── fix_chromedriver.sh    # ChromeDriver依赖修复
├── fix_dpkg.sh            # dpkg错误修复
├── force_fix_dpkg.sh      # 强制dpkg修复
├── test_env.sh            # 环境检测
├── test_detection.py      # 测试检测逻辑
└── venv/                  # Python虚拟环境
```

## 故障排除

遇到问题？查看详细的 [故障排除指南](TROUBLESHOOTING.md)

**快速修复命令：**
```bash
bash test_env.sh              # 检测环境
bash fix_chromedriver.sh      # 修复ChromeDriver依赖（状态码127错误）
bash fix_dpkg.sh              # 修复dpkg错误
```

## 更新日志

查看 [CHANGELOG.md](CHANGELOG.md) 了解版本更新历史。

## 许可证

本项目仅供学习和个人使用，请勿用于商业目的或频繁请求。
