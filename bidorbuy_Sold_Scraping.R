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


#########################################################
                     #bind rows and save
##########################################################

table1 <- rbind(base1_200,table1)

write.xlsx(table1, "E:/Work/R Script/web scraping/table1.xlsx")

