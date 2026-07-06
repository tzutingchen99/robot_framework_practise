# robot_framework_practise

Robot Framework 練習專案：單一 repo 涵蓋 QA 四大自動化面向 — Web、API、App、壓力測試。

## 結構

```
variables/            環境設定（URL、帳號、capabilities），--variablefile 載入
resources/            keywords 分層：common + web / api / app
tests/
  web/                SeleniumLibrary（對象：saucedemo 練習站）
  web_playwright/     Browser Library（Playwright 引擎），案例與 web/ 一對一對應供並排比較
  api/                RequestsLibrary（對象：restful-booker 練習服務）
  app/                AppiumLibrary 骨架（需 Appium server + emulator）
load/                 Locust 壓測腳本
docs/                 架構審查報告
.github/workflows/    CI：dry-run + API/Web 實跑（headless）
```

## 安裝

```bash
python -m venv .venv
.venv\Scripts\activate        # Windows；macOS/Linux 用 source .venv/bin/activate
pip install -r requirements.txt
rfbrowser init chromium       # Browser Library 初始化（需 Node.js，下載 Playwright chromium）
```

## 執行

所有指令都在 repo root 下，並帶環境設定檔：

```bash
# API 測試（最快，不需瀏覽器）
robot --variablefile variables/env_practice.py --outputdir results tests/api

# Web 測試（headless chrome；要看畫面把 env_practice.py 的 HEADLESS 改 False）
robot --variablefile variables/env_practice.py --outputdir results tests/web

# Web 測試 Browser Library 版（同一批案例的 Playwright 實作，供並排比較）
robot --variablefile variables/env_practice.py --outputdir results tests/web_playwright

# 只跑冒煙
robot --variablefile variables/env_practice.py --include smoke --outputdir results tests/

# pabot 平行執行（排除需要裝置的 app suite）
# 注意：pabot 會另外 spawn `robot` 子程序，必須在「已啟用 venv」的 shell 執行，
# 直接呼叫 .venv/Scripts/pabot.exe 會因子程序找不到 robot 而全數失敗
pabot --processes 2 --testlevelsplit --variablefile variables/env_practice.py \
      --exclude requires-device --outputdir results tests/

# App 測試：先啟動 emulator 與 Appium server（見下方「App 測試環境建置」）
robot --variablefile variables/env_practice.py --include requires-device --outputdir results tests/app
```

## App 測試環境建置

App 測試（`tests/app/`）需要本機額外環境，尚未建置前 CI 與本機都用 `--exclude requires-device` 跳過。

1. **Android SDK + Emulator**：裝 [Android Studio](https://developer.android.com/studio)，用內建 Device Manager 建一台 AVD 並啟動。設好環境變數 `ANDROID_HOME`（SDK 路徑），並把 `%ANDROID_HOME%\platform-tools` 加進 PATH
2. **Node.js**：Appium server 跑在 Node 上，從 [nodejs.org](https://nodejs.org) 裝 LTS 版
3. **Appium server + driver**：
   ```bash
   npm install -g appium
   appium driver install uiautomator2
   ```
4. **確認裝置連上**：`adb devices` 應列出 emulator（預設 `emulator-5554`，若不同就改 `variables/env_practice.py` 的 `deviceName`）
5. **啟動 server 後執行**：
   ```bash
   appium --port 4723
   robot --variablefile variables/env_practice.py --include requires-device --outputdir results tests/app
   ```

冒煙案例用系統內建的設定 app（`com.android.settings`）驗證環境接通，不需要準備 apk；之後要測自家 app 就把 `ANDROID_CAPS` 的 `appPackage` / `appActivity` 換掉，或改用 `app` capability 指向 apk 路徑。iOS 需要 macOS + Xcode（XCUITest driver），Windows 環境先不列。

## 壓力測試

```bash
locust -f load/locustfile.py --host https://restful-booker.herokuapp.com \
       --headless -u 5 -r 1 -t 1m --html results/locust_report.html
```

目標是公開練習服務，請維持低併發；真實壓測換成自家測試環境 host。

## Tag 慣例

| Tag | 意義 |
|-----|------|
| `smoke` | 冒煙：最小健康檢查集合 |
| `regression` | 回歸：完整功能驗證 |
| `web` / `api` / `app` | 平台別（suite 層以 `Test Tags` 統一標） |
| `playwright` | Browser Library 實作的 web 案例（`web` tag 之外的細分） |
| `requires-device` | 需要實機/模擬器，CI 排除 |

## 測試對象

皆為公開練習服務，帳密為官方文件公開資訊：

- Web：<https://www.saucedemo.com>
- API / 壓測：<https://restful-booker.herokuapp.com>（[API 文件](https://restful-booker.herokuapp.com/apidoc/index.html)）
