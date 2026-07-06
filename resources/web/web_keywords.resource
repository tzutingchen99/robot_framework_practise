*** Settings ***
Documentation     Web 層 keywords（SeleniumLibrary）。
...               命名原則：不要與 library 內建 keyword 同名，一律用描述性動詞片語。
Library           SeleniumLibrary    timeout=${SELENIUM_TIMEOUT}
Resource          ../common.resource


*** Keywords ***
Open Test Browser
    [Documentation]    開啟瀏覽器並導向 ${WEB_URL}。HEADLESS=True 時走 headless chrome（CI 用）。
    IF    ${HEADLESS}
        Open Browser    ${WEB_URL}    ${BROWSER}
        ...    options=add_argument("--headless=new");add_argument("--window-size=1920,1080");add_argument("--no-sandbox")
    ELSE
        Open Browser    ${WEB_URL}    ${BROWSER}
        Maximize Browser Window
    END

Close All Test Browsers
    [Documentation]    收掉所有瀏覽器。作為 Test Teardown 用，開瀏覽器失敗也安全。
    Run Keyword And Ignore Error    Close All Browsers

Login To Store
    [Arguments]    ${username}    ${password}
    Input Text    id:user-name    ${username}
    Input Text    id:password    ${password}
    Click Button    id:login-button

Verify Login Succeeded
    Wait Until Element Is Visible    css:.inventory_list
    Location Should Contain    /inventory.html

Verify Login Failed With Message
    [Arguments]    ${expected_message}
    Wait Until Element Is Visible    css:h3[data-test="error"]
    Element Should Contain    css:h3[data-test="error"]    ${expected_message}

Add Product To Cart
    [Arguments]    ${product_id}
    Click Button    id:add-to-cart-${product_id}

Verify Cart Badge Count
    [Arguments]    ${expected_count}
    Wait Until Element Is Visible    css:.shopping_cart_badge
    Element Text Should Be    css:.shopping_cart_badge    ${expected_count}
