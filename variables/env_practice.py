# Environment: practice
# 執行時用 --variablefile variables/env_practice.py 載入；
# 之後要加新環境就複製一份改值（例：env_staging.py），測試碼不動。

# --- Web ---
WEB_URL = "https://www.saucedemo.com"
BROWSER = "chrome"
HEADLESS = True
SELENIUM_TIMEOUT = "10s"

# saucedemo 官方公開的練習帳號（網站首頁直接列出，非機密）
WEB_USER = "standard_user"
WEB_PASSWORD = "secret_sauce"

# --- API ---
API_URL = "https://restful-booker.herokuapp.com"
API_USER = "admin"          # restful-booker 官方文件公開的練習帳號
API_PASSWORD = "password123"

# --- App (Appium) ---
APPIUM_SERVER = "http://127.0.0.1:4723"
ANDROID_CAPS = {
    "platformName": "Android",
    "automationName": "UiAutomator2",
    "deviceName": "emulator-5554",
    "appPackage": "com.android.settings",
    "appActivity": ".Settings",
    "newCommandTimeout": 120,
}
