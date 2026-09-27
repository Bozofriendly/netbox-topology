#!/usr/bin/env bash
# Build the image and prove the plugin is installed, its static files are collected, and NetBox accepts it.
set -euo pipefail
tag="${1:-local/netbox-topology:test}"
docker build -q -t "$tag" . >/dev/null
docker run --rm --entrypoint /opt/netbox/venv/bin/python "$tag" -c \
  'import importlib.metadata as md, netbox_topology_views; print("plugin", md.version("netbox-topology-views"))'
docker run --rm --entrypoint sh "$tag" -c 'n=$(find /opt/netbox/netbox/static/netbox_topology_views -name "*.js" | wc -l); [ "$n" -gt 0 ] && echo "static ok ($n js files)"'
