from utilities.commonMethods import CommonMethods

class HomePage:

    #   Elements of the Home Page
    items = "//div[@id='tbodyid']//div[@class='col-lg-4 col-md-6 mb-4']"
    next_btn = "//button[@id='next2']"
    phones_hyperlink = "//a[@id='itemc' and text()='Phones']"
    phones_url = "https://www.demoblaze.com/#"

    def __init__(self, driver):
        self.driver = driver

    def wait_until_homepage_fully_loaded(self):
            return CommonMethods.wait_elements_presence(self.driver, "//*")

    def get_items_count(self):
        return CommonMethods.count_the_elements(self.driver, self.items)

    def click_next(self):
        return CommonMethods.click_element(self.driver, self.next_btn)

    def navigate_to_phones(self):
        CommonMethods.click_element(self.driver, self.phones_hyperlink)
        assert self.driver.current_url == self.phones_url, f"Expected URL to be {self.phones_url}, but got {self.driver.current_url}"

    def select_phone_by_name(self, phoneName, index):
        phoneXpath = f"//a[contains(text(),'{phoneName}')]"
        CommonMethods.click_element(self.driver, phoneXpath)
        return f"https://www.demoblaze.com/prod.html?idp_={index}"
        # assert self.driver.current_url == phoneUrl, f"Expected URL to be {phoneUrl}, but got {self.driver.current_url}"

    def check_next_btn_not_visible(self):
        return CommonMethods.check_element_not_visible(self.driver, self.next_btn)
