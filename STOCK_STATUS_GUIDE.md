# 库存状态检测说明

## 程序如何判断库存

程序会打开网页的尺码下拉菜单，查找Size M旁边的文本，根据关键词判断：

### ✅ 有货的标识

程序会识别以下文本为"有货"：

| 网页显示文本 | 程序输出 | 说明 |
|------------|---------|------|
| `M` + `1 Left` | ✅ Size M 有货! (仅剩1件！) | 只剩1件 |
| `M` + `2 Left` | ✅ Size M 有货! | 剩余2件 |
| `M` + `Only a Few Left` | ✅ Size M 有货! (只剩少量) | 少量库存 |
| `M` + `Available` | ✅ Size M 有货! | 有库存 |
| `M` + `3 Left` | ✅ Size M 有货! | 剩余3件 |

### ❌ 无货的标识

程序会识别以下文本为"无货"：

| 网页显示文本 | 程序输出 | 说明 |
|------------|---------|------|
| `M` + `Sold Out Online` | ❌ Size M 无货 (Sold Out Online) | 网上已售罄 |
| `M` + `Out of Stock` | ❌ Size M 无货 (Out of Stock) | 缺货 |

## 调试模式

程序现在会显示读取到的完整文本：

```
找到Size M，完整文本: 'M
1 Left'

✅✅✅ Size M 有货! ✅✅✅
    (仅剩1件！)
```

## 如果程序判断错误

### 情况1: 网页显示有货，程序显示无货

**可能原因：**
1. 网页加载不完整
2. 文本格式变化
3. 需要更长的等待时间

**解决方案：**
```python
# 在check_stock.py中增加等待时间
time.sleep(5)  # 改为更长时间，如 time.sleep(10)
```

### 情况2: 看不到具体文本

运行程序后，查看输出：
```bash
./run.sh

# 输出会显示：
# 找到Size M，完整文本: 'xxx'
```

检查这个文本内容，如果有新的库存关键词，需要更新代码。

## 测试检测逻辑

运行测试脚本：
```bash
python3 test_detection.py
```

会测试各种库存文本的检测结果。

## 当前支持的关键词

### 有货关键词（不区分大小写）
- `left` - 如"1 Left", "2 Left"等
- `only a few left` - 只剩少量
- `available` - 可用

### 无货关键词（不区分大小写）
- `sold out` - 售罄
- `out of stock` - 缺货

## 如何添加新的关键词

如果网站使用了新的库存文本，编辑 `check_stock.py`：

```python
# 找到这段代码（约第160-180行）
if 'sold out' in parent_lower:
    stock_status = "无货"
elif '1 left' in parent_lower or 'only a few left' in parent_lower:
    stock_status = "有货"
    
# 添加新的关键词，例如：
elif 'in stock' in parent_lower:
    stock_status = "有货"
```

## 查看检测详情

程序会实时显示找到的文本：

```bash
./run.sh

# 输出示例：
# 找到Size M，完整文本: 'M
# 1 Left'
```

根据显示的文本可以判断检测是否正确。

## 实时监控示例

如果想持续监控库存，可以创建一个循环脚本：

```bash
#!/bin/bash
# monitor_stock.sh

while true; do
    echo "$(date): 检测库存..."
    ./run.sh
    echo "等待5分钟后再次检测..."
    sleep 300  # 5分钟
done
```

**注意：** 不要设置过于频繁的检测，建议至少间隔5分钟。
