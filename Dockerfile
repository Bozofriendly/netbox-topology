# NetBox with the netbox-topology-views plugin. Versions move together: the plugin tracks NetBox minor releases.
ARG NETBOX_VERSION=v4.7.1
FROM ghcr.io/netbox-community/netbox:${NETBOX_VERSION}
COPY plugin_requirements.txt /opt/netbox/
RUN /usr/local/bin/uv pip install -r /opt/netbox/plugin_requirements.txt
# The plugin's README asks for this folder (role images live there).
RUN mkdir -p /opt/netbox/netbox/static/netbox_topology_views/img
COPY configuration/plugins.py /etc/netbox/config/plugins.py
RUN DEBUG="true" SECRET_KEY="build-only-not-a-secret-000000000000000000000000000000" \
    /opt/netbox/venv/bin/python /opt/netbox/netbox/manage.py collectstatic --no-input
LABEL org.opencontainers.image.source="https://github.com/Bozofriendly/netbox-topology" \
      org.opencontainers.image.description="NetBox with the netbox-topology-views plugin" \
      org.opencontainers.image.licenses="Apache-2.0"
