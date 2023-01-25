# Loading Data into R

## Objectives
In this exercise, you will explore the different types of data that can be loaded into R for processing.

### Overview
R has tremendous flexibility in reading data. This exercise will allow you to load internal data sets, .csv files, web pages (webscraping) and XML. We will also load data from a nonrelational (NoSQL) data source.


3. View all loaded packages

` library() `

 4. List all the data sets available in loaded package


` data()`

 5. Load the AirPassengers data set into memory


`data(AirPassengers)`

 6. View the AirPassengers data set


`AirPassengers`

7. Load some other of the available data sets into memory and view them

`data(BJsales)`

8. When you have loaded a number of data sets into memory, list all loaded data sets


`ls()`

9. Remove the AirPassengers data set from memory and confirm that it has been removed


`rm(AirPassengers)`

10. Remove all loaded data sets from memory
`rm(list=ls())`

11. View data sets available in the rpart package
data(package="rpart")

12. View the current working directory in R
`getwd()`


13. View the structure of the following .csv file using Textpad   C:\1253\Ex11-weather.csv
`myData <- read.csv("C:\\1253\\Ex11-weather.csv ", sep=",", header= TRUE); `

14. View the loaded data in a data viewer.  When you have finished, remove the data from memory 
```View(myData)
rm(myData)```

15. View the structure of the following .csv file using Textpad 	C:\1253\Ex11-weather2.csv
`myData <- read.csv("C:\\Course\\Ex11-weather2.csv ", sep=",", header= FALSE); `


16. Give column headings to the first few columns
`names(myData) <- c("Date","MinTemp","MaxTemp")`

24. Load the RMongo package into memory 
`library(RMongo)`

25. View RMongo help:
`? RMongo `

26. Connect to the database:
`mg1 <- mongoDbConnect('rainforest')`

27. Query which recordings have a runtime of 137 minutes:
`dbGetQuery(mg1,"video_recordings", 	'{"RunTime":137}')`

28. Close the connection:
`dbDisconnect (mg1) `

29. Load a web page into R and view it
`file <- readLines("http://en.wikipedia.org/wiki/Data_science")`

30. View the loaded data:
`file`

31. Load a HTML table from a website into R
```
library(XML)
library(httr)

url <- "http://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"

population <- GET(url)

population <- readHTMLTable(rawToChar(population$content), stringAsFactors = F)
```
32. View the loaded data (the 2nd element):
`View(population[[2]])`




