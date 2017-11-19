# r-mysql
Custom functions for using MySQL database with R

# UPDATE a MySQL table
Currently MySQL functions built into packages like RMySQL and dbplyr allow you to INSERT data into a table, with the choice to append or overwrite. rmysql_update() provides  an easy way to UPDATE a table so that if duplicate records are found, it will update the row with the new data, minus any primary key values.

Here is an example of how it can be used.

```R
library(dplyr)

# Source scripts
source('connect_to_mydb.R')
source('rmysql_update.R')

# In my database, I have a table that looks like this:
#
# Id | SepalLength | SepalWidth | PetalLength | PetalWidth | Species
# ---+-------------+------------+-------------+------------+---------
#  1 |    5.1      |     3.5    |     1.4     |     0.2    | setosa

# Load in data set
data(iris)
example <- iris %>%
  setNames(gsub('\\.', '', names(.))) %>% # remove punctuation from column names
  mutate(Id = row_number()) %>%
  select(Id, everything())

# Make some changes
example[5, 'SepalLength'] <- 70.2
example[6, 'Species']     <- 'virginica'
example[7, 'SepalWidth']  <- 150.3

# Establish connection to database
con <- connect_to_mydb('database_name')

# Run upate query
rmysql_update(con, example, 'iris', verbose = TRUE)

# Clean up connections
dbDisconnect(con)
```
---
title: "How to UPDATE a MySQL table"
author: "datawranglerai"
date: "11/19/2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
suppressMessages(library(dplyr))
suppressMessages(library(DBI))
suppressMessages(library(RMySQL))

source('connect_to_mydb.R')
source('rmysql_update.R')

# Establish connection to a schema, mine is called 'playground'
con <- connect_to_mydb('playground')

# Have a look at the data already in the database
mytable <- dbReadTable(con, 'iris')
head(mytable, 10)

# Make some changes
new_data <- mytable[1:10, ]

new_data[5, 'SepalLength'] <- 70.2
new_data[6, 'Species']     <- 'virginica'
new_data[7, 'SepalWidth']  <- 150.3

new_data

# Run upate query
rmysql_update(con, new_data, 'iris', verbose = TRUE)

# Check that it worked
mytable <- dbReadTable(con, 'iris')
head(mytable, 10)

# Clean up connections
dbDisconnect(con)

```
