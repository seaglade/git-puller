FROM alpine/git:latest
COPY cred_helper.sh /cred_helper.sh
COPY entrypoint.sh /entrypoint.sh
RUN git config --system credential.helper "/cred_helper.sh"
WORKDIR /tmp/repo
ENTRYPOINT /sync.sh