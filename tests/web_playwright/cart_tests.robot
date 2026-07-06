*** Settings ***
Documentation     購物車功能測試 — Browser Library 版。
...               案例與 tests/web/cart_tests.robot（SeleniumLibrary）一對一對應。
Resource          ../../resources/web_browser/browser_keywords.resource
Variables         ../../variables/env_practice.py
Test Setup        Login As Standard User
Test Teardown     Close Store Page
Test Tags         web    playwright    regression


*** Test Cases ***
Add Single Product Updates Cart Badge
    Add Product To Cart    sauce-labs-backpack
    Verify Cart Badge Count    1

Add Two Products Updates Cart Badge
    Add Product To Cart    sauce-labs-backpack
    Add Product To Cart    sauce-labs-bike-light
    Verify Cart Badge Count    2


*** Keywords ***
Login As Standard User
    Open Store Page
    Login To Store    ${WEB_USER}    ${WEB_PASSWORD}
    Verify Login Succeeded
