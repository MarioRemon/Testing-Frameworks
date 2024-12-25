import pytest
import requests
import environment

@pytest.fixture(scope="function")
def petId():

    # New Pet's Attributes
    pet_id = 1234
    category_id = 4321
    category_name = "Cats"
    pet_name = "Super"
    photo_url = "https://asd.com"
    tag_id = 7890
    tag_name = "Tag 0"
    status = "available"

    # Post request body
    payload = {
  "id": pet_id,
  "category": {
    "id": category_id,
    "name": category_name
  },
  "name": pet_name,
  "photoUrls": [photo_url],
  "tags": [
    {
      "id": tag_id,
      "name": tag_name
    }
  ],
  "status": status
}

    # Setup: Create a new Pet
    response_post = requests.post(f"{environment.base_url}/pet", json=payload, headers=environment.HEADERS)

    # Assert Status code success
    assert response_post.status_code == 200, f"Setup Failed with status code {response_post.status_code} in Post request"

    # Assert Response headers
    for header, header_value in environment.HEADERS.items():
        assert environment.HEADERS.get(header) == header_value, f"Header {header} mismatch: Expected {header_value}, but got {environment.HEADERS.get(header)}"

    response_json = response_post.json()

    print("The response of the Post request:", response_json)

    # Assert response body is identical to the request body
    assert response_json == payload, f"Post response body Expected {payload}, but got {response_json}"

    # Assert specific fields in the response body
    assert pet_id == response_json["id"], f"pet_id in Post response body Expected {pet_id}, but got {response_json["id"]}"
    assert category_id == response_json["category"]["id"], f"category_id in Post response body Expected {category_id}, but got {response_json["category"]["id"]}"
    assert category_name == response_json["category"]["name"], f"category_name in Post response body Expected {category_name}, but got {response_json["category"]["name"]}"
    assert pet_name == response_json["name"], f"pet_name in Post response body Expected {pet_name}, but got {response_json["name"]}"
    assert photo_url in response_json["photoUrls"], f"photo_url in Post response body Expected {photo_url}, but got {response_json["photoUrls"]}"
    assert tag_id == response_json["tags"][0]["id"], f"tag_id in Post response body Expected {tag_id}, but got {response_json["tags"][0]["id"]}"
    assert tag_name == response_json["tags"][0]["name"], f"tag_name in  Post response body Expected {tag_name}, but got {response_json["tags"][0]["name"]}"
    assert status == response_json["status"], f"status in Post response body Expected {status}, but got {response_json["status"]}"

    # Assert the response time is less than 1000ms
    assert response_post.elapsed.total_seconds() < 1, f"Post response for creation a new pet took too long: {response_post.elapsed.total_seconds()} seconds"

    # Assert the pet is created and can be retrieved by Get request
    response_get = requests.get(f"{environment.base_url}/pet/{pet_id}", headers=environment.HEADERS)
    assert response_get.status_code == 200, f"Setup Failed with status code{response_get.status_code} in Get request"

    # Assert Response headers
    for header, header_value in environment.HEADERS.items():
        assert environment.HEADERS.get(
            header) == header_value, f"Header {header} mismatch: Expected {header_value}, but got {environment.HEADERS.get(header)}"

    response_json = response_get.json()
    assert response_json == payload, f"Get response body Expected {payload}, but got {response_json}"

    # Assert the response time is less than 1000ms
    assert response_get.elapsed.total_seconds() < 1, f"Get response for retrieving the data new pet took too long: {response_get.elapsed.total_seconds()} seconds"

    yield pet_id

    # Teardown: Delete the new pet
    response_delete = requests.delete(f"{environment.base_url}/pet/{pet_id}", headers=environment.HEADERS)
    assert response_delete.status_code == 200, f"Teardown Failed with status code {response_delete.status_code} in Delete request"

    # Assert Response headers
    for header, header_value in environment.HEADERS.items():
        assert environment.HEADERS.get(
            header) == header_value, f"Header {header} mismatch: Expected {header_value}, but got {environment.HEADERS.get(header)}"

    # Assert the response time is less than 1000ms
    assert response_delete.elapsed.total_seconds() < 1, f"Delete response for deleting the pet took too long: {response_delete.elapsed.total_seconds()} seconds"

    # Assert the new pet is deleted and can't be retrieved again by Get request
    response_get = requests.get(f"{environment.base_url}/pet/{pet_id}", headers=environment.HEADERS)
    assert response_get.status_code == 404, f"Teardown Failed with status code{response_get.status_code} in Get request"

    # Assert Response headers
    for header, header_value in environment.HEADERS.items():
        assert environment.HEADERS.get(
            header) == header_value, f"Header {header} mismatch: Expected {header_value}, but got {environment.HEADERS.get(header)}"

    # Assert the response time is less than 1000ms
    assert response_get.elapsed.total_seconds() < 1, f"Get response for retrieving the data of the deleted pet took too long: {response_get.elapsed.total_seconds()} seconds"
