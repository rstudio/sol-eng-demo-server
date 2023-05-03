FROM rstudio/r-session-complete:jammy-2023.03.0--fa5bcba
LABEL maintainer="RStudio Docker <docker@rstudio.com>"

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# ------------------------------------------------------------------------------
# Install system depdendenies requested by users
# ------------------------------------------------------------------------------
RUN apt-get update \
    && apt-get install -y \
        acl \
        build-essential \
        chromium-browser \
        chromium-chromedriver \
        gdebi-core \
        ggobi \
        llvm \
        lmodern \
        openjdk-8-jdk \
        psmisc \
        qpdf \
        saint \
        subversion \
        texlive-latex-extra \
        tree \
        vim \
        wget \
        xz-utils \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# Install additional versions of R
# ------------------------------------------------------------------------------
# rstudio/r-session-complete:jammy-2023.03.0--fa5bcba already includes:
# - R 4.1.3
# - R 4.2.3
ARG R_VERSIONS="3.6.3 4.0.5"
ARG R_DEFAULT_VERSION="4.2.3"
RUN for R_VER in $R_VERSIONS; \
    do \
        curl -O https://cdn.rstudio.com/r/ubuntu-2204/pkgs/r-${R_VER}_1_amd64.deb \
        && gdebi -n r-${R_VER}_1_amd64.deb \
        && rm -f ./r-${R_VER}_1_amd64.deb; \
    done
# Set the default version of R
RUN ln -sf /opt/R/${R_DEFAULT_VERSION}/bin/R /usr/local/bin/R \
    && ln -sf /opt/R/${R_DEFAULT_VERSION}/bin/Rscript /usr/local/bin/Rscript

# ------------------------------------------------------------------------------
# Install additional versions of Python
# ------------------------------------------------------------------------------
# rstudio/r-session-complete:jammy-2023.03.0--fa5bcba already includes:
# - Python 3.8.15
# - Python 3.9.14
ARG PYTHON_VERSIONS="3.10.11 3.11.3"
ARG PYTHON_DEFAULT_VERSION="3.10.11"
RUN for PYTHON_VER in $PYTHON_VERSIONS; \
    do \
        curl -O https://cdn.rstudio.com/python/ubuntu-2204/pkgs/python-${PYTHON_VER}_1_amd64.deb \
        && gdebi -n python-${PYTHON_VER}_1_amd64.deb \
        && rm -rf python-${PYTHON_VER}_1_amd64.deb \
        && /opt/python/${PYTHON_VER}/bin/python3 -m pip install --upgrade pip wheel setuptools; \
    done
ENV PATH="/opt/python/${PYTHON_DEFAULT_VERSION}/bin:${PATH}"
ENV RETICULATE_PYTHON="/opt/python/${PYTHON_DEFAULT_VERSION}/bin/python"
ENV WORKBENCH_JUPYTER_PATH=/usr/local/bin/jupyter

# ------------------------------------------------------------------------------
# Quarto extras
# ------------------------------------------------------------------------------
# Install depdencies required to render a quarto doc to a pdf.
RUN tlmgr install \
  koma-script \
  caption \
  tcolorbox \
  pgf \
  pdfcol \
  environ \
  oberdiek \
  tikzfill \
  bookmark

# ------------------------------------------------------------------------------
# User requested tools
# ------------------------------------------------------------------------------
# Install the GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install justfile
RUN wget -qO - 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1> /dev/null \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list \
    && apt-get update \
    && apt-get install -y just \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install the AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm awscliv2.zip

# Install linux brew
# RUN apt-get update && \
#     apt-get install -y \
#         build-essential \
#     && apt-get autoremove -y \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/* \
#     && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
#     && (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /etc/profile.d/homebrew.sh \
#     && chmod +x /etc/profile.d/homebrew.sh \
#     && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
#     && brew install gcc

# ------------------------------------------------------------------------------
# Set environment variables
# ------------------------------------------------------------------------------
ENV SHELL="/bin/bash"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# ------------------------------------------------------------------------------
# Testing
# ------------------------------------------------------------------------------
# This section is for testing only. Comment out before committing to main.
# Create a new user:
# RUN useradd -ms /bin/bash newuser
# USER newuser
# WORKDIR /home/newuser

# ------------------------------------------------------------------------------
# Workbench port
# ------------------------------------------------------------------------------
EXPOSE 8788/tcp
