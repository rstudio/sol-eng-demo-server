FROM ubuntu:focal
LABEL maintainer="RStudio Docker <docker@rstudio.com>"

ARG DEBIAN_FRONTEND=noninteractive
# hadolint ignore=DL3008,DL3009
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        curl \
        git \
        libcap2 \
        libglib2.0-0 \
        libpq5 \
        libsm6 \
        libssl-dev \
        libuser \
        libuser1-dev \
        libxext6 \
        libxrender1 \
        locales \
        openssh-client \
        rrdtool \
	    tzdata \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Locale configuration --------------------------------------------------------#
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install R -------------------------------------------------------------------#
ARG DISTRIBUTION=ubuntu-2004
ARG R_VERSION=4.0.3
ARG R_INSTALLER=r-${R_VERSION}_1_amd64.deb
RUN curl -fsSL -O https://cdn.rstudio.com/r/${DISTRIBUTION}/pkgs/${R_INSTALLER} && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -f -y ./${R_INSTALLER} && \
    rm ${R_INSTALLER} && \
    rm -rf /var/lib/apt/lists/*

# Install Python  -------------------------------------------------------------#
ARG PYTHON_VERSION=3.9.13
ARG PYTHON_INSTALLER=python-${PYTHON_VERSION}_1_amd64.deb
RUN curl -fsSL -O https://cdn.rstudio.com/python/${DISTRIBUTION}/pkgs/${PYTHON_INSTALLER} && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -f -y ./${PYTHON_INSTALLER} && \
    rm ${PYTHON_INSTALLER} && \
    rm -rf /var/lib/apt/lists/*

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

# Install RSP/RSC Notebook Extensions --------------------#

RUN /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsp_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsp_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension install --sys-prefix --py rsconnect_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-nbextension enable --sys-prefix --py rsconnect_jupyter && \
    /opt/python/${PYTHON_VERSION}/bin/jupyter-serverextension enable --sys-prefix --py rsconnect_jupyter

# Runtime settings ------------------------------------------------------------#
RUN curl -L -o /usr/local/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x /usr/local/bin/wait-for-it.sh

# Set default env values
ENV RSP_LICENSE ""
ENV RSP_LICENSE_SERVER ""
ENV RSP_TESTUSER rstudio
ENV RSP_TESTUSER_PASSWD rstudio
ENV RSP_TESTUSER_UID 10000
ENV RSP_LAUNCHER true
ENV RSP_LAUNCHER_TIMEOUT 10

# Copy config and startup
COPY startup.sh /usr/local/bin/startup.sh
COPY launcher-startup.sh /usr/local/bin/launcher-startup.sh
RUN chmod +x /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/launcher-startup.sh
COPY conf/* /etc/rstudio/

# Enforce UID/GID
RUN groupadd -g 998 -r rstudio-server && \
    useradd -g 998 -u 998 -r rstudio-server

# Install RStudio Server Pro --------------------------------------------------#
ARG RSP_VERSION=2022.07.1-554.pro3
ARG RSP_DOWNLOAD_URL=https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64
RUN apt-get update --fix-missing \
    && apt-get install -y gdebi-core \
    && RSP_VERSION_URL=`echo -n "${RSP_VERSION}" | sed 's/+/-/g'` \
    && curl -o rstudio-workbench.deb ${RSP_DOWNLOAD_URL}/rstudio-workbench-${RSP_VERSION_URL}-amd64.deb \
    && gdebi --non-interactive rstudio-workbench.deb \
    && rm rstudio-workbench.deb \
    && apt-get remove gdebi-core -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Change Startup behavior
COPY sssd.conf /etc/sssd/sssd.conf
RUN mkdir -p /startup/custom/ \
    && apt-get update --fix-missing \
    && apt-get install -y \
        supervisor \
        sssd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/lib/rstudio-server/monitor/log \
    && chown -R rstudio-server:rstudio-server /var/lib/rstudio-server/monitor \
    && chmod 600 /etc/sssd/sssd.conf

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY startup/* /startup/base/

EXPOSE 8787/tcp

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
CMD []
