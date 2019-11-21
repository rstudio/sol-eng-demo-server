docker_pkg_install <- function(package_csv, install_loc) {
  pkgs <- read.csv(package_csv, stringsAsFactors = FALSE)

  utils::install.packages(pkgs$package, lib = install_loc)
}
