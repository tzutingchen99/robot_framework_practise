*** Settings ***
Documentation     App 層 keywords（AppiumLibrary）。
...               需要本機跑 Appium server + Android emulator（或實機）才能執行，
...               CI 預設用 --exclude requires-device 跳過。
Library           AppiumLibrary
Resource          ../common.resource


*** Keywords ***
Open Android App
    [Documentation]    以 ${ANDROID_CAPS}（variables/env_practice.py）連上 Appium server。
    Open Application    ${APPIUM_SERVER}    &{ANDROID_CAPS}

Close Android App
    Run Keyword And Ignore Error    Close Application

Verify Page Contains Text
    [Arguments]    ${text}
    Wait Until Page Contains    ${text}    timeout=15s
