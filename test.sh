#!/usr/bin/env bash
# Build the image and prove the plugin is installed, its static files are collected, and NetBox accepts it.
set -euo pipefail
tag="${1:-local/netbox-topology:test}"
# Renovate can only bump a literal tag: the base image must not come from a build ARG
grep -qE '^FROM ghcr.io/netbox-community/netbox:v[0-9]+\.[0-9]+\.[0-9]+$' Dockerfile || { echo "FAIL: FROM must be a literal ghcr.io/netbox-community/netbox:vX.Y.Z"; exit 1; }
docker build -q -t "$tag" . >/dev/null
docker run --rm --entrypoint /opt/netbox/venv/bin/python "$tag" -c \
  'import importlib.metadata as md, netbox_topology_views; print("plugin", md.version("netbox-topology-views"))'
docker run --rm --entrypoint sh "$tag" -c 'n=$(find /opt/netbox/netbox/static/netbox_topology_views -name "*.js" | wc -l); [ "$n" -gt 0 ] && echo "static ok ($n js files)"'
# NetBox itself must load with the plugin enabled (Django system checks; no database needed)
docker run --rm --entrypoint sh -e SECRET_KEY=test-only-000000000000000000000000000000000000000000 -e SKIP_SUPERUSER=true "$tag" -c \
  '/opt/netbox/venv/bin/python /opt/netbox/netbox/manage.py check 2>&1 | tail -1'
