*** Settings ***
Library  RequestsLibrary
Library  Collections
Resource  ../resources/custom_keywords.robot

Test Setup  Setup
Test Teardown  Teardown

*** Test Cases ***
testcase1
    # Preparing the payload and headers for updating a pet

    # Create category dictionary
    ${category_dict_updated}=   create dictionary   id=${category_id_updated}    name=${category_name_updated}

    # Create tag dictionary to be inserted in the tags list
    ${tag_dict_updated}=        create dictionary   id=${tag_id_updated}    name=${tag_name_updated}

    # Create list for photoUrls
    ${photo_url_list_updated}=      create list     ${photo_url}

    # Create list for tags
    ${tag_list_updated}=    create list     ${tag_dict_updated}

    # Create payload dictionary for the Put request
    ${payload}=     create dictionary     id=${pet_id}    category=${category_dict_updated}   name=${pet_name_updated}    photoUrls=${photo_url_list_updated}     tags=${tag_list_updated}    status=${status_updated}

    # Create headers dictionary for the Put request
    ${Headers}     create dictionary   accept=${accept}     Content-Type=${Content-Type}

    # send a Put Request to update a Pet
    Create Session      mysession       ${base_url}
    ${response_put}=   PUT On Session  mysession     /pet    json=${payload}     headers=${Headers}

    # Validate the response status code
    Status Should Be  200   ${response_put}    Updating Pet detailes Failed with status code ${response_put.status_code} in Post request

    # Validate the response headers ignoring some headers
    dictionaries should be equal  ${response_put.headers}      ${Headers}           Header mismatch: Expected ${Headers}, but got ${response_put.headers}      ignore_keys=['accept', 'Date','Transfer-Encoding', 'Connection', 'Access-Control-Allow-Origin', 'Access-Control-Allow-Methods', 'Access-Control-Allow-Headers', 'Server']

    # Validate the response Content-Type header
    ${response_header_content_type}=    get from dictionary     ${response_put.headers}    Content-Type
    should be equal as strings  ${response_header_content_type}     ${Content-Type}         Header mismatch: Expected ${Content-Type}, but got ${response_header_content_type}

    # Assert response body is identical to the request body
#    Dictionaries Should Be Equal   ${response_put.json()}      ${payload}     Put response body Expected {payload}, but got {response_put.json()}

    # Validate each field in the Post response body
    ${put_response_petId}=   get from dictionary     ${response_put.json()}     id
    ${put_response_category_dict}=   get from dictionary     ${response_put.json()}     category
    ${put_response_petName}=   get from dictionary     ${response_put.json()}   name
    ${put_response_photo_url_list}=   get from dictionary     ${response_put.json()}     photoUrls
    ${put_response_tag_list}=   get from dictionary     ${response_put.json()}     tags
    ${put_response_status}=   get from dictionary     ${response_put.json()}    status

    # Validate the pet id
    should be equal as strings  ${put_response_petId}      ${pet_id}       pet_id in Put response body Expected ${pet_id}, but got ${put_response_petId}

#    Dictionaries Should Be Equal   ${put_response_category_dict}      ${category_dict_updated}
    should be equal as strings  ${put_response_category_dict}[id]      ${category_id_updated}      category_id in Post response body Expected ${category_id_updated}, but got ${put_response_category_dict}[id]
    should be equal as strings  ${put_response_category_dict}[name]      ${category_name_updated}  category_name in Post response body Expected ${category_name_updated}, but got ${put_response_category_dict}[name]

    should be equal as strings  ${put_response_petName}      ${pet_name_updated}       pet_name in Post response body Expected ${pet_name_updated}, but got ${put_response_petName}

    Lists Should Be Equal  ${put_response_photo_url_list}      ${photo_url_list_updated}       photo_url in Post response body Expected ${photo_url_list_updated}, but got ${put_response_photo_url_list}

#    Lists Should Be Equal  ${post_response_tag_list}      ${tag_list_updated}
    should be equal as strings  ${put_response_tag_list}[0][id]      ${tag_id_updated}     tag_id in Post response body Expected ${tag_id_updated}, but got ${put_response_tag_list}[0][id]
    should be equal as strings  ${put_response_tag_list}[0][name]      ${tag_name_updated}     tag_name in  Post response body Expected ${tag_name_updated}, but got ${put_response_tag_list}[0][name]


    should be equal as strings  ${put_response_status}      ${status_updated}      status in Post response body Expected ${status}, but got ${put_response_status}

    should be true  ${response_put.elapsed.total_seconds()}<2.0        Post response for creation a new pet took too long: ${response_put.elapsed.total_seconds()} seconds


    # Assert the pet is updated and can be retrieved by Get request
    Create Session      mysession       ${base_url}
    ${response_Get}=   GET On Session  mysession     /pet/${pet_id}      headers=${Headers}

    # Validate the response status code
    Status Should Be  200   ${response_Get}     Get pet by pet id failed with status code ${response_Get.status_code}

    # Validate the response headers ignoring some headers
    dictionaries should be equal  ${response_Get.headers}      ${Headers}     Header mismatch: Expected ${Headers}, but got ${response_Get.headers}      ignore_keys=['accept', 'Date','Transfer-Encoding', 'Connection', 'Access-Control-Allow-Origin', 'Access-Control-Allow-Methods', 'Access-Control-Allow-Headers', 'Server']

    # Validate the response Content-Type header
    ${response_header_content_type}=    get from dictionary     ${response_Get.headers}    Content-Type
    should be equal as strings  ${response_header_content_type}     ${Content-Type}     Header mismatch: Expected ${Content-Type}, but got ${response_header_content_type}

    # Assert response body is identical to the request body
#    Dictionaries Should Be Equal   ${response_Get.json()}      ${payload}      Get response body Expected {payload}, but got {response_Get.json()}

    # Validate each field in the Get response body
    ${get_response_petId}=   get from dictionary     ${response_Get.json()}     id
    ${get_response_category_dict}=   get from dictionary     ${response_Get.json()}     category
    ${get_response_petName}=   get from dictionary     ${response_Get.json()}   name
    ${get_response_photo_url_list}=   get from dictionary     ${response_Get.json()}     photoUrls
    ${get_response_tag_list}=   get from dictionary     ${response_Get.json()}     tags
    ${get_response_status}=   get from dictionary     ${response_Get.json()}    status

    # Validate the pet id
    should be equal as strings  ${get_response_petId}      ${pet_id}        pet_id in GET response body Expected ${pet_id}, but got ${get_response_petId}

#    Dictionaries Should Be Equal   ${get_response_category_dict}      ${category_dict}
    should be equal as strings  ${get_response_category_dict}[id]      ${category_id_updated}       category_id in GET response body Expected ${category_id_updated}, but got ${get_response_category_dict}[id]
    should be equal as strings  ${get_response_category_dict}[name]      ${category_name_updated}       category_name in GET response body Expected ${category_name_updated}, but got ${get_response_category_dict}[name]

    should be equal as strings  ${get_response_petName}      ${pet_name_updated}        pet_name in GET response body Expected ${pet_name_updated}, but got ${get_response_petName}

    Lists Should Be Equal  ${get_response_photo_url_list}      ${photo_url_list_updated}        photo_url in GET response body Expected ${photo_url_list_updated}, but got ${get_response_photo_url_list}

#    Lists Should Be Equal  ${post_response_tag_list}      ${tag_list}
    should be equal as strings  ${get_response_tag_list}[0][id]      ${tag_id_updated}      tag_id in GET response body Expected ${tag_id_updated}, but got ${get_response_tag_list}[0][id]
    should be equal as strings  ${get_response_tag_list}[0][name]      ${tag_name_updated}      tag_name in  GET response body Expected ${tag_name_updated}, but got ${get_response_tag_list}[0][name]


    should be equal as strings  ${get_response_status}      ${status_updated}       status in GET response body Expected ${status_updated}, but got ${get_response_status}

    should be true  ${response_Get.elapsed.total_seconds()}<2.0     GET response for Updating a pet took too long: ${response_get.elapsed.total_seconds()} seconds



*** Variables ***
${category_id_updated}  4321
${category_name_updated}    Cats
${pet_name_updated}     Super Mario
${photo_url_updated}    https://asd.com
${tag_id_updated}       7890
${tag_name_updated}     Tag 0 updated
${status_updated}       sold

*** Keywords ***