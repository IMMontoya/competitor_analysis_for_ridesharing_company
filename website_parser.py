# %% website_parser
# Import libraries
import requests
from bs4 import BeautifulSoup
import pandas as pd

# Specify the URL
url = 'https://practicum-content.s3.us-west-1.amazonaws.com/data-analyst-eng/moved_chicago_weather_2017.html'

# Get the HTML of the page
response = requests.get(url)

# Parse HTML
soup = BeautifulSoup(response.text, 'lxml')

# Find the table
table = soup.find('table', attrs={'id': 'weather_records'})


# Put table headings into a list
table_headings = []

for th in table.find_all('th'):
    table_headings.append(th.text)


# Put content of table into a list of lists
content = []

for tr in table.find_all('tr'):
    if not tr.find_all('th'):
        content.append([td.text for td in tr.find_all('td')])

# Create a DataFrame
weather_records = pd.DataFrame(content, columns=table_headings)

print(weather_records)

# %%
