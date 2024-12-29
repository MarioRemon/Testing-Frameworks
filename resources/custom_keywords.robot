*** Settings ***
Library  RequestsLibrary
Library  Collections
Resource  ./environment.robot

*** Variables ***
${pet_id}   1234
${category_id}  4321
${category_name}    Cats
${pet_name}     Super
${photo_url}    https://asd.com
${tag_id}       7890
${tag_name}     Tag 0
${status}       available

*** Keywords ***
Setup
    # Preparing the payload and headers for adding a new pet

    # Create category dictionary
    ${category_dict}=   create dictionary   id=${category_id}    name=${category_name}

    # Create tag dictionary to be inserted in the tags list
    ${tag_dict}=        create dictionary   id=${tag_id}    name=${tag_name}

    # Create list for photoUrls
    ${photo_url_list}=      create list     ${photo_url}

    # Create list for tags
    ${tag_list}=    create list     ${tag_dict}

    # Create payload dictionary for the Post request
    ${payload}=     create dictionary     id=${pet_id}    category=${category_dict}   name=${pet_name}    photoUrls=${photo_url_list}     tags=${tag_list}    status=${status}

    # Create headers dictionary for the Post request
    ${Headers}     create dictionary   accept=${accept}     Content-Type=${Content-Type}

    # send a Post Request to add a new Pet
    Create Session      mysession       ${base_url}
    ${response_post}=   POST On Session  mysession     /pet    json=${payload}     headers=${Headers}

    # Validate the response status code
    Status Should Be  200   ${response_post}    Setup Failed with status code ${response_post.status_code} in Post request

    # Validate the response headers ignoring some headers
    dictionaries should be equal  ${response_post.headers}      ${Headers}           Header mismatch: Expected ${Headers}, but got ${response_post.headers}      ignore_keys=['accept', 'Date','Transfer-Encoding', 'Connection', 'Access-Control-Allow-Origin', 'Access-Control-Allow-Methods', 'Access-Control-Allow-Headers', 'Server']

    # Validate the response Content-Type header
    ${response_header_content_type}=    get from dictionary     ${response_post.headers}    Content-Type
    should be equal as strings  ${response_header_content_type}     ${Content-Type}         Header mismatch: Expected ${Content-Type}, but got ${response_header_content_type}

    # Assert response body is identical to the request body
#    Dictionaries Should Be Equal   ${response_post.json()}      ${payload}     Post response body Expected {payload}, but got {response_post.json()}

    # Validate each field in the Post response body
    ${post_response_petId}=   get from dictionary     ${response_post.json()}     id
    ${post_response_category_dict}=   get from dictionary     ${response_post.json()}     category
    ${post_response_petName}=   get from dictionary     ${response_post.json()}   name
    ${post_response_photo_url_list}=   get from dictionary     ${response_post.json()}     photoUrls
    ${post_response_tag_list}=   get from dictionary     ${response_post.json()}     tags
    ${post_response_status}=   get from dictionary     ${response_post.json()}    status

    # Validate the pet id
    should be equal as strings  ${post_response_petId}      ${pet_id}       pet_id in Post response body Expected ${pet_id}, but got ${post_response_petId}

#    Dictionaries Should Be Equal   ${post_response_category_dict}      ${category_dict}
    should be equal as strings  ${post_response_category_dict}[id]      ${category_id}      category_id in Post response body Expected ${category_id}, but got ${post_response_category_dict}[id]
    should be equal as strings  ${post_response_category_dict}[name]      ${category_name}  category_name in Post response body Expected ${category_name}, but got ${post_response_category_dict}[name]

    should be equal as strings  ${post_response_petName}      ${pet_name}       pet_name in Post response body Expected ${pet_name}, but got ${post_response_petName}

    Lists Should Be Equal  ${post_response_photo_url_list}      ${photo_url_list}       photo_url in Post response body Expected ${photo_url_list}, but got ${post_response_photo_url_list}

#    Lists Should Be Equal  ${post_response_tag_list}      ${tag_list}
    should be equal as strings  ${post_response_tag_list}[0][id]      ${tag_id}     tag_id in Post response body Expected ${tag_id}, but got ${post_response_tag_list}[0][id]
    should be equal as strings  ${post_response_tag_list}[0][name]      ${tag_name}     tag_name in  Post response body Expected ${tag_name}, but got ${post_response_tag_list}[0][name]


    should be equal as strings  ${post_response_status}      ${status}      status in Post response body Expected ${status}, but got ${post_response_status}

    should be true  ${response_post.elapsed.total_seconds()}<2.0        Post response for creation a new pet took too long: ${response_post.elapsed.total_seconds()} seconds


    # Assert the pet is created and can be retrieved by Get request
    Create Session      mysession       ${base_url}
    ${response_Get}=   GET On Session  mysession     /pet/${post_response_petId}      headers=${Headers}

    # Validate the response status code
    Status Should Be  200   ${response_Get}     Setup Failed with status code{response_Get.status_code} in Get request

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
    should be equal as strings  ${get_response_category_dict}[id]      ${category_id}       category_id in GET response body Expected ${category_id}, but got ${get_response_category_dict}[id]
    should be equal as strings  ${get_response_category_dict}[name]      ${category_name}       category_name in GET response body Expected ${category_name}, but got ${get_response_category_dict}[name]

    should be equal as strings  ${get_response_petName}      ${pet_name}        pet_name in GET response body Expected ${pet_name}, but got ${get_response_petName}

    Lists Should Be Equal  ${get_response_photo_url_list}      ${photo_url_list}        photo_url in GET response body Expected ${photo_url_list}, but got ${get_response_photo_url_list}

#    Lists Should Be Equal  ${post_response_tag_list}      ${tag_list}
    should be equal as strings  ${get_response_tag_list}[0][id]      ${tag_id}      tag_id in GET response body Expected ${tag_id}, but got ${get_response_tag_list}[0][id]
    should be equal as strings  ${get_response_tag_list}[0][name]      ${tag_name}      tag_name in  GET response body Expected ${tag_name}, but got ${get_response_tag_list}[0][name]


    should be equal as strings  ${get_response_status}      ${status}       status in GET response body Expected ${status}, but got ${get_response_status}

    should be true  ${response_Get.elapsed.total_seconds()}<2.0     GET response for creation a new pet took too long: ${response_get.elapsed.total_seconds()} seconds

    # Test variable can be used by the testcase
    set test variable  ${pet_id}    ${post_response_petId}

Teardown
    # Preparing the headers for deleting the new pet

    # Create headers dictionary for the Delete request
    ${Headers}     create dictionary   accept=${accept}     Content-Type=${Content-Type}

    # send a Delete Request to add a new Pet
    Create Session      mysession       ${base_url}
    ${response_delete}=   DELETE On Session  mysession     /pet/${pet_id}      headers=${Headers}

    # Validate the response status code
    Status Should Be  200   ${response_delete}      Teardown Failed with status code{response_delete.status_code} in DELETE request

    # Validate the response headers ignoring some headers
    dictionaries should be equal  ${response_delete.headers}      ${Headers}       Header mismatch: Expected ${Headers}, but got ${response_delete.headers}     ignore_keys=['accept', 'Date','Transfer-Encoding', 'Connection', 'Access-Control-Allow-Origin', 'Access-Control-Allow-Methods', 'Access-Control-Allow-Headers', 'Server']

    # Validate the response Content-Type header
    ${response_header_content_type}=    get from dictionary     ${response_delete.headers}    Content-Type
    should be equal as strings  ${response_header_content_type}     ${Content-Type}     Header mismatch: Expected ${Content-Type}, but got ${response_header_content_type}

    should be true  ${response_delete.elapsed.total_seconds()}<2.0      DELETE response for creation a new pet took too long: ${response_delete.elapsed.total_seconds()} seconds

    # Assert the pet is deleted and can't be retrieved by Get request
    Create Session      mysession       ${base_url}
    run keyword and expect error    *   GET On Session    mysession     /pet/${pet_id}      headers=${Headers}      Teardown Failed in Get request
