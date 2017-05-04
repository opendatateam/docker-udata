##########################################
# Dockerfile for udata
##########################################

FROM debian:jessie

# File Author / Maintainer
MAINTAINER Axel Haustant

# Install uData system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essential Tools
    tar git wget curl build-essential pkg-config \
    # Python tools
    python python-dev python-pip\
    # Pillow
    libjpeg-dev zlib1g-dev libpng12-dev libtiff5-dev libfreetype6-dev \
    liblcms2-dev libopenjpeg-dev libwebp-dev libpng12-dev libopenjpeg-dev \
    # lxml dependencies
    libxml2-dev libxslt1-dev \
    # Misc dependencies
    liblzma-dev libyaml-dev libffi-dev \
    # uWSGI features
    libpcre3-dev \
    # Clean up
    && apt-get autoremove\
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LIBIMAGEQUANT_VERSION 2.9.1

# Install libpngquant for better images quantization
RUN git clone https://github.com/ImageOptim/libimagequant \
    && cd libimagequant \
    && git checkout $LIBIMAGEQUANT_VERSION \
    && make shared\
    && mv libimagequant.so* /usr/local/lib \
    && cp libimagequant.h /usr/local/include \
    && cd .. \
    && rm -fr libimagequant \
    && ldconfig

# Set version as environment variable to force rebuild
ENV UDATA_VERSION 1.0.9
ENV UDATA_PIWIK_VERSION 0.9.1
ENV UDATA_GOUVFR_VERSION 1.0.6
ENV UDATA_YOUCKAN_VERSION 1.0.0

# Install udata and all known plugins
RUN pip install uwsgi gevent raven \
    udata==$UDATA_VERSION \
    udata-piwik==$UDATA_PIWIK_VERSION \
    udata-gouvfr==$UDATA_GOUVFR_VERSION \
    udata-youckan==$UDATA_YOUCKAN_VERSION

RUN mkdir -p /udata/fs

COPY udata.cfg entrypoint.sh /udata/
COPY uwsgi/*.ini /udata/uwsgi/

WORKDIR /udata

VOLUME /udata/fs

ENV UDATA_SETTINGS /udata/udata.cfg

EXPOSE 7000 7001

HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:7000/ || exit 1

ENTRYPOINT ["/udata/entrypoint.sh"]
CMD ["uwsgi"]
