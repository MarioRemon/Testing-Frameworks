*** Settings ***
Library  SeleniumLibrary
Resource  ../resources/keywords/custom_keywords.robot
Resource  ../resources/keywords/homepage_keywords.robot
Resource  ../resources/keywords/phonePage_keywords.robot
Library     DataDriver      ../testdata/data_csv.csv
Test Template   FirstTestCase using NumberOfItems, phoneName, phoneId, phonePrice, phoneDescription

Suite Setup  LaucnhBrowser   ${browser}  ${url}
Suite Teardown  Close All Browsers

Test Setup  GoToUrl     ${url}
Test Teardown  log to console      End of Testcase

*** Variables ***
${browser}  chrome
${url}  https://www.demoblaze.com/

*** Test Cases ***
FirstTestCase using NumberOfItems ${NumberOfItems}, phoneName ${phoneName}, phoneId ${phoneId}, phonePrice ${phonePrice}, phoneDescription ${phoneDescription}

*** Keywords ***
FirstTestCase using NumberOfItems, phoneName, phoneId, phonePrice, phoneDescription
    [Arguments]    ${NumberOfItems}   ${phoneName}    ${phoneId}   ${phonePrice}    ${phoneDescription}
    Wait Until Page is Fully Loaded
    ${HomePageItemsCount}=  Get HomePage items Count
    Click Next
    Wait Until The Next Is Invisible
    ${NextPageItemsCount}=  Get HomePage items Count
    ${TotalNumberOfItems}=  Evaluate    ${HomePageItemsCount} + ${NextPageItemsCount}
    ${NumberOfItems_integer}=   Evaluate    int(${NumberOfItems})
    Should Be Equal     ${TotalNumberOfItems}   ${NumberOfItems_integer}

    Navigate To Phones
    Select a Phone By Name   ${phoneName}  ${phoneId}

    ${expected_price_integer}=      Evaluate    int(${phonePrice})
    Check The Price Of The Phone    ${expected_price_integer}

    Check The Description Of The Phone      ${phoneDescription}
