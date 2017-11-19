How to UPDATE a MySQL table
================
datawranglerai
11/19/2017

Currently, packages for working with MySQL databses from R allow you to insert new data into tables, with the option of either appending or overwriting existing information.

rmysql_update() provides a way to UPDATE tables existing records with new information if duplicate records are found, identified by the primary key.

The code below demonstrates exactly how to use rmysql_update() function to achieve this.

``` r
library(dplyr)
library(DBI)
library(RMySQL)

source('connect_to_mydb.R')
source('rmysql_update.R')

# Establish connection to a schema, mine is called 'playground'
con <- connect_to_mydb('playground')
```

    ## Attempting to connect to playground 
    ## Connection successful!

``` r
# Have a look at the data already in the database
mytable <- dbReadTable(con, 'iris')
head(mytable, 10)
```

    ##    Id SepalLength SepalWidth PetalLength PetalWidth   Species
    ## 1   1         5.1        3.5         1.4        0.2    setosa
    ## 2   2         4.9        3.0         1.4        0.2    setosa
    ## 3   3         4.7        3.2         1.3        0.2    setosa
    ## 4   4         4.6        3.1         1.5        0.2    setosa
    ## 5   5        70.2        3.6         1.4        0.2    setosa
    ## 6   6         5.4        3.9         1.7        0.4 virginica
    ## 7   7         4.6      150.3         1.4        0.3    setosa
    ## 8   8         5.0        3.4         1.5        0.2    setosa
    ## 9   9         4.4        2.9         1.4        0.2    setosa
    ## 10 10         4.9        3.1         1.5        0.1    setosa

``` r
# Make some changes
new_data <- mytable[1:10, ]

new_data[5, 'SepalLength'] <- 70.2
new_data[6, 'Species']     <- 'virginica'
new_data[7, 'SepalWidth']  <- 150.3

new_data
```

    ##    Id SepalLength SepalWidth PetalLength PetalWidth   Species
    ## 1   1         5.1        3.5         1.4        0.2    setosa
    ## 2   2         4.9        3.0         1.4        0.2    setosa
    ## 3   3         4.7        3.2         1.3        0.2    setosa
    ## 4   4         4.6        3.1         1.5        0.2    setosa
    ## 5   5        70.2        3.6         1.4        0.2    setosa
    ## 6   6         5.4        3.9         1.7        0.4 virginica
    ## 7   7         4.6      150.3         1.4        0.3    setosa
    ## 8   8         5.0        3.4         1.5        0.2    setosa
    ## 9   9         4.4        2.9         1.4        0.2    setosa
    ## 10 10         4.9        3.1         1.5        0.1    setosa

``` r
# Run upate query
rmysql_update(con, new_data, 'iris', verbose = TRUE)
```

    ## Performing query 1 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('1', '5.1', '3.5', '1.4', '0.2', 'setosa') ON DUPLICATE KEY UPDATE SepalLength = '5.1', SepalWidth = '3.5', PetalLength = '1.4', PetalWidth = '0.2', Species = 'setosa'; 
    ## 
    ## Performing query 2 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('2', '4.9', '3', '1.4', '0.2', 'setosa') ON DUPLICATE KEY UPDATE SepalLength = '4.9', SepalWidth = '3', PetalLength = '1.4', PetalWidth = '0.2', Species = 'setosa'; 
    ## 
    ## Performing query 3 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('3', '4.7', '3.2', '1.3', '0.2', 'setosa') ON DUPLICATE KEY UPDATE SepalLength = '4.7', SepalWidth = '3.2', PetalLength = '1.3', PetalWidth = '0.2', Species = 'setosa'; 
    ## 
    ## Performing query 4 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('4', '4.6', '3.1', '1.5', '0.2', 'setosa') ON DUPLICATE KEY UPDATE SepalLength = '4.6', SepalWidth = '3.1', PetalLength = '1.5', PetalWidth = '0.2', Species = 'setosa'; 
    ## 
    ## Performing query 5 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('5', '70.2', '3.6', '1.4', '0.2', 'setosa') ON DUPLICATE KEY UPDATE SepalLength = '70.2', SepalWidth = '3.6', PetalLength = '1.4', PetalWidth = '0.2', Species = 'setosa'; 
    ## 
    ## Performing query 6 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('6', '5.4', '3.9', '1.7', '0.4', 'virginica') ON DUPLICATE KEY UPDATE SepalLength = '5.4', SepalWidth = '3.9', PetalLength = '1.7', PetalWidth = '0.4', Species = 'virginica'; 
    ## 
    ## Performing query 7 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('7', '4.6', '150.3', '1.4', '0.3', 'setosa') ON DUPLICATE KEY UPDATE SepalLength = '4.6', SepalWidth = '150.3', PetalLength = '1.4', PetalWidth = '0.3', Species = 'setosa'; 
    ## 
    ## Performing query 8 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('8', '5', '3.4', '1.5', '0.2', 'setosa') ON DUPLICATE KEY UPDATE SepalLength = '5', SepalWidth = '3.4', PetalLength = '1.5', PetalWidth = '0.2', Species = 'setosa'; 
    ## 
    ## Performing query 9 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('9', '4.4', '2.9', '1.4', '0.2', 'setosa') ON DUPLICATE KEY UPDATE SepalLength = '4.4', SepalWidth = '2.9', PetalLength = '1.4', PetalWidth = '0.2', Species = 'setosa'; 
    ## 
    ## Performing query 10 of 10 :
    ##  INSERT INTO iris(Id, SepalLength, SepalWidth, PetalLength, PetalWidth, Species) VALUES('10', '4.9', '3.1', '1.5', '0.1', 'setosa') ON DUPLICATE KEY UPDATE SepalLength = '4.9', SepalWidth = '3.1', PetalLength = '1.5', PetalWidth = '0.1', Species = 'setosa';

``` r
# Check that it worked
mytable <- dbReadTable(con, 'iris')
head(mytable, 10)
```

    ##    Id SepalLength SepalWidth PetalLength PetalWidth   Species
    ## 1   1         5.1        3.5         1.4        0.2    setosa
    ## 2   2         4.9        3.0         1.4        0.2    setosa
    ## 3   3         4.7        3.2         1.3        0.2    setosa
    ## 4   4         4.6        3.1         1.5        0.2    setosa
    ## 5   5        70.2        3.6         1.4        0.2    setosa
    ## 6   6         5.4        3.9         1.7        0.4 virginica
    ## 7   7         4.6      150.3         1.4        0.3    setosa
    ## 8   8         5.0        3.4         1.5        0.2    setosa
    ## 9   9         4.4        2.9         1.4        0.2    setosa
    ## 10 10         4.9        3.1         1.5        0.1    setosa

``` r
# Clean up connections
dbDisconnect(con)
```

    ## [1] TRUE
