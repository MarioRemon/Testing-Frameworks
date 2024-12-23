from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class CommonMethods:
    def __init__(self):
        pass

    #DOC: This function counts the element
    @staticmethod
    def count_the_elements(driver, xpath):
        try:
            CommonMethods.wait_elements_presence(driver, xpath)
            return len(driver.find_elements(By.XPATH, xpath))
        except:
            return 0

    @staticmethod
    def wait_elements_presence(driver, xpath):
        try:
            return WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.XPATH, xpath)),"Cannot wait for all elements to be present")
        except Exception as e:
            return None

    @staticmethod
    def click_element(driver, xpath):
        try:
            WebDriverWait(driver, 10).until(
                EC.element_to_be_clickable((By.XPATH, xpath))
            )
            return driver.find_element(By.XPATH, xpath).click()
        except Exception as e:
            return None


    @staticmethod
    def get_element_text(driver, xpath):
        try:
            element = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.XPATH, xpath))
            )
            return element.text
        except:
            return None

    @staticmethod
    def check_element_not_visible(driver, xpath):
        try:
            WebDriverWait(driver, 10).until(
                EC.invisibility_of_element_located((By.XPATH, xpath))
            )
            return True
        except:
            return False
