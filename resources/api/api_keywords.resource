*** Settings ***
Documentation     API 層 keywords（RequestsLibrary），對象為 restful-booker 練習服務。
Library           RequestsLibrary
Library           Collections
Resource          ../common.resource


*** Keywords ***
Create API Session
    [Documentation]    建立 named session，之後所有 request 共用連線與 base URL。
    Create Session    booker    ${API_URL}    verify=${True}

Get Auth Token
    [Documentation]    restful-booker 的 PUT/DELETE 需要 token（Cookie 帶入）。
    ${body}=    Create Dictionary    username=${API_USER}    password=${API_PASSWORD}
    ${resp}=    POST On Session    booker    /auth    json=${body}
    Dictionary Should Contain Key    ${resp.json()}    token    Auth 失敗：回應沒有 token
    RETURN    ${resp.json()}[token]

Create Booking
    [Arguments]    ${firstname}    ${lastname}    ${totalprice}
    ${dates}=    Create Dictionary    checkin=2026-08-01    checkout=2026-08-05
    ${body}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${True}
    ...    bookingdates=${dates}
    ${resp}=    POST On Session    booker    /booking    json=${body}
    RETURN    ${resp.json()}[bookingid]

Get Booking
    [Arguments]    ${booking_id}
    ${resp}=    GET On Session    booker    /booking/${booking_id}
    RETURN    ${resp.json()}

Update Booking Price
    [Arguments]    ${booking_id}    ${token}    ${new_price}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${booking}=    Get Booking    ${booking_id}
    Set To Dictionary    ${booking}    totalprice=${new_price}
    ${resp}=    PUT On Session    booker    /booking/${booking_id}    json=${booking}    headers=${headers}
    RETURN    ${resp.json()}

Delete Booking
    [Arguments]    ${booking_id}    ${token}
    ${headers}=    Create Dictionary    Cookie=token=${token}
    ${resp}=    DELETE On Session    booker    /booking/${booking_id}    headers=${headers}
    ...    expected_status=201
    # restful-booker 刪除成功回 201（該服務的既定行為，非 REST 慣例）
    RETURN    ${resp}
