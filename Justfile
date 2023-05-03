tag := "pwb-session"

x:
    echo {{tag}}

build:
    docker build \
        --build-arg R_VERSIONS='4.0.5' \
        --build-arg PYTHON_VERSIONS='3.10.11' \
        --tag {{tag}} \
        .
test:
    docker run -it --rm \
        --volume $(pwd)/tests:/tests \
        --workdir /tests \
        pwb-session \
        /opt/R/4.2.3/bin/Rscript install_r_packages_popular.R
    
    docker run -it --rm \
        --volume $(pwd)/tests:/tests \
        --workdir /tests \
        pwb-session \
        /opt/R/4.2.3/bin/Rscript install_r_packages_complete.R

