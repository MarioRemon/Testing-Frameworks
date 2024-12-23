import pytest
from pages.homePage import HomePage
from pages.phonePage import PhonePage
from data.data_handling import *


class TestMain:
    @pytest.mark.parametrize(
        "NumberOfItems, phoneName, phoneId, phonePrice, phoneDescription",
        [(item["NumberOfItems"], item["phoneName"], item["phoneId"], item["phonePrice"], item["phoneDescription"])
         for item in load_json_data("../data/data_json.json")]
    )
    def test_main(self, driver, NumberOfItems, phoneName, phoneId, phonePrice, phoneDescription):
        homePage = HomePage(driver)

        # Check the DOM is completely ready.
        homePage.wait_until_homepage_fully_loaded()

        # Check the number of items in the homepage and the next page
        home_page_number_elements = homePage.get_items_count()
        homePage.click_next()
        assert homePage.check_next_btn_not_visible()
        next_number_elements = homePage.get_items_count()
        total_number_of_items = home_page_number_elements + next_number_elements
        assert total_number_of_items == int(NumberOfItems), f"Expected 15 but found {total_number_of_items}"

        # Navigate to Phones
        homePage.navigate_to_phones()
        expected_url = homePage.select_phone_by_name(phoneName, phoneId)
        assert driver.current_url == expected_url, f"Expected {expected_url} but found {driver.current_url}"

        phonePage = PhonePage(driver)

        # Check the price of the phone as expected or not
        phone_price = int(phonePage.get_the_price())
        assert phone_price == int(phonePrice), f"Expected URL to be {phonePrice}, but got{phone_price}"

        # Check the description of the phone as expected or not
        actual_description = phonePage.get_phone_description()
        expected_description = """The HTC One M9 is powered by 1.5GHz octa-core Qualcomm Snapdragon 810 processor and it comes with 3GB of RAM. The phone packs 32GB of internal storage that can be expanded up to 128GB via a microSD card."""
        assert actual_description == phoneDescription, f"Expected description to be {phoneDescription}, but found {actual_description}"
