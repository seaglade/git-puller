FROM alpine/git:latest

LABEL org.opencontainers.image.source=https://github.com/seaglade/git-puller
LABEL org.opencontainers.image.description="`git-puller` is a docker container that keeps a cloned git repo in sync with its origin by pulling on an interval."
LABEL org.opencontainers.image.licenses=Apache-2.0


COPY cred_helper.sh /cred_helper.sh
COPY entrypoint.sh /entrypoint.sh
RUN git config --system credential.helper "/cred_helper.sh"
WORKDIR /tmp/repo
ENTRYPOINT /entrypoint.sh