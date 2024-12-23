*** Settings ***
Library  SeleniumLibrary
Variables  ../../pages/phonePage.py

*** Keywords ***
Get The Price Of The Phone
    ${price_text}=   Get Text   ${price}
    ${price_value}=    Evaluate    re.sub(r'[^0-9]', '', '''${price_text}''')    modules=re
    ${price_number}=    Evaluate    int(${price_value})
    [RETURN]    ${price_number}

Check The Price Of The Phone
    [Arguments]     ${expected_price}
    ${price}=   Get The Price Of The Phone
    Should be equal     ${price}   ${expected_price}

Check The Description Of The Phone
    [Arguments]     ${expected_Description}
    ${actual_Description}=   Get Text   ${phone_description}
    Should Be Equal     ${actual_Description}   ${expected_Description}
