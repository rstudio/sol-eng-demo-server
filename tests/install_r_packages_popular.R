# Test that it is possible to install a subset of the most popular R packages
# used by Posit Workbench users.

options(
    repos = c(
        CRAN = "https://packagemanager.rstudio.com/cran/__linux__/jammy/latest"
    )
)

# Install pak for faster package installation of other packages.
install.packages("pak")

# Install test packages
install.packages(
    pkgs = c(
        "tidyverse",
        "tidymodels",
        "DBI",
        "odbc",
        "rsconnect",
        "connectapi"
    )
)
