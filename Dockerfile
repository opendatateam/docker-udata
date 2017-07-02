##########################################
# Dockerfile for udata
##########################################

FROM udata/system

MAINTAINER Open Data Team

# Install some production system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # uWSGI rooting features
    libpcre3-dev \
    # Clean up
    && apt-get autoremove\
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set version as environment variable to force rebuild
ENV UDATA_VERSION 1.1.0.dev2283
ENV UDATA_PIWIK_VERSION 0.9.1
ENV UDATA_GOUVFR_VERSION 1.1.0.dev267
ENV UDATA_YOUCKAN_VERSION 1.0.0

# Install udata and all known plugins
RUN pip install uwsgi gevent raven \
    udata==$UDATA_VERSION \
    udata-piwik==$UDATA_PIWIK_VERSION \
    udata-gouvfr==$UDATA_GOUVFR_VERSION \
    udata-youckan==$UDATA_YOUCKAN_VERSION

RUN mkdir -p /udata/fs /src

COPY udata.cfg entrypoint.sh /udata/
COPY uwsgi/*.ini /udata/uwsgi/

WORKDIR /udata

VOLUME /udata/fs

ENV UDATA_SETTINGS /udata/udata.cfg

EXPOSE 7000 7001

HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:7000/ || exit 1

ENTRYPOINT ["/udata/entrypoint.sh"]
CMD ["uwsgi"]
