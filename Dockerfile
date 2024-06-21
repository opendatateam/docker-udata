##########################################
# Dockerfile for udata
##########################################

FROM udata/system:py3.11

# Optionnal build arguments
ARG REVISION="N/A"
ARG CREATED="Undefined"

# Write .pyc files only once. See: https://stackoverflow.com/a/60797635/2556577
ENV PYTHONDONTWRITEBYTECODE 1
# Make sure that stdout and stderr are not buffered. See: https://stackoverflow.com/a/59812588/2556577
ENV PYTHONUNBUFFERED 1
# Remove assert statements and any code conditional on __debug__. See: https://docs.python.org/3/using/cmdline.html#cmdoption-O
ENV PYTHONOPTIMIZE 2
# PIP - DISABLE VERSION CHECK
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
# PIP - HIDE PROGRESS BAR
ENV PIP_PROGRESS_BAR off
# PIP - RETRIES
ENV PIP_RETRIES 1
# PIP - DISABLE WARNING ABOUT ROOT USER
ENV PIP_ROOT_USER_ACTION ignore


# OCI annotations
# See: https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL "org.opencontainers.image.title"="udata all-in-one"
LABEL "org.opencontainers.image.description"="udata with all known plugins and themes for SETEC Geodatahub"
LABEL "org.opencontainers.image.authors"="Open Data Team, Oslandia"
LABEL "org.opencontainers.image.sources"="https://github.com/opendatateam/docker-udata"
LABEL "org.opencontainers.image.revision"=$REVISION
LABEL "org.opencontainers.image.created"=$CREATED

RUN apt update && apt upgrade -y && apt install -y --no-install-recommends \
    # uWSGI rooting features
    libpcre3-dev \
    # Clean up
    && apt autoremove --purge \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install udata and all known plugins
COPY requirements.pip /tmp/requirements.pip
RUN python -m pip install --no-cache-dir -U pip && \
    python -m pip install --no-cache-dir -U setuptools wheel && \
    python -m pip install --no-cache-dir -U --no-cache-dir -r tmp/requirements.pip && \
    python -m pip check || pip install --no-cache-dir -U --no-cache-dir -r /tmp/requirements.pip

RUN rm -r /root/.cache

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
