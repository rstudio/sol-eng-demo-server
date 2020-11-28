FROM httpd:2.4

# install system deps
	#pkg-config \
RUN apt-get update && \
	apt-get install -y \
	autoconf \
	autotools-dev \
	gcc \
	gdebi \
	libapr1-dev \
	libaprutil1-dev \
	pkgconf \
	wget \
	libcurl4-gnutls-dev && \
	wget -O libssl1.0.0.deb http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb \
    && gdebi -n libssl1.0.0.deb

RUN apt-get install -y \
	curl \
	jq \
	liblasso3-dev \
	libssl-dev \
	libxmlsec1-dev \
	make

# build and install mod_auth_mellon
RUN cd /usr/src && \
	wget https://github.com/Uninett/mod_auth_mellon/archive/v0.14.0.tar.gz && \
	wget -O mellon.tar.gz https://github.com/latchset/mod_auth_mellon/releases/download/v0.17.0/mod_auth_mellon-0.17.0.tar.gz && \
	tar -xzvf mellon.tar.gz && \
	rm -rf mellon.tar.gz && \
	cd mod_auth_mellon-0.17.0 && \
	aclocal && \
	autoreconf && \
	autoconf && \
	./configure --with-apxs2=/usr/local/apache2/bin/apxs && \
	make && \
	make install
