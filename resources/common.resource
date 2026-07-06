*** Settings ***
Documentation     跨平台共用 keywords。平台專屬的放 resources/<platform>/。


*** Keywords ***
Log Test Start
    [Documentation]    在 log 中標記測試起點，方便平行執行時對照時間軸。
    Log    [START] ${TEST NAME} @ ${SUITE NAME}
