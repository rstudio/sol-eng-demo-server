# Test data for the multiple databases

The R scripts here are used to generate the multiple `.csv` files.

We commit the data so it's easier to build the Docker images and add them to the databases without running any R scripts.

For the flights dataset we only include 1000 records since we don't need the whole dataset for our testing.

Special cases:

- MySQL doesn't allow empty values as `NULL`s, it has to be explictly `"NULL"`
- Hive can ignore the row headers by using `TBLPROPERTIES("skip.header.line.count"="1")` but impala won't respect it so have the CSV's without headers aswell.
This is a best practice anyway for Hadoop files.
