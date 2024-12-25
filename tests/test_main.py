import requests
import environment

class TestMain:

    def test_main_scenario(self, petId):
        print("The Pet Id for this testcase is ", petId)

        # Updated Pet's Attributes
        category_id = 4321
        category_name = "Cats"
        pet_name = "Super Mario"
        photo_url = "https://asd.com"
        tag_id = 7890
        tag_name = "Tag 0 updated"
        status = "sold"

        # Put request body
        payload = {
            "id": petId,
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

        # Update the pet attributes
        response_put = requests.put(f"{environment.base_url}/pet", json=payload, headers=environment.HEADERS)

        # Assert Status code success
        assert response_put.status_code == 200, f"Put request Failed with status code {response_put.status_code}"

        # Assert Response headers
        for header, header_value in environment.HEADERS.items():
            assert environment.HEADERS.get(
                header) == header_value, f"Header {header} mismatch: Expected {header_value}, but got {environment.HEADERS.get(header)}"

        response_json = response_put.json()

        print("The response of the Put request:", response_json)

        # Assert response body is identical to the request body
        assert response_json == payload, f"Put response body Expected {payload}, but got {response_json}"

        # Assert specific fields in the response body
        assert petId == response_json["id"], f"pet_id in Put response body Expected {petId}, but got {response_json["id"]}"
        assert category_id == response_json["category"]["id"], f"category_id in Put response body Expected {category_id}, but got {response_json["category"]["id"]}"
        assert category_name == response_json["category"]["name"], f"category_name in Put response body Expected {category_name}, but got {response_json["category"]["name"]}"
        assert pet_name == response_json["name"], f"pet_name in Put response body Expected {pet_name}, but got {response_json["name"]}"
        assert photo_url in response_json["photoUrls"], f"photo_url in Put response body Expected {photo_url}, but got {response_json["photoUrls"]}"
        assert tag_id == response_json["tags"][0]["id"], f"tag_id in Put response body Expected {tag_id}, but got {response_json["tags"][0]["id"]}"
        assert tag_name == response_json["tags"][0]["name"], f"tag_name in Put response body Expected {tag_name}, but got {response_json["tags"][0]["name"]}"
        assert status == response_json["status"], f"status in Put response body Expected {status}, but got {response_json["status"]}"

        # Assert the response time is less than 1000ms
        assert response_put.elapsed.total_seconds() < 1, f"Put response for editing the data of the pet took too long: {response_put.elapsed.total_seconds()} seconds"

        # Verify the update of pet's attributes
        response_get = requests.get(f"{environment.base_url}/pet/{petId}", headers=environment.HEADERS)
        assert response_get.status_code == 200, f"Get pet by pet id failed with status code{response_get.status_code}"

        # Assert Response headers
        for header, header_value in environment.HEADERS.items():
            assert environment.HEADERS.get(
                header) == header_value, f"Header {header} mismatch: Expected {header_value}, but got {environment.HEADERS.get(header)}"

        response_json = response_get.json()
        assert response_json == payload, f"Get response body Expected {payload}, but got {response_json}"

        # Assert specific fields in the response body
        assert petId == response_json["id"], f"pet_id in Get response body Expected {petId}, but got {response_json["id"]}"
        assert category_id == response_json["category"]["id"], f"category_id in Get response body Expected {category_id}, but got {response_json["category"]["id"]}"
        assert category_name == response_json["category"]["name"], f"category_name in Get response body Expected {category_name}, but got {response_json["category"]["name"]}"
        assert pet_name == response_json["name"], f"pet_name in Get response body Expected {pet_name}, but got {response_json["name"]}"
        assert photo_url in response_json["photoUrls"], f"photo_url in Get response body Expected {photo_url}, but got {response_json["photoUrls"]}"
        assert tag_id == response_json["tags"][0]["id"], f"tag_id in Get response body Expected {tag_id}, but got {response_json["tags"][0]["id"]}"
        assert tag_name == response_json["tags"][0]["name"], f"tag_name in Get response body Expected {tag_name}, but got {response_json["tags"][0]["name"]}"
        assert status == response_json["status"], f"status in Get response body Expected {status}, but got {response_json["status"]}"

        # Assert the response time is less than 1000ms
        assert response_get.elapsed.total_seconds() < 1, f"Get response for retrieving the data of the updated pet took too long: {response_get.elapsed.total_seconds()} seconds"