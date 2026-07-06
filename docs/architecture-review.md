# 架構審查報告 — robot_framework_practise

> 審查日期：2026-07-06
> 審查範圍：以「涵蓋 QA 全平台自動化（Web / App / API / 壓力測試）」為目標，盤點現況與缺漏。

## 一、現況盤點

| 檔案 | 內容 | 狀態 |
|------|------|------|
| `demo.robot` | 3 個練習 case（Log、開關瀏覽器、Evaluate） | 僅 Web 冒煙等級 |
| `keywords.robot` | `Open site` / `Close Browser` 兩個 keyword | 僅 Web |
| `README.md` | 只有標題一行 | 無任何說明 |
| `.gitignore` | ActionScript / Flash Builder 範本 | 與本專案技術棧無關 |

結論：現況是單檔練習專案，四大測試面向只有 Web 有雛形，App / API / 壓測完全缺席，也沒有任何工程化基礎（依賴管理、環境設定、CI、報告產出）。

## 二、缺漏清單

### A. 測試覆蓋面缺漏

| # | 缺漏 | 影響 | 補法 |
|---|------|------|------|
| A1 | 無 API 測試層 | 最快、最穩定的回歸手段缺席 | RequestsLibrary + 公開練習 API |
| A2 | 無 App 測試層 | iOS / Android 無自動化能力 | AppiumLibrary 骨架 + capabilities 設定檔 |
| A3 | 無壓力測試 | 無法驗證效能與併發行為；RF 本身不適合做壓測 | 獨立 `load/` 目錄，採 Locust（Python，與技術棧一致） |
| A4 | Web 測試只有開關瀏覽器 | 沒有實際驗證行為 | 補齊真實互動案例（搜尋、斷言） |

### B. 架構與工程化缺漏

| # | 缺漏 | 影響 | 補法 |
|---|------|------|------|
| B1 | 無分層結構：tests 與 keywords 混在 root | 平台一多就無法維護 | `tests/`（依平台分）＋ `resources/`（共用/平台 keywords）＋ `variables/`（環境設定） |
| B2 | 無 `requirements.txt` | 環境不可重建、版本不可控 | 鎖定 RF / SeleniumLibrary / RequestsLibrary / AppiumLibrary / pabot / locust 版本 |
| B3 | 無環境變數管理 | URL 寫死在 keyword 檔 | `variables/` 依環境拆檔，執行時用 `--variablefile` 切換 |
| B4 | 無 CI | 無排程、無自動回歸 | GitHub Actions workflow（本 repo 在 GitHub；概念可平移到 Jenkins） |
| B5 | 無平行化設定 | 案例成長後執行時間不可控 | 引入 pabot，測試設計維持 suite 間獨立 |
| B6 | 無測試結果管理 | output/log/report 會進版控 | `.gitignore` 改為 Python + RF 範本，`results/` 排除 |
| B7 | 無 tag 規範 | 無法切 smoke / regression、無法依平台挑測試 | 制定 tag 慣例：`smoke`、`regression`、`web`、`api`、`app` |

### C. 既有程式碼問題

| # | 位置 | 問題 | 修法 |
|---|------|------|------|
| C1 | `keywords.robot` | 自訂 keyword `Close Browser` 與 SeleniumLibrary 內建同名，靠 prefix 才避開遞迴，屬地雷寫法 | 改名為描述性名稱（如 `Close All Test Browsers`） |
| C2 | `keywords.robot` | `Library BuiltIn` 多餘（BuiltIn 永遠自動載入） | 移除 |
| C3 | `keywords.robot` | `Library Dialogs` 需要人工互動，進 CI 會卡死 | 移除 |
| C4 | `keywords.robot` | `Open Browser` 未指定 browser 參數（預設 firefox），也未支援 headless | 參數化 browser，CI 用 headless chrome |
| C5 | `demo.robot` | 無 Suite/Test 級 Setup、Teardown；瀏覽器開失敗不會清理 | 用 `Test Teardown` 收瀏覽器 |
| C6 | `demo.robot` | 無 `[Documentation]`、無 `[Tags]` | 全部案例補上 |
| C7 | root | 測試檔直接放 root | 遷入 `tests/web/` |

## 三、目標結構

```
robot_framework_practise/
├── README.md                  # 專案說明、安裝、執行方式
├── requirements.txt           # 鎖版依賴
├── .gitignore                 # Python + RF 範本
├── docs/
│   └── architecture-review.md # 本報告
├── variables/
│   └── env_practice.py        # 環境設定（URL、browser、timeout）
├── resources/
│   ├── common.resource        # 跨平台共用 keywords
│   ├── web/web_keywords.resource
│   ├── api/api_keywords.resource
│   └── app/app_keywords.resource
├── tests/
│   ├── web/                   # SeleniumLibrary
│   ├── api/                   # RequestsLibrary
│   └── app/                   # AppiumLibrary（骨架，需實機/模擬器）
├── load/
│   └── locustfile.py          # Locust 壓測腳本
├── results/                   # 執行產物（gitignored）
└── .github/workflows/ci.yml   # CI：lint + api/web 冒煙
```

## 四、技術選型說明

| 面向 | 選擇 | 理由 |
|------|------|------|
| Web | SeleniumLibrary | 延續現有程式碼；如要換 Browser Library（Playwright）屬另一個決策 |
| API | RequestsLibrary | RF 生態最通用的 HTTP library；練習目標用公開 API（restful-booker） |
| App | AppiumLibrary | 與現行工作技術棧一致；repo 內只放可跑骨架，需連 Appium server 才會實跑 |
| 壓測 | Locust | Python 原生、腳本即程式碼、可版控；RF 不適合壓測，JMeter 偏 GUI/XML 難 review |
| 平行化 | pabot | 與現行工作流程一致 |
| CI | GitHub Actions | repo 在 GitHub 上；pipeline 概念（stage、artifact、排程）可平移 Jenkins |

## 五、驗證結果（2026-07-06 補齊後實測）

| 項目 | 指令 | 結果 |
|------|------|------|
| 全 suite dry-run | `robot --dryrun ... tests/` | 10/10 PASS（含 app 骨架） |
| API 實跑 | `robot ... tests/api` | 4/4 PASS |
| Web 實跑（headless chrome） | `robot ... tests/web` | 5/5 PASS |
| 壓測腳本 | `locust --headless -u 2 -t 15s` | 11 requests、0 failures |
| pabot 平行 | `pabot --processes 2 --testlevelsplit ...` | 9/9 PASS，牆鐘 19.8s（累計 33.2s） |

已知限制：
- App suite 只驗證到 dry-run；實跑需要 Appium server + emulator，本機尚未架設
- pabot 必須在啟用 venv 的 shell 執行（詳見 README 注意事項）
- 環境組合：Python 3.14.6 + requirements.txt 內鎖定版本，於 Windows 11 驗證

## 六、補齊順序

1. 基礎設施：`.gitignore`、`requirements.txt`、目錄結構
2. Web 層：修 C1–C7，遷移既有案例並擴充
3. API 層：CRUD + 斷言範例
4. App 層：骨架 + capabilities 管理（標記 `requires-device`，CI 不跑）
5. 壓測層：Locust 腳本 + 執行說明
6. CI + pabot 設定
7. README 全面改寫、依賴安裝與 dry-run 驗證
