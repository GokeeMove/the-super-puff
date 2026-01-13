#!/usr/bin/env python3
"""
测试库存检测逻辑
"""

# 模拟不同的库存状态文本
test_cases = [
    ("M\nSold Out Online", "无货"),
    ("M\n1 Left", "有货"),
    ("M\nOnly a Few Left", "有货"),
    ("M\nOut of Stock", "无货"),
    ("M", "可能有货"),
    ("M\n2 Left", "有货"),
    ("M\nAvailable", "有货"),
]

print("测试库存检测逻辑:")
print("=" * 60)

for text, expected in test_cases:
    text_lower = text.lower()
    
    if 'sold out' in text_lower:
        result = "无货 (Sold Out)"
    elif 'out of stock' in text_lower:
        result = "无货 (Out of Stock)"
    elif '1 left' in text_lower or 'only a few left' in text_lower:
        result = "有货 (少量)"
    elif 'left' in text_lower or 'available' in text_lower:
        result = "有货"
    else:
        result = "需要点击验证"
    
    status = "✅" if "有货" in result and "有货" in expected else ("❌" if "无货" in result and "无货" in expected else "⚠️")
    
    print(f"{status} 文本: '{text}' -> {result} (预期: {expected})")

print("=" * 60)
