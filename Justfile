# This justfile provides common commands for building and testing the images
# locally. It is NOT part of the CI/CD pipeline. The CI/CD pipeline is driven by
# the Jenkinsfile.

# Define the all of shared parameters
tag := "sol-eng-demo-server"

# List all of the just recipes
default:
    just --list

# Build the docker image
build:
    docker build \
        --build-arg R_VERSIONS='4.0.5' \
        --build-arg R_DEFAULT_VERSION='4.2.3' \
        --build-arg PYTHON_VERSIONS='3.10.11' \
        --build-arg PYTHON_DEFAULT_VERSION='3.10.11' \
        --platform "linux/amd64" \
        --tag {{tag}} \
        .

# Run the docker image with the bash process. Helpful for debugging.
run:
    docker run -it --rm --platform "linux/amd64" {{tag}} /bin/bash
 
# Run all tests
test:
    just test-aws-cli
    just test-install-r-popular
    just test-install-r-complete

# Test the most popular R packages are installable (2 min +)
test-install-r-popular:
    docker run -it --rm \
        --volume $(pwd)/tests:/tests \
        --workdir /tests \
        {{tag}} \
        /opt/R/4.2.3/bin/Rscript install_r_packages_popular.R
    
# Test that a comprehsive list of R packages are installable (30 min +)
test-install-r-complete:
    docker run -it --rm \
        --volume $(pwd)/tests:/tests \
        --workdir /tests \
        {{tag}} \
        /opt/R/4.2.3/bin/Rscript install_r_packages_complete.R

# Test that the AWS CLI is callable
test-aws-cli:
    docker run -it --rm \
        --volume $(pwd)/tests:/tests \
        --workdir /tests \
        {{tag}} \
        'aws --help'
