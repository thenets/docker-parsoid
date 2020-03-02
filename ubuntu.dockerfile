FROM node:13

LABEL maintainer="luiz@thenets.org"

ENV PARSOID_HOME=/var/lib/parsoid \
    PARSOID_USER=parsoid \
    # PARSOID_VERSION [v0.8.1, v0.9.0, v0.10.0, v0.11.0, master]
    PARSOID_VERSION=v0.11.0

COPY run-parsoid.sh /run-parsoid.sh

# Parsoid setup
RUN set -x \
    # Install required packages
    && apt-get update \
    && apt-get install -y python git tar bash make

RUN set -x \
    # Add user
    && useradd -M -u 1001 -s /bin/bash ${PARSOID_USER} \
    # Set permissions
    && chmod -v +x /run-parsoid.sh \
    # Core
    && mkdir -p ${PARSOID_HOME} \
    && git clone \
        --branch ${PARSOID_VERSION} \
        --single-branch \
        --depth 1 \
        --quiet \
        https://gerrit.wikimedia.org/r/p/mediawiki/services/parsoid \
        ${PARSOID_HOME}

RUN set -x \
    && cd ${PARSOID_HOME} \
    && npm install

EXPOSE 8000
EXPOSE 8001

CMD ["/run-parsoid.sh"]
