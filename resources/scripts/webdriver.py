from webdriver_manager.chrome import ChromeDriverManager

def get_driver(browser_name):
    """
    Driver
    """
    if browser_name.lower() == "chrome":
        driver = ChromeDriverManager().install()
        return driver
    else:
        raise ValueError(f"Unsupported browser: ")
