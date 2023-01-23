FROM ubuntu:bionic

LABEL maintainer="sol-eng@rstudio.com"

# Install RStudio Server Pro session components -------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    libcurl4-gnutls-dev \
    libssl1.0.0 \
    libssl-dev \
    libuser \
    libuser1-dev \
    rrdtool \
    wget

# Install RStudio Server Pro (for session) --------------------------------------------------#
ARG RSP_VERSION=2022.12.0-353.pro20
ARG RSP_DOWNLOAD_URL=https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64
RUN apt-get update --fix-missing \
    && apt-get install -y gdebi-core \
    && RSP_VERSION_URL=`echo -n "${RSP_VERSION}" | sed 's/+/-/g'` \
    && curl -o rstudio-workbench.deb ${RSP_DOWNLOAD_URL}/rstudio-workbench-${RSP_VERSION_URL}-amd64.deb \
    && gdebi --non-interactive rstudio-workbench.deb \
    && rm rstudio-workbench.deb \
    # && apt-get remove gdebi-core -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/rstudio-server/r-versions

EXPOSE 8788/tcp

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
    chromium-browser \
    chromium-chromedriver \
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
    qpdf \
    tree \
    # pyenv dependencies
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev

# Link Quarto -------------------------------------------------------------------#
RUN ln -s /usr/lib/rstudio-server/bin/quarto/bin/quarto /usr/local/bin/quarto

# Install R -------------------------------------------------------------------#
#Default R Version but gets overwritten by values passed in from Jenkins Build Process
ARG R_VERSION=3.6.2
RUN curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VERSION}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive r-${R_VERSION}_1_amd64.deb && \
    rm -f ./r-${R_VERSION}_1_amd64.deb

RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript

# Install R packages ----------------------------------------------------------#

RUN JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 /opt/R/${R_VERSION}/bin/R CMD javareconf

COPY ./pkg_names.csv /opt/R/${R_VERSION}/lib/pkg_names.csv
COPY ./pkg_installer.R /opt/R/${R_VERSION}/lib/pkg_installer.R

ARG R_REPO='https://colorado.rstudio.com/rspm/cran/__linux__/bionic/latest'
ARG R_REPO_LATEST='https://colorado.rstudio.com/rspm/cran/__linux__/bionic/latest'
RUN echo "options(\"repos\" = c(RSPM = \"${R_REPO}\"), \"HTTPUserAgent\" = \"R/${R_VERSION} R (${R_VERSION} x86_64-pc-linux-gnu x86_64-pc-linux-gnu x86_64-pc-linux-gnu)\");" >> \
	/opt/R/${R_VERSION}/lib/R/etc/Rprofile.site

# need to install packages from list of packages...
RUN /opt/R/${R_VERSION}/bin/R -e "source(\"/opt/R/${R_VERSION}/lib/pkg_installer.R\"); docker_pkg_install(\"/opt/R/${R_VERSION}/lib/pkg_names.csv\", \"/opt/R/${R_VERSION}/lib/R/library\")"

# Install Alt R -------------------------------------------------------------------#

ARG R_VERSION_ALT=3.5.3
RUN curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VERSION_ALT}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive r-${R_VERSION_ALT}_1_amd64.deb && \
    rm -f ./r-${R_VERSION_ALT}_1_amd64.deb

# Install Alt R packages ----------------------------------------------------------#

RUN JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 /opt/R/${R_VERSION_ALT}/bin/R CMD javareconf

COPY ./pkg_names.csv /opt/R/${R_VERSION_ALT}/lib/pkg_names.csv
COPY ./pkg_installer.R /opt/R/${R_VERSION_ALT}/lib/pkg_installer.R

ARG R_REPO_ALT='https://colorado.rstudio.com/rspm/cran/__linux__/bionic/latest'
RUN echo "options(\"repos\" = c(RSPM = \"${R_REPO_ALT}\"), \"HTTPUserAgent\" = \"R/${R_VERSION_ALT} R (${R_VERSION_ALT} x86_64-pc-linux-gnu x86_64-pc-linux-gnu x86_64-pc-linux-gnu)\");" >> \
	/opt/R/${R_VERSION_ALT}/lib/R/etc/Rprofile.site

# need to install packages from list of packages...
RUN /opt/R/${R_VERSION_ALT}/bin/R -e "source(\"/opt/R/${R_VERSION_ALT}/lib/pkg_installer.R\"); docker_pkg_install(\"/opt/R/${R_VERSION_ALT}/lib/pkg_names.csv\", \"/opt/R/${R_VERSION_ALT}/lib/R/library\")"

# Install r-versions configuration for rJava ----------------------------------#
RUN mkdir -p /mnt/dynamic/rstudio \
    && echo "Path: /opt/R/${R_VERSION}\nScript: /opt/R/${R_VERSION}/lib/R/etc/ldpaths" > \
	/mnt/dynamic/rstudio/r-versions \
    && echo "\nPath: /opt/R/${R_VERSION_ALT}\nScript: /opt/R/${R_VERSION_ALT}/lib/R/etc/ldpaths" >> \
    	/mnt/dynamic/rstudio/r-versions

# Install Python --------------------------------------------------------------#

ARG PYTHON_VERSION=3.9.13
RUN curl -O https://cdn.rstudio.com/python/ubuntu-1804/pkgs/python-${PYTHON_VERSION}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive python-${PYTHON_VERSION}_1_amd64.deb && \
    rm -f ./python-${PYTHON_VERSION}_1_amd64.deb

RUN /opt/python/${PYTHON_VERSION}/bin/pip3 install \
    --upgrade pip setuptools wheel && \ 
    /opt/python/${PYTHON_VERSION}/bin/pip3 install \
    jupyter \
    jupyterlab \
    workbench_jupyterlab \
    rsp_jupyter \
    rsconnect_jupyter \
    rsconnect_python && \
    ln -s /opt/python/${PYTHON_VERSION}/bin/jupyter /usr/local/bin/jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/python3 -m ipykernel install --name py${PYTHON_VERSION} --display-name "Python ${PYTHON_VERSION}"

RUN /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsp_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsp_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsconnect_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsconnect_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-serverextension enable --sys-prefix --py rsconnect_jupyter

ENV PATH="~/.local/bin:/opt/python/${PYTHON_VERSION}/bin:${PATH}"
ENV SHELL="/bin/bash"
ENV RETICULATE_PYTHON="/opt/python/${PYTHON_VERSION}/bin/python"

# Install Alt Python --------------------------------------------------------------#

ARG PYTHON_VERSION_ALT=3.8.13
RUN curl -O https://cdn.rstudio.com/python/ubuntu-1804/pkgs/python-${PYTHON_VERSION_ALT}_1_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive python-${PYTHON_VERSION_ALT}_1_amd64.deb && \
    rm -f ./python-${PYTHON_VERSION_ALT}_1_amd64.deb

RUN /opt/python/${PYTHON_VERSION_ALT}/bin/pip3 install \
    --upgrade pip setuptools wheel && \ 
    /opt/python/${PYTHON_VERSION_ALT}/bin/pip3 install \
    jupyter && \
    /opt/python/${PYTHON_VERSION_ALT}/bin/python3 -m ipykernel install --name py${PYTHON_VERSION_ALT} --display-name "Python ${PYTHON_VERSION_ALT}"

# Install RStudio Professional Drivers ----------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc unixodbc-dev gdebi-core

ARG DRIVERS_VERSION=2021.10.0
RUN curl -O https://cdn.rstudio.com/drivers/7C152C12/installer/rstudio-drivers_${DRIVERS_VERSION}_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive gdebi --non-interactive rstudio-drivers_${DRIVERS_VERSION}_amd64.deb && \
    rm rstudio-drivers_${DRIVERS_VERSION}_amd64.deb && \
    cat /opt/rstudio-drivers/odbcinst.ini.sample | tee /etc/odbcinst.ini

# Install Instant Client for Oracle Driver
RUN curl -O https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-basiclite-linux.x64-19.10.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-19.10.0.0.0dbru.zip -d /opt/oracle && \
    ln -s /opt/oracle/instantclient_19_10/* /opt/rstudio-drivers/oracle/bin/lib/ && \
    rm instantclient-basiclite-linux.x64-19.10.0.0.0dbru.zip

# install latest versions of important IDE packages
RUN /opt/R/${R_VERSION}/bin/R -e "install.packages(c(\"odbc\", \"rsconnect\", \"rstudioapi\"), repos=\"${R_REPO_LATEST}\")"
RUN /opt/R/${R_VERSION_ALT}/bin/R -e "install.packages(c(\"odbc\", \"rsconnect\", \"rstudioapi\"), repos=\"${R_REPO_LATEST}\")"

# Install VSCode code-server --------------------------------------------------#
RUN rstudio-server install-vs-code /opt/code-server
    # TODO: rstudio-server install-vs-code-ext

# Locale configuration --------------------------------------------------------#

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales locales-all
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ UTC
ENV R_BUILD_TAR /bin/tar

# RStudio Package Manager Remote CLI -------------------------------------------#

ARG PACKAGEMANAGER_TOKEN='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJwYWNrYWdlbWFuYWdlciIsImp0aSI6Ijk1Y2RkMWU5LTIzOWEtNDBiMS04MTY3LTM3NmU3NmMzY2Y5OSIsImlhdCI6MTY2NjgxOTg1NiwiaXNzIjoicGFja2FnZW1hbmFnZXIiLCJzY29wZXMiOnsic291cmNlcyI6ImNlYTQwMDA2LThiOTYtNDZlMi05NmNmLTVmNzAzNzU3OTM4NyJ9fQ.7yweKMFS2CJaNLcBJwaMebjMDk7YSRkjeXlSFpylL1I'
ARG PACKAGEMANAGER_ADDRESS='https://colorado.rstudio.com/rspm'
RUN curl -fOJH "Authorization: Bearer ${PACKAGEMANAGER_TOKEN}" "${PACKAGEMANAGER_ADDRESS}/__api__/download"
RUN cp ./rspm /usr/local/bin/rspm
RUN chmod +x /usr/local/bin/rspm


