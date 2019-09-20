FROM ubuntu:bionic

LABEL maintainer="sol-eng@rstudio.com"

# Set versions and platforms
ARG RSP_PLATFORM=trusty
ARG RSP_VERSION=1.2.1578-2
ARG R_VERSION=3.6.1
ARG PYTHON_VERSION=3.6.9
ARG DRIVERS_VERSION=1.6.0
ARG R_REPO=https://demo.rstudiopm.com/cran/__linux__/bionic/latest

# Install RStudio Server Pro session components -------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    gdebi \
    libcurl4-gnutls-dev \
    libssl1.0.0 \
    libssl-dev \
    libuser \
    libuser1-dev \
    rrdtool \
    wget

RUN curl -O https://s3.amazonaws.com/rstudio-ide-build/session/${RSP_PLATFORM}/rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz && \
    mkdir -p /usr/lib/rstudio-server && \
    tar -zxvf ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz -C /usr/lib/rstudio-server/ && \
    mv /usr/lib/rstudio-server/rsp-session*/* /usr/lib/rstudio-server/ && \
    rm -rf /usr/lib/rstudio-server/rsp-session* && \
    rm -f ./rsp-session-${RSP_PLATFORM}-${RSP_VERSION}.tar.gz

EXPOSE 8788/tcp

# Install additional system packages ------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    libssl1.0.0 \
    libuser \
    libxml2-dev
    # subversion \
    # lmodern \
    # bowtie2 \
    # bwidget \
    # cargo \
    # cmake \
    # coinor-libclp-dev \
    # dcraw \
    # gdal-bin \
    # ggobi \
    # git \
    # haveged \
    # imagej \
    # imagemagick \
    # jags \
    # libapparmor-dev \
    # libatk1.0-dev \
    # libavfilter-dev \
    # libcairo2-dev \
    # libcurl4-openssl-dev \
    # libfftw3-dev \
    # libfreetype6-dev \
    # libgdal-dev \
    # libgeos-dev \
    # libgit2-dev \
    # libgl1-mesa-dev \
    # libglib2.0-dev \
    # libglu1-mesa-dev \
    # libgmp3-dev \
    # libgpgme11-dev \
    # libgsl0-dev \
    # libgtk2.0-dev \
    # libhdf5-dev \
    # libhiredis-dev \
    # libimage-exiftool-perl \
    # libjpeg-dev \
    # libjq-dev \
    # libleptonica-dev \
    # libmagic-dev \
    # libmagick++-dev \
    # libmpfr-dev \
    # libmysqlclient-dev \
    # libnetcdf-dev \
    # libopenmpi-dev \
    # libpango1.0-dev \
    # libpng-dev \
    # libpoppler-cpp-dev \
    # libpq-dev \
    # libproj-dev \
    # libprotobuf-dev \
    # libqgis-dev \
    # librdf0-dev \
    # librrd-dev \
    # librsvg2-dev \
    # libsasl2-dev \
    # libsecret-1-dev \
    # libsndfile1-dev \
    # libsodium-dev \
    # libssh2-1-dev \
    # libssl-dev \
    # libtesseract-dev \
    # libtiff-dev \
    # libudunits2-dev \
    # libv8-dev \
    # libwebp-dev \
    # libxft-dev \
    # libxml2-dev \
    # libxslt-dev \
    # libzmq3-dev \
    # make \
    # nvidia-cuda-dev \
    # ocl-icd-opencl-dev \
    # openjdk-8-jdk \
    # pari-gp \
    # perl \
    # protobuf-compiler \
    # rustc \
    # saga \
    # saint \
    # swftools \
    # tcl \
    # tesseract-ocr-eng \
    # texlive \
    # tk \
    # tk-table \
    # unixodbc-dev \
    # wget \
    # zlib1g-dev  \
    # libfontconfig1-dev


# Install R -------------------------------------------------------------------#

RUN curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VERSION}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive r-${R_VERSION}_1_amd64.deb

RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript

# Install R packages ----------------------------------------------------------#

#RUN /opt/R/${R_VERSION}/bin/R CMD javareconf

COPY ./pkg_names.csv /opt/R/${R_VERSION}/lib/pkg_names.csv
COPY ./pkg_installer.R /opt/R/${R_VERSION}/lib/pkg_installer.R

RUN echo "options(\"repos\" = c(RSPM = \"${R_REPO}\"), \"HTTPUserAgent\" = \"R Demo (${R_VERSION} x86_64-pc-linux-gnu x86_64 linux-gnu)\");" >> \
	/opt/R/${R_VERSION}/lib/R/etc/Rprofile.site

# need to install packages from list of packages...
RUN /opt/R/${R_VERSION}/bin/R -e "source(\"/opt/R/${R_VERSION}/lib/pkg_installer.R\"); docker_pkg_install(\"/opt/R/${R_VERSION}/lib/pkg_names.csv\", \"/opt/R/${R_VERSION}/lib/R/library\")"

# Install Python --------------------------------------------------------------#

RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -bp /opt/python/${PYTHON_VERSION} && \
    /opt/python/${PYTHON_VERSION}/bin/conda install -y python==${PYTHON_VERSION} && \
    /opt/python/${PYTHON_VERSION}/bin/pip install virtualenv && \
    rm -rf Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/opt/python/${PYTHON_VERSION}/bin:${PATH}"

# Install Jupyter Notebook and RSP/RSC Notebook Extensions --------------------#

RUN /opt/python/${PYTHON_VERSION}/bin/pip install \
    jupyter \
    jupyterlab \
    rsp_jupyter \
    rsconnect_jupyter

RUN /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsp_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsp_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsconnect_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsconnect_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-serverextension enable --sys-prefix --py rsconnect_jupyter

# Install Python packages -----------------------------------------------------#

RUN /opt/python/${PYTHON_VERSION}/bin/pip install \
    altair \
    beautifulsoup4 \
    cloudpickle \
    cython \
    dask \
    gensim \
    keras \
    matplotlib \
    nltk \
    numpy \
    pandas \
    pillow \
    pyarrow \
    requests \
    scipy \
    scikit-image \
    scikit-learn \
    scrapy \
    seaborn \
    spacy \
    sqlalchemy \
    statsmodels \
    tensorflow \
    xgboost

# Install RStudio Professional Drivers ----------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc unixodbc-dev gdebi

RUN curl -O https://drivers.rstudio.org/7C152C12/installer/rstudio-drivers_${DRIVERS_VERSION}_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive rstudio-drivers_${DRIVERS_VERSION}_amd64.deb

RUN /opt/R/${R_VERSION}/bin/R -e 'install.packages("odbc", repos="https://demo.rstudiopm.com/cran/__linux__/bionic/latest")'

# Locale configuration --------------------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
