docker_pkg_install <- function(package_csv, install_loc) {
  pkgs <- read.csv(package_csv, stringsAsFactors = FALSE)

  #utils::install.packages("pak")

  utils::install.packages('future')
  ncores <- max(1, future::availableCores())

  print(sprintf("Installing on %s cores", ncores - 1))
  options(Ncpus = ncores)

  utils::install.packages(pkgs$package, lib = install_loc)


  # try_package <- function(package, ...) {
  #   tryCatch({
  #     pak::pkg_install(package, lib = install_loc)
  #     return("Install Complete")
  #   }, error = function(e) {
  #     return(e)
  #   })
  # }

  # lapply(pkgs$package, try_package)
}
