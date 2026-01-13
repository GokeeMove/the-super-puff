#!/bin/bash
# 快速配置微信推送

echo "========================================"
echo "  微信推送快速配置"
echo "========================================"
echo ""

echo "支持的推送方式："
echo "1. Server酱 (推荐，最简单)"
echo "2. 企业微信机器人"
echo "3. PushPlus"
echo "4. 不使用推送"
echo ""

read -p "请选择推送方式 (1-4): " choice

case $choice in
    1)
        echo ""
        echo "📱 配置 Server酱"
        echo "----------------------------------------"
        echo "1. 访问: https://sct.ftqq.com/"
        echo "2. 用GitHub账号登录"
        echo "3. 微信扫码绑定"
        echo "4. 复制你的 SendKey"
        echo ""
        read -p "请输入你的 SendKey: " key
        
        if [ -z "$key" ]; then
            echo "❌ SendKey 不能为空"
            exit 1
        fi
        
        cat > notify_config.json <<EOF
{
  "method": "serverchan",
  "server_chan_key": "$key",
  "wecom_webhook": "",
  "pushplus_token": ""
}
EOF
        
        echo ""
        echo "✅ Server酱 配置成功！"
        ;;
        
    2)
        echo ""
        echo "📱 配置企业微信机器人"
        echo "----------------------------------------"
        echo "1. 在企业微信中创建一个群聊"
        echo "2. 群设置 → 群机器人 → 添加机器人"
        echo "3. 复制 Webhook 地址"
        echo ""
        read -p "请输入 Webhook 地址: " webhook
        
        if [ -z "$webhook" ]; then
            echo "❌ Webhook 不能为空"
            exit 1
        fi
        
        cat > notify_config.json <<EOF
{
  "method": "wecom",
  "server_chan_key": "",
  "wecom_webhook": "$webhook",
  "pushplus_token": ""
}
EOF
        
        echo ""
        echo "✅ 企业微信 配置成功！"
        ;;
        
    3)
        echo ""
        echo "📱 配置 PushPlus"
        echo "----------------------------------------"
        echo "1. 访问: http://www.pushplus.plus/"
        echo "2. 微信扫码登录"
        echo "3. 复制你的 Token"
        echo ""
        read -p "请输入你的 Token: " token
        
        if [ -z "$token" ]; then
            echo "❌ Token 不能为空"
            exit 1
        fi
        
        cat > notify_config.json <<EOF
{
  "method": "pushplus",
  "server_chan_key": "",
  "wecom_webhook": "",
  "pushplus_token": "$token"
}
EOF
        
        echo ""
        echo "✅ PushPlus 配置成功！"
        ;;
        
    4)
        cat > notify_config.json <<EOF
{
  "method": "none",
  "server_chan_key": "",
  "wecom_webhook": "",
  "pushplus_token": ""
}
EOF
        
        echo ""
        echo "✅ 已禁用推送"
        exit 0
        ;;
        
    *)
        echo "❌ 无效的选择"
        exit 1
        ;;
esac

echo ""
echo "正在测试推送..."
echo "----------------------------------------"

# 激活虚拟环境
if [ -d "venv" ]; then
    source venv/bin/activate
    python3 wechat_notify.py
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "========================================"
        echo "  配置完成！"
        echo "========================================"
        echo ""
        echo "下一步："
        echo "1. 单次检测: ./run.sh"
        echo "2. 持续监控: bash monitor_background.sh"
        echo ""
        echo "详细说明: cat WECHAT_NOTIFY_SETUP.md"
        echo ""
    else
        echo ""
        echo "⚠️  推送测试失败，请检查配置"
        echo "查看详细说明: cat WECHAT_NOTIFY_SETUP.md"
    fi
else
    echo ""
    echo "⚠️  虚拟环境未安装"
    echo "请先运行: bash install_linux.sh"
fi
