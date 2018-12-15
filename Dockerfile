FROM alpine

MAINTAINER luiz@thenets.org

# Install required packages
RUN apk add --no-cache nodejs nodejs-npm python git tar bash make

ENV PARSOID_HOME=/var/lib/parsoid \
    PARSOID_USER=parsoid

# Build branch name: v0.8.0, v0.9.0, v0.10.0 master 
ENV PARSOID_VERSION=v0.10.0

# Parsoid setup
RUN set -x; \
    # Add user
    adduser -D -u 1000 -s /bin/bash $PARSOID_USER \
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

COPY run-parsoid.sh /run-parsoid.sh
RUN chmod -v +x /run-parsoid.sh

EXPOSE 8000
CMD ["/run-parsoid.sh"]
