#!/usr/bin/env python3
"""
微信推送模块
支持多种推送方式：
1. Server酱 (推荐，最简单)
2. 企业微信机器人
3. PushPlus
"""

import requests
import json
from datetime import datetime

class WeChatNotifier:
    def __init__(self):
        # 从配置文件读取密钥
        self.config = self.load_config()
    
    def load_config(self):
        """加载配置文件"""
        try:
            with open('notify_config.json', 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            return {
                'method': 'none',
                'server_chan_key': '',
                'wecom_webhook': '',
                'pushplus_token': ''
            }
    
    def notify(self, title, content):
        """发送通知"""
        method = self.config.get('method', 'none')
        
        if method == 'none':
            print("⚠️  未配置微信推送，跳过通知")
            return False
        
        if method == 'serverchan':
            return self.send_serverchan(title, content)
        elif method == 'wecom':
            return self.send_wecom(title, content)
        elif method == 'pushplus':
            return self.send_pushplus(title, content)
        else:
            print(f"⚠️  未知的推送方式: {method}")
            return False
    
    def send_serverchan(self, title, content):
        """通过Server酱发送 (推荐)"""
        key = self.config.get('server_chan_key', '')
        if not key:
            print("❌ Server酱密钥未配置")
            return False
        
        url = f"https://sctapi.ftqq.com/{key}.send"
        data = {
            'title': title,
            'desp': content
        }
        
        try:
            response = requests.post(url, data=data, timeout=10)
            result = response.json()
            
            if result.get('code') == 0:
                print("✅ 微信推送成功 (Server酱)")
                return True
            else:
                print(f"❌ 推送失败: {result.get('message', '未知错误')}")
                return False
        except Exception as e:
            print(f"❌ 推送出错: {e}")
            return False
    
    def send_wecom(self, title, content):
        """通过企业微信机器人发送"""
        webhook = self.config.get('wecom_webhook', '')
        if not webhook:
            print("❌ 企业微信Webhook未配置")
            return False
        
        data = {
            "msgtype": "markdown",
            "markdown": {
                "content": f"## {title}\n\n{content}"
            }
        }
        
        try:
            response = requests.post(webhook, json=data, timeout=10)
            result = response.json()
            
            if result.get('errcode') == 0:
                print("✅ 微信推送成功 (企业微信)")
                return True
            else:
                print(f"❌ 推送失败: {result.get('errmsg', '未知错误')}")
                return False
        except Exception as e:
            print(f"❌ 推送出错: {e}")
            return False
    
    def send_pushplus(self, title, content):
        """通过PushPlus发送"""
        token = self.config.get('pushplus_token', '')
        if not token:
            print("❌ PushPlus Token未配置")
            return False
        
        url = "http://www.pushplus.plus/send"
        data = {
            'token': token,
            'title': title,
            'content': content,
            'template': 'html'
        }
        
        try:
            response = requests.post(url, json=data, timeout=10)
            result = response.json()
            
            if result.get('code') == 200:
                print("✅ 微信推送成功 (PushPlus)")
                return True
            else:
                print(f"❌ 推送失败: {result.get('msg', '未知错误')}")
                return False
        except Exception as e:
            print(f"❌ 推送出错: {e}")
            return False

# 便捷函数
def send_stock_alert(product_name="The Super Puff Size M", stock_info="有货"):
    """发送库存提醒"""
    notifier = WeChatNotifier()
    
    now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    title = f"🎉 {product_name} {stock_info}！"
    
    content = f"""
**商品**: {product_name}
**状态**: {stock_info}
**时间**: {now}
**链接**: https://www.aritzia.com/intl/en/product/the-super-puff™/126464.html?color=6038_3

⚡ 请尽快购买！
"""
    
    return notifier.notify(title, content)

# 测试函数
def test_notification():
    """测试推送是否正常"""
    print("正在测试微信推送...")
    send_stock_alert("测试商品", "测试推送")

if __name__ == "__main__":
    test_notification()
