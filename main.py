import yaml
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException
from concurrent.futures import ThreadPoolExecutor


def read_config():
    with open('projects.yaml', 'r') as file:
        return yaml.safe_load(file).split(" ")


FAILS_COUNT = 0


def press_the_button(url, value='[data-testid="wakeup-button-viewer"]'):
    global FAILS_COUNT
    chrome_options = Options()
    driver = webdriver.Chrome(service=Service(), options=chrome_options)
    driver.get(url)
    driver.implicitly_wait(5)

    try:
        button = driver.find_element(By.CSS_SELECTOR, value)
    except NoSuchElementException:
        if FAILS_COUNT < 2:
            FAILS_COUNT += 1
            return press_the_button(url, value='[data-testid="wakeup-button-owner"]')
        else:
            raise NoSuchElementException(msg=f'The button was not found on {url}')

    button.click()
    driver.implicitly_wait(4)
    driver.quit()


def execute_in_threads(urls):
    with ThreadPoolExecutor() as executor:
        futures = [executor.submit(press_the_button, url=url) for url in urls]

    for future in futures:
        try:
            future.result()
        except NoSuchElementException as err:
            print({str(err)})
            continue


urls = read_config()
execute_in_threads(urls)
