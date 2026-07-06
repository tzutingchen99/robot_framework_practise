*** Settings ***
Documentation     Web 登入功能測試 — Browser Library 版。
...               案例與 tests/web/login_tests.robot（SeleniumLibrary）一對一對應，
...               供兩套 library 的語法、速度、穩定性並排比較。
Resource          ../../resources/web_browser/browser_keywords.resource
Variables         ../../variables/env_practice.py
Test Setup        Open Store Page
Test Teardown     Close Store Page
Test Tags         web    playwright


*** Test Cases ***
Valid Login Lands On Inventory Page
    [Documentation]    正確帳密登入後應進入商品列表頁。
    [Tags]    smoke
    Login To Store    ${WEB_USER}    ${WEB_PASSWORD}
    Verify Login Succeeded

Invalid Password Shows Error Message
    [Documentation]    錯誤密碼應留在登入頁並顯示錯誤訊息。
    [Tags]    regression
    Login To Store    ${WEB_USER}    wrong-password
    Verify Login Failed With Message    Username and password do not match

Locked Out User Cannot Login
    [Documentation]    被鎖帳號應顯示 locked out 訊息。
    [Tags]    regression
    Login To Store    locked_out_user    ${WEB_PASSWORD}
    Verify Login Failed With Message    Sorry, this user has been locked out
