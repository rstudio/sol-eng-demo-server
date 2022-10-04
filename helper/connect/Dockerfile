FROM ubuntu:bionic

LABEL maintainer="sol-eng@rstudio.com"

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008,DL3009
RUN apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends \
        wget \
        bzip2 \
        ca-certificates \
        libglib2.0-0 \
        libxext6 \
        libsm6 \
        libxrender1 \
        gdebi-core \
        libssl1.0.0 \
        libssl-dev git \
        curl \
        gdebi \
        libcurl4-gnutls-dev \
        libssl1.0.0 \
        libssl-dev \
        libuser \
        libuser1-dev \
        rrdtool \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install additional system packages ------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    libxml2-dev \
    # these are other package system requirements, should uncomment and re-run
    subversion \
    lmodern \
    bowtie2 \
    bwidget \
    cargo \
    cmake \
    coinor-libclp-dev \
    dcraw \
    gdal-bin \
    ggobi \
    haveged \
    imagej \
    imagemagick \
    jags \
    libapparmor-dev \
    libatk1.0-dev \
    libavfilter-dev \
    libcairo2-dev \
    #libcurl4-openssl-dev \
    libfftw3-dev \
    libfreetype6-dev \
    libgdal-dev \
    libgeos-dev \
    libgit2-dev \
    libgl1-mesa-dev \
    libglib2.0-dev \
    libglpk-dev \
    libglu1-mesa-dev \
    libgmp3-dev \
    libgpgme11-dev \
    libgsl0-dev \
    libgtk2.0-dev \
    libhdf5-dev \
    libhiredis-dev \
    libicu-dev \
    libimage-exiftool-perl \
    libjpeg-dev \
    libjq-dev \
    libleptonica-dev \
    libmagic-dev \
    libmagick++-dev \
    libmpfr-dev \
    libmysqlclient-dev \
    libnetcdf-dev \
    libopenmpi-dev \
    libpango1.0-dev \
    libpng-dev \
    libpoppler-cpp-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libqgis-dev \
    libraptor2-dev \
    librasqal3-dev \
    librdf0-dev \
    librrd-dev \
    librsvg2-dev \
    libsasl2-dev \
    libsecret-1-dev \
    libsndfile1-dev \
    libsodium-dev \
    libssh2-1-dev \
    libssl-dev \
    libtesseract-dev \
    libtiff-dev \
    libudunits2-dev \
    libv8-dev \
    libwebp-dev \
    libxft-dev \
    libxml2-dev \
    libxslt-dev \
    libzmq3-dev \
    make \
    nvidia-cuda-dev \
    ocl-icd-opencl-dev \
    openjdk-8-jdk \
    pari-gp \
    perl \
    protobuf-compiler \
    rustc \
    saga \
    saint \
    swftools \
    tcl \
    tesseract-ocr-eng \
    texlive \
    texlive-latex-extra \
    tk \
    tk-table \
    unixodbc-dev \
    wget \
    zlib1g-dev  \
    libfontconfig1-dev \
    # other dev deps
    vim \
    psmisc \
    tree

# Install R -------------------------------------------------------------------#

ARG R_VERSION=4.0.2
RUN curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VERSION}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive r-${R_VERSION}_1_amd64.deb && \
    rm -f ./r-${R_VERSION}_1_amd64.deb

# Install R -------------------------------------------------------------------#

ARG R_VERSION_2=3.6.2
RUN curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VERSION_2}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive r-${R_VERSION_2}_1_amd64.deb && \
    rm -f ./r-${R_VERSION_2}_1_amd64.deb

# Install Alt R -------------------------------------------------------------------#

ARG R_VERSION_ALT=3.5.3
RUN curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VERSION_ALT}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive r-${R_VERSION_ALT}_1_amd64.deb && \
    rm -f ./r-${R_VERSION_ALT}_1_amd64.deb

# Install Python --------------------------------------------------------------#

ARG PYTHON_VERSION_2=3.8.3
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh && \
    bash Miniconda3-4.7.12.1-Linux-x86_64.sh -bp /opt/python/${PYTHON_VERSION_2} && \
    /opt/python/${PYTHON_VERSION_2}/bin/conda install -y python==${PYTHON_VERSION_2} && \
    /opt/python/${PYTHON_VERSION_2}/bin/pip install virtualenv && \
    /opt/python/${PYTHON_VERSION_2}/bin/pip install 'setuptools>40.8.0' && \
    rm -rf Miniconda3-*-Linux-x86_64.sh

ENV PATH="/opt/python/${PYTHON_VERSION_2}/bin:${PATH}"
ENV RETICULATE_PYTHON="/opt/python/${PYTHON_VERSION_2}/bin/python"

# Install Python --------------------------------------------------------------#

ARG PYTHON_VERSION=3.7.3
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh && \
    bash Miniconda3-4.7.12.1-Linux-x86_64.sh -bp /opt/python/${PYTHON_VERSION} && \
    /opt/python/${PYTHON_VERSION}/bin/conda install -y python==${PYTHON_VERSION} && \
    /opt/python/${PYTHON_VERSION}/bin/pip install virtualenv && \
    /opt/python/${PYTHON_VERSION_2}/bin/pip install 'setuptools>40.8.0' && \
    rm -rf Miniconda3-*-Linux-x86_64.sh

ENV PATH="/opt/python/${PYTHON_VERSION}/bin:${PATH}"
ENV RETICULATE_PYTHON="/opt/python/${PYTHON_VERSION}/bin/python"

# Install Alt Python --------------------------------------------------------------#

ARG PYTHON_VERSION_ALT=3.6.7
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh && \
    bash Miniconda3-4.7.12.1-Linux-x86_64.sh -bp /opt/python/${PYTHON_VERSION_ALT} && \
    /opt/python/${PYTHON_VERSION_ALT}/bin/conda install -y python==${PYTHON_VERSION_ALT} && \
    /opt/python/${PYTHON_VERSION_ALT}/bin/pip install virtualenv && \
    /opt/python/${PYTHON_VERSION_2}/bin/pip install 'setuptools>40.8.0' && \
    rm -rf Miniconda3-*-Linux-x86_64.sh

# Runtime settings ------------------------------------------------------------#
ARG TINI_VERSION=0.18.0
RUN curl -L -o /usr/local/bin/tini https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini && \
    chmod +x /usr/local/bin/tini

COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Enforce UID/GID
RUN groupadd -g 998 -r rstudio-connect && \
    useradd -g 998 -u 998 -r rstudio-connect

# Download RStudio Connect -----------------------------------------------------#
ARG RSC_VERSION=1.8.6.6
RUN apt-get update --fix-missing \
    && apt-get install -y gpg dpkg-sig \
    && curl -LO https://cdn.rstudio.com/connect/installer/installer-latest.sh \
    && UNATTENDED=1 bash installer-latest.sh ${RSC_VERSION} \
    && rm installer-latest.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Locale configuration --------------------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

EXPOSE 3939/tcp
ENV RSC_LICENSE ""
ENV RSC_LICENSE_SERVER ""
COPY rstudio-connect.gcfg /etc/rstudio-connect/rstudio-connect.gcfg
VOLUME ["/data"]

ENTRYPOINT ["tini", "--"]
CMD ["/usr/local/bin/startup.sh"]