*** Settings ***
Documentation     API 測試（restful-booker 練習服務）：健康檢查 + Booking CRUD。
Resource          ../../resources/api/api_keywords.resource
Variables         ../../variables/env_practice.py
Suite Setup       Create API Session
Test Tags         api


*** Test Cases ***
Service Health Check
    [Documentation]    /ping 回 201 代表服務存活（該服務的既定行為）。
    [Tags]    smoke
    GET On Session    booker    /ping    expected_status=201

Create And Get Booking
    [Tags]    smoke
    ${booking_id}=    Create Booking    Lucy    Chen    ${1500}
    ${booking}=    Get Booking    ${booking_id}
    Should Be Equal    ${booking}[firstname]    Lucy
    Should Be Equal    ${booking}[totalprice]    ${1500}

Update Booking Requires Token
    [Tags]    regression
    ${booking_id}=    Create Booking    Lucy    Chen    ${1000}
    ${token}=    Get Auth Token
    ${updated}=    Update Booking Price    ${booking_id}    ${token}    ${2000}
    Should Be Equal    ${updated}[totalprice]    ${2000}

Delete Booking Removes Record
    [Tags]    regression
    ${booking_id}=    Create Booking    Lucy    Chen    ${800}
    ${token}=    Get Auth Token
    Delete Booking    ${booking_id}    ${token}
    GET On Session    booker    /booking/${booking_id}    expected_status=404
