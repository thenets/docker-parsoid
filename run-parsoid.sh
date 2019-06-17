#!/bin/bash

set -e

# backward compatibility
if [[ -z "$PARSOID_NUM_WORKERS" && -n "$NUM_WORKERS" ]]; then
    PARSOID_NUM_WORKERS="$NUM_WORKERS"
fi

cd $PARSOID_HOME

domains="${!PARSOID_DOMAIN_*} ${!PARSOID_MWAPIS_*}"

if [ -z "$domains" ]; then
    echo >&2 'You must provide PARSOID_DOMAIN_* variables, for example: export PARSOID_DOMAIN_localhost=http://localhost/w/api.php'
    exit 2;
fi

# see https://phabricator.wikimedia.org/diffusion/GPAR/browse/master/config.example.yaml
cat <<EOT > config.yaml
# Number of worker processes to spawn.
# Set to 0 to run everything in a single process without clustering.
# Use 'ncpu' to run as many workers as there are CPU units
num_workers: ${PARSOID_NUM_WORKERS:-'0'}

worker_heartbeat_timeout: 300000

logging:
    level: ${PARSOID_LOGGING_LEVEL:-info}

services:
  - module: lib/index.js
    entrypoint: apiServiceWorker
    conf:

        # Set your own user-agent string
        # Otherwise, defaults to:
        #   'Parsoid/<current-version-defined-in-package.json>'
        #userAgent: 'My-User-Agent-String'

        # We pre-define wikipedias as 'enwiki', 'dewiki' etc. Similarly
        # for other projects: 'enwiktionary', 'enwikiquote', 'enwikibooks',
        # 'enwikivoyage' etc.
        # The default for this is false. Uncomment the line below if you want
        # to load WMF's config for wikipedias, etc.
        #loadWMF: true

        # A default proxy to connect to the API endpoints.
        # Default: undefined (no proxying).
        # Overridden by per-wiki proxy config in setMwApi.
        #defaultAPIProxyURI: 'http://proxy.example.org:8080'

        # Enable debug mode (prints extra debugging messages)
        #debug: true

        # Use the PHP preprocessor to expand templates via the MW API (default true)
        #usePHPPreProcessor: false

        # Use selective serialization (default false)
        #useSelser: true

        # Allow cross-domain requests to the API (default '*')
        # Sets Access-Control-Allow-Origin header
        # disable:
        #allowCORS: false
        # restrict:
        #allowCORS: 'some.domain.org'

        # Allow override of port/interface:
        serverPort: 8000
        #serverInterface: '127.0.0.1'

        # Enable linting of some wikitext errors to the log
        #linting: true
        # Send lint errors to MW API instead of to the log
        #linterSendAPI: false

        # Require SSL certificates to be valid (default true)
        # Set to false when using self-signed SSL certificates
        strictSSL: ${PARSOID_STRICT_SSL:-true}

        # Use a different server for CSS style modules.
        # Leaving it undefined (the default) will use the same URI as the MW API,
        # changing api.php for load.php.
        #modulesLoadURI: 'http://example.org/load.php'

        # Configure Parsoid to point to your MediaWiki instances.
        mwApis:
EOT

# see https://www.mediawiki.org/wiki/Parsoid/Setup#Configuration
for var in $domains
do
    if [ -z "${!var}" ]; then
        echo >&2 "The $var variable must not be an empty string";
    fi

    cat <<EOT >> config.yaml
          -
            uri: '${!var}'
            domain: '${var:15}'
EOT
done
chmod 744 config.yaml
su -c 'node bin/server.js' $PARSOID_USER
