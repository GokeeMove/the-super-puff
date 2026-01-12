# The Super Puff 库存检测工具

这是一个用于检测Aritzia网站上The Super Puff羽绒服库存的Python程序。

## 功能

- 检测指定商品的Size M库存状态
- 支持自动解析网页内容
- 提供详细的调试信息

## 安装

### 1. 创建Python虚拟环境

由于macOS的Python环境受系统保护，建议使用虚拟环境：

```bash
# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境
source venv/bin/activate
```

### 2. 安装Python依赖包

```bash
pip install -r requirements.txt
```

### 3. 安装ChromeDriver

程序使用Selenium和Chrome浏览器，需要安装ChromeDriver：

**macOS (使用Homebrew):**
```bash
brew install chromedriver
```

**或者手动下载:**
1. 访问 https://chromedriver.chromium.org/downloads
2. 下载与你的Chrome版本匹配的ChromeDriver
3. 将chromedriver添加到系统PATH

## 使用方法

运行程序：

```bash
# 确保虚拟环境已激活
source venv/bin/activate

# 运行程序
python check_stock.py
```

程序会：
1. 启动Chrome浏览器（**无界面模式，后台运行**）
2. 访问The Super Puff商品页面
3. 等待页面加载完成
4. 自动点击"Select a Size"下拉框
5. 查找Size M的库存状态
6. 显示检测结果（有货/无货）

**示例输出：**
```
============================================================
  The Super Puff 库存检测工具 - Size M
============================================================
使用无界面模式运行...
正在启动浏览器（后台模式）...
正在加载页面...
正在检测尺码...

❌ Size M 无货 (Sold Out Online)

检测完成!
============================================================
```

## 特点

- ✅ **无界面运行** - 后台模式，不显示浏览器窗口
- ✅ **快速检测** - 约15秒完成检测
- ✅ **自动化** - 全程无需人工干预
- ✅ **准确识别** - 精确定位Size M并判断库存
- ✅ **简洁输出** - 清晰显示有货/无货状态

## 注意事项

- 程序使用Selenium模拟真实浏览器访问，可以绕过基本的反爬虫机制
- 无界面模式（headless）后台运行，不会显示浏览器窗口
- 建议不要频繁请求以避免IP被封禁
- 需要保持网络连接稳定

## 依赖

- selenium: 浏览器自动化工具
- ChromeDriver: Chrome浏览器驱动（需单独安装）
