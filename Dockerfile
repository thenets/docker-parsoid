FROM alpine

LABEL maintainer="luiz@thenets.org"

ENV PARSOID_HOME=/var/lib/parsoid \
    PARSOID_USER=parsoid \
    # PARSOID_VERSION [v0.8.1, v0.9.0, v0.10.0, master]
    PARSOID_VERSION=master

COPY run-parsoid.sh /run-parsoid.sh

# Parsoid setup
RUN set -x \
    # Install required packages
    && apk add --no-cache nodejs nodejs-npm python git tar bash make \
    # Add user
    && adduser -D -u 1000 -s /bin/bash $PARSOID_USER \
    # Set permissions
    && chmod -v +x /run-parsoid.sh \
    # Core
    && mkdir -p $PARSOID_HOME \
    && git clone \
        --branch ${PARSOID_VERSION} \
        --single-branch \
        --depth 1 \
        --quiet \
        https://gerrit.wikimedia.org/r/p/mediawiki/services/parsoid \
        $PARSOID_HOME \
    && cd $PARSOID_HOME \
    && npm install

EXPOSE 8000
EXPOSE 8001

CMD ["/run-parsoid.sh"]
