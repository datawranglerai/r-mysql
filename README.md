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
