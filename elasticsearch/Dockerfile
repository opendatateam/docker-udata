##########################################
# Dockerfile for udata base system
# Based on Debian
##########################################

FROM elasticsearch:2.4

# Install uData system dependencies
RUN plugin install analysis-icu

# Provide healthcheck for Docker 1.12+
HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:9200/ || exit 1
