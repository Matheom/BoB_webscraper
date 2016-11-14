library(rvest)
library(dplyr)
library(xlsx)
library(tidyr)

#to extract categories, we need to go into each sold item and select category
#below is a function that does this - use it by linking it up to the title ie we have to click on title to get category


info_xtr <- function(x){
  page <- read_html(x)
  
  c1 <- page %>% html_nodes("#bc1") %>% html_text()
  c2 <- page %>% html_nodes("#bc2") %>% html_text()
  c3 <- page %>% html_nodes("#bc3") %>% html_text()
  
cbind(c1[1],c2[1],c3[1])
  
}

# Start the scraper ==============
#as url is variant, use scraper to run through all pages

base <- list()
for(i in 1:155)
{
  
  site = read_html(paste0("http://www.bidorbuy.co.za/jsp/category/Winners.jsp?pageNo=",i))
  
  #variables i want to extract on each page
  
  title <- site%>%html_nodes(".tradelist_title")%>%html_text()
  buyer <- site%>%html_nodes(".alias")%>%html_text()
  price <- site%>%html_nodes(".bigPriceText2")%>%html_text()
  date <- site%>%html_nodes(".time")%>%html_text()
  
  #go to sold page and extract category
  title_href <- html_nodes(site,".tradelist_title a") %>% html_attr("href")
  
  cat <- as.matrix(sapply(title_href, function(x) info_xtr(x)))
  cat <- t(cat) 
  row.names(cat) <- NULL
  colnames(cat) <- c("cat1", "cat2", "cat3")
  
  
  # bind all the information into a nicely formatted data.frame()
  base[[i]] <- data.frame(title,buyer,price,date, cat, stringsAsFactors = F) 
  
  # I add in a sleep as not the flood the website that I am scraping with requests
  #Sys.sleep(runif(1,0,3))
  
}

#with all obersrvations collected per page, I bind rows to form one sexy table

base1_200 <- bind_rows(base)
base1_200$price <- as.numeric(gsub("[^0-9]","",base1_200$price))

#parse date
date <- t(data.frame(strsplit(base1_200$date, " ")))
rownames(date) <- NULL
colnames(date) <- c("closed" , "day", "month", "time" )

date1 <- as.data.frame(date)


base1_200$month <- date1$month
base1_200$day <- date1$day
base1_200$time <- date1$time


########3

table1 <- rbind(base1_200,table1)




write.xlsx(table1, "E:/Work/R Script/web scraping/table1.xlsx")


# Start the scraper ==============
#as url is variant, use scraper to run through all pages

base <- list()
for(i in 201:400)
{
  
site = read_html(paste0("http://www.bidorbuy.co.za/jsp/category/Winners.jsp?pageNo=",i))

#variables i want to extract on each page

title <- site%>%html_nodes(".tradelist_title")%>%html_text()
buyer <- site%>%html_nodes(".alias")%>%html_text()
price <- site%>%html_nodes(".bigPriceText2")%>%html_text()
date <- site%>%html_nodes(".time")%>%html_text()

#go to sold page and extract category
title_href <- html_nodes(site,".tradelist_title a") %>% html_attr("href")

# here I go collect all the information from each of the wines seperately
cat <- as.matrix(sapply(title_href, function(x) info_xtr(x)))
cat <- t(cat) 
row.names(cat) <- NULL
colnames(cat) <- c("cat1", "cat2", "cat3")


# bind all the information into a nicely formatted data.frame()
base[[i]] <- data.frame(title,buyer,price,date, cat, stringsAsFactors = F) 

# I add in a sleep as not the flood the website that I am scraping with requests
#Sys.sleep(runif(1,0,3))

}

#with all obersrvations collected per page, I bind rows to form one sexy table


base200_400 <- bind_rows(base)
base200_400$price <- as.numeric(gsub("[^0-9]","",base200_400$price))



# Start the scraper ==============
#as url is variant, use scraper to run through all pages

base <- list()
for(i in 401:600)
{
  
  site = read_html(paste0("http://www.bidorbuy.co.za/jsp/category/Winners.jsp?pageNo=",i))
  
  #variables i want to extract on each page
  
  title <- site%>%html_nodes(".tradelist_title")%>%html_text()
  buyer <- site%>%html_nodes(".alias")%>%html_text()
  price <- site%>%html_nodes(".bigPriceText2")%>%html_text()
  date <- site%>%html_nodes(".time")%>%html_text()
  
  #go to sold page and extract category
  title_href <- html_nodes(site,".tradelist_title a") %>% html_attr("href")
  
  # here I go collect all the information from each of the wines seperately
  cat <- as.matrix(sapply(title_href, function(x) info_xtr(x)))
  cat <- t(cat) 
  row.names(cat) <- NULL
  colnames(cat) <- c("cat1", "cat2", "cat3")
  
  
  # bind all the information into a nicely formatted data.frame()
  base[[i]] <- data.frame(title,buyer,price,date, cat, stringsAsFactors = F) 
  
  # I add in a sleep as not the flood the website that I am scraping with requests
  #Sys.sleep(runif(1,0,3))
  
}

#with all obersrvations collected per page, I bind rows to form one sexy table


base400_600 <- bind_rows(base)
base400_600$price <- as.numeric(gsub("[^0-9]","",base400_600$price))


###################################################################################################
#lets get all data together and start structuring it
table1 <- rbind(base1_200,base200_400,base400_600)

#concatenate all cats for granular view

table1$fullcat <- paste(table1$cat1, table1$cat2,table1$cat3, sep = "ll")


#data exploration

hist(table1$price, breaks = 1000)


#only interested in items over R1k, let's see who the ain sellers are buy rand amount and volumes

y <- filter(table1, price > 1000)

hist(y$price, breaks = 1000, xlim = c(1000,10000))



majorplayers <- aggregate(y$price, by=list(Category=y$cat1), FUN=sum)
volumes <- aggregate(y$price, by=list(Category=y$cat1), FUN = function(x){NROW(x)})

majorplayers$volume <- volumes$x
majorplayers$avg <- majorplayers$x/majorplayers$volume

saveWorkbook(cars, "Cars_datasets.xlsx")

#save table 1
gtwd()
hist()

install.packages("readxl")

library(xlsx)
write.xlsx(table1, "E:/Work/R Script/web scraping/table1.xlsx")



WriteXLS(x, ExcelFileName = "R.xls"




#####################################################################################################


