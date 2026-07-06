*** Settings ***
Documentation     購物車功能測試（saucedemo 練習站）。
Resource          ../../resources/web/web_keywords.resource
Variables         ../../variables/env_practice.py
Test Setup        Login As Standard User
Test Teardown     Close All Test Browsers
Test Tags         web    regression


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
    Open Test Browser
    Login To Store    ${WEB_USER}    ${WEB_PASSWORD}
    Verify Login Succeeded
