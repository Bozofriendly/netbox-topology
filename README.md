# netbox-topology

[NetBox](https://github.com/netbox-community/netbox) with the
[netbox-topology-views](https://github.com/netbox-community/netbox-topology-views) plugin baked in, so the topology map
works without installing anything at startup.

    docker pull ghcr.io/bozofriendly/netbox-topology:v4.7.1-4.7.0

The tag is `<netbox version>-<plugin version>`. The plugin tracks NetBox minor releases (plugin 4.7.x needs NetBox 4.7.x),
so both are pinned here and bumped together: the `FROM` tag in the `Dockerfile` and the pin in
`plugin_requirements.txt`. Push to `main`; CI builds, runs `test.sh` (plugin importable, static files collected) and
pushes the image. Renovate proposes both bumps in one PR.

Enable it in NetBox's config (the official Helm chart: `plugins: [netbox_topology_views]`):

```python
PLUGINS = ["netbox_topology_views"]
PLUGINS_CONFIG = {"netbox_topology_views": {"allow_coordinates_saving": True}}
```

Test locally: `bash test.sh`.
