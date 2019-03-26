FROM alpine:3.8

# This is the release of Vault to pull in.
ENV VAULT_VERSION=1.0.3

# This is the release of Consul to pull in.
ENV CONSUL_VERSION=1.4.4

# This is the location of the releases.
ENV HASHICORP_RELEASES=https://releases.hashicorp.com

# Create a vault user and group first so the IDs get set the same way,
# even as the rest of this may change over time.
RUN addgroup vault && adduser -S -G vault vault

# Create a consul user and group first so the IDs get set the same way, even as
# the rest of this may change over time.
RUN addgroup consul && adduser -S -G consul consul

# Set up base tools, consul, vault.
RUN apk add --update --no-cache libcap su-exec dumb-init && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    wget ${HASHICORP_RELEASES}/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /bin && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip -d /bin && \
    cd /tmp && \
    rm -rf /tmp/build

# /vault/logs is made available to use as a location to store audit logs, if
# desired; /vault/file is made available to use as a location with the file
# storage backend, if desired; the server will be started with /vault/config as
# the configuration directory so you can add additional config files in that location.
RUN mkdir -p /vault/logs && mkdir -p /vault/file && mkdir -p /vault/config && chown -R vault:vault /vault

# The /consul/data dir is used by Consul to store state. The agent will be started
# with /consul/config as the configuration directory so you can add additional config files in that location.
RUN mkdir -p /consul/data && mkdir -p /consul/config && chown -R consul:consul /consul

# Expose the logs directory as a volume since there's potentially long-running state in there
VOLUME /vault/logs

# Expose the file directory as a volume since there's potentially long-running state in there
VOLUME /vault/file

# 8200/tcp is the primary interface that applications use to interact with Vault.
EXPOSE 8200

COPY vault-entrypoint.sh /usr/local/bin/vault-entrypoint.sh
COPY consul-entrypoint.sh /usr/local/bin/consul-entrypoint.sh
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/vault-entrypoint.sh
RUN chmod +x /usr/local/bin/consul-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["/bin/sh"]