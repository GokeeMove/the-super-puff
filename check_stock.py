#!/usr/bin/env python3
"""
检测Aritzia网站上The Super Puff羽绒服Size M的库存情况
支持 macOS、Linux (Debian/Ubuntu) 等系统
"""

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
import time
import json
import os
import platform
import sys

def check_stock():
    """
    检查指定商品的Size M库存状态
    """
    url = "https://www.aritzia.com/intl/en/product/the-super-puff%E2%84%A2/126464.html?color=6038_3"
    
    # 检测操作系统
    system = platform.system()
    print(f"检测到操作系统: {system}")
    
    # 配置Chrome选项（跨平台兼容）
    chrome_options = Options()
    chrome_options.add_argument('--headless=new')  # 无头模式（不显示浏览器窗口）
    chrome_options.add_argument('--no-sandbox')  # Linux必需，root用户必须
    chrome_options.add_argument('--disable-dev-shm-usage')  # Linux必需，解决共享内存问题
    chrome_options.add_argument('--disable-gpu')  # Linux headless模式建议禁用GPU
    chrome_options.add_argument('--disable-software-rasterizer')  # 禁用软件光栅化
    chrome_options.add_argument('--disable-blink-features=AutomationControlled')
    chrome_options.add_argument('--window-size=1920,1080')  # 设置窗口大小
    chrome_options.add_argument('--disable-extensions')  # 禁用扩展
    chrome_options.add_argument('--disable-setuid-sandbox')  # Linux沙箱设置，root用户必须
    
    # Linux系统额外配置
    if system == 'Linux':
        chrome_options.add_argument('--single-process')  # Linux单进程模式
        # 检查是否为root用户
        if os.geteuid() == 0:
            print("检测到root用户，添加额外的安全配置...")
            chrome_options.add_argument('--disable-web-security')  # root用户运行需要
            chrome_options.add_argument('--allow-running-insecure-content')  # 允许不安全内容
    
    # 根据系统设置User-Agent
    if system == 'Linux':
        user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    else:
        user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    
    chrome_options.add_argument(f'user-agent={user_agent}')
    chrome_options.add_experimental_option("excludeSwitches", ["enable-automation"])
    chrome_options.add_experimental_option('useAutomationExtension', False)
    
    print("使用无界面模式运行...")
    
    driver = None
    
    try:
        print("正在启动浏览器（后台模式）...")
        
        # 创建WebDriver实例
        driver = webdriver.Chrome(options=chrome_options)
        
        # 隐藏webdriver特征
        driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})")
        
        # 访问页面
        print("正在加载页面...")
        driver.get(url)
        
        # 等待页面加载
        time.sleep(5)
        
        # 滚动页面以触发懒加载
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight/2);")
        time.sleep(2)
        driver.execute_script("window.scrollTo(0, 0);")
        time.sleep(2)
        
        # 尝试等待尺码选择器出现
        try:
            wait = WebDriverWait(driver, 15)
            
            print("正在检测尺码...")
            
            size_m_button = None
            stock_status = None
            
            # 步骤1: 查找并点击"Select a Size"下拉框
            try:
                # 查找尺码选择器
                size_selector_candidates = driver.find_elements(By.XPATH, "//*[contains(text(), 'Select a Size')]")
                
                if not size_selector_candidates:
                    size_selector_candidates = driver.find_elements(By.CSS_SELECTOR, "[class*='size-select'], [class*='sizeSelect'], select")
                
                if size_selector_candidates:
                    for selector in size_selector_candidates:
                        try:
                            if selector.is_displayed():
                                # 滚动到元素位置并点击
                                driver.execute_script("arguments[0].scrollIntoView({behavior: 'smooth', block: 'center'});", selector)
                                time.sleep(1)
                                
                                # 尝试多种点击方式
                                try:
                                    selector.click()
                                except:
                                    try:
                                        driver.execute_script("arguments[0].click();", selector)
                                    except:
                                        parent = selector.find_element(By.XPATH, "..")
                                        driver.execute_script("arguments[0].click();", parent)
                                
                                time.sleep(3)  # 等待下拉菜单展开
                                
                                # 截图
                                driver.save_screenshot('dropdown_opened.png')
                                
                                # 查找Size M选项
                                size_options = driver.find_elements(By.XPATH, "//*")
                                visible_options = [opt for opt in size_options if opt.is_displayed() and len(opt.text.strip()) <= 20]
                                
                                for option in visible_options:
                                    try:
                                        if not option.is_displayed():
                                            continue
                                            
                                        option_text = option.text.strip()
                                        option_value = option.get_attribute('value') or ''
                                        data_value = option.get_attribute('data-value') or ''
                                        
                                        # 查找Size M - 必须完全匹配
                                        is_size_m = (
                                            option_text == 'M' or 
                                            option_value == 'M' or 
                                            data_value == 'M' or
                                            option_text == 'M - Sold Out' or
                                            option_text == 'M - Out of Stock' or
                                            option_text.startswith('M ') or
                                            option_text == 'Size M'
                                        )
                                        
                                        if is_size_m:
                                            # 检查M选项旁边是否有库存状态文本
                                            try:
                                                parent = option.find_element(By.XPATH, "..")
                                                parent_text = parent.text
                                                
                                                # 检查是否包含无货信息
                                                if 'sold out' in parent_text.lower():
                                                    stock_status = "无货"
                                                    print(f"\n❌ Size M 无货 (Sold Out Online)")
                                                    size_m_button = None
                                                    break
                                                elif 'out of stock' in parent_text.lower():
                                                    stock_status = "无货"
                                                    print(f"\n❌ Size M 无货 (Out of Stock)")
                                                    size_m_button = None
                                                    break
                                                elif 'only a few left' in parent_text.lower():
                                                    stock_status = "有货"
                                                    print(f"\n✅ Size M 有货! (只剩少量)")
                                                    size_m_button = option
                                                    break
                                                else:
                                                    # 可能有货，需要点击验证
                                                    size_m_button = option
                                                    break
                                            except:
                                                size_m_button = option
                                                break
                                    except:
                                        continue
                                
                                break
                        except Exception as e:
                            print(f"点击选择器时出错: {e}")
                            continue
                else:
                    print("未找到'Select a Size'元素")
                    
            except Exception as e:
                print(f"查找尺码选择器时出错: {e}")
            
            if size_m_button and not stock_status:
                # 如果找到按钮但还没确定库存，尝试点击验证
                try:
                    driver.execute_script("arguments[0].scrollIntoView(true);", size_m_button)
                    time.sleep(1)
                    size_m_button.click()
                    time.sleep(2)
                    
                    # 查找Add to Bag按钮
                    add_to_bag_selectors = [
                        (By.XPATH, "//button[contains(text(), 'ADD TO BAG')]"),
                        (By.XPATH, "//button[contains(text(), 'Add to Bag')]"),
                    ]
                    
                    for selector_type, selector_value in add_to_bag_selectors:
                        try:
                            add_button = driver.find_element(selector_type, selector_value)
                            if add_button.is_displayed() and add_button.is_enabled():
                                stock_status = "有货"
                                print(f"\n✅ Size M 有货!")
                                break
                        except:
                            continue
                    
                    if not stock_status:
                        stock_status = "无货"
                        print(f"\n❌ Size M 无货")
                    
                    driver.save_screenshot('page_screenshot_after_click.png')
                    
                except Exception as e:
                    pass
            else:
                if not stock_status:
                    print("\n⚠️  未能确定Size M库存状态")
            
            # 保存截图供参考
            driver.save_screenshot('page_screenshot.png')
            
        except TimeoutException:
            print("⚠️  页面加载超时")
        
        print("\n检测完成!")
        
    except Exception as e:
        print(f"发生错误: {e}")
        import traceback
        traceback.print_exc()
        
    finally:
        if driver:
            driver.quit()

if __name__ == "__main__":
    print("\n" + "=" * 60)
    print("  The Super Puff 库存检测工具 - Size M")
    print("=" * 60)
    
    check_stock()
    
    print("\n" + "=" * 60)
    print("  检测完成")
    print("=" * 60 + "\n")
