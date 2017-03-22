# BoB webscraper and EDA

This script is designed to jump onto the BoB website and gather all transactions data including but not limited to sellers, prices, categories, dates, etc

I automated this script on my free AWS EC2 instance - thus this script is run in the cloud. Specifically I set up a chron job to run this script every night at 1am so as not to flood the BoB server

The data collected is stored in csv format on my AWS EC2 instance

Then, once a month, I extract the csv files onto my laptop where I have build a python script in Ipython Notebook to consolidate and perform EDA
