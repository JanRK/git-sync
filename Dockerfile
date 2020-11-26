FROM quay.io/janrk/pwsh-slim

RUN apt-get update; \
        apt-get install -y --no-install-recommends git; \
        apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*

ADD ./gitsync.ps1 /

ENTRYPOINT [pwsh", "-f", "/gitsync.ps1"]