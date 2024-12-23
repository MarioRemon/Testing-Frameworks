import re

from utilities.commonMethods import CommonMethods

class PhonePage:
    # Elements of the Phone Page
    price = "//h3[@class='price-container']"
    phone_description = "//div[@id='more-information']//p"

    def __init__(self, driver):
        self.driver = driver

    def get_the_price(self):
        price = CommonMethods.get_element_text(self.driver, self.price)
        return re.sub(r'[^0-9]', '', price)

    def get_phone_description(self):
        return CommonMethods.get_element_text(self.driver, self.phone_description)
