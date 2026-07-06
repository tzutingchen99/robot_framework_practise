*** Settings ***
Documentation     Android App 冒煙測試骨架。
...
...               前置條件（本機執行）：
...               1. 啟動 Android emulator（或接實機，改 ANDROID_CAPS 的 deviceName）
...               2. 啟動 Appium server：appium --port 4723
...               3. robot --variablefile variables/env_practice.py --include requires-device tests/app
...
...               CI 不具備裝置環境，用 --exclude requires-device 跳過本 suite。
Resource          ../../resources/app/app_keywords.resource
Variables         ../../variables/env_practice.py
Test Teardown     Close Android App
Test Tags         app    requires-device


*** Test Cases ***
Settings App Launches
    [Documentation]    以系統設定 app 驗證 Appium 環境接通（不依賴自製 apk）。
    [Tags]    smoke
    Open Android App
    Verify Page Contains Text    Settings
