library(dplyr)
library(datasets)
library(nycflights13)

flights %>%
  head(1000) %>%
  write.csv("./docker/data/flights.csv", na ="", row.names = FALSE, quote = FALSE)

airlines %>%
  write.csv("./docker/data/airlines.csv", na ="", row.names = FALSE, quote = FALSE)

airports %>%
  write.csv("./docker/data/airports.csv", na ="", row.names = FALSE, quote = FALSE)

mtcars %>%
  write.csv("./docker/data/mtcars.csv", na ="", row.names = FALSE, quote = FALSE)

iris %>%
  write.csv("./docker/data/iris.csv", na ="", row.names = FALSE, quote = FALSE)

# MySQL needs NAs to be `NULL`
flights %>%
  head(1000) %>%
  write.csv("./docker/data/flights-null.csv", na ="NULL", row.names = FALSE, quote = FALSE)

