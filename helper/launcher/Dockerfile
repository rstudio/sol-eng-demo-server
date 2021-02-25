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
ARG TINI_VERSION=0.18.0
RUN curl -L -o /usr/local/bin/tini https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini && \
    chmod +x /usr/local/bin/tini

# Copy config
COPY conf/* /etc/rstudio/

# Install RStudio Server Pro (for launcher) --------------------------------------------------#
ARG RSP_VERSION=1.4.1103-4
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

EXPOSE 5559/tcp

ENTRYPOINT ["tini", "--"]
CMD ["/usr/lib/rstudio-server/bin/rstudio-launcher"]
