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
ARG R_DISTRIBUTION=ubuntu-2004
ARG R_VERSION=4.0.3
ARG R_INSTALLER=r-${R_VERSION}_1_amd64.deb
RUN curl -fsSL -O https://cdn.rstudio.com/r/${R_DISTRIBUTION}/pkgs/${R_INSTALLER} && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -f -y ./${R_INSTALLER} && \
    rm ${R_INSTALLER} && \
    rm -rf /var/lib/apt/lists/*

# Install Python  -------------------------------------------------------------#
ARG MINICONDA_VERSION=4.7.12.1
ARG PYTHON_VERSION=3.8.3

# The documented approach uses a particular miniconda install script version
# to obtain the desired Python version. We are first installing miniconda and
# then asking it to install different Python versions.

RUN curl -fsSL -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh \
    && chmod 755 miniconda.sh \
    && ./miniconda.sh -b -p /opt/miniconda \
    && /opt/miniconda/bin/conda create --quiet --yes --prefix /opt/python/${PYTHON_VERSION} --channel conda-forge python=${PYTHON_VERSION} \
    && rm -f miniconda.sh \
    # remove miniconda too, for size
    && rm -rf /opt/miniconda

# Install other Python PyPi packages
RUN /opt/python/${PYTHON_VERSION}/bin/pip install --no-cache-dir \
                pip==20.0.2 \
                jupyter==1.0.0 \
                'jupyterlab<3.0.0' \
                rsp_jupyter \
                rsconnect_jupyter

# Install Jupyter extensions
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
RUN chmod +x /usr/local/bin/startup.sh
COPY conf/* /etc/rstudio/

# Install RStudio Server Pro --------------------------------------------------#
ARG RSP_VERSION=1.4.1106-5
ARG RSP_DOWNLOAD_URL=https://download2.rstudio.org/server/bionic/amd64
RUN apt-get update --fix-missing \
    && apt-get install -y gdebi-core \
    && curl -O ${RSP_DOWNLOAD_URL}/rstudio-server-pro-${RSP_VERSION}-amd64.deb \
    && gdebi --non-interactive rstudio-server-pro-${RSP_VERSION}-amd64.deb \
    && rm rstudio-server-pro-${RSP_VERSION}-amd64.deb \
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
