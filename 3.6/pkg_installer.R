docker_pkg_install <- function(package_csv, install_loc) {
  pkgs <- read.csv(package_csv, stringsAsFactors = FALSE)

  utils::install.packages('future')
  ncores <- max(1, future::availableCores())

  print(sprintf("Installing on %s cores", ncores - 1))
  options(Ncpus = ncores)

  utils::install.packages(pkgs$package, lib = install_loc)
}
