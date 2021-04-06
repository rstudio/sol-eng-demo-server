CREATE directory load_dir as '/tmp/data';
GRANT read,write ON directory load_dir TO system;

CREATE TABLE flights (
    "year" INTEGER,
    "month" INTEGER,
    "day" INTEGER,
    "dep_time" INTEGER,
    "sched_dep_time" INTEGER,
    "dep_delay" FLOAT,
    "arr_time" INTEGER,
    "sched_arr_time" INTEGER,
    "arr_delay" FLOAT,
    "carrier" VARCHAR(100),
    "flight" INTEGER,
    "tailnum" VARCHAR(100),
    "origin" VARCHAR(100),
    "dest" VARCHAR(100),
    "air_time" FLOAT,
    "distance" FLOAT,
    "hour" FLOAT,
    "minute" FLOAT,
    "time_hour" DATE
)
ORGANIZATION EXTERNAL
(
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY load_dir
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE SKIP 1
        FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "'"
        (
            "year"          CHAR(100),
            "month"         CHAR(100),
            "day"           CHAR(100),
            "dep_time"        CHAR(100),
            "sched_dep_time"  CHAR(100),
            "dep_delay"       CHAR(100),
            "arr_time"        CHAR(100),
            "sched_arr_time"  CHAR(100),
            "arr_delay"       CHAR(100),
            "carrier"         CHAR(100),
            "flight"          CHAR(100),
            "tailnum"         CHAR(100),
            "origin"          CHAR(100),
            "dest"            CHAR(100),
            "air_time"        CHAR(100),
            "distance"        CHAR(100),
            "hour"            CHAR(100),
            "minute"          CHAR(100),
            "time_hour"       CHAR(100) DATE_FORMAT TIMESTAMP MASK "YYYY-MM-DD HH24:MI:SS"
        )
    )
    LOCATION ('flights.csv')
);

CREATE TABLE airports (
    "faa" VARCHAR(100),
    "name" VARCHAR(100),
    "lat" REAL,
    "lon" REAL,
    "alt" NUMBER,
    "tz" REAL,
    "dst" VARCHAR(100),
    "tzone" VARCHAR(100)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
    DEFAULT DIRECTORY load_dir
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE SKIP 1
        FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "'"
    )
    LOCATION ('airports.csv')
);

CREATE TABLE airlines(
    "carrier" VARCHAR2(100),
    "name" VARCHAR2(100)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
    DEFAULT DIRECTORY load_dir
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE SKIP 1
        FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "'"
    )
    LOCATION ('airlines.csv')
);

CREATE TABLE mtcars(
    "mpg" REAL,
    "cyl" REAL,
    "disp" REAL,
    "hp" REAL,
    "drat" REAL,
    "wt" REAL,
    "qsec" REAL,
    "vs" REAL,
    "am" REAL,
    "gear" REAL,
    "carb" REAL
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
    DEFAULT DIRECTORY load_dir
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE SKIP 1
        FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "'"
    )
    LOCATION ('mtcars.csv')
);

CREATE TABLE iris (
    "Sepal.Length" FLOAT,
    "Sepal.Width" FLOAT,
    "Petal.Length" FLOAT,
    "Petal.Width" FLOAT,
    "Species" VARCHAR2(100)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
    DEFAULT DIRECTORY load_dir
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE SKIP 1
        FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY "'"
    )
    LOCATION ('iris.csv')
);
