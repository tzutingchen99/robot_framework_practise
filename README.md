# robot_framework_practise

Robot Framework 練習專案：單一 repo 涵蓋 QA 四大自動化面向 — Web、API、App、壓力測試。

## 結構

```
variables/            環境設定（URL、帳號、capabilities），--variablefile 載入
resources/            keywords 分層：common + web / api / app
tests/
  web/                SeleniumLibrary（對象：saucedemo 練習站）
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
```

## 執行

所有指令都在 repo root 下，並帶環境設定檔：

```bash
# API 測試（最快，不需瀏覽器）
robot --variablefile variables/env_practice.py --outputdir results tests/api

# Web 測試（headless chrome；要看畫面把 env_practice.py 的 HEADLESS 改 False）
robot --variablefile variables/env_practice.py --outputdir results tests/web

# 只跑冒煙
robot --variablefile variables/env_practice.py --include smoke --outputdir results tests/

# pabot 平行執行（排除需要裝置的 app suite）
# 注意：pabot 會另外 spawn `robot` 子程序，必須在「已啟用 venv」的 shell 執行，
# 直接呼叫 .venv/Scripts/pabot.exe 會因子程序找不到 robot 而全數失敗
pabot --processes 2 --testlevelsplit --variablefile variables/env_practice.py \
      --exclude requires-device --outputdir results tests/

# App 測試：先啟動 emulator 與 Appium server（appium --port 4723）
robot --variablefile variables/env_practice.py --include requires-device --outputdir results tests/app
```

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
| `requires-device` | 需要實機/模擬器，CI 排除 |

## 測試對象

皆為公開練習服務，帳密為官方文件公開資訊：

- Web：<https://www.saucedemo.com>
- API / 壓測：<https://restful-booker.herokuapp.com>（[API 文件](https://restful-booker.herokuapp.com/apidoc/index.html)）
