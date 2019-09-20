docker_pkg_install <- function(package_csv, install_loc) {
  pkgs <- read.csv(package_csv, stringsAsFactors = FALSE)

  print("INSTALLING PAK")
  utils::install.packages("pak")

  pak::pkg_install(pkgs$package, lib = install_loc)
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
