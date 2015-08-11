from lxml import html
import requests
import matplotlib.pyplot as plt
import numpy as np
import time
from selenium import webdriver


page = requests.get('http://controls.als.lbl.gov/als-beamstatus/curvals')
tree = html.fromstring(page.text)

#This will create a list of buyers:
#buyers = tree.xpath('/html/body/text()')


driver = webdriver.Firefox()
html_page = driver.get('http://controls.als.lbl.gov/als-beamstatus/curvals')

print html_page











