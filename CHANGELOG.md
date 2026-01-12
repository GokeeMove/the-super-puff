# 更新日志

## v2.0 - 2026-01-12

### 🎯 跨平台支持

**新增功能：**
- ✅ 支持Linux系统（Debian、Ubuntu、Debian sid等）
- ✅ 自动检测操作系统并应用对应配置
- ✅ Linux专用Chrome选项优化
- ✅ 跨平台User-Agent自动适配

**代码改进：**
- 添加 `platform.system()` 检测
- 针对Linux添加必要的Chrome参数：
  - `--single-process` - 单进程模式
  - `--disable-setuid-sandbox` - 沙箱设置
  - `--disable-software-rasterizer` - 禁用软件光栅化
- 根据系统自动设置User-Agent

**新增文件：**
- `install_linux.sh` - Linux自动安装脚本
- `run.sh` - 快速运行脚本
- `INSTALL_LINUX.md` - Linux详细安装指南

**文档更新：**
- README添加Linux安装说明
- 使用说明添加Linux故障排除
- 添加Debian sid特别说明

---

## v1.0 - 2026-01-12

### 🚀 初始版本

**核心功能：**
- ✅ 自动检测Aritzia The Super Puff Size M库存
- ✅ Selenium模拟真实浏览器访问
- ✅ 无界面模式（headless）运行
- ✅ 自动点击尺码选择器
- ✅ 智能识别库存状态

**技术栈：**
- Python 3.9+
- Selenium WebDriver
- Chrome/ChromeDriver
- 支持系统：macOS

**特点：**
- 绕过403反爬虫限制
- 简洁的输出界面
- 约15秒完成检测
- 自动保存截图供参考
