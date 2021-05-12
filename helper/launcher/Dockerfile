FROM ubuntu:bionic
LABEL maintainer="RStudio Docker <docker@rstudio.com>"

ARG DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008,DL3009
RUN apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        locales \
	    tzdata \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Locale configuration --------------------------------------------------------#
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Runtime settings ------------------------------------------------------------#

# Set default env values
ENV RSP_TESTUSER rstudio
ENV RSP_TESTUSER_PASSWD rstudio
ENV RSP_TESTUSER_UID 10000

# Copy config and startup
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh
COPY conf/* /etc/rstudio/

# Install RStudio Server Pro (for launcher) --------------------------------------------------#
ARG RSP_VERSION=1.4.1707-8
ARG RSP_DOWNLOAD_URL=https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64
RUN apt-get update --fix-missing \
    && apt-get install -y gdebi-core \
    && curl -O ${RSP_DOWNLOAD_URL}/rstudio-workbench-${RSP_VERSION}-amd64.deb \
    && gdebi --non-interactive rstudio-workbench-${RSP_VERSION}-amd64.deb \
    && rm rstudio-workbench-${RSP_VERSION}-amd64.deb \
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

EXPOSE 5559/tcp

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
CMD []
