*** Settings ***
Library  SeleniumLibrary
Variables  ../../pages/homepage.py

*** Keywords ***
Wait Until Page is Fully Loaded
    Wait For Elements To Be Present     //*

Get HomePage items Count
    ${count}=   Get Element Count   ${items}
    [RETURN]  ${count}

Click Next
    Click Button    ${next_btn}
Wait Until The Next Is Invisible
    Wait For Element Not To Be Present  ${next_btn}

Navigate To Phones
    Click Link  ${phones_hyperlink}
    Validate Current Url    ${phones_url}

Select a Phone By Name
    [Arguments]     ${phoneName}     ${index}
    ${xpath}=    Set Variable    xpath://a[contains(text(),'${phoneName}')]
    Click Element   ${xpath}
    ${phonePageUrl}=    Set Variable    https://www.demoblaze.com/prod.html?idp_=${index}
    Validate Current Url    ${phonePageUrl}
