library(dplyr)

# Source scripts
source('connect_to_mydb.R')
source('rmysql_update.R')

# My table looks like this:
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
con <- connect_to_mydb('playground')

# Run upate query
rmysql_update(con, example, 'iris', verbose = TRUE)

# Clean up connections
dbDisconnect(con)
