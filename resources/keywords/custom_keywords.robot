*** Settings ***
Library  SeleniumLibrary
Library  ../resources/scripts/webdriver.py

*** Keywords ***
LaucnhBrowser
    [Arguments]  ${browser}    ${url}
    ${driver}=  Get Driver  ${browser}
    Open Browser  ${url}    ${browser}  executable_path=${driver}
    Maximize Browser Window
    Set Selenium Implicit Wait   10s
GoToUrl
    [Arguments]  ${url}
    Go To    ${url}

Wait For Elements To Be Present
    [Arguments]     ${xpath}
    Wait Until Keyword Succeeds   10s   1s   Element Should Be Visible   ${xpath}
Wait For Element Not To Be Present
    [Arguments]     ${xpath}
    Wait Until Keyword Succeeds   15s   1s   Element Should Not Be Visible   ${xpath}

Validate Current Url
    [Arguments]    ${expected_url}
    ${current_url}=    Get Location
    Should Be Equal    ${current_url}    ${expected_url}