docker_pkg_install <- function(package_csv) {
  pkgs <- read.csv(package_csv, stringsAsFactors = FALSE)

  utils::install.packages("parallel")

  cores <- max(1, parallel::detectCores() - 1)

  print("Trying on cores:")
  print(cores)

  try_package <- function(package, ...) {
    tryCatch({
      # TODO: Do we need a particular install library?
      utils::install.packages(package, Ncpus = cores)
      return("Install Complete")
    }, error = function(e) {
      return(e)
    })
  }

  lapply(pkgs$package, try_package)
}
