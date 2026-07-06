*** Settings ***
Documentation     Web 層 keywords（Browser Library / Playwright 引擎）。
...               與 resources/web/（SeleniumLibrary）功能對等，供並排比較用；
...               兩套 library 不要混進同一個 suite。
Library           Browser    timeout=${SELENIUM_TIMEOUT}
Resource          ../common.resource


*** Keywords ***
Open Store Page
    [Documentation]    開瀏覽器並導向 ${WEB_URL}。headless 由 ${HEADLESS} 控制。
    New Browser    chromium    headless=${HEADLESS}
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page    ${WEB_URL}

Close Store Page
    Run Keyword And Ignore Error    Close Browser    ALL

Login To Store
    [Arguments]    ${username}    ${password}
    Fill Text    id=user-name    ${username}
    Fill Text    id=password    ${password}
    Click    id=login-button

Verify Login Succeeded
    Wait For Elements State    css=.inventory_list    visible
    ${url}=    Get Url
    Should Contain    ${url}    /inventory.html

Verify Login Failed With Message
    [Arguments]    ${expected_message}
    Wait For Elements State    css=h3[data-test="error"]    visible
    Get Text    css=h3[data-test="error"]    contains    ${expected_message}

Add Product To Cart
    [Arguments]    ${product_id}
    Click    id=add-to-cart-${product_id}

Verify Cart Badge Count
    [Arguments]    ${expected_count}
    Wait For Elements State    css=.shopping_cart_badge    visible
    Get Text    css=.shopping_cart_badge    ==    ${expected_count}
