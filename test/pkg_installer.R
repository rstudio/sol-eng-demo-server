options(repos = c(REPO_NAME = "https://packagemanager.rstudio.com/cran/__linux__/jammy/latest"))

install.packages("pak")

packages_to_install <- read.csv("pkg_names.csv", stringsAsFactors = FALSE)$package

pak::pkg_install(packages_to_install)